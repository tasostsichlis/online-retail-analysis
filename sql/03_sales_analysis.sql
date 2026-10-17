USE online_retail;

SELECT COUNT(*) AS sales_rows
FROM retail_clean
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%';

-- First calculations: include special charges such as postage.

CREATE VIEW retail_sales AS
SELECT *
FROM retail_clean
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%';

SELECT
    COUNT(DISTINCT invoice_no) AS total_invoices,
    SUM(quantity) AS total_units,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_sales;

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_sales
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    stock_code,
    SUM(quantity) AS total_units,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_sales
GROUP BY stock_code
ORDER BY sales_revenue DESC
LIMIT 10;

SELECT DISTINCT
    stock_code,
    description
FROM retail_sales
WHERE stock_code IN ('DOT', 'M', 'POST')
ORDER BY stock_code, description;

SELECT DISTINCT stock_code, description
FROM retail_sales
WHERE stock_code NOT REGEXP '^[0-9]'
ORDER BY stock_code, description;

-- Exclude special charges to analyse product sales.
-- The calculations below are used in the dashboards.

CREATE VIEW retail_product_sales AS
SELECT *
FROM retail_sales
WHERE stock_code NOT IN (
    'AMAZONFEE', 'B', 'BANK CHARGES',
    'C2', 'DOT', 'M', 'POST', 'S',
    'gift_0001_10', 'gift_0001_20', 'gift_0001_30',
    'gift_0001_40', 'gift_0001_50'
);

SELECT
    COUNT(DISTINCT invoice_no) AS total_invoices,
    SUM(quantity) AS total_units,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_product_sales;

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_product_sales
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    stock_code,
    SUM(quantity) AS total_units,
    SUM(quantity * unit_price) AS sales_revenue
FROM retail_product_sales
GROUP BY stock_code
ORDER BY sales_revenue DESC
LIMIT 10;