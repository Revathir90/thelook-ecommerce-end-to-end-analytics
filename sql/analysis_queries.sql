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

--Repeat order analysis insights
SELECT
    order_count,
    COUNT(user_id) AS customers,
    SUM(total_revenue) AS revenue
FROM vw_customer_summary
GROUP BY order_count
ORDER BY order_count;

--Business Question Answererd
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


