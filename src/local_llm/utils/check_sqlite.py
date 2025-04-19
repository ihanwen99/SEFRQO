import sqlite3

def query_sqlite_data(db_file, table_name, limit=10):
    try:
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        query = f"SELECT * FROM {table_name} LIMIT ?"
        cursor.execute(query, (limit,))
        rows = cursor.fetchall()
        if rows:
            print(f"Found {limit} rows of the table {table_name}:")
            for row in rows:
                print(row)
        else:
            print("There is no data in the table.")
    except sqlite3.Error as e:
        print("SQLite errors", e)
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    db_file = "/home/qihanzha/LLM4QO/src/local_llm/online_records/online_test.db"
    table_name = "execution_results"
    limit = 5
    query_sqlite_data(db_file, table_name, limit)
