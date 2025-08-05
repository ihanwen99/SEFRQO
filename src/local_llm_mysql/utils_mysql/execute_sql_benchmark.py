#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import time
import argparse
import mysql.connector
import statistics
import json
import re
from collections import defaultdict

def connect_to_database(host, port, user, password, database):
    """Connect to MySQL database"""
    try:
        conn = mysql.connector.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database,
            autocommit=True
        )
        print(f"✅ Successfully connected to {user}@{host}:{port}/{database}")
        return conn
    except mysql.connector.Error as err:
        print(f"❌ Database connection failed: {err}")
        sys.exit(1)

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
    # Improved table name extraction, handling comma-separated FROM clauses and aliases
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

def get_explain_analysis(cursor, sql):
    """Get EXPLAIN analysis results"""
    try:
        # Execute EXPLAIN FORMAT=JSON
        cursor.execute(f"EXPLAIN FORMAT=JSON {sql}")
        result = cursor.fetchone()
        if result and result[0]:
            return json.loads(result[0])
        return None
    except mysql.connector.Error as err:
        print(f"   ⚠️ EXPLAIN analysis failed: {err}")
        return None

def extract_join_order(explain_data):
    """Extract JOIN order from EXPLAIN results"""
    if not explain_data:
        return []
    
    join_order = []
    
    def traverse_plan(node):
        if isinstance(node, dict):
            # Handle table_name field
            if 'table_name' in node:
                table_name = node['table_name']
                if table_name not in join_order:
                    join_order.append(table_name)
            
            # Handle nested_loop structure
            if 'nested_loop' in node:
                nested_loop = node['nested_loop']
                if isinstance(nested_loop, list):
                    for item in nested_loop:
                        traverse_plan(item)
                else:
                    traverse_plan(nested_loop)
            
            # Handle query_block structure
            if 'query_block' in node:
                qb = node['query_block']
                # Find table information
                if 'table' in qb:
                    table_info = qb['table']
                    if isinstance(table_info, list):
                        for table in table_info:
                            traverse_plan(table)
                    else:
                        traverse_plan(table_info)
                
                # Find nested_loop information
                if 'nested_loop' in qb:
                    nested_loop = qb['nested_loop']
                    if isinstance(nested_loop, list):
                        for item in nested_loop:
                            traverse_plan(item)
                    else:
                        traverse_plan(nested_loop)
                
                # Find ordering_operation
                if 'ordering_operation' in qb:
                    traverse_plan(qb['ordering_operation'])
                
                # Find grouping_operation
                if 'grouping_operation' in qb:
                    traverse_plan(qb['grouping_operation'])
            
            # Recursively handle other fields
            for key, value in node.items():
                if key not in ['table_name', 'nested_loop', 'query_block'] and isinstance(value, (dict, list)):
                    traverse_plan(value)
                    
        elif isinstance(node, list):
            for item in node:
                traverse_plan(item)
    
    traverse_plan(explain_data)
    return join_order

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

def analyze_sql_query(cursor, name, query, mode="analyze"):
    """Analyze single SQL query, get execution time and statistics"""
    try:
        if mode == "analyze":
            print(f"→ Analyzing {name} ...", end="")
        else:
            print(f"→ Explaining {name} ...", end="")
        
        # 1. Get table names
        table_names = extract_table_names_from_sql(query)
        
        # 2. Get table cardinalities
        table_cardinalities = {}
        for table_name in table_names:
            cardinality = get_table_cardinality(cursor, table_name)
            if cardinality > 0:
                table_cardinalities[table_name] = cardinality
        
        # 3. Get EXPLAIN analysis
        explain_data = get_explain_analysis(cursor, query)
        
        # 4. Extract JOIN order
        join_order = extract_join_order(explain_data)
        
        # 5. Extract filter cardinalities
        filter_cardinalities = extract_filter_cardinality(explain_data)
        
        # 6. Decide whether to execute query based on mode
        if mode == "analyze":
            # Execute query and measure time
            start = time.time()
            cursor.execute(query)
            rows = cursor.fetchall()
            elapsed = time.time() - start
            
            print(f" Completed [{elapsed:.4f}s, {len(rows)} rows]")
            
            return {
                'execution_time': elapsed,
                'row_count': len(rows),
                'table_cardinalities': table_cardinalities,
                'join_order': join_order,
                'filter_cardinalities': filter_cardinalities
            }
        else:
            # Only get query plan, don't execute
            print(f" Completed [EXPLAIN mode, not executed]")
            
            return {
                'execution_time': 0.0,  # No execution time in EXPLAIN mode
                'row_count': 0,         # No result rows in EXPLAIN mode
                'table_cardinalities': table_cardinalities,
                'join_order': join_order,
                'filter_cardinalities': filter_cardinalities
            }
    except mysql.connector.Error as err:
        print(f"\n   ❌ Analysis failed ({err})")
        return None

