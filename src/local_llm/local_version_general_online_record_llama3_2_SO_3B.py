import os
import re
import time
import subprocess
import psycopg2
import json

from pymilvus import MilvusClient
from sentence_transformers import SentenceTransformer  
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

from unsloth import FastLanguageModel
from unsloth.chat_templates import get_chat_template


from utils.notification import send_email

from utils.translation_sql_2_nlenv_new import analyze_sql
from utils.get_postgres_hint import get_postgres_hint,extract_sql_hint_from_text_chunk,print_plan_bracket,extract_hint_block
from utils.check_hint_validity import is_bushy_hint_reasonable
from utils.RAG_connection import keep_fastest_queries_by_sqlid, get_fastest_plan_by_sqlid, update_init_collection, get_next_id

DATABASE_HOST = "localhost"
DATABASE_PORT = 5432
DATABASE_NAME = "soload"
DATABASE_USER = "your_username"

print(f"Database host: {DATABASE_HOST}")
print(f"Database port: {DATABASE_PORT}")
print(f"Database name: {DATABASE_NAME}")
print(f"Database user: {DATABASE_USER}")

# 30 seconds 
DATABASE_TIMEOUT = 30000

print(f"Database timeout: {DATABASE_TIMEOUT}")


CONNECTION_INFO = {
        "host": DATABASE_HOST,
        "port": DATABASE_PORT,
        "database": DATABASE_NAME,
        "user": DATABASE_USER,
    }

DOMAIN_FILE = "/home/your_username/LLM4QO/src/local_llm/prompts/SO/domain.nl"
INIT_VEC_QUERIES_DIR = "/home/your_username/LLM4QO/src/local_llm/prompts/SO/so_within_transfer_original_with_time.sql"
TEST_SQL_DIR = "/home/your_username/LLM4QO/sql/so_assorted"

print(f"Domain file: {DOMAIN_FILE}")
print(f"Initial vector queries directory: {INIT_VEC_QUERIES_DIR}")
print(f"Test SQL directory: {TEST_SQL_DIR}")

REAL_EXECUTION = False
ONLY_ORDER = False
DROP_CACHE = False
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

milvus_position = f"/home/your_username/LLM4QO/src/local_llm/online_records/{DATABASE_NAME}_online_vec.db"
model_milvus = SentenceTransformer('paraphrase-MiniLM-L6-v2')
client_milvus = MilvusClient(milvus_position)
encoding_model_dimension = 384
SQL_INIT_COLLECTION_NAME = "sql_init_collection"
SQL_ONLINE_COLLECTION_NAME = "sql_online_collection"
SQL_POSTGRES_COLLECTION_NAME = "sql_postgres_collection"



local_model_name = "unsloth/Llama-3.2-3B-Instruct-unsloth-bnb-4bit"
print(f"Model name: {local_model_name}")

# load tokenizer
local_tokenizer = AutoTokenizer.from_pretrained(local_model_name, trust_remote_code=True)

# load model with bitsandbytes for 4bit quantization
model = AutoModelForCausalLM.from_pretrained(
    local_model_name,
    device_map="auto",
    torch_dtype=torch.bfloat16,
    trust_remote_code=True
)
model.eval()

# define the generation function
def generate_response(messages, max_new_tokens=512, temperature=1.0):
    # prepare the input
    inputs = local_tokenizer.apply_chat_template(
        messages,
        add_generation_prompt=True,
        return_tensors="pt"
    ).to(model.device)
    
    # generate the response
    with torch.no_grad():
        outputs = model.generate(
            inputs,
            max_new_tokens=max_new_tokens,
            temperature=temperature,
            do_sample=temperature > 0,
            pad_token_id=local_tokenizer.eos_token_id
        )
    
    # decode and return the generated text
    response = local_tokenizer.decode(outputs[0][inputs.shape[1]:], skip_special_tokens=True)
    return response.strip()

