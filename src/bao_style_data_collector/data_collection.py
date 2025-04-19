#!/usr/bin/env python3
import os
import sys
import glob
import time
import json
import psycopg2

#------------------------------------------------------------------
# Constants and function definitions from the previous code snippet
#------------------------------------------------------------------

TIMEOUT = 30000  # 30 seconds
_ALL_OPTIONS = [
    "enable_nestloop", "enable_hashjoin", "enable_mergejoin",
    "enable_seqscan", "enable_indexscan", "enable_indexonlyscan"
]

# Each shorthand name corresponds to an enable_* option.
# _ARMS = [
#     #  0
#     ["hashjoin", "indexonlyscan"],
#     #  1
#     ["hashjoin", "indexonlyscan", "indexscan"],
#     #  2  
#     ["hashjoin", "indexonlyscan", "indexscan", "mergejoin"],
#     #  3
#     ["hashjoin", "indexonlyscan", "indexscan", "mergejoin", "nestloop"],
#     #  4
#     ["hashjoin", "indexonlyscan", "indexscan", "mergejoin", "seqscan"],
#     #  5
#     ["hashjoin", "indexonlyscan", "indexscan", "nestloop"],
#     #  6
#     ["hashjoin", "indexonlyscan", "indexscan", "nestloop", "seqscan"],
#     #  7
#     ["hashjoin", "indexonlyscan", "indexscan", "seqscan"],
#     #  8
#     ["hashjoin", "indexonlyscan", "mergejoin"],
#     #  9
#     ["hashjoin", "indexonlyscan", "mergejoin", "nestloop"],
#     # 10
#     ["hashjoin", "indexonlyscan", "mergejoin", "nestloop", "seqscan"],
#     # 11
#     ["hashjoin", "indexonlyscan", "mergejoin", "seqscan"],
#     # 12
#     ["hashjoin", "indexonlyscan", "nestloop"],
#     # 13
#     ["hashjoin", "indexonlyscan", "nestloop", "seqscan"],
#     # 14
#     ["hashjoin", "indexonlyscan", "seqscan"],
#     # 15
#     ["hashjoin", "indexscan"],
#     # 16
#     ["hashjoin", "indexscan", "mergejoin"],
#     # 17
#     ["hashjoin", "indexscan", "mergejoin", "nestloop"],
#     # 18
#     ["hashjoin", "indexscan", "mergejoin", "nestloop", "seqscan"],
#     # 19
#     ["hashjoin", "indexscan", "mergejoin", "seqscan"],
#     # 20
#     ["hashjoin", "indexscan", "nestloop"],
#     # 21
#     ["hashjoin", "indexscan", "nestloop", "seqscan"],
#     # 22
#     ["hashjoin", "indexscan", "seqscan"],
#     # 23
#     ["hashjoin", "mergejoin", "nestloop", "seqscan"],
#     # 24
#     ["hashjoin", "mergejoin", "seqscan"],
#     # 25
#     ["hashjoin", "nestloop", "seqscan"],
#     # 26
#     ["hashjoin", "seqscan"],
#     # 27
#     ["indexonlyscan", "indexscan", "mergejoin"],
#     # 28
#     ["indexonlyscan", "indexscan", "mergejoin", "nestloop"],
#     # 29
#     ["indexonlyscan", "indexscan", "mergejoin", "nestloop", "seqscan"],
#     # 30
#     ["indexonlyscan", "indexscan", "mergejoin", "seqscan"],
#     # 31
#     ["indexonlyscan", "indexscan", "nestloop"],
#     # 32
#     ["indexonlyscan", "indexscan", "nestloop", "seqscan"],
#     # 33
#     ["indexonlyscan", "mergejoin"],
#     # 34
#     ["indexonlyscan", "mergejoin", "nestloop"],
#     # 35
#     ["indexonlyscan", "mergejoin", "nestloop", "seqscan"],
#     # 36
#     ["indexonlyscan", "mergejoin", "seqscan"],
#     # 37
#     ["indexonlyscan", "nestloop"],
#     # 38
#     ["indexonlyscan", "nestloop", "seqscan"],
#     # 39
#     ["indexscan", "mergejoin"],
#     # 40
#     ["indexscan", "mergejoin", "nestloop"],
#     # 41
#     ["indexscan", "mergejoin", "nestloop", "seqscan"],
#     # 42
#     ["indexscan", "mergejoin", "seqscan"],
#     # 43
#     ["indexscan", "nestloop"],
#     # 44
#     ["indexscan", "nestloop", "seqscan"],
#     # 45
#     ["mergejoin", "nestloop", "seqscan"],
#     # 46
#     ["mergejoin", "seqscan"],
#     # 47
#     ["nestloop", "seqscan"],
#     # 48 (all 6 options enabled)
#     ["hashjoin", "indexonlyscan", "indexscan", "mergejoin", "nestloop", "seqscan"],
# ]

