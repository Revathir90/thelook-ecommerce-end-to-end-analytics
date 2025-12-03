WITH subset_users AS (
  SELECT
    u.*
  FROM 
    bigquery-public-data.thelook_ecommerce.users AS u
  JOIN 
    bigquery-public-data.thelook_ecommerce.orders AS o
    ON u.id = o.user_id 
  WHERE u.created_at BETWEEN '2024-05-01' AND '2025-05-31'
  LIMIT 1000),
  
  subset_orders AS (SELECT 
   o.* 
  FROM 
    bigquery-public-data.thelook_ecommerce.orders AS o
  JOIN subset_users 
    ON o.user_id = subset_users.id 
  LIMIT 1000),

  subset_order_items AS (SELECT 
    oi.*
  FROM 
   subset_orders
  JOIN 
    bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON subset_orders.order_id = oi.order_id
  LIMIT 1000)

SELECT 
  p.*
  FROM 
   subset_order_items
  JOIN 
    bigquery-public-data.thelook_ecommerce.products AS p
  ON subset_order_items.product_id = p.id
  LIMIT 1000
  