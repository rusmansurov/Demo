CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    password TEXT
);

INSERT INTO users (username, password) VALUES
('admin', 'adminpass'),
('user1', 'pass1'),
('user2', 'pass2');
