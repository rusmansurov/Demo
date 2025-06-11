-- Create a sample table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    email TEXT
);

-- Vulnerable function: unsafe dynamic SQL
CREATE OR REPLACE FUNCTION vulnerable_find_user(username TEXT)
RETURNS SETOF users AS $$
DECLARE
    sql TEXT;
BEGIN
    sql := 'SELECT * FROM users WHERE username = ''' || username || '''';
    RETURN QUERY EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

-- Safe function: parameterized dynamic SQL
CREATE OR REPLACE FUNCTION safe_find_user(username TEXT)
RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT * FROM users WHERE username = $1'
        USING username;
END;
$$ LANGUAGE plpgsql;
