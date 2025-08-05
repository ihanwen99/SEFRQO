import os
import re
import time
import subprocess
import json
import torch
import mysql.connector

from pymilvus import MilvusClient
from sentence_transformers import SentenceTransformer  
# from vllm import LLM, SamplingParams
from transformers import AutoTokenizer, AutoModelForCausalLM
from peft import PeftModel, PeftConfig

from utils_mysql.mysql_analyze_sql import analyze_sql
from utils_mysql.RAG_connection import keep_fastest_queries_by_sqlid, get_fastest_plan_by_sqlid, update_init_collection, get_next_id
from utils_mysql.notification import send_email
DATABASE_HOST = "127.0.0.1"
DATABASE_PORT = 3306
DATABASE_NAME = "imdbload"
DATABASE_USER = "your_username"
DATABASE_PASSWORD = "your_password"

print(f"Database host: {DATABASE_HOST}")
print(f"Database port: {DATABASE_PORT}")
print(f"Database name: {DATABASE_NAME}")
print(f"Database user: {DATABASE_USER}")

# 300 seconds 
DATABASE_TIMEOUT = 300000
print(f"Database timeout: {DATABASE_TIMEOUT}")

CONNECTION_INFO = {
        "host": DATABASE_HOST,
        "port": DATABASE_PORT,
        "database": DATABASE_NAME,
        "user": DATABASE_USER,
        "password": DATABASE_PASSWORD,
    }

DOMAIN_FILE = "/home/your_username/LLM4QO/src/local_llm_mysql/prompts/domain.nl"
INIT_VEC_QUERIES_DIR = "/home/your_username/LLM4QO/src/local_llm_mysql/prompts/IMDB_job_set_with_time.sql"
TEST_SQL_DIR = "/home/your_username/LLM4QO/sql/imdb_assorted_5_mysql"

print(f"Domain file: {DOMAIN_FILE}")
print(f"Initial vector queries directory: {INIT_VEC_QUERIES_DIR}")
print(f"Test SQL directory: {TEST_SQL_DIR}")

REAL_EXECUTION = False
ONLY_ORDER = True
DROP_CACHE = False
# set it to True if you want to use the reference queries
USE_REFERENCE = True
DELETE_VECTOR_AFTER_USE = True
USE_UPDATING_RAG = True
NUM_ITERATIONS = 50
# greater than or equal to 1
NUM_REFERENCE_QUERIES = 1

print(f"Real execution: {REAL_EXECUTION}")
print(f"Only order: {ONLY_ORDER}")
print(f"Drop cache: {DROP_CACHE}")
print(f"Use reference: {USE_REFERENCE}")
print(f"Delete vector after use: {DELETE_VECTOR_AFTER_USE}")
print(f"Use updating RAG: {USE_UPDATING_RAG}")
print(f"Number of iterations: {NUM_ITERATIONS}")
print(f"Number of reference queries: {NUM_REFERENCE_QUERIES}")

milvus_position = f"/home/your_username/LLM4QO/src/local_llm_mysql/online_records/{DATABASE_NAME}_online_vec.db"
model_milvus = SentenceTransformer('paraphrase-MiniLM-L6-v2')
client_milvus = MilvusClient(milvus_position)
encoding_model_dimension = 384
SQL_INIT_COLLECTION_NAME = "sql_init_collection"
SQL_ONLINE_COLLECTION_NAME = "sql_online_collection"
SQL_MYSQL_COLLECTION_NAME = "sql_mysql_collection"


local_model_name = "/home/your_username/LLM4QO/Apr13-8B-GRPO/checkpoint-100"
print(f"Model name: {local_model_name}")

# 载入基础模型并应用LoRA适配器
base_model_path = "/home/your_username/LLM4QO/latest-checkpoints-Apr5/8B-JOB-Apr2-ckpts/ckpt-1074"
print(f"Base model path: {base_model_path}")

# 检查路径是否存在
if not os.path.exists(base_model_path):
    print(f"警告：基础模型路径 {base_model_path} 不存在!")
    raise FileNotFoundError(f"基础模型路径 {base_model_path} 不存在")

# 列出基础模型目录中的文件
print(f"基础模型目录内容:")
for item in os.listdir(base_model_path):
    print(f"  - {item}")

# 载入tokenizer
local_tokenizer = AutoTokenizer.from_pretrained(
    base_model_path, 
    trust_remote_code=True,
    local_files_only=True  # 强制使用本地文件
)

