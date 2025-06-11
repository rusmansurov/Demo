# SQL Injection Demo with Python & PostgreSQL

This project demonstrates how SQL injection works in a vulnerable query and how to prevent it using prepared statements (`psycopg2` with parameterized queries).

## What It Does

- Spins up a PostgreSQL server with some test users.
- Runs a Python script that:
  - Executes an unsafe SQL query (with SQL injection).
  - Executes a safe query using a parameterized statement.

## Requirements

- Docker
- Docker Compose

## How to Run

Clone the repo and run:

```bash
docker-compose up --build
```

You will see output like:

```text
=== VULNERABLE QUERY (SQL Injection works) ===
Executing: SELECT * FROM users WHERE username = 'admin' AND password = '' OR '1'='1'
>> Logged in as: admin
>> Logged in as: user

=== SAFE QUERY (Using PreparedStatement) ===
>> Login failed.
```
--

# Lessons

- Never build SQL queries using string concatenation.
- Always use parameterized queries or ORM frameworks that do it for you.
- Validate and sanitize user input.