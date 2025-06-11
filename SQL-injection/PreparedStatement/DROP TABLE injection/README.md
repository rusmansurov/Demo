# SQL Injection Demo with Python and PostgreSQL

This project demonstrates a basic SQL Injection attack using a vulnerable Python script with string-based query construction and how to prevent it using `PreparedStatement` (parameterized queries).

## Stack

- Python 3.11
- PostgreSQL 17
- Docker & Docker Compose

## How it works

1. The `init.sql` script sets up a `users` table and populates it with some test data.
2. The `app.py` script runs two login attempts:
   - One using **parameterized queries** (`safe_login`)
   - One using **raw SQL with string interpolation** (`unsafe_login`)

## Run

```bash
docker compose up --build
```

## Test Input

```python
"admin'; DROP TABLE users; --"
```

- This will not work in the **safe** query.
- This will break or delete the table in the **unsafe** query.

## Safe Output

The safe query will escape the input, and no SQL injection will occur.

## ❌ Unsafe Output

The unsafe query will execute:

```sql
SELECT * FROM users WHERE username = 'admin'; DROP TABLE users; --'
```
You will see output like:

```text
=== Step 1: Safe login attempt using parameterized query ===

[SAFE] Executing protected query with parameterized input:

Query: SELECT * FROM users WHERE username = %s | Value: ("admin'; DROP TABLE users; --")

Returned rows (SAFE): []

Users table exists after SAFE query: True

=== Step 2: Unsafe login attempt vulnerable to SQL Injection ===

[UNSAFE] Executing vulnerable query:

SELECT * FROM users WHERE username = 'admin'; DROP TABLE users; --'

Returned rows (UNSAFE): []

Users table exists after UNSAFE query: False
```

## Cleanup

```bash
docker compose down -v
```

Enjoy responsibly. Never use raw SQL with user input in production.