_ARMS = [
    # 0
    ["hashjoin", "indexonlyscan", "indexscan", "mergejoin", "nestloop", "seqscan"],
    # 1
    ["hashjoin", "indexonlyscan", "indexscan", "mergejoin", "seqscan"],
    # 2
    ["hashjoin", "indexonlyscan", "nestloop", "seqscan"],
    # 3
    ["hashjoin", "indexonlyscan", "seqscan"],
    # 4
    ["hashjoin", "indexonlyscan", "indexscan", "nestloop", "seqscan"],
]

def _arm_idx_to_hints(arm_idx):
    """
    Return a list of PostgreSQL configuration hints corresponding to the given arm index.
    For example, it returns a list like ["SET enable_hashjoin TO on", "SET enable_nestloop TO off", ...].
    """
    chosen_short_opts = set(_ARMS[arm_idx])
    hints = []
    # Mapping from shorthand name to the actual enable_* parameter.
    short_to_enable = {
        "hashjoin":       "enable_hashjoin",
        "indexonlyscan":  "enable_indexonlyscan",
        "indexscan":      "enable_indexscan",
        "mergejoin":      "enable_mergejoin",
        "nestloop":       "enable_nestloop",
        "seqscan":        "enable_seqscan",
    }
    for short_opt in short_to_enable:
        pg_opt = short_to_enable[short_opt]
        if short_opt in chosen_short_opts:
            hints.append(f"SET {pg_opt} TO on")
        else:
            hints.append(f"SET {pg_opt} TO off")
    return hints

#------------------------------------------------------------------
# Main process: Read .sql files from a directory, execute each SQL with 49 different configurations,
# and record the execution time, query plan tree, and configuration hints for each arm.
#------------------------------------------------------------------