def load_sql_queries_from_dir(directory):
    """
    Scan all .sql files in directory, and return list with filename (without .sql)
    as sql_name and file content (stripped) as sql_query.
    """
    sql_queries = []
    for fname in sorted(os.listdir(directory)):
        if not fname.lower().endswith('.sql'):
            continue
        path = os.path.join(directory, fname)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
        if not content:
            print(f"⚠️ File {fname} is empty, skipping")
            continue
        name = os.path.splitext(fname)[0]
        sql_queries.append((name, content))
    return sql_queries

def format_join_order_hint(join_order):
    """Format JOIN order as MySQL hint form"""
    if not join_order:
        return ""
    return f"/*+ JOIN_ORDER({', '.join(join_order)}) */"

def main():
    parser = argparse.ArgumentParser(description="Batch execute all SQL files in directory and record execution times and statistics")
    parser.add_argument("sql_dir", help="Directory path containing .sql files")
    parser.add_argument("--host", default="127.0.0.1", help="MySQL host address")
    parser.add_argument("--port", type=int, default=3306, help="MySQL port")
    parser.add_argument("--user", default="qihanzha", help="MySQL username")
    parser.add_argument("--password", default="qihanzha", help="MySQL password")
    parser.add_argument("--database", default="imdbload", help="Default database name")
    parser.add_argument("--output", default="/home/qihanzha/LLM4QO/src/local_llm_mysql/utils_mysql/execution_times_report_test_demo.txt",
                        help="Output report file (relative or absolute path)")
    parser.add_argument("--mode", choices=["analyze", "explain"], default="analyze", 
                        help="Analysis mode: analyze=execute queries and analyze (default), explain=only get query plans without execution")
    args = parser.parse_args()

    # 1. Connect to database
    conn = connect_to_database(
        host=args.host,
        port=args.port,
        user=args.user,
        password=args.password,
        database=args.database
    )
    cursor = conn.cursor()

    # 2. Load SQL files
    print(f"\n🔍 Scanning .sql files in directory {args.sql_dir}...")
    sql_list = load_sql_queries_from_dir(args.sql_dir)
    if not sql_list:
        print("‼️ No SQL files found, exiting program")
        sys.exit(0)
    print(f"Found {len(sql_list)} SQL files\n")

    # 3. Execute analysis, collect data
    print(f"\n📊 Current mode: {args.mode.upper()}")
    if args.mode == "explain":
        print("⚠️  EXPLAIN mode: Only get query plans, do not actually execute queries")
    else:
        print("⚠️  ANALYZE mode: Will execute queries and collect performance data")
    
    execution_results = defaultdict(list)
    rounds = (1, 2) if args.mode == "analyze" else (1,)  # EXPLAIN mode only needs one round
    
    for round_idx in rounds:
        print(f"\n" + "="*60)
        if args.mode == "analyze":
            print(f"🏃‍ Round {round_idx} started")
        else:
            print(f"🔍 EXPLAIN analysis started")
        print("="*60)
        for idx, (name, query) in enumerate(sql_list, start=1):
            if args.mode == "analyze":
                print(f"[{round_idx} - {idx}/{len(sql_list)}]", end=" ")
            else:
                print(f"[{idx}/{len(sql_list)}]", end=" ")
            result = analyze_sql_query(cursor, name, query, args.mode)
            if result:
                execution_results[name].append(result)

    cursor.close()
    conn.close()
    print("\n🔌 Database connection closed")

    # 4. Output statistical report to screen & file
    if args.mode == "analyze":
        header = f"{'SQL Name':<30}{'1st(s)':<12}{'2nd(s)':<12}{'Avg(s)':<12}{'Diff(s)':<12}"
        sep = "-" * len(header)
        print("\n" + sep)
        print("📊 Execution Time Statistics Report")
        print(sep)
        print(header)
        print(sep)
    else:
        header = f"{'SQL Name':<30}{'Query Plan Status':<20}"
        sep = "-" * len(header)
        print("\n" + sep)
        print("📊 Query Plan Analysis Report")
        print(sep)
        print(header)
        print(sep)

    total1, total2 = 0.0, 0.0
    lines = []
    detailed_analysis = []
    
    for name, _ in sql_list:
        results = execution_results.get(name, [])
        if args.mode == "analyze" and len(results) == 2:
            t1, t2 = results[0]['execution_time'], results[1]['execution_time']
            avg = statistics.mean([t1, t2])
            diff = abs(t2 - t1)
            total1 += t1
            total2 += t2
            line = f"{name:<30}{t1:<12.4f}{t2:<12.4f}{avg:<12.4f}{diff:<12.4f}"
            print(line)
            lines.append(line)
        elif args.mode == "explain" and len(results) >= 1:
            line = f"{name:<30}{'Analyzed query plan':<20}"
            print(line)
            lines.append(line)
        else:
            if args.mode == "analyze":
                print(f"{name:<30} Failed to get two complete execution times")
            else:
                print(f"{name:<30} Query plan analysis failed")
            continue
            
        # Add detailed analysis information
        result = results[0]  # Use first analysis result
        detailed_analysis.append(f"\n=== {name} ===")
        
        # Table cardinalities
        if result['table_cardinalities']:
            detailed_analysis.append("Table Cardinality:")
            for table, cardinality in result['table_cardinalities'].items():
                detailed_analysis.append(f"  {table}: {cardinality}")
        
        # Filter cardinalities
        if result['filter_cardinalities']:
            detailed_analysis.append("Filter Cardinality:")
            for filter_desc, cardinality in result['filter_cardinalities'].items():
                detailed_analysis.append(f"  {filter_desc}: {cardinality}")
        
        # JOIN order
        if result['join_order']:
            join_hint = format_join_order_hint(result['join_order'])
            detailed_analysis.append(f"Join Order Hint: {join_hint}")

    print(sep)
    if args.mode == "analyze":
        total_avg = (total1 + total2) / 2
        print(f"{'Total':<30}{total1:<12.4f}{total2:<12.4f}{total_avg:<12.4f}{abs(total2-total1):<12.4f}")
    else:
        print(f"{'Total':<30}{'Analysis completed':<20}")

    # Write to file
    with open(args.output, 'w', encoding='utf-8') as f:
        if args.mode == "analyze":
            f.write("Batch SQL Execution Time and Statistics Report\n")
        else:
            f.write("Batch SQL Query Plan Analysis Report\n")
        f.write(time.strftime("Generated time: %Y-%m-%d %H:%M:%S\n", time.localtime()))
        f.write(f"Analysis mode: {args.mode.upper()}\n")
        f.write(sep + "\n")
        f.write(header + "\n")
        f.write(sep + "\n")
        for ln in lines:
            f.write(ln + "\n")
        f.write(sep + "\n")
        if args.mode == "analyze":
            total_avg = (total1 + total2) / 2
            f.write(f"{'Total':<30}{total1:<12.4f}{total2:<12.4f}{total_avg:<12.4f}{abs(total2-total1):<12.4f}\n")
        else:
            f.write(f"{'Total':<30}{'Analysis completed':<20}\n")
        
        # Write detailed analysis
        f.write("\n" + "="*80 + "\n")
        f.write("Detailed Statistical Analysis\n")
        f.write("="*80 + "\n")
        for line in detailed_analysis:
            f.write(line + "\n")

    print(f"\n✅ Report saved to {args.output}")

if __name__ == "__main__":
    main()
