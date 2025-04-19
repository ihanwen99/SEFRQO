
import os
import subprocess
import psycopg2
import time


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
    try:
       
        connection = psycopg2.connect(
            host="localhost",      
            database="imdbload",    
            user="qihanzha",
            port=5438,
            connect_timeout=5  
        )
        connection.autocommit = True  

        cursor = connection.cursor()
        # 1800 s timeout
        cursor.execute("SET statement_timeout = 1800000;") 
        cursor.execute("load 'pg_hint_plan';")
        cursor.execute('DISCARD ALL;')  

        try:
            start_time = time.time()
            cursor.execute(sql_query)
            # records = cursor.fetchall()
            # for row in records:
            #     print(row)
            
            connection.commit()  
        except psycopg2.OperationalError as e:
            print(f"Query timed out: {e}")
            connection.rollback() 

        end_time = time.time()
        print(f"Query execution time: {end_time - start_time:.3f} seconds")

    except Exception as error:
        print(f"Error: {error}")
    
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()        



directory = "/home/qihanzha/LLM4QO/sql/imdb_assorted_5"
sql_files = get_sql_files(directory)
number_of_questions = len(sql_files)
keys = list(sql_files.keys())
values = list(sql_files.values())

assert number_of_questions > 0, "The number of questions should be greater than 0"

for i in range(1, number_of_questions+1):
    print(f"=========Processing question {keys[i-1]}=========\n")
    
    sql_query = values[i-1]

    DropBufferCache()
    # execute the sql queries without hints
    print(f"Executing sql query {keys[i-1]} without hints")
    execute_sql(sql_query)
    
    


    
    


        



    
    