collections = client_milvus.list_collections() 
if f"{SQL_INIT_COLLECTION_NAME}" not in collections:
    print(f"Collection '{SQL_INIT_COLLECTION_NAME}' does not exist, initializing...")
    
    client_milvus.create_collection(
        collection_name=f"{SQL_INIT_COLLECTION_NAME}",
        dimension=encoding_model_dimension 
    )
    # read the SQL query content from the file, assuming each entry is separated by an empty line
    with open(INIT_VEC_QUERIES_DIR, 'r', encoding='utf-8') as file:
        data = file.read().split('\n\n')
    
    # define the regex to match:
    # 1. the first line comment (e.g. -- 01.sql), capture the file name as id
    # 2. the second line comment (e.g. -- 3034.749), capture the original execution plan time (unit: ms)
    # 3. the following block comment (e.g. /* ... */), capture the execution plan comment
    # 4. the following SQL statement part
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
            file_id = match.group(1).strip()              # file id, e.g. "01.sql"
            execution_time = float(match.group(2).strip())  # original execution plan time (unit: ms), e.g. 3034.749
            plan_comment = match.group(3).strip()           # execution plan comment block, e.g. /*+ ... */
            sql_text = match.group(4).strip()               # SQL statement part
            sql_plan_pairs.append((file_id, sql_text, plan_comment, execution_time))
        else:
            print("Warning: entry does not match expected format, skipping:")
            print(entry)
    
    # encode each SQL and insert into Milvus,s using file_id as identifier, and save the execution time
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


if SQL_POSTGRES_COLLECTION_NAME not in client_milvus.list_collections():
    print(f"Collection '{SQL_POSTGRES_COLLECTION_NAME}' does not exist, initializing...")
    client_milvus.create_collection(
         collection_name=SQL_POSTGRES_COLLECTION_NAME,
         dimension=encoding_model_dimension
    )
    print(f"Milvus collection '{SQL_POSTGRES_COLLECTION_NAME}' initialized.")
else:
    print(f"Collection '{SQL_POSTGRES_COLLECTION_NAME}' already exists.")


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

def execute_sql(sql_query, print_dummy_join=False, only_order=False):
    """
    Executes an SQL query that already includes EXPLAIN (ANALYZE, FORMAT JSON),
    extracts the execution time from the returned JSON, and generates a bracket-style query plan hint.
    
    Parameters:
      sql_query: The SQL statement that includes EXPLAIN (ANALYZE, FORMAT JSON)
      print_dummy_join: Whether to include DummyJoin nodes in the bracket hint

    Returns:
      (execution_time, bracket_plan)
        execution_time: Query execution time in milliseconds; if timeout occurs, returns DATABASE_TIMEOUT.
        bracket_plan: Bracket-style query plan hint as a string
    """
    exec_time = None
    bracket_plan = None
    connection = None
    cursor = None
    try:
        connection = psycopg2.connect(
            host=DATABASE_HOST,      
            database=DATABASE_NAME,    
            user=DATABASE_USER,
            port=DATABASE_PORT,
        )
        connection.autocommit = True  
        cursor = connection.cursor()
        cursor.execute(f"SET statement_timeout = {DATABASE_TIMEOUT};")
        cursor.execute("load 'pg_hint_plan';")
        
        # Execute the SQL query that includes EXPLAIN (ANALYZE, FORMAT JSON)
        cursor.execute(sql_query)
        result = cursor.fetchone()
        cursor.execute('DISCARD ALL;')
        
        if result is not None:
            json_data = result[0]
            if isinstance(json_data, str):
                json_data = json.loads(json_data)
            # The EXPLAIN result is generally a list containing a single dictionary
            if isinstance(json_data, list) and len(json_data) > 0:
                exec_time = json_data[0].get("Execution Time")
                plan_json_str = json.dumps(json_data[0])
                bracket_plan = print_plan_bracket(plan_json_str, print_dummy_join=print_dummy_join, only_order=only_order)
            else:
                print("Unexpected JSON structure:", json_data)
        else:
            print("No result returned from query execution")
    except psycopg2.extensions.QueryCanceledError as e:
        # Query timeout
        print(f"Query timed out: {e}")
        exec_time = DATABASE_TIMEOUT
    except Exception as error:
        print(f"Error: {error}")
    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None:
            connection.close()
    
    # if exec_time is None, set it to DATABASE_TIMEOUT
    if exec_time is None:
        exec_time = DATABASE_TIMEOUT
        
    return exec_time, bracket_plan

