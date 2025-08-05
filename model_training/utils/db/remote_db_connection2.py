import psycopg2
from psycopg2.extras import RealDictCursor

from hanwen.db.normal_execution import extract_execution_time, extract_planning_time
from hanwen.db.remote_db_connection import get_remote_connection


def execute_query_remote_with_states(sql_query, conn):
    try:
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
    tunnel, conn = get_remote_connection()
    for i in range(10):
        result, explain_analyze, execution_time, planning_time = execute_query_remote_with_states(sql_query,conn)

        # Print query results
        if result is not None:
            print("Query Results: ")
            for row in result:
                print(row)

        # Print EXPLAIN ANALYZE results
        if explain_analyze is not None:
            print("\nEXPLAIN ANALYZE Results:")
            print(explain_analyze)
