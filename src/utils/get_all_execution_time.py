import psycopg2
import os
import time
# execute all sqls from one folder
db_config = {
    'host': 'localhost',
    'port': 5432,
    'dbname': 'your_database_name',
    'user': 'your_username',
}


target_dir = '/your_path/sql/your_dataset_name'


conn = psycopg2.connect(**db_config)
conn.autocommit = True

with conn.cursor() as cur:
    sql_files = [f for f in os.listdir(target_dir) if f.endswith('.sql')]
    sql_files.sort()

    for filename in sql_files:
        file_path = os.path.join(target_dir, filename)

        with open(file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read().strip()

        start_time = time.time()
        try:
            cur.execute("SET statement_timeout = your_timeout;")
            cur.execute(sql_content)
            end_time = time.time()
            exec_time = end_time - start_time
            print(f"{filename}: cost {exec_time:.4f} seconds")
            cur.execute('DISCARD ALL;')  
        except Exception as e:
            print(f"{filename}: failed {e}, exceed your_timeout seconds")

conn.close()