def fill_postgres_collection(client_milvus, collection_name, model_milvus, keys, values):
    """
    For each SQL file, perform two rounds:
      1. First round: Execute the SQL to warm up the cache.
      2. Second round: Execute the SQL again using EXPLAIN (ANALYZE, FORMAT JSON) to obtain the execution plan and time,
         then compute the SQL text embedding and store the data in the Milvus collection.
    
    The stored data is a dictionary with the following keys:
      - "id": a unique identifier (counter),
      - "iteration": iteration number (0),
      - "sqlid": the SQL file name,
      - "vector": the embedding vector of the SQL text,
      - "sql": the SQL text,
      - "plan": the execution plan (bracket-style hint),
      - "execution_time": the execution time in milliseconds.
    
    Parameters:
      client_milvus: The Milvus client instance.
      collection_name: The target Milvus collection name (e.g., original_postgres_collection_name).
      model_milvus: The SentenceTransformer model used to encode SQL text.
      keys: A list of SQL file names, used as sqlid.
      values: A list of SQL statement strings.
    """
    print("Starting first round of SQL execution (cache warm-up)...")
    # First round: Execute all SQL statements (for warming up the cache)
    for file_name, sql in zip(keys, values):
        # If the SQL does not contain EXPLAIN, prepend EXPLAIN clause
        if "EXPLAIN" not in sql.upper():
            sql_query = "EXPLAIN (ANALYZE, FORMAT JSON) " + sql
        else:
            sql_query = sql
        # Execute the SQL without processing the results
        execute_sql(sql_query)
        if DROP_CACHE:
            DropBufferCache()
            print("Buffer cache dropped.")
    print("First round of SQL execution completed.")
    
    # Wait briefly to ensure minimal interference
    time.sleep(1)
    
    print("Starting second round of SQL execution and collecting results...")
    counter = 0
    for file_name, sql in zip(keys, values):
        # Encode the SQL text into a vector using the SentenceTransformer model
        vector = model_milvus.encode(sql).tolist()
        # Ensure the SQL query includes the EXPLAIN clause
        if "EXPLAIN" not in sql.upper():
            sql_query = "EXPLAIN (ANALYZE, FORMAT JSON) " + sql
        else:
            sql_query = sql
        
        # Execute the SQL and retrieve the execution time and bracket-style plan hint
        exec_time, plan = execute_sql(sql_query, only_order=ONLY_ORDER)
        if DROP_CACHE:
            DropBufferCache()
            print("Buffer cache dropped.")
            
        if exec_time is None or plan is None:
            print(f"Warning: SQL {file_name} did not return a valid execution time or plan, skipping.")
            continue
        
        # Construct the data dictionary to be inserted into Milvus
        data_entry = {
            "id": counter,
            "iteration": 1,
            "sqlid": file_name,
            "vector": vector,
            "sql": sql,
            "plan": plan,
            "execution_time": exec_time
        }
        
        client_milvus.insert(
            collection_name=collection_name,
            data=[data_entry]
        )
        print(f"SQL {file_name} (execution time {exec_time} ms) inserted into collection '{collection_name}'.")
        counter += 1
    print("Postgres collection filled successfully.")

