-- Set catalog and schema
USE dlh.my_schema;

-- Create a basic Iceberg table
CREATE TABLE IF NOT EXISTS demo_users (
    id BIGINT,
    name VARCHAR
)
WITH (
    format = 'PARQUET',
    location = 's3://dlh/iceberg/demo_users/'
);

-- Insert initial rows
INSERT INTO demo_users (id, name) VALUES
    (1, 'Alice'),
    (2, 'Bob');

-- View results
SELECT * FROM demo_users;