# 载入基础模型
base_model = AutoModelForCausalLM.from_pretrained(
    base_model_path,
    trust_remote_code=True,
    torch_dtype="bfloat16",
    device_map="auto",
    local_files_only=True  # 强制使用本地文件
)

# 载入LoRA适配器
model = PeftModel.from_pretrained(base_model, local_model_name)
# 将模型设置为评估模式
model.eval()

# 定义生成函数，替代原来的pipeline
def generate_text(prompt, max_new_tokens=512, temperature=1.0):
    inputs = local_tokenizer(prompt, return_tensors="pt").to(model.device)
    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=max_new_tokens,
            temperature=temperature,
            do_sample=temperature > 0,
            pad_token_id=local_tokenizer.eos_token_id
        )
    return local_tokenizer.decode(outputs[0][inputs["input_ids"].shape[1]:], skip_special_tokens=True)

collections = client_milvus.list_collections() 
if f"{SQL_INIT_COLLECTION_NAME}" not in collections:
    print(f"Collection '{SQL_INIT_COLLECTION_NAME}' does not exist, initializing...")
    
    client_milvus.create_collection(
        collection_name=f"{SQL_INIT_COLLECTION_NAME}",
        dimension=encoding_model_dimension 
    )
    # 从文件中读取SQL查询内容，假设各个 entry 之间以空行分隔
    with open(INIT_VEC_QUERIES_DIR, 'r', encoding='utf-8') as file:
        data = file.read().split('\n\n')
    
    # 定义正则表达式来匹配:
    # 1. 第一行注释（形如 -- 01.sql），捕获文件名作为 id
    # 2. 第二行注释（形如 -- 3034.749），捕获原始执行计划时间（单位ms）
    # 3. 紧跟着的 block 注释（形如 /* ... */），捕获执行计划注释
    # 4. 后面的 SQL 语句部分
    pattern = re.compile(
        r"^\s*--\s*(\S+)\s*\n\s*--\s*([\d.]+)\s*\n\s*(/\*[\s\S]*?\*/)\s*(.+)$",
        re.DOTALL
    )
    
    sql_plan_pairs = []
    for entry in data:
        entry = entry.strip()
        if not entry:
            continue
        match = pattern.match(entry)
        if match:
            file_id = match.group(1).strip()              # 文件 id，如 "01.sql"
            execution_time = float(match.group(2).strip())  # 原始执行计划时间 ms，如 3034.749
            plan_comment = match.group(3).strip()           # 执行计划注释块，如 /*+ ... */
            sql_text = match.group(4).strip()               # SQL 语句部分
            sql_plan_pairs.append((file_id, sql_text, plan_comment, execution_time))
        else:
            print("Warning: entry does not match expected format, skipping:")
            print(entry)
    
    # 对每个 SQL 进行编码后插入到 Milvus 中，使用 file_id 作为标识，同时保存执行时间
    counter = 0
    for file_id, sql, plan, exec_time in sql_plan_pairs:
        vector = model_milvus.encode(sql).tolist()
        client_milvus.insert(
            collection_name=f"{SQL_INIT_COLLECTION_NAME}",
            data=[{
                "id": counter, 
                "iteration": 0, 
                "sqlid": file_id, 
                "vector": vector, 
                "sql": sql, 
                "plan": plan, 
                "execution_time": exec_time
            }]
        )
        counter += 1
    print(f"Milvus collection '{SQL_INIT_COLLECTION_NAME}' initialized.")
else:
    print(f"Collection '{SQL_INIT_COLLECTION_NAME}' already exists.")

# =====================================
# create online and postgres collections
# =====================================

if SQL_ONLINE_COLLECTION_NAME not in client_milvus.list_collections():
    print(f"Collection '{SQL_ONLINE_COLLECTION_NAME}' does not exist, initializing...")
    client_milvus.create_collection(
         collection_name=SQL_ONLINE_COLLECTION_NAME,
         dimension=encoding_model_dimension
    )
    print(f"Milvus collection '{SQL_ONLINE_COLLECTION_NAME}' initialized.")
else:
    print(f"Collection '{SQL_ONLINE_COLLECTION_NAME}' already exists.")


