import subprocess

import psycopg2
from psycopg2.extras import RealDictCursor
from sshtunnel import SSHTunnelForwarder

from hanwen.db.normal_execution import extract_execution_time, extract_planning_time


def cleanup_port(port):
    """
    Clean up any processes occupying the specified local port.
    This forcibly kills any process using this port, so make sure the port 
    is only used for your SSH tunnel to avoid killing unintended processes.
    """
    try:
        # Use the 'lsof' command to find process IDs that are using the specified port
        result = subprocess.run(
            ["lsof", "-t", "-i:" + str(port)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        pids = result.stdout.strip().split()
        if pids:
            for pid in pids:
                print(f"Detected process {pid} using port {port}, terminating it...")
                subprocess.run(["kill", "-9", pid])
            print(f"Port {port} cleanup complete.")
        else:
            print(f"Port {port} is free, proceeding...")
    except Exception as e:
        print("Error during port cleanup:", e)


def get_remote_connection():
    # Step 1: Clean up local port 5438 to ensure no stale SSH tunnels or other processes are using it
    cleanup_port(5438)

    # Step 2: Establish the SSH tunnel
    tunnel = SSHTunnelForwarder(
        ("rmarcus.info", 28745),  # SSH server address and port
        ssh_username="your_username",
        ssh_pkey="/nfs/gdata/rzhao/storage/wen/LLM4QO/src/local_llm/your_path/id_rsa",
        remote_bind_address=("localhost", 5438),  # Remote address and port where PostgreSQL is running
        local_bind_address=("localhost", 5438)  # Local port binding set to 5438 (ensure cleanup before binding)
    )
    tunnel.start()
    # print("SSH tunnel established on local port:", tunnel.local_bind_port)

    # Step 3: Create the database connection using the established SSH tunnel
    conn = psycopg2.connect(
        host="localhost",
        port=tunnel.local_bind_port,  # Use the actual bound port from the tunnel
        user="your_username",
        password="",
        database="imdbload"
    )
    return tunnel, conn


def execute_query_remote_not_in_usage(sql_query):
    tunnel = None
    conn = None
    try:
        tunnel, conn = get_remote_connection()
        conn.autocommit = True
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SET statement_timeout = 60000;")
            cursor.execute('DISCARD ALL;')

            cursor.execute(sql_query)
            result = cursor.fetchall()

            explain_query = f"EXPLAIN ANALYZE {sql_query}"
            cursor.execute(explain_query)
            explain_result = cursor.fetchall()

            explain_analyze_lines = [row['QUERY PLAN'] for row in explain_result]
            explain_analyze = "\n".join(explain_analyze_lines)

            execution_time = extract_execution_time(explain_analyze_lines)
            planning_time = extract_planning_time(explain_analyze_lines)

            conn.commit()
        return result, explain_analyze, execution_time, planning_time
    except psycopg2.Error as e:
        print(f"Error executing query: {e}")
        return None, None, None, None
    finally:
        if conn:
            conn.close()  # print("[Database] Connection closed.")
        if tunnel and tunnel.is_active:
            tunnel.stop()  # print("[Tunnel] SSH tunnel closed.")


if __name__ == "__main__":
    # SQL Query
    sql_query = '''
    SELECT MIN(chn.name) AS uncredited_voiced_character,
           MIN(t.title) AS russian_movie
    FROM char_name AS chn,
         cast_info AS ci,
         company_name AS cn,
         company_type AS ct,
         movie_companies AS mc,
         role_type AS rt,
         title AS t
    WHERE ci.note LIKE '%(voice)%'
      AND ci.note LIKE '%(uncredited)%'
      AND cn.country_code = '[ru]'
      AND rt.role = 'actor'
      AND t.production_year > 2005
      AND t.id = mc.movie_id
      AND t.id = ci.movie_id
      AND ci.movie_id = mc.movie_id
      AND chn.id = ci.person_role_id
      AND rt.id = ci.role_id
      AND cn.id = mc.company_id
      AND ct.id = mc.company_type_id;
    '''

    ### Remote
    # Execute the query

    for i in range(10):
        result, explain_analyze, execution_time, planning_time = execute_query_remote_not_in_usage(sql_query)

        # Print query results
        if result is not None:
            print("Query Results: ")
            for row in result:
                print(row)

        # Print EXPLAIN ANALYZE results
        if explain_analyze is not None:
            print("\nEXPLAIN ANALYZE Results:")
            print(explain_analyze)
