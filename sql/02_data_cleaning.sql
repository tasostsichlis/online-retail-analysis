USE online_retail;
SELECT
    SUM(invoice_no IS NULL OR TRIM(invoice_no) = '') AS missing_invoice_no,
    SUM(stock_code IS NULL OR TRIM(stock_code) = '') AS missing_stock_code,
    SUM(description IS NULL OR TRIM(description) = '') AS missing_description,
    SUM(quantity IS NULL OR TRIM(quantity) = '') AS missing_quantity,
    SUM(invoice_date IS NULL OR TRIM(invoice_date) = '') AS missing_invoice_date,
    SUM(unit_price IS NULL OR TRIM(unit_price) = '') AS missing_unit_price,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(country IS NULL OR TRIM(country) = '') AS missing_country
FROM retail_raw;

SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    COUNT(*) AS row_count
FROM retail_raw
GROUP BY
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
HAVING COUNT(*) > 1;

SELECT
    SUM(CAST(quantity AS SIGNED) < 0) AS negative_quantity,
    SUM(CAST(quantity AS SIGNED) = 0) AS zero_quantity
FROM retail_raw;
SELECT
    SUM(invoice_no LIKE 'C%') AS negative_with_c,
    SUM(invoice_no NOT LIKE 'C%') AS negative_without_c
FROM retail_raw
WHERE CAST(quantity AS SIGNED) < 0;
SELECT *
FROM retail_raw
WHERE CAST(quantity AS SIGNED) < 0
  AND invoice_no NOT LIKE 'C%'
LIMIT 10;

SELECT
    SUM(CAST(unit_price AS DECIMAL(12,3)) = 0) AS zero_price,
    SUM(CAST(unit_price AS DECIMAL(12,3)) <> 0) AS non_zero_price
FROM retail_raw
WHERE CAST(quantity AS SIGNED) < 0
  AND invoice_no NOT LIKE 'C%';

SELECT
    SUM(CAST(unit_price AS DECIMAL(12,3)) < 0) AS negative_price,
    SUM(CAST(unit_price AS DECIMAL(12,3)) = 0) AS zero_price
FROM retail_raw;

SELECT *
FROM retail_raw
WHERE CAST(unit_price AS DECIMAL(12,3)) < 0;

SELECT
    SUM(CAST(quantity AS SIGNED) > 0) AS positive_quantity,
    SUM(CAST(quantity AS SIGNED) < 0) AS negative_quantity
FROM retail_raw
WHERE CAST(unit_price AS DECIMAL(12,3)) = 0;

SELECT *
FROM retail_raw
WHERE CAST(unit_price AS DECIMAL(12,3)) = 0
  AND CAST(quantity AS SIGNED) > 0
LIMIT 10;

SELECT COUNT(*) AS missing_description
FROM retail_raw
WHERE CAST(unit_price AS DECIMAL(12,3)) = 0
  AND CAST(quantity AS SIGNED) > 0
  AND (description IS NULL OR TRIM(description) = '');

SELECT *
FROM retail_raw
WHERE CAST(unit_price AS DECIMAL(12,3)) = 0
  AND CAST(quantity AS SIGNED) > 0
  AND description IS NOT NULL
  AND TRIM(description) <> ''
LIMIT 10;

SELECT COUNT(*) AS invalid_dates
FROM retail_raw
WHERE STR_TO_DATE(invoice_date, '%m/%d/%Y %H:%i') IS NULL;

SELECT
    MIN(STR_TO_DATE(invoice_date, '%m/%d/%Y %H:%i')) AS first_date,
    MAX(STR_TO_DATE(invoice_date, '%m/%d/%Y %H:%i')) AS last_date
FROM retail_raw;

CREATE TABLE retail_clean AS
SELECT
    TRIM(invoice_no) AS invoice_no,
    TRIM(stock_code) AS stock_code,
    NULLIF(TRIM(description), '') AS description,
    CAST(quantity AS SIGNED) AS quantity,
    STR_TO_DATE(invoice_date, '%m/%d/%Y %H:%i') AS invoice_date,
    CAST(unit_price AS DECIMAL(12,3)) AS unit_price,
    NULLIF(TRIM(customer_id), '') AS customer_id,
    TRIM(country) AS country
FROM retail_raw;

SELECT COUNT(*) AS total_rows
FROM retail_clean;

SELECT *
FROM retail_clean
LIMIT 10;