CREATE TABLE users (
    id serial PRIMARY KEY,
    username text,
    password text
);

INSERT INTO users (username, password) VALUES
('admin', 'admin123'),
('user', 'userpass');
