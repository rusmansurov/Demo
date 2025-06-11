import os
import psycopg2

conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    dbname=os.getenv("DB_NAME", "demo"),
    user=os.getenv("DB_USER", "demo"),
    password=os.getenv("DB_PASS", "demo"),
)

cursor = conn.cursor()

username = "admin"
password_injection = "' OR '1'='1"
password_safe = "admin123"

# UNSAFE query: vulnerable to SQL injection
print("=== VULNERABLE QUERY (SQL Injection works) ===")
vulnerable_query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password_injection}'"
print(f"Executing: {vulnerable_query}")
cursor.execute(vulnerable_query)
for row in cursor.fetchall():
    print(f">> Logged in as: {row[1]}")

# SAFE query: using PreparedStatement (parameterized query)
print("\n=== SAFE QUERY (Using PreparedStatement) ===")
secure_query = "SELECT * FROM users WHERE username = %s AND password = %s"
cursor.execute(secure_query, (username, password_injection))
rows = cursor.fetchall()
if not rows:
    print(">> Login failed.")
else:
    for row in rows:
        print(f">> Logged in as: {row[1]}")

cursor.close()
conn.close()
