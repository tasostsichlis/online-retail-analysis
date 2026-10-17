USE online_retail;

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_product_sales
WHERE customer_id IS NOT NULL;

CREATE TABLE customer_rfm AS
SELECT
    customer_id,
    MAX(invoice_date) AS last_purchase,
    DATEDIFF('2011-12-10', MAX(invoice_date)) AS recency,
    COUNT(DISTINCT invoice_no) AS frequency,
    SUM(quantity * unit_price) AS monetary
FROM retail_product_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

SELECT COUNT(*) AS total_customers
FROM customer_rfm;

CREATE VIEW customer_rfm_scores AS
SELECT
    customer_rfm.*,
    CEIL(5 * CUME_DIST() OVER (ORDER BY recency DESC)) AS r_score,
    CEIL(5 * CUME_DIST() OVER (ORDER BY frequency ASC)) AS f_score,
    CEIL(5 * CUME_DIST() OVER (ORDER BY monetary ASC)) AS m_score
FROM customer_rfm;

SELECT *
FROM customer_rfm_scores
LIMIT 10;

CREATE VIEW customer_rfm_segments AS
SELECT
    customer_rfm_scores.*,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'High-value active customers'
        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Active repeat customers'
        WHEN r_score <= 2 AND (f_score >= 3 OR m_score >= 4)
            THEN 'At risk'
        WHEN r_score >= 4 AND f_score <= 2
            THEN 'Recent infrequent customers'
        ELSE 'Other customers'
    END AS customer_segment
FROM customer_rfm_scores;

SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM customer_rfm_segments
GROUP BY customer_segment
ORDER BY total_customers DESC;