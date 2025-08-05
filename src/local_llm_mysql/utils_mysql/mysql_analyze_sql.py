#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import mysql.connector
import json
import re
from collections import defaultdict

def connect_to_database(connection_info):
    """Connect to MySQL database using connection_info dict"""
    try:
        conn = mysql.connector.connect(
            host=connection_info['host'],
            port=connection_info['port'], 
            user=connection_info['user'],
            password=connection_info['password'],
            database=connection_info['database'],
            autocommit=True
        )
        return conn
    except mysql.connector.Error as err:
        print(f"❌ Database connection failed: {err}")
        return None

def get_table_cardinality(cursor, table_name):
    """Get table cardinality (row count)"""
    try:
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        result = cursor.fetchone()
        return result[0] if result else 0
    except mysql.connector.Error:
        return 0

def extract_table_names_from_sql(sql):
    """Extract table names from SQL"""
    tables = set()
    # Remove comments
    sql_clean = re.sub(r'--.*?\n', ' ', sql)
    sql_clean = re.sub(r'/\*.*?\*/', ' ', sql_clean, flags=re.DOTALL)
    
    # Find FROM clause (handling comma-separated cases)
    from_match = re.search(r'FROM\s+(.*?)(?:\s+WHERE|\s+ORDER\s+BY|\s+GROUP\s+BY|\s+HAVING|\s*$)', sql_clean, re.IGNORECASE | re.DOTALL)
    if from_match:
        from_clause = from_match.group(1).strip()
        # Split comma-separated tables
        table_parts = re.split(r',\s*', from_clause)
        for part in table_parts:
            part = part.strip()
            # Extract table name (handle "table_name as alias" or "table_name alias" patterns)
            table_match = re.match(r'(\w+)(?:\s+(?:as\s+)?(\w+))?', part, re.IGNORECASE)
            if table_match:
                table_name = table_match.group(1)
                tables.add(table_name)
    
    # Find explicit JOIN statements
    join_patterns = [
        r'JOIN\s+(\w+)(?:\s+(?:as\s+)?(\w+))?',  # JOIN table_name [as alias]
        r'INNER\s+JOIN\s+(\w+)(?:\s+(?:as\s+)?(\w+))?',
        r'LEFT\s+JOIN\s+(\w+)(?:\s+(?:as\s+)?(\w+))?',
        r'RIGHT\s+JOIN\s+(\w+)(?:\s+(?:as\s+)?(\w+))?',
        r'FULL\s+JOIN\s+(\w+)(?:\s+(?:as\s+)?(\w+))?'
    ]
    
    for pattern in join_patterns:
        matches = re.findall(pattern, sql_clean, re.IGNORECASE)
        for match in matches:
            table_name = match[0] if isinstance(match, tuple) else match
            tables.add(table_name)
    
    return list(tables)

def get_explain_analysis(cursor, sql, use_analyze=False):
    """Get EXPLAIN analysis results"""
    try:
        if use_analyze:
            # Try EXPLAIN ANALYZE FORMAT=JSON first (MySQL 8.0.18+)
            try:
                cursor.execute(f"EXPLAIN ANALYZE FORMAT=JSON {sql}")
                result = cursor.fetchone()
                if result and result[0]:
                    return json.loads(result[0]), True  # Return (data, executed)
            except mysql.connector.Error:
                # If EXPLAIN ANALYZE FORMAT=JSON fails, fall back to EXPLAIN FORMAT=JSON
                # and we'll execute the query separately
                cursor.execute(f"EXPLAIN FORMAT=JSON {sql}")
                result = cursor.fetchone()
                if result and result[0]:
                    return json.loads(result[0]), False  # Return (data, not_executed_yet)
        else:
            # Execute EXPLAIN FORMAT=JSON (plan only)
            cursor.execute(f"EXPLAIN FORMAT=JSON {sql}")
            result = cursor.fetchone()
            if result and result[0]:
                return json.loads(result[0]), False  # Return (data, not_executed)
        
        return None, False
    except mysql.connector.Error as err:
        analyze_type = "EXPLAIN ANALYZE" if use_analyze else "EXPLAIN"
        print(f"   ⚠️ {analyze_type} analysis failed: {err}")
        return None, False

