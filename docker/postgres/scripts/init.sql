CREATE USER my_user WITH PASSWORD '12345';

DROP DATABASE IF EXISTS my_db;

CREATE DATABASE my_db;
\connect my_db;

CREATE SCHEMA IF NOT EXISTS my_schema AUTHORIZATION my_user;

CREATE TABLE IF NOT EXISTS my_schema.sales
(
    invoice_id VARCHAR(255) NOT NULL,
    branch CHAR(1) NOT NULL,
    city VARCHAR(255) NOT NULL,
    customer_type VARCHAR(255) NOT NULL,
    gender VARCHAR(255) NOT NULL,
    product_line VARCHAR(255) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    tax_5_percent NUMERIC(10,4) NOT NULL,
    total NUMERIC(10,4) NOT NULL,
    "date" DATE NOT NULL,
    "time" VARCHAR(25) NOT NULL,
    payment VARCHAR(255) NOT NULL,
    cost_of_goods_sold NUMERIC(10,2) NOT NULL,
    gross_margin_percentage NUMERIC(12,10) NOT NULL,
    gross_income NUMERIC(10,4) NOT NULL,
    customer_stratification_rating NUMERIC(4,2) NOT NULL
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA my_schema TO my_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA my_schema TO my_user;