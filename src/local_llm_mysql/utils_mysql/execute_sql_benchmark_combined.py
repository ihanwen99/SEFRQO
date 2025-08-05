#!/usr/bin/env python3

import mysql.connector
import time
import re
import json
import argparse
from collections import defaultdict
import statistics

def connect_to_database():
    """Connect to MySQL database"""
    try:
        connection = mysql.connector.connect(
            host='127.0.0.1',
            port=3306,
            user='qihanzha',
            password='qihanzha',
            database='imdbload',
            autocommit=True
        )
        print("Successfully connected to database")
        return connection
    except mysql.connector.Error as err:
        print(f"Database connection failed: {err}")
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

def format_join_order_hint(join_order):
    """Format JOIN order as MySQL hint form"""
    if not join_order:
        return ""
    return f"/*+ JOIN_ORDER({', '.join(join_order)}) */"

def parse_sql_file(file_path):
    """Parse SQL file, extract SQL names and query statements"""
    sql_queries = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    current_sql_name = None
    current_sql = ""
    
    for line in lines:
        line = line.strip()
        
        # Identify SQL name comment lines
        if line.startswith('-- imdbload_'):
            # If there's a previous SQL, save it first
            if current_sql_name and current_sql.strip():
                sql_queries.append((current_sql_name, current_sql.strip()))
            
            # Start new SQL
            current_sql_name = line[3:]  # Remove '-- '
            current_sql = ""
        
        # If it's a SELECT statement, accumulate to current SQL
        elif line.startswith('SELECT') or (current_sql and line and not line.startswith('--')):
            if current_sql:
                current_sql += " " + line
            else:
                current_sql = line
    
    # Handle the last SQL
    if current_sql_name and current_sql.strip():
        sql_queries.append((current_sql_name, current_sql.strip()))
    
    return sql_queries

