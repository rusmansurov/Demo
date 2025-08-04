-- Set catalog and schema
USE USE dlh.my_schema;

-- Drop if exists
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS countries;

-- Create small dimension table
CREATE TABLE countries (
    code VARCHAR,
    name VARCHAR
)
WITH (format = 'PARQUET');

INSERT INTO countries VALUES
    ('RU', 'Russia'),
    ('US', 'United States'),
    ('FR', 'France');

-- Create larger table to simulate fact
CREATE TABLE users (
    id BIGINT,
    name VARCHAR,
    country_code VARCHAR
)
WITH (format = 'PARQUET');

INSERT INTO users VALUES
    (1, 'Alice', 'RU'),
    (2, 'Bob', 'US'),
    (3, 'Charlie', 'FR'),
    (4, 'Diana', 'RU');

-- Default join (adaptive strategy)
SELECT u.name, c.name AS country
FROM users u
JOIN countries c
ON u.country_code = c.code;

-- Force broadcast join
SET SESSION join_distribution_type = 'broadcast';

SELECT u.name, c.name AS country
FROM users u
JOIN countries c
ON u.country_code = c.code;

-- Force partitioned join
SET SESSION join_distribution_type = 'partitioned';

SELECT u.name, c.name AS country
FROM users u
JOIN countries c
ON u.country_code = c.code;

-- View the query plan
EXPLAIN SELECT u.name, c.name AS country
FROM users u
JOIN countries c
ON u.country_code = c.code;

-- Check active queries in Trino
SELECT query_id, state, user, source, query
FROM system.runtime.queries
ORDER BY created DESC
LIMIT 5;
