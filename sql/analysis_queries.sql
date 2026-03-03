-- Creating Views for business logic.
-- PURPOSE:
-- Clean product-level sales data and customer summary for completed order

-- GRAIN:
-- one row per product per completed order

CREATE VIEW vw_sales_clean AS
(SELECT
    o.order_id,
    o.user_id,
    o.created_at,
    oi.product_id,
    oi.sale_price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Complete'
  AND oi.sale_price IS NOT NULL);

-- Top customers by Revenue
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    user_id,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(product_id) AS product_count,
    SUM(sale_price) AS total_revenue
FROM vw_sales_clean
GROUP BY user_id;	

--Customer Strategy Analysis
--1. Top 10 customers
SELECT *
FROM vw_customer_summary
ORDER BY total_revenue DESC
LIMIT 10;

-- Sanity check and bulk order insight validation for the business answer
SELECT
	product_id,
	COUNT(product_id)
FROM vw_sales_clean
WHERE user_id = 52979
GROUP BY product_id

--2. Revenue concentration % 
WITH ranked_customers AS (
    SELECT
        user_id,
        SUM(sale_price) AS total_revenue
    FROM vw_sales_clean
    GROUP BY user_id
    ORDER BY total_revenue DESC
    LIMIT 10
)
SELECT
    (SELECT SUM(total_revenue) FROM ranked_customers) * 100.0 /
    (SELECT SUM(sale_price) FROM vw_sales_clean)
    AS top10_revenue_percentage;


--3. Repeat order analysis insights
SELECT
    order_count,
    COUNT(user_id) AS customers,
    ROUND(SUM(total_revenue),1) AS revenue
FROM vw_customer_summary
GROUP BY order_count
ORDER BY order_count;

-- Customer Distribution % and Revenue Percentage
SELECT
    order_count,
    ROUND (COUNT(user_id) * 100.0 / 
		(SELECT COUNT(*) FROM vw_customer_summary),1) AS customer_percentage,
	ROUND (SUM(total_revenue) * 100.0 / 
        (SELECT SUM(total_revenue) FROM vw_customer_summary),1) AS revenue_percentage
FROM vw_customer_summary
GROUP BY order_count
ORDER BY order_count;

-- 4. Average Revenue per customer
SELECT
    ROUND (AVG(total_revenue),1) AS avg_revenue_per_customer
FROM vw_customer_summary;

SELECT
    MIN(total_revenue),
    MAX(total_revenue),
    AVG(total_revenue),
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY total_revenue) AS median_revenue
FROM vw_customer_summary;