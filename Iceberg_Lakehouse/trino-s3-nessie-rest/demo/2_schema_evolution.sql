-- Set catalog and schema
USE USE dlh.my_schema;

-- Add new column
ALTER TABLE demo_users ADD COLUMN email VARCHAR;

-- Insert new data with email
INSERT INTO demo_users (id, name, email) VALUES
    (3, 'Charlie', 'charlie@example.com'),
    (4, 'Diana', 'diana@example.com');

-- Update existing data
UPDATE demo_users SET email = 'alice@acme.com' WHERE id = 1;

-- Delete a row
DELETE FROM demo_users WHERE id = 2;

-- Final result
SELECT * FROM demo_users;
