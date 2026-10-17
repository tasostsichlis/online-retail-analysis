CREATE DATABASE IF NOT EXISTS online_retail;
USE online_retail;
CREATE TABLE retail_raw (
invoice_no VARCHAR(50),
    stock_code VARCHAR(50),
    description VARCHAR(500),
    quantity VARCHAR(50),
    invoice_date VARCHAR(50),
    unit_price VARCHAR(50),
    customer_id VARCHAR(50),
    country VARCHAR(100)
);
SELECT COUNT(*) AS total_rows FROM retail_raw;
SELECT * FROM retail_raw LIMIT 10;