def analyze_sql_query(cursor, sql_name, sql_query, mode="analyze"):
    """Analyze single SQL query, get execution time and statistics"""
    try:
        if mode == "analyze":
            print(f"Analyzing: {sql_name}")
        else:
            print(f"Explaining: {sql_name}")
        
        # 1. Get table names
        table_names = extract_table_names_from_sql(sql_query)
        
        # 2. Get table cardinalities
        table_cardinalities = {}
        for table_name in table_names:
            cardinality = get_table_cardinality(cursor, table_name)
            if cardinality > 0:
                table_cardinalities[table_name] = cardinality
        
        # 3. Get EXPLAIN analysis
        explain_data = get_explain_analysis(cursor, sql_query)
        
        # 4. Extract JOIN order
        join_order = extract_join_order(explain_data)
        
        # 5. Extract filter cardinalities
        filter_cardinalities = extract_filter_cardinality(explain_data)
        
        # Display statistics (for both modes)
        if table_cardinalities:
            print("  Table cardinalities:")
            for table, cardinality in table_cardinalities.items():
                print(f"    {table}: {cardinality}")
        
        if filter_cardinalities:
            print("  Filter cardinalities:")
            for filter_desc, cardinality in filter_cardinalities.items():
                print(f"    {filter_desc}: {cardinality}")
        
        if join_order:
            join_hint = format_join_order_hint(join_order)
            print(f"  JOIN order hint: {join_hint}")
        
        # 6. Decide whether to execute query based on mode
        if mode == "analyze":
            # Execute query and measure time
            start_time = time.time()
            cursor.execute(sql_query)
            
            # Get all results to ensure query is fully executed
            results = cursor.fetchall()
            end_time = time.time()
            
            execution_time = end_time - start_time
            print(f"  Execution time: {execution_time:.4f}s, Result rows: {len(results)}")
            
            return {
                'execution_time': execution_time,
                'row_count': len(results),
                'table_cardinalities': table_cardinalities,
                'join_order': join_order,
                'filter_cardinalities': filter_cardinalities
            }
        else:
            # Only get query plan, don't execute
            print(f"  Query plan analysis completed")
            
            return {
                'execution_time': 0.0,  # No execution time in EXPLAIN mode
                'row_count': 0,         # No result rows in EXPLAIN mode
                'table_cardinalities': table_cardinalities,
                'join_order': join_order,
                'filter_cardinalities': filter_cardinalities
            }
        
    except mysql.connector.Error as err:
        print(f"  Analysis failed: {err}")
        return None

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="Analyze queries in SQL file and record execution times and statistics")
    parser.add_argument("--sql-file", default="/home/qihanzha/LLM4QO/src/local_llm_mysql/prompts/IMDB_job_set_with_names.sql",
                        help="Path to file containing SQL queries")
    parser.add_argument("--output", default="/home/qihanzha/LLM4QO/src/local_llm_mysql/utils_mysql/execution_times_report_combined.txt",
                        help="Output report file path")
    parser.add_argument("--mode", choices=["analyze", "explain"], default="analyze", 
                        help="Analysis mode: analyze=execute queries and analyze (default), explain=only get query plans without execution")
    args = parser.parse_args()
    
    sql_file_path = args.sql_file
    
    # Connect to database
    connection = connect_to_database()
    if not connection:
        return
    
    cursor = connection.cursor()
    
    try:
        # Parse SQL file
        print("Parsing SQL file...")
        sql_queries = parse_sql_file(sql_file_path)
        print(f"Found {len(sql_queries)} SQL queries")
        
        # Show current mode
        print(f"\n📊 Current mode: {args.mode.upper()}")
        if args.mode == "explain":
            print("⚠️  EXPLAIN mode: Only get query plans, do not actually execute queries")
        else:
            print("⚠️  ANALYZE mode: Will execute queries and collect performance data")
        
        # Store execution results
        execution_results = defaultdict(list)
        rounds = (1, 2) if args.mode == "analyze" else (1,)  # EXPLAIN mode only needs one round
        
        for round_idx in rounds:
            print("\n" + "="*60)
            if args.mode == "analyze":
                print(f"Starting round {round_idx} execution...")
            else:
                print("Starting query plan analysis...")
            print("="*60)
            
            for i, (sql_name, sql_query) in enumerate(sql_queries, 1):
                if args.mode == "analyze":
                    print(f"\n[Round {round_idx} {i}/{len(sql_queries)}]")
                else:
                    print(f"\n[{i}/{len(sql_queries)}]")
                result = analyze_sql_query(cursor, sql_name, sql_query, args.mode)
                if result is not None:
                    execution_results[sql_name].append(result)
        
        # Statistics and output results
        print("\n" + "="*80)
        if args.mode == "analyze":
            print("Execution Time Statistics Report")
            print("="*80)
            print(f"{'SQL Name':<25} {'First(s)':<12} {'Second(s)':<12} {'Average(s)':<12} {'Diff(s)':<12}")
        else:
            print("Query Plan Analysis Report")
            print("="*80)
            print(f"{'SQL Name':<25} {'Query Plan Status':<20}")
        print("-" * 80)
        
        total_time_1 = 0
        total_time_2 = 0
        detailed_analysis = []
        
        for sql_name, _ in sql_queries:
            if args.mode == "analyze" and len(execution_results[sql_name]) == 2:
                time_1, time_2 = execution_results[sql_name][0]['execution_time'], execution_results[sql_name][1]['execution_time']
                avg_time = statistics.mean([time_1, time_2])
                diff_time = abs(time_2 - time_1)
                
                print(f"{sql_name:<25} {time_1:<12.4f} {time_2:<12.4f} {avg_time:<12.4f} {diff_time:<12.4f}")
                
                total_time_1 += time_1
                total_time_2 += time_2
            elif args.mode == "explain" and len(execution_results[sql_name]) >= 1:
                print(f"{sql_name:<25} {'Analyzed query plan':<20}")
            else:
                if args.mode == "analyze":
                    print(f"{sql_name:<25} Failed to get two complete execution times")
                else:
                    print(f"{sql_name:<25} Query plan analysis failed")
                continue
                
            # Add detailed analysis information
            result = execution_results[sql_name][0]  # Use first analysis result
            detailed_analysis.append(f"\n=== {sql_name} ===")
            
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
        
        print("-" * 80)
        if args.mode == "analyze":
            print(f"{'Total':<25} {total_time_1:<12.4f} {total_time_2:<12.4f} {(total_time_1+total_time_2)/2:<12.4f} {abs(total_time_2-total_time_1):<12.4f}")
        else:
            print(f"{'Total':<25} {'Analysis completed':<20}")
        
        # Save results to file
        output_file = args.output
        with open(output_file, 'w', encoding='utf-8') as f:
            if args.mode == "analyze":
                f.write("IMDB SQL Query Execution Time and Statistics Report\n")
            else:
                f.write("IMDB SQL Query Plan Analysis Report\n")
            f.write("="*80 + "\n")
            f.write(f"Total queries: {len(sql_queries)}\n")
            f.write(f"Execution date: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Analysis mode: {args.mode.upper()}\n\n")
            
            if args.mode == "analyze":
                f.write(f"{'SQL Name':<25} {'First(s)':<12} {'Second(s)':<12} {'Average(s)':<12} {'Diff(s)':<12}\n")
                f.write("-" * 80 + "\n")
                
                for sql_name, _ in sql_queries:
                    if len(execution_results[sql_name]) == 2:
                        time_1, time_2 = execution_results[sql_name][0]['execution_time'], execution_results[sql_name][1]['execution_time']
                        avg_time = statistics.mean([time_1, time_2])
                        diff_time = abs(time_2 - time_1)
                        
                        f.write(f"{sql_name:<25} {time_1:<12.4f} {time_2:<12.4f} {avg_time:<12.4f} {diff_time:<12.4f}\n")
                
                f.write("-" * 80 + "\n")
                f.write(f"{'Total':<25} {total_time_1:<12.4f} {total_time_2:<12.4f} {(total_time_1+total_time_2)/2:<12.4f} {abs(total_time_2-total_time_1):<12.4f}\n")
            else:
                f.write(f"{'SQL Name':<25} {'Query Plan Status':<20}\n")
                f.write("-" * 50 + "\n")
                
                for sql_name, _ in sql_queries:
                    if len(execution_results[sql_name]) >= 1:
                        f.write(f"{sql_name:<25} {'Analyzed query plan':<20}\n")
                    else:
                        f.write(f"{sql_name:<25} {'Analysis failed':<20}\n")
                
                f.write("-" * 50 + "\n")
                f.write(f"{'Total':<25} {'Analysis completed':<20}\n")
            
            # Write detailed analysis
            f.write("\n" + "="*80 + "\n")
            f.write("Detailed Statistical Analysis\n")
            f.write("="*80 + "\n")
            for line in detailed_analysis:
                f.write(line + "\n")
        
        print(f"\nDetailed report saved to: {output_file}")
        
    except Exception as e:
        print(f"Error occurred during execution: {e}")
    
    finally:
        cursor.close()
        connection.close()
        print("\nDatabase connection closed")

if __name__ == "__main__":
    main() 