def fill_postgres_collection_one_record(client_milvus, collection_name, model_milvus, key, value):
    """
    For a single SQL file, perform two rounds:
      1. First round: Execute the SQL to warm up the cache.
      2. Second round: Execute the SQL again using EXPLAIN (ANALYZE, FORMAT JSON) to obtain the execution plan and time,
         then compute the SQL text embedding and store the data in the Milvus collection.

    The stored data includes a unique ID (auto-incremented from max ID in collection).
    """
    print("Starting first round of SQL execution (cache warm-up)...")
    # First round: Execute the SQL to warm up the cache
    if "EXPLAIN" not in value.upper():
        sql_query = "EXPLAIN (ANALYZE, FORMAT JSON) " + value
    else:
        sql_query = value
    execute_sql(sql_query)
    if DROP_CACHE:
        DropBufferCache()
        print("Buffer cache dropped.")
    print("First round of SQL execution completed.")

    # Wait briefly to ensure minimal interference
    time.sleep(1)

    print("Starting second round of SQL execution and collecting results...")
    vector = model_milvus.encode(value).tolist()
    if "EXPLAIN" not in value.upper():
        sql_query = "EXPLAIN (ANALYZE, FORMAT JSON) " + value
    else:
        sql_query = value

    exec_time, plan = execute_sql(sql_query, only_order=ONLY_ORDER)
    if DROP_CACHE:
        DropBufferCache()
        print("Buffer cache dropped.")

    if exec_time is None or plan is None:
        print(f"Warning: SQL {key} did not return a valid execution time or plan, skipping.")
        return

    # Get next available ID
    new_id = get_next_id(client_milvus, collection_name)

    data_entry = {
        "id": new_id,
        "iteration": 1,
        "sqlid": key,
        "vector": vector,
        "sql": value,
        "plan": plan,
        "execution_time": exec_time
    }

    client_milvus.insert(
        collection_name=collection_name,
        data=[data_entry]
    )
    print(f"A new SQL {key} (execution time {exec_time} ms) inserted into collection '{collection_name}' with ID {new_id}.")
    print("Postgres collection filled a new query successfully.")

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
        fill_postgres_collection(client_milvus, SQL_POSTGRES_COLLECTION_NAME, model_milvus, keys, values)
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
            if ONLY_ORDER:
                original_plan = result['entity']['plan']
                leading_line = None
                # Extract the Leading hint line from the original plan
                for line in original_plan.splitlines():
                    stripped_line = line.strip()
                    if stripped_line.startswith("Leading("):
                        leading_line = stripped_line
                        break
                if leading_line is not None:
                    new_plan = "/*+ \n" + leading_line  # Do not add the closing " */"
                else:
                    # If no Leading hint is found, fallback to the original plan
                    new_plan = original_plan
                milvus_res.append(new_plan)
            else:
                milvus_res.append(result['entity']['plan'])
            milvus_res_envs.append(analyze_sql(result['entity']['sql'],CONNECTION_INFO,REAL_EXECUTION,result['entity']['sqlid']))

        sql_query_original = sql_query

        with open(DOMAIN_FILE, "r") as file:
            domain_nl = file.read()

        messages = [{"role": "system", "content": domain_nl}]

        question_nl = analyze_sql(sql_query,CONNECTION_INFO,REAL_EXECUTION,keys[i-1])
        
        if USE_REFERENCE:
            if current_iteration == 1:
                combined_query = f"## Here is {NUM_REFERENCE_QUERIES} similar query-answer pairs you can reference:\n"
                for j in range(NUM_REFERENCE_QUERIES):
                    combined_query += milvus_res_envs[j] + "\nThe optimal hint:\n" + milvus_res[j] + "\n"
                
                postgres_hint = get_postgres_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                
                combined_query += (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by Postgres: \n{postgres_hint}\n"
                "## Please provide a better hint in the same format as Postgres's. Return ONLY the final SQL hint"
                "DO NOT USE THE SAME HINT AS THE Postgres HINT.\n"
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS. IMPORTANT: The hint must include an extra outer pair of parentheses in the Leading clause, and the brackets should match. "
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ Leading((((a b) c) d)) */\n"
                "Invalid hint (missing extra outer parentheses): /*+ Leading(((a b) c) d) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((((a b) c) d)) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((a b) c) d)) */\n"
                )
            else:
                # we also need to get the current best hint from the online collection, and use it as part of the prompt
                best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
                if best_online_record_hint is None:
                    best_online_record_hint = "NOT FOUND"
                _, postgres_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_POSTGRES_COLLECTION_NAME}", keys[i-1])
                if postgres_time == 0:
                    # Qihan: add this to fill the postgres collection
                    fill_postgres_collection_one_record(client_milvus, SQL_POSTGRES_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
              
                postgres_hint = get_postgres_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                if postgres_time == 0 or best_online_record_time == 0:
                    performance_gain = "UNKNOWN"
                else:
                    performance_gain = (postgres_time - best_online_record_time) / postgres_time * 100
                gain_str = f"{performance_gain:.3f}%" if isinstance(performance_gain, (int, float)) else performance_gain
                             
                combined_query = f"## Here is {NUM_REFERENCE_QUERIES} similar query-answer pairs you can reference:\n"
                for j in range(NUM_REFERENCE_QUERIES):
                    combined_query += milvus_res_envs[j] + "\nThe optimal hint:\n" + milvus_res[j] + "\n"
                
                combined_query += (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by Postgres: \n{postgres_hint}\n"
                f"The current best hint provided by LLM: \n{best_online_record_hint}\n"
                f"The current performance gain is {gain_str}\n"
                "If the performance gain is negative, it means that the current LLM-generated plan is inferior to the Postgres plan.\n"
                "## Please generate a different hint that at least meets or exceeds their best performance in the same format. Return ONLY the final SQL hint."
                "DO NOT USE THE SAME HINT AS THE CURRENT BEST HINT or Postgres HINT.\n"                
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS. IMPORTANT: The hint must include an extra outer pair of parentheses in the Leading clause, and the brackets should match. "
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ Leading((((a b) c) d)) */\n"
                "Invalid hint (missing extra outer parentheses): /*+ Leading(((a b) c) d) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((((a b) c) d)) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((a b) c) d)) */\n"
                )
        
        else: 
            if current_iteration == 1:
                
                postgres_hint = get_postgres_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                
                combined_query = (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by Postgres: \n{postgres_hint}\n"
                "## Please provide a better hint in the same format as Postgres's. Return ONLY the final SQL hint. "
                "DO NOT USE THE SAME HINT AS THE Postgres HINT.\n"                                
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS. IMPORTANT: The hint must include an extra outer pair of parentheses in the Leading clause, and the brackets should match. "
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ Leading((((a b) c) d)) */\n"
                "Invalid hint (missing extra outer parentheses): /*+ Leading(((a b) c) d) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((((a b) c) d)) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((a b) c) d)) */\n"
                )
            else:
                # we also need to get the current best hint from the online collection, and use it as part of the prompt
                best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
                if best_online_record_hint is None:
                    best_online_record_hint = "NOT FOUND"
                _, postgres_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_POSTGRES_COLLECTION_NAME}", keys[i-1])
                if postgres_time == 0:
                    # Qihan: add this to fill the postgres collection
                    fill_postgres_collection_one_record(client_milvus, SQL_POSTGRES_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
              
                postgres_hint = get_postgres_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
                if postgres_time == 0 or best_online_record_time == 0:
                    performance_gain = "UNKNOWN"
                else:
                    performance_gain = (postgres_time - best_online_record_time) / postgres_time * 100
                gain_str = f"{performance_gain:.3f}%" if isinstance(performance_gain, (int, float)) else performance_gain
                           
                combined_query = (
                f"## Here is the query and its corresponding statistics: \n{question_nl}\n"
                f"The hint provided by Postgres: \n{postgres_hint}\n"
                f"The current best hint provided by LLM: \n{best_online_record_hint}\n"
                f"The current performance gain is {gain_str}\n"
                "If the performance gain is negative, it means that the current LLM-generated plan is inferior to the Postgres plan.\n"
                "## Please generate a hint that at least meets or exceeds their best performance in the same format. Return ONLY the final SQL hint."
                "DO NOT USE THE SAME HINT AS THE CURRENT BEST HINT or Postgres HINT.\n"                                
                "NO OTHER REDUNDANT OUTPUTS OR COMMENTS. IMPORTANT: The hint must include an extra outer pair of parentheses in the Leading clause, and the brackets should match. "
                "For example, given a join order of 'a b c d':\n"
                "Valid hint: /*+ Leading((((a b) c) d)) */\n"
                "Invalid hint (missing extra outer parentheses): /*+ Leading(((a b) c) d) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((((a b) c) d)) */\n"
                "Invalid hint (brackets do not match): /*+ Leading(((a b) c) d)) */\n"
                )
              
        messages.append({"role": "user", "content": combined_query})
        # 使用新的生成函数替代vLLM
        action_sequence = generate_response(messages, max_new_tokens=512, temperature=1.0)
        action_sequence = action_sequence.strip()
        ## 提取SQL hint
        action_sequence = extract_sql_hint_from_text_chunk(action_sequence)

        try:
            print(f"hint for question {keys[i-1]} given by LLM (may not be valid): ", action_sequence)
            print("\n")
            # append the hint to the original SQL query
            sql_query_hinted = action_sequence + "\n" + "EXPLAIN (ANALYZE, FORMAT JSON) " + sql_query_original
        except Exception as e:
            print(f"Error: {e}")
            print("The conversion failed, please check the action sequence for question ", i)
            print("\n")
        
        if DROP_CACHE:
            DropBufferCache()
        # exeuete the SQL query with hints
        print(f"Executing sql query {keys[i-1]} with hints")
        # the real hint is the hint that is used in the execution, so sometimes the LLM generated hint is not used since it's not valid
        exec_time, real_hint = execute_sql(sql_query_hinted, print_dummy_join=False, only_order=ONLY_ORDER)
        print("\n")
        
        online_record = {
            "id": online_counter,
            "iteration": current_iteration+1,
            "sqlid": keys[i-1],
            "vector": new_vector,
            "sql": sql_query_original,
            "plan": real_hint,
            "execution_time": exec_time
        }
        
        client_milvus.insert(
            collection_name=SQL_ONLINE_COLLECTION_NAME,
            data=[online_record]
        )
        online_counter += 1
        print(f"Inserted online execution result for question {keys[i-1]} into Milvus collection '{SQL_ONLINE_COLLECTION_NAME}'.\n")
        
        
        _, postgres_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_POSTGRES_COLLECTION_NAME}", keys[i-1])
        if postgres_time == 0:
            # Qihan: add this to fill the postgres collection
            fill_postgres_collection_one_record(client_milvus, SQL_POSTGRES_COLLECTION_NAME, model_milvus, keys[i-1], sql_query)
     
        postgres_hint = get_postgres_hint(sql_query, CONNECTION_INFO, keys[i-1], print_dummy_join=False,real_execution = REAL_EXECUTION, only_order=ONLY_ORDER)
        best_online_record_hint, best_online_record_time = get_fastest_plan_by_sqlid(milvus_position,  f"{SQL_ONLINE_COLLECTION_NAME}", keys[i-1])
        print(f"Postgres execution plan ({postgres_time} ms) for question {keys[i-1]} is \n{postgres_hint}\n")
        if current_iteration == NUM_ITERATIONS - 1:
            print(f"Final LLM generated optimal execution plan ({best_online_record_time} ms) for question {keys[i-1]} is \n{best_online_record_hint}\n")
            if postgres_time == 0:
                print(f"The final performance gain is UNKNOWN\n")
            else:
                print(f"The final performance gain is {postgres_time - best_online_record_time} / {postgres_time} = {((postgres_time - best_online_record_time) / postgres_time * 100):.3f}%\n")
        else:
            if best_online_record_time == 0:
                print(f"The current LLM generated optimal execution plan is UNKNOWN\n")
            else:
                print(f"Current LLM generated optimal execution plan ({best_online_record_time} ms) for question {keys[i-1]} is \n{best_online_record_hint}\n")
            if postgres_time == 0:
                print(f"The current performance gain is UNKNOWN\n")
            else:
                print(f"The current performance gain is {postgres_time - best_online_record_time} / {postgres_time} = {((postgres_time - best_online_record_time) / postgres_time * 100):.3f}%\n")
            

        # comparer the postgres_hint and best_online_record_hint are the same or not
        if best_online_record_hint is None or best_online_record_hint == "NOT FOUND" or postgres_hint.strip() == best_online_record_hint.strip():
            print(f"The final/current LLM generated optimal execution plan for question {keys[i-1]} is the same as the Postgres execution plan\n")
        else:
            print(f"The final/current LLM generated optimal execution plan for question {keys[i-1]} is different from the Postgres execution plan\n")
   
        # print(f"Checking the syntax correct rate of the hints for question {keys[i-1]}")
        # res = is_bushy_hint_reasonable(action_sequence, sql_query_original)
        
        # if res:
        #     print("The bushy plan is valid\n")
        # else:
        #     print("The bushy plan is invalid\n")

    # just keep the optimal records for each sqlid each iteration
    keep_fastest_queries_by_sqlid(milvus_position, SQL_ONLINE_COLLECTION_NAME)
    if USE_UPDATING_RAG:
        update_init_collection(milvus_position, SQL_INIT_COLLECTION_NAME, SQL_POSTGRES_COLLECTION_NAME, SQL_ONLINE_COLLECTION_NAME)
      
    if (current_iteration+ 1) % 5 == 0:
        send_email("llmqo LOCAL Experiment ", f"The experiment of IMDB6 LLAMA finished! The iteration is {current_iteration + 1}", "")

if DELETE_VECTOR_AFTER_USE:
    # delete the file after use milvus_position
    os.remove(milvus_position)
    print("The file has been deleted successfully")