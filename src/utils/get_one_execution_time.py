import psycopg2
import os
import time


db_config = {
    'host': 'localhost',
    'port': 5438,
    'dbname': 'tpcds1load',
    'user': 'qihanzha',  
}


sql_file_path = '/home/qihanzha/LLM4QO/sql/tpcds/11.sql'

conn = psycopg2.connect(**db_config)
conn.autocommit = True

with conn.cursor() as cur:
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        sql_content = f.read().strip()

    start_time = time.time()
    try:
        cur.execute(sql_content)
        end_time = time.time()
        exec_time = end_time - start_time
        print(f"{os.path.basename(sql_file_path)}: cost {exec_time:.4f} seconds")
    except Exception as e:
        print(f"{os.path.basename(sql_file_path)}: failed {e}")

conn.close()