import psycopg2
from psycopg2.extras import RealDictCursor

from hanwen.db.db_connection import get_connection


def extract_execution_time(explain_analyze_lines):
    """
    Extracts execution time from the output of EXPLAIN ANALYZE.

    Args:
        explain_analyze_lines (list): List of lines from the EXPLAIN ANALYZE output.

    Returns:
        execution_time (float): Execution time in milliseconds.
    """
    execution_time = None
    for line in reversed(explain_analyze_lines):
        if 'Execution Time' in line:
            try:
                execution_time_str = line.strip()
                execution_time = float(execution_time_str.split('Execution Time:')[1].strip().split(' ')[0])
                break
            except (IndexError, ValueError) as e:
                print(f"Error extracting execution time: {e}")
                execution_time = None
                break
    return execution_time


def extract_planning_time(explain_analyze_lines):
    """
    Extracts planning time from the output of EXPLAIN ANALYZE.

    Args:
        explain_analyze_lines (list): List of lines from the EXPLAIN ANALYZE output.

    Returns:
        planning_time (float): Planning time in milliseconds.
    """
    for line in explain_analyze_lines:
        if "Planning Time" in line:
            return float(line.split(":")[1].strip().replace("ms", ""))
    return None


def execute_query(sql_query):
    """
    Executes the given SQL query and returns the results, EXPLAIN ANALYZE output, and execution time.

    Args:
        sql_query (str): The SQL query to be executed.

    Returns:
        result (list of dict): Query results.
        explain_analyze (str): Output of EXPLAIN ANALYZE.
        execution_time (float): Execution time in milliseconds.
        planning_time (float): Planning time in milliseconds.
    """
    conn = get_connection()
    if conn is None:
        print("Failed to establish a database connection.")
        return None, None, None, None

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            # Preparation
            cursor.execute("SET statement_timeout = 60000;")
            # cursor.execute("load 'pg_hint_plan';")
            # cursor.execute('DISCARD ALL;')

            # Execute the query and fetch results
            cursor.execute(sql_query)
            result = cursor.fetchall()

            # Execute EXPLAIN ANALYZE
            explain_query = f"EXPLAIN ANALYZE {sql_query}"
            cursor.execute(explain_query)
            explain_result = cursor.fetchall()

            # Get EXPLAIN ANALYZE output
            explain_analyze_lines = [row['QUERY PLAN'] for row in explain_result]
            explain_analyze = "\n".join(explain_analyze_lines)

            # Extract execution time and planning time
            execution_time = extract_execution_time(explain_analyze_lines)
            planning_time = extract_planning_time(explain_analyze_lines)

        conn.commit()
        return result, explain_analyze, execution_time, planning_time
    except psycopg2.Error as e:
        print(f"Error executing query: {e}")
        return None, None, None, None
    finally:
        conn.close()


def measure_query_latency(sql_query, debug_mode=False):
    """
    One wrapper function for execute_query
    """
    result, explain_analyze, execution_time, planning_time = execute_query(sql_query)
    if debug_mode:
        print(explain_analyze)

    return execution_time


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

    # Execute the query
    result, explain_analyze, execution_time, planning_time = execute_query(sql_query)

    # Print query results
    if result is not None:
        print("Query Results: ")
        for row in result:
            print(row)

    # Print EXPLAIN ANALYZE results
    if explain_analyze is not None:
        print("\nEXPLAIN ANALYZE Results:")
        print(explain_analyze)