if SQL_MYSQL_COLLECTION_NAME not in client_milvus.list_collections():
    print(f"Collection '{SQL_MYSQL_COLLECTION_NAME}' does not exist, initializing...")
    client_milvus.create_collection(
         collection_name=SQL_MYSQL_COLLECTION_NAME,
         dimension=encoding_model_dimension
    )
    print(f"Milvus collection '{SQL_MYSQL_COLLECTION_NAME}' initialized.")
else:
    print(f"Collection '{SQL_MYSQL_COLLECTION_NAME}' already exists.")


def DropBufferCache():
    # WARNING: no effect if PG is running on another machine
    print("Dropping buffer cache")
    # Run 'free' and 'sync' separately
    subprocess.check_output(['free'])
    subprocess.check_output(['sync'])
    # Drop caches
    subprocess.check_output(
        ['sudo', 'sh', '-c', 'echo 3 > /proc/sys/vm/drop_caches'])
    # Show free memory again
    subprocess.check_output(['free'])
    print("Buffer cache dropped")
      
def read_single_sql_file(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()
    return content

def get_sql_files(directory):
    sql_files = {}
    for filename in os.listdir(directory):
        if filename.endswith(".sql"):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'r') as file:
                sql_files[filename] = file.read()
    return sql_files

def execute_sql(sql_query):
    """
    Executes EXPLAIN ANALYZE FORMAT=JSON in MySQL and extracts:
      - exec_time: actual execution time in milliseconds
      - join_order_hint: a MySQL JOIN_ORDER(...) hint
    """
    exec_time = 0.0
    join_order_hint = ""
    
    try:
        import mysql.connector
        import json
        import time

        # Connect to the database
        conn = mysql.connector.connect(
            host=DATABASE_HOST,
            database=DATABASE_NAME,
            user=DATABASE_USER,
            port=DATABASE_PORT,
            password=DATABASE_PASSWORD,
            autocommit=True
        )
        cur = conn.cursor()

        # Try to enable newer JSON format if available
        try:
            cur.execute("SET SESSION explain_json_format_version = 2;")
        except:
            pass  # Ignore if not supported

        # Set timeout
        try:
            cur.execute(f"SET SESSION max_execution_time = {DATABASE_TIMEOUT};")
        except:
            pass  # Ignore if not supported

        # Try EXPLAIN ANALYZE first, with fallback
        try:
            explain_sql = f"EXPLAIN ANALYZE FORMAT=JSON {sql_query}"
            cur.execute(explain_sql)
            row = cur.fetchone()
            
            if row and row[0]:
                data = json.loads(row[0])
                # Extract execution time in milliseconds
                exec_time = data.get("actual_last_row_ms", 0.0)
                # Extract join order using our helper
                join_order = extract_join_order_mysql(data)
                if join_order:
                    join_order_hint = f"/*+ JOIN_ORDER({', '.join(join_order)}) */"
                    
        except mysql.connector.Error as analyze_error:
            print(f"EXPLAIN ANALYZE failed: {analyze_error}")
            print("Falling back to EXPLAIN FORMAT=JSON + actual execution...")
            
            try:
                # Fallback: Use EXPLAIN FORMAT=JSON + actual execution
                explain_sql = f"EXPLAIN FORMAT=JSON {sql_query}"
                cur.execute(explain_sql)
                row = cur.fetchone()
                
                if row and row[0]:
                    data = json.loads(row[0])
                    # Extract join order from EXPLAIN
                    join_order = extract_join_order_mysql(data)
                    if join_order:
                        join_order_hint = f"/*+ JOIN_ORDER({', '.join(join_order)}) */"
                
                # Execute the actual query to get timing
                start_time = time.time()
                cur.execute(sql_query)
                cur.fetchall()  # Consume all results
                end_time = time.time()
                exec_time = (end_time - start_time) * 1000  # Convert to milliseconds
                
            except Exception as fallback_error:
                print(f"Fallback execution also failed: {fallback_error}")
                exec_time = 0.0
                join_order_hint = "/*+ Error in execution */"

    except Exception as e:
        print(f"Error while executing SQL: {e}")
        exec_time = 0.0
        join_order_hint = f"/*+ Error: {str(e)} */"

    finally:
        # Clean up
        try:
            cur.close()
            conn.close()
        except:
            pass

    return exec_time, join_order_hint


def extract_join_order_mysql(explain_data):
    """Extract JOIN order from MySQL EXPLAIN results"""
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