def extract_filter_cardinality(explain_data):
    """Extract filter cardinality information from EXPLAIN results"""
    if not explain_data:
        return {}
    
    filter_info = {}
    
    def clean_condition(condition):
        """Clean condition string, remove database prefix"""
        if condition:
            # Remove database prefix `imdbload`.
            condition = re.sub(r'`\w+`\.', '', condition)
            # Remove extra backticks
            condition = re.sub(r'`([^`]+)`', r'\1', condition)
            return condition
        return condition
    
    def traverse_for_filters(node):
        if isinstance(node, dict):
            # Extract table-level filter information
            if 'table_name' in node:
                table_name = node['table_name']
                
                # Get basic row count information
                rows_examined = node.get('rows_examined_per_scan', 0)
                rows_produced = node.get('rows_produced_per_join', 0)
                filtered_percentage = node.get('filtered', 100)
                
                # Safely convert to numeric types
                try:
                    rows_examined = int(rows_examined) if rows_examined else 0
                    rows_produced = int(rows_produced) if rows_produced else 0
                    filtered_percentage = float(filtered_percentage) if filtered_percentage else 100.0
                    
                    # Calculate filtered row count
                    estimated_filtered_rows = int(rows_examined * filtered_percentage / 100) if rows_examined > 0 else 0
                    
                    # Prioritize showing information with specific conditions
                    if 'attached_condition' in node:
                        condition = clean_condition(node['attached_condition'])
                        effective_rows = rows_produced if rows_produced > 0 else estimated_filtered_rows
                        if effective_rows > 0:
                            filter_info[f"({table_name}, {condition})"] = effective_rows
                    # If no specific condition but has filtering, show filtered row count
                    elif estimated_filtered_rows > 0 and filtered_percentage < 100:
                        filter_info[f"({table_name}, filtered_rows)"] = estimated_filtered_rows
                
                except (ValueError, TypeError):
                    # If conversion fails, skip this entry
                    pass
            
            # Recursive traversal
            for key, value in node.items():
                if isinstance(value, (dict, list)):
                    traverse_for_filters(value)
        elif isinstance(node, list):
            for item in node:
                traverse_for_filters(item)
    
    traverse_for_filters(explain_data)
    return filter_info

def analyze_sql(sql, connection_info, REAL_EXECUTION, sql_name):
    """
    Analyze SQL query and return formatted cardinality information.
    
    Args:
        sql: SQL query string
        connection_info: Dictionary with database connection parameters
        REAL_EXECUTION: Boolean - if True, use EXPLAIN ANALYZE (actual execution); 
                                 if False, use EXPLAIN only (plan analysis)
        sql_name: Name/ID of the SQL query for logging
        
    Returns:
        String with formatted table and filter cardinality information
    """
    # Remove timeout from connection_info if it exists
    connection_info_cp = connection_info.copy()
    if 'timeout' in connection_info_cp:
        del connection_info_cp['timeout']
    
    # Connect to database
    conn = connect_to_database(connection_info_cp)
    if not conn:
        return "Error: Failed to connect to database"
    
    try:
        cursor = conn.cursor()
        
        # 1. Get table names
        table_names = extract_table_names_from_sql(sql)
        
        # 2. Get table cardinalities
        table_cardinalities = {}
        for table_name in table_names:
            cardinality = get_table_cardinality(cursor, table_name)
            if cardinality > 0:
                table_cardinalities[table_name] = cardinality
        
        # 3. Get EXPLAIN analysis
        # If REAL_EXECUTION=True: try EXPLAIN ANALYZE, fallback to EXPLAIN + actual execution
        # If REAL_EXECUTION=False: use EXPLAIN only (gets execution plan without running query)
        explain_data, was_executed = get_explain_analysis(cursor, sql, use_analyze=REAL_EXECUTION)
        
        # 4. If REAL_EXECUTION=True but query wasn't executed via EXPLAIN ANALYZE, execute it now
        if REAL_EXECUTION and not was_executed and explain_data:
            try:
                cursor.execute(sql)
                cursor.fetchall()  # Consume results but don't use them for analysis
            except mysql.connector.Error:
                # If execution fails, still return the analysis from EXPLAIN
                pass
        
        # 5. Extract filter cardinalities from explain results
        filter_cardinalities = extract_filter_cardinality(explain_data)
        
        cursor.close()
        conn.close()
        
        # 6. Format results as expected string
        result_lines = []
        
        result_lines.append("Table Cardinality:")
        for table, rows in table_cardinalities.items():
            result_lines.append(f"  {table}: {rows}")
        
        result_lines.append("Filter Cardinality:")
        for filter_desc, rows in filter_cardinalities.items():
            result_lines.append(f"  {filter_desc}: {rows}")
        
        return "\n".join(result_lines)
        
    except Exception as e:
        if conn:
            conn.close()
        return f"Error analyzing SQL: {e}" 