def process_sql_file(sql_file, conn):
    """
    读取单个 SQL 文件，针对 49 个不同配置（arm）执行 SQL 查询，
    并将每个 arm 的查询执行时间、查询计划树和配置提示写入指定目录下的文本文件中。
    """
    import json, os
    with open(sql_file, 'r', encoding='utf-8') as f:
        query = f.read().strip()
    print(f"Processing file: {sql_file}")
    results = []
    cur = conn.cursor()

    for arm_idx in range(len(_ARMS)):
        try:
            # 重置配置，确保环境干净
            cur.execute("RESET ALL")
            # 设置查询最大超时时间为600000 ms
            cur.execute(f"SET statement_timeout TO {TIMEOUT}")
            hints = _arm_idx_to_hints(arm_idx)
            for hint in hints:
                cur.execute(hint)
            # 构造 EXPLAIN ANALYZE 查询，使用 FORMAT JSON 得到结构化查询计划
            explain_query = "EXPLAIN (ANALYZE, FORMAT JSON) " + query
            print(f"  Executing arm {arm_idx} ...")
            cur.execute(explain_query)
            plan_result = cur.fetchall()
            cur.execute('DISCARD ALL;')

            # 取返回的第一行第一列（通常是 JSON 格式的查询计划）
            plan_json = plan_result[0][0] if plan_result else None
            if isinstance(plan_json, str):
                try:
                    plan_obj = json.loads(plan_json)
                except Exception as e:
                    plan_obj = f"JSON parse error: {e}"
                    exec_time = None
                else:
                    # 根据返回的 JSON 结构类型，提取执行时间
                    if isinstance(plan_obj, list) and len(plan_obj) > 0:
                        exec_time = plan_obj[0].get("Execution Time")
                    elif isinstance(plan_obj, dict):
                        exec_time = plan_obj.get("Execution Time")
                    else:
                        exec_time = None
            else:
                plan_obj = plan_json
                exec_time = plan_obj.get("Execution Time") if isinstance(plan_obj, dict) else None

        except Exception as e:
            error_msg = str(e)
            # 若报错信息包含超时提示，则设置执行时间为 TIMEOUT
            if "statement timeout" in error_msg:
                exec_time = TIMEOUT
            else:
                exec_time = TIMEOUT
            plan_obj = f"Query execution error: {e}"
            print(f"    Error: {e}")

        results.append({
            "arm": arm_idx,
            "execution_time": plan_obj[0].get("Execution Time") if isinstance(plan_obj, list) and len(plan_obj) > 0 else exec_time,
            "plan": plan_obj,
            "hints": hints
        })

    # 将结果写入指定目录下的文本文件
    output_dir = "/home/qihanzha/LLM4QO/src/bao_style_data_collector/stackoverflow_raw_exec_records"
    os.makedirs(output_dir, exist_ok=True)
    base_name = os.path.splitext(os.path.basename(sql_file))[0] + ".txt"
    output_file = os.path.join(output_dir, base_name)

    output_data = {
        "sql_file": os.path.basename(sql_file),
        "query": query,
        "results": results
    }
    with open(output_file, 'w', encoding='utf-8') as out_f:
        json.dump(output_data, out_f, indent=4, ensure_ascii=False)
    print(f"Results have been written to {output_file}")

def execute_all_sql_files(directory, conn):
    """
    遍历指定目录下所有 .sql 文件，并依次执行每个文件中的 SQL 查询。
    :param directory: 包含 SQL 文件的目录路径
    :param conn: 数据库连接对象
    """
    # 遍历目录中的所有文件
    for file_name in os.listdir(directory):
        # 仅处理以 .sql 结尾的文件（不区分大小写）
        if file_name.lower().endswith('.sql'):
            sql_file_path = os.path.join(directory, file_name)
            print(f"正在执行文件: {sql_file_path}")
            try:
                # 读取 SQL 文件内容
                with open(sql_file_path, 'r', encoding='utf-8') as f:
                    sql_query = f.read().strip()
                
                # 执行 SQL 查询
                cur = conn.cursor()
                cur.execute(sql_query)
                conn.commit()  # 如果 SQL 语句需要提交事务，则执行 commit
                cur.close()
                
                print(f"文件 {file_name} 执行成功")
            except Exception as e:
                print(f"执行文件 {file_name} 时出错: {e}")

def main():
    """
    Main function:
      1. Get the directory containing SQL files from command-line arguments.
      2. Connect to the PostgreSQL database (please modify connection parameters as needed).
      3. Iterate over all .sql files in the directory and process each one.
    """
    if len(sys.argv) < 2:
        print("Usage: python script.py <sql_files_directory>")
        sys.exit(1)
    sql_dir = sys.argv[1]
    if not os.path.isdir(sql_dir):
        print(f"Error: Directory {sql_dir} does not exist")
        sys.exit(1)

    # Modify the connection parameters as needed
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="soload",
            user="qihanzha",
            port="5438",
        )
        conn.autocommit = True
    except Exception as e:
        print(f"Failed to connect to the database: {e}")
        sys.exit(1)
        

    try:

        # 指定包含 SQL 文件的目录
        sql_files_directory = sys.argv[1]
        # warm up the database
        execute_all_sql_files(sql_files_directory, conn)
    except Exception as err:
        print(f"数据库连接错误: {err}")


    # Get all .sql files in the directory
    sql_files = glob.glob(os.path.join(sql_dir, "*.sql"))
    if not sql_files:
        print("No .sql files found in the directory")
        sys.exit(0)

    for sql_file in sql_files:
        process_sql_file(sql_file, conn)

    conn.close()
    print("All processing completed.")

if __name__ == "__main__":
    main()