def get_mysql_hint(sql_query, connection_info, sql_id, print_dummy_join=False, real_execution=True, only_order=True):
    """
    Get MySQL join order hint by analyzing the query execution plan.
    
    Args:
        sql_query: SQL query string
        connection_info: Database connection parameters dict  
        sql_id: SQL query identifier for logging
        print_dummy_join: Whether to print debug information (not used)
        real_execution: If True, use EXPLAIN ANALYZE; if False, use EXPLAIN only
        only_order: If True, only return JOIN_ORDER hint (not used, always returns JOIN_ORDER)
        
    Returns:
        String containing MySQL JOIN_ORDER hint, e.g., "/*+ JOIN_ORDER(table1, table2, table3) */"
    """
    join_order_hint = ""
    
    try:
        import mysql.connector
        import json

        # Connect to the database using connection_info
        conn = mysql.connector.connect(
            host=connection_info.get('host', DATABASE_HOST),
            database=connection_info.get('database', DATABASE_NAME),
            user=connection_info.get('user', DATABASE_USER),
            port=connection_info.get('port', DATABASE_PORT),
            password=connection_info.get('password', DATABASE_PASSWORD),
            autocommit=True
        )
        cur = conn.cursor()

        # Try to enable newer JSON format if available
        try:
            cur.execute("SET SESSION explain_json_format_version = 2;")
        except:
            # If this fails, continue with default format
            pass

        # Choose EXPLAIN command based on real_execution parameter
        if real_execution:
            # Use EXPLAIN ANALYZE for actual execution (may fail on older MySQL versions)
            try:
                explain_sql = f"EXPLAIN ANALYZE FORMAT=JSON {sql_query}"
                cur.execute(explain_sql)
                row = cur.fetchone()
            except mysql.connector.Error:
                # Fallback to EXPLAIN FORMAT=JSON if EXPLAIN ANALYZE fails
                explain_sql = f"EXPLAIN FORMAT=JSON {sql_query}"
                cur.execute(explain_sql)
                row = cur.fetchone()
                # Also execute the query to simulate the analyze behavior
                try:
                    cur.execute(sql_query)
                    cur.fetchall()  # Consume results
                except:
                    pass  # If query execution fails, still return the plan
        else:
            # Use EXPLAIN FORMAT=JSON only (no actual execution)
            explain_sql = f"EXPLAIN FORMAT=JSON {sql_query}"
            cur.execute(explain_sql)
            row = cur.fetchone()

        if row and row[0]:
            data = json.loads(row[0])
            
            # Extract join order using the existing helper function
            join_order = extract_join_order_mysql(data)
            if join_order:
                join_order_hint = f"/*+ JOIN_ORDER({', '.join(join_order)}) */"
            else:
                join_order_hint = "/*+ No join order detected */"
        else:
            join_order_hint = "/*+ No JSON result returned */"

    except Exception as e:
        print(f"Error while getting MySQL hint for {sql_id}: {e}")
        join_order_hint = f"/*+ Error: {str(e)} */"

    finally:
        # Clean up
        try:
            cur.close()
            conn.close()
        except:
            pass

    return join_order_hint

def fill_mysql_collection(client_milvus, collection_name, model_milvus, keys, values):
    """
    For each SQL file, perform two rounds:
      1. First round: execute the SQL to warm up the cache.
      2. Second round: execute the SQL again using EXPLAIN ANALYZE FORMAT=JSON
         to obtain the execution plan and time, then compute the SQL text
         embedding and store the data in the Milvus collection.

    The stored data is a dictionary with the following keys:
      - "id": a unique identifier (counter)
      - "iteration": iteration number (1 for the explain round)
      - "sqlid": the SQL file name
      - "vector": the embedding vector of the SQL text
      - "sql": the SQL text
      - "plan": the MySQL join-order hint
      - "execution_time": the execution time in milliseconds

    Parameters:
      client_milvus:       Milvus client instance
      collection_name:     target Milvus collection name
      model_milvus:        SentenceTransformer model for encoding
      keys:                list of SQL file names (sqlid)
      values:              list of SQL statement strings
    """
    import time

    print("Starting first round of SQL execution (cache warm-up)...")
    for file_name, sql in zip(keys, values):
        # Just execute the plain SQL for warm-up
        try:
            import mysql.connector
            conn = mysql.connector.connect(
                host=DATABASE_HOST,
                database=DATABASE_NAME,
                user=DATABASE_USER,
                port=DATABASE_PORT,
                password=DATABASE_PASSWORD,
                autocommit=True
            )
            cur = conn.cursor()
            cur.execute(sql)
            cur.fetchall()  # Consume results
            cur.close()
            conn.close()
        except Exception as e:
            print(f"Warm-up execution failed for {file_name}: {e}")
        
        if DROP_CACHE:
            DropBufferCache()
            print("Buffer cache dropped.")
    print("First round of SQL execution completed.")

    # Short pause to minimize interference
    time.sleep(1)

    print("Starting second round of SQL execution and collecting results...")
    counter = 0
    for file_name, sql in zip(keys, values):
        # Compute embedding vector
        vector = model_milvus.encode(sql).tolist()

        # Execute the plain SQL query to get execution time and plan
        exec_time, plan_hint = execute_sql(sql)
        if DROP_CACHE:
            DropBufferCache()
            print("Buffer cache dropped.")

        if exec_time is None or plan_hint is None:
            print(f"Warning: SQL {file_name} returned no valid execution time or plan, skipping.")
            continue

        # Prepare the record for Milvus
        data_entry = {
            "id": counter,
            "iteration": 1,
            "sqlid": file_name,
            "vector": vector,
            "sql": sql,
            "plan": plan_hint,
            "execution_time": exec_time
        }

        client_milvus.insert(
            collection_name=collection_name,
            data=[data_entry]
        )
        print(f"SQL {file_name} (execution time {exec_time} ms) inserted into '{collection_name}'.")
        counter += 1

    print("MySQL collection filled successfully.")

