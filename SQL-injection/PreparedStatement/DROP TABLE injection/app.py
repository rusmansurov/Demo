import os
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def check_users_table_exists():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        dbname=os.getenv("DB_NAME", "demo"),
        user=os.getenv("DB_USER", "demo"),
        password=os.getenv("DB_PASS", "demo"),
    )
    cur = conn.cursor()
    cur.execute("""
        SELECT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_name = 'users'
        );
    """)
    exists = cur.fetchone()[0]
    cur.close()
    conn.close()
    return exists

def unsafe_login(username):
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        dbname=os.getenv("DB_NAME", "demo"),
        user=os.getenv("DB_USER", "demo"),
        password=os.getenv("DB_PASS", "demo"),
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)  # Allow multiple statements
    cur = conn.cursor()

    query = f"SELECT * FROM users WHERE username = '{username}'"
    print("\n[UNSAFE] Executing vulnerable query:")
    print(query)

    try:
        cur.execute(query)
        result = []
        while True:
            try:
                result.extend(cur.fetchall())
            except:
                break
            if not cur.nextset():
                break
    except Exception as e:
        print("[UNSAFE] Error occurred:", e)
        result = []
    finally:
        cur.close()
        conn.close()

    return result

def safe_login(username):
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        dbname=os.getenv("DB_NAME", "demo"),
        user=os.getenv("DB_USER", "demo"),
        password=os.getenv("DB_PASS", "demo"),
    )
    cur = conn.cursor()

    query = "SELECT * FROM users WHERE username = %s"
    print("\n[SAFE] Executing protected query with parameterized input:")
    print(f"Query: {query} | Value: ({username!r})")

    try:
        cur.execute(query, (username,))
        result = cur.fetchall()
    except Exception as e:
        print("[SAFE] Error occurred:", e)
        result = []
    finally:
        cur.close()
        conn.close()

    return result

if __name__ == "__main__":
    malicious_input = "admin'; DROP TABLE users; --"

    print("=== Step 1: Safe login attempt using parameterized query ===")
    safe_result = safe_login(malicious_input)
    print("Returned rows (SAFE):", safe_result)
    print("Users table exists after SAFE query:", check_users_table_exists())

    print("\n=== Step 2: Unsafe login attempt vulnerable to SQL Injection ===")
    unsafe_result = unsafe_login(malicious_input)
    print("Returned rows (UNSAFE):", unsafe_result)
    print("Users table exists after UNSAFE query:", check_users_table_exists())