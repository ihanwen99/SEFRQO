"""
PostgreSQL Connection:
- Function: get_connection()
- Function: DropBufferCache()
"""
import psycopg2
import subprocess


def get_connection():
    """
    Create and return one database connection
    """
    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5438",
            database="imdbload",
            user="hanwenliu",
            password="",
        )
        return conn
    except psycopg2.Error as e:
        print(f"Database Connection Error: {e}")
        return None


def DropBufferCache():
    # WARNING: no effect if PG is running on another machine
    print("Dropping buffer cache...")
    # Run 'free' and 'sync' separately
    subprocess.check_output(['free'])
    subprocess.check_output(['sync'])
    # Drop caches
    subprocess.check_output(
        ['sudo', 'sh', '-c', 'echo 3 > /proc/sys/vm/drop_caches'])
    # Show free memory again
    subprocess.check_output(['free'])
    print("Buffer cache dropped")


if __name__ == '__main__':
    conn = get_connection()
    DropBufferCache()
    if conn is None:
        print("Failed to establish a database connection.")
