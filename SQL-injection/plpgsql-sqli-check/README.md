# PostgreSQL SQL Injection Demo with plpgsql_check

This project demonstrates how to detect a SQL injection vulnerability in PL/pgSQL functions using the open-source static analyzer `plpgsql_check`.

## What's Included

- `vulnerable_find_user`: Unsafe PL/pgSQL function using string concatenation.
- `safe_find_user`: Safe version using `EXECUTE ... USING`.
- `plpgsql_check`: Extension for static analysis inside PostgreSQL.
- Docker environment for easy setup.

## How to Run

### 1. Build and start PostgreSQL

```bash
docker-compose up --build -d
```

--

# 2. Run the static analysis
```bash
./run-check.sh
```
You will see output like this:
```sql
 level  |        message
--------+-----------------------------
 warning | SQL injection risk.
 hint    | Use EXECUTE ... USING instead of string concatenation.
```

About plpgsql_check

plpgsql_check is an extension that performs static analysis of PL/pgSQL functions.

Homepage: https://github.com/okbob/plpgsql_check
Author: Pavel Stehule