def fill_mysql_collection_one_record(client_milvus, collection_name, model_milvus, key, value):
    """
    For a single SQL file, perform two rounds:
      1. First round: execute the SQL to warm up the cache.
      2. Second round: execute the SQL again using EXPLAIN ANALYZE FORMAT=JSON
         to obtain the execution plan and time, then compute the SQL text
         embedding and store the data in the Milvus collection.

    The stored data includes a unique ID (auto-incremented from max ID in collection).
    """
    import time

    print("Starting first round of SQL execution (cache warm-up)...")
    # Round 1: warm-up
    try:
        import mysql.connector
        conn = mysql.connector.connect(
            host=DATABASE_HOST,
            database=DATABASE_NAME,
            user=DATABASE_USER,
            port=DATABASE_PORT,
            password=DATABASE_PASSWORD,
            autocommit=True
        )
        cur = conn.cursor()
        cur.execute(value)
        cur.fetchall()  # Consume results
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Warm-up execution failed for {key}: {e}")
    
    if DROP_CACHE:
        DropBufferCache()
        print("Buffer cache dropped.")
    print("First round of SQL execution completed.")

    # Brief pause
    time.sleep(1)

    print("Starting second round of SQL execution and collecting results...")
    # Compute embedding vector
    vector = model_milvus.encode(value).tolist()
    # Round 2: explain & analyze
    exec_time, plan_hint = execute_sql(value)
    if DROP_CACHE:
        DropBufferCache()
        print("Buffer cache dropped.")

    if exec_time is None or plan_hint is None:
        print(f"Warning: SQL {key} did not return a valid execution time or plan, skipping.")
        return

    # Determine next ID in the collection
    new_id = get_next_id(client_milvus, collection_name)

    # Prepare the record
    data_entry = {
        "id": new_id,
        "iteration": 1,
        "sqlid": key,
        "vector": vector,
        "sql": value,
        "plan": plan_hint,
        "execution_time": exec_time
    }

    # Insert into Milvus
    client_milvus.insert(
        collection_name=collection_name,
        data=[data_entry]
    )
    print(f"Inserted SQL {key} (execution time {exec_time} ms) into '{collection_name}' with ID {new_id}.")
    print("MySQL collection updated successfully for one record.")

# Main process
directory = TEST_SQL_DIR
sql_files = get_sql_files(directory)
number_of_questions = len(sql_files)
keys = list(sql_files.keys())
values = list(sql_files.values())

assert number_of_questions > 0, "The number of questions should be greater than 0"



