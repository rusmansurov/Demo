-- Set catalog and schema
USE USE dlh.my_schema;

-- Drop table if it exists
DROP TABLE IF EXISTS sales;

-- Create partitioned table: partition by "region"
CREATE TABLE sales (
    id BIGINT,
    region VARCHAR,
    product VARCHAR,
    total DOUBLE
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['region']
);

-- Insert sample data into multiple regions
INSERT INTO sales VALUES
    (1, 'RU', 'Phone', 100.0),
    (2, 'RU', 'Laptop', 500.0),
    (3, 'US', 'Phone', 110.0),
    (4, 'US', 'Tablet', 300.0),
    (5, 'DE', 'Camera', 200.0),
    (6, 'FR', 'Laptop', 450.0);

-- Show all data
SELECT * FROM sales;

-- Query for specific region: should only scan 'RU' partition
SELECT * FROM sales WHERE region = 'RU';

-- Check the query plan
EXPLAIN SELECT * FROM sales WHERE region = 'RU';
