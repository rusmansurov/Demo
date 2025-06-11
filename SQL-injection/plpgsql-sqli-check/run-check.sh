#!/bin/bash

echo "🔍 Running static analysis with plpgsql_check..."

docker exec -it pg_sqli_demo psql -U postgres -d demo -c "CREATE EXTENSION IF NOT EXISTS plpgsql_check;"
docker exec -it pg_sqli_demo psql -U postgres -d demo -c \
  "SELECT * FROM plpgsql_check_function('vulnerable_find_user(text)', security_warnings := true);"