online_counter = 0 
for current_iteration in range(NUM_ITERATIONS):
    if current_iteration == 0:
        fill_mysql_collection(client_milvus, SQL_MYSQL_COLLECTION_NAME, model_milvus, keys, values)
        continue
    
    print(f"=========Processing iteration {current_iteration+1}=========\n")
    for i in range(1, number_of_questions+1):
        print(f"=========Processing question {keys[i-1]}=========\n")
        milvus_res = []
        milvus_res_envs = []

        # get the SQL query, encode it and insert into Milvus
        sql_query = values[i-1]
        new_vector = model_milvus.encode(sql_query).tolist()
            
        # find the similar SQL query in Milvus
        filter_expr = f"sqlid != '{keys[i-1]}'"
        res = client_milvus.search(
            collection_name=f"{SQL_INIT_COLLECTION_NAME}",
            data=[new_vector],
            limit=NUM_REFERENCE_QUERIES,
            output_fields=["sql", "plan", "sqlid"],
            filter=filter_expr,
        )

        for result in res[0]: 
            # Since for MySQL we only support join order hint, we only need to return the plan
            milvus_res.append(result['entity']['plan'])
            
            milvus_res_envs.append(analyze_sql(result['entity']['sql'],CONNECTION_INFO,REAL_EXECUTION,result['entity']['sqlid']))

        sql_query_original = sql_query

        with open(DOMAIN_FILE, "r") as file:
            domain_nl = file.read()

        # messages = [{"role": "system", "content": domain_nl}]
        # FIXME try do not use system prompt
        messages = []

        question_nl = analyze_sql(sql_query,CONNECTION_INFO,REAL_EXECUTION,keys[i-1])
        
        if USE_REFERENCE:
            if current_iteration == 1:
                combined_query = f"## Here is {NUM_REFERENCE_QUERIES} similar query-answer pairs you can reference:\n"
                for j in range(NUM_REFERENCE_QUERIES):
                    combined_query += milvus_res_envs[j] + "\nThe optimal hint:\n" + milvus_res[j] + "\n"
                
                mysql_hint = get_mysql_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                
                combined_query += (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by MySQL: \n{mysql_hint}\n"
                "## Please provide a better hint in the same format as MySQL's. Return ONLY the final SQL hint. "
                "DO NOT USE THE SAME HINT AS THE MySQL HINT.\n"
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS."
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ JOIN_ORDER(a, c, b, d) */\n"
                "Invalid hint (duplicate table): /*+ JOIN_ORDER(a, a, b, c, d) */\n"
                "Invalid hint (missing table): /*+ JOIN_ORDER(a, c, d) */\n"
                "Invalid hint (forget the keyword): /*+ (a, c, b, d) */\n"
                )
            else:
                # we also need to get the current best hint from the online collection, and use it as part of the prompt
                best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
                if best_online_record_hint is None:
                    best_online_record_hint = "NOT FOUND"
                _, mysql_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_MYSQL_COLLECTION_NAME}", keys[i-1])
                if mysql_time == 0:
                    # Qihan: add this to fill the mysql collection
                    fill_mysql_collection_one_record(client_milvus, SQL_MYSQL_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
              
                mysql_hint = get_mysql_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                if mysql_time == 0 or best_online_record_time == 0:
                    performance_gain = "UNKNOWN"
                else:    
                    performance_gain = (mysql_time - best_online_record_time) / mysql_time * 100
                gain_str = f"{performance_gain:.3f}%" if isinstance(performance_gain, (int, float)) else performance_gain
                             
                
                combined_query = f"## Here is {NUM_REFERENCE_QUERIES} similar query-answer pairs you can reference:\n"
                for j in range(NUM_REFERENCE_QUERIES):
                    combined_query += milvus_res_envs[j] + "\nThe optimal hint:\n" + milvus_res[j] + "\n"
                
                combined_query += (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by MySQL: \n{mysql_hint}\n"
                f"The current best hint provided by LLM: \n{best_online_record_hint}\n"
                f"The current performance gain is {gain_str}\n"
                "If the performance gain is negative, it means that the current LLM-generated plan is inferior to the MySQL plan.\n"
                "## Please generate a different hint that at least meets or exceeds their best performance in the same format. Return ONLY the final SQL hint."
                "DO NOT USE THE SAME HINT AS THE CURRENT BEST HINT or MySQL HINT.\n"
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS."
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ JOIN_ORDER(a, c, b, d) */\n"
                "Invalid hint (duplicate table): /*+ JOIN_ORDER(a, a, b, c, d) */\n"
                "Invalid hint (missing table): /*+ JOIN_ORDER(a, c, d) */\n"
                "Invalid hint (forget the keyword): /*+ (a, c, b, d) */\n"
                )
        
        else: 
            if current_iteration == 1:
                
                mysql_hint = get_mysql_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                
                combined_query = (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by MySQL: \n{mysql_hint}\n"
                "## Please provide a better hint in the same format as MySQL's. Return ONLY the final SQL hint. "
                "DO NOT USE THE SAME HINT AS THE MySQL HINT.\n"
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS."
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ JOIN_ORDER(a, c, b, d) */\n"
                "Invalid hint (duplicate table): /*+ JOIN_ORDER(a, a, b, c, d) */\n"
                "Invalid hint (missing table): /*+ JOIN_ORDER(a, c, d) */\n"
                "Invalid hint (forget the keyword): /*+ (a, c, b, d) */\n"
                )
            else:
                # we also need to get the current best hint from the online collection, and use it as part of the prompt
                best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
                if best_online_record_hint is None:
                    best_online_record_hint = "NOT FOUND"               
                _, mysql_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_MYSQL_COLLECTION_NAME}", keys[i-1])
                if mysql_time == 0:
                    # Qihan: add this to fill the mysql collection
                    fill_mysql_collection_one_record(client_milvus, SQL_MYSQL_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
               
                mysql_hint = get_mysql_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                if mysql_time == 0 or best_online_record_time == 0:
                    performance_gain = "UNKNOWN"
                else:
                    performance_gain = (mysql_time - best_online_record_time) / mysql_time * 100
              
                gain_str = f"{performance_gain:.3f}%" if isinstance(performance_gain, (int, float)) else performance_gain
                    
                combined_query = (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by MySQL: \n{mysql_hint}\n"
                f"The current best hint provided by LLM: \n{best_online_record_hint}\n"
                f"The current performance gain is {gain_str}\n"
                "If the performance gain is negative, it means that the current LLM-generated plan is inferior to the MySQL plan.\n"
                "## Please generate a hint that at least meets or exceeds their best performance in the same format. Return ONLY the final SQL hint."
                "DO NOT USE THE SAME HINT AS THE CURRENT BEST HINT or MySQL HINT.\n"
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS."
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ JOIN_ORDER(a, c, b, d) */\n"
                "Invalid hint (duplicate table): /*+ JOIN_ORDER(a, a, b, c, d) */\n"
                "Invalid hint (missing table): /*+ JOIN_ORDER(a, c, d) */\n"
                "Invalid hint (forget the keyword): /*+ (a, c, b, d) */\n"
                )
              
        messages.append({"role": "user", "content": combined_query})
        after_template_messages = local_tokenizer.apply_chat_template(messages, add_generation_prompt=True, tokenize=False)
        
        # 使用自定义的生成函数替代pipeline
        action_sequence = generate_text(after_template_messages, max_new_tokens=512, temperature=1.0)
        action_sequence = action_sequence.strip()

        print(f"The hint for question {keys[i-1]} given by LLM is: \n{action_sequence}\n")

        # Parse and execute the LLM-generated hint
        # try:
        #     # Check if the action_sequence already contains hint syntax
        #     if action_sequence.strip().startswith("/*+") and action_sequence.strip().endswith("*/"):
        #         # Already properly formatted
        #         hint_to_use = action_sequence.strip()
        #     else:
        #         # Try to extract JOIN_ORDER from the action_sequence
        #         import re
        #         join_order_match = re.search(r'JOIN_ORDER\([^)]+\)', action_sequence)
        #         if join_order_match:
        #             hint_to_use = f"/*+ {join_order_match.group(0)} */"
        #         else:
        #             # Fallback: try to use the sequence as-is
        #             hint_to_use = f"/*+ {action_sequence.strip()} */"
            
        #     print(f"Formatted hint for question {keys[i-1]}: {hint_to_use}")
            
        #     # Apply hint to original SQL query (MySQL syntax)
        #     sql_query_hinted = hint_to_use + "\n" + sql_query_original
            
        # except Exception as e:
        #     print(f"Error formatting hint: {e}")
        #     print("Using original SQL without hint")
        #     sql_query_hinted = sql_query_original
        #     hint_to_use = "NO HINT"
   
   
   


        # Extract the Leading(...) line from the LLM output
        leading_match = re.search(r'Leading\((.*)\)', action_sequence, re.DOTALL)
        if leading_match:
            # 1. 原文顺序抽表名，去重保序
            tokens = re.findall(r'[A-Za-z_][A-Za-z0-9_]*', leading_match.group(1))
            seen = set()
            join_order = []
            for tok in tokens:
                if tok not in seen:
                    seen.add(tok)
                    join_order.append(tok)

            # 2. 直接用原序列拼 hint
            hint_to_use = f"/*+ JOIN_ORDER({', '.join(join_order)}) */"

            # 3. 注入到 SELECT 后
            sql_query_hinted = re.sub(
                r'(?i)\bSELECT\b',
                f"SELECT {hint_to_use}",
                sql_query_original,
                count=1
            )
        else:
            hint_to_use = "/*+ NO_LEADING_HINT_FOUND */"
            sql_query_hinted = sql_query_original

        print(f"Formatted hint: {hint_to_use}")
 
        
        if DROP_CACHE:
            DropBufferCache()
            
        # Execute the SQL query with hints
        print(f"Executing SQL query {keys[i-1]} with hints...")
        exec_time, real_hint = execute_sql(sql_query_hinted)
        print(f"Execution time: {exec_time} ms")
        print(f"Detected join order: {real_hint}")
        print()
        
        online_record = {
            "id": online_counter,
            "iteration": current_iteration+1,
            "sqlid": keys[i-1],
            "vector": new_vector,
            "sql": sql_query_original,
            "plan": hint_to_use,
            "execution_time": exec_time
        }
        
        client_milvus.insert(
            collection_name=SQL_ONLINE_COLLECTION_NAME,
            data=[online_record]
        )
        online_counter += 1
        print(f"Inserted online execution result for question {keys[i-1]} into Milvus collection '{SQL_ONLINE_COLLECTION_NAME}'.\n")
        
        # Performance comparison
        _, mysql_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_MYSQL_COLLECTION_NAME}", keys[i-1])
        if mysql_time == 0:
            # Fill the mysql collection if needed
            fill_mysql_collection_one_record(client_milvus, SQL_MYSQL_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
            _, mysql_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_MYSQL_COLLECTION_NAME}", keys[i-1])
     
        mysql_hint = get_mysql_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False, real_execution=REAL_EXECUTION, only_order=ONLY_ORDER)
        best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
        print(f"MySQL execution plan ({mysql_time} ms) for question {keys[i-1]} is \n{mysql_hint}\n")
        
        if current_iteration == NUM_ITERATIONS - 1:
            print(f"Final LLM generated optimal execution plan ({best_online_record_time} ms) for question {keys[i-1]} is \n{best_online_record_hint}\n")
            if mysql_time == 0:
                print(f"The final performance gain is UNKNOWN\n")
            else:
                print(f"The final performance gain is {mysql_time - best_online_record_time} / {mysql_time} = {((mysql_time - best_online_record_time) / mysql_time * 100):.3f}%\n")
        else:
            if best_online_record_time == 0:
                print(f"The current LLM generated optimal execution plan is UNKNOWN\n")
            else:
                print(f"Current LLM generated optimal execution plan ({best_online_record_time} ms) for question {keys[i-1]} is \n{best_online_record_hint}\n")
            if mysql_time == 0:
                print(f"The current performance gain is UNKNOWN\n")
            else:
                print(f"The current performance gain is {mysql_time - best_online_record_time} / {mysql_time} = {((mysql_time - best_online_record_time) / mysql_time * 100):.3f}%\n")
 
        # Compare the mysql_hint and best_online_record_hint
        if best_online_record_hint is None or best_online_record_hint == "NOT FOUND" or mysql_hint.strip() == best_online_record_hint.strip():
            print(f"The final/current LLM generated optimal execution plan for question {keys[i-1]} is the same as the MySQL execution plan\n")
        else:
            print(f"The final/current LLM generated optimal execution plan for question {keys[i-1]} is different from the MySQL execution plan\n")

        

    # Keep only the optimal records for each sqlid each iteration
    keep_fastest_queries_by_sqlid(milvus_position, SQL_ONLINE_COLLECTION_NAME)
    if USE_UPDATING_RAG:
        update_init_collection(milvus_position, SQL_INIT_COLLECTION_NAME, SQL_MYSQL_COLLECTION_NAME, SQL_ONLINE_COLLECTION_NAME)
    
    if (current_iteration+ 1) % 5 == 0:
        send_email("llmqo LOCAL Experiment test1", f"The experiment of imdbload finished! The iteration is {current_iteration + 1}", "your_email@example.com")

if DELETE_VECTOR_AFTER_USE:
    # delete the file after use milvus_position
    os.remove(milvus_position)
    print("The file has been deleted successfully")


