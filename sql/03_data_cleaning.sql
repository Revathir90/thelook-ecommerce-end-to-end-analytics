--Validating PRIMARY KEY values for all the clean.base tables
SELECT 
	* 
FROM 
	clean.users_base 
WHERE 
	city IS NULL

--PRIMARY KEY duplicates check 
SELECT 
	order_id
FROM
	clean.orders_base
GROUP BY order_id
HAVING COUNT(*) > 1;

--"clean.users_base" table data validation

--1. Duplicate check
--Identifying dupllicate users
SELECT 
	first_name, 
	last_name, 
	COUNT(*) AS count 
FROM 
	clean.users_base
GROUP BY first_name, last_name
HAVING COUNT (*) > 1

--Confirming duplication by examining the records 
SELECT 
	*
FROM 
	clean.users_base AS u
WHERE 
	u.first_name = 'Taylor' AND u.last_name = 'Reed'

--Double checking duplicate user based on email
SELECT 
	email, 
	COUNT(*)
FROM 
	clean.users_base
GROUP BY email
HAVING COUNT(*) > 1

--Taking action for the duplicate records (In this case, deleting a record)
DELETE FROM 
	clean.users_base
WHERE 
	email = 'taylorreed@example.net' AND age = 38

--2. Checking for missing or NULL values 
SELECT
	*
FROM 
	clean.users_base AS u
WHERE 
	first_name IN ('', 'N/A', 'na', 'unknown', 'null') OR -- Identifying string nulls (Not actually a SQL NULLs) values
	last_name IN ('', 'N/A', 'na', 'unknown', 'null') OR
	city IN ('', 'N/A', 'na', 'unknown', 'null') OR
	state IN ('', 'N/A', 'na', 'unknown', 'null') OR
	country IN ('', 'N/A', 'na', 'unknown', 'null')

SELECT
  SUM(CASE WHEN first_name ILIKE 'null' THEN 1 ELSE 0 END) AS first_name_null_count, --count=0
  SUM(CASE WHEN last_name ILIKE 'null' THEN 1 ELSE 0 END) AS last_name_null_count, --count=0 
  SUM(CASE WHEN city ILIKE 'null' THEN 1 ELSE 0 END) AS city_null_strings, --count=27
  SUM(CASE WHEN state ILIKE 'null' THEN 1 ELSE 0 END) AS state_null_strings, --count=0
  SUM(CASE WHEN country ILIKE 'null' THEN 1 ELSE 0 END) AS country_null_strings --count=0
FROM clean.users_base;

--Updating the string nulls to real SQL NULL values
UPDATE clean.users_base
SET city = NULL
WHERE city ILIKE 'null';

--Verifying the actual NULL count result with the before update count,
--And query result matches with the previous count 27)
SELECT COUNT(*)
FROM clean.users_base
WHERE city is NULL;

--3. Format/data completeness/domain validation checks
-- Email  validation
SELECT 
	email
FROM 
	clean.users_base
WHERE 
	email NOT LIKE '%_@__%.__%'

-- Gender field validation
SELECT 
	*
FROM 
	clean.users_base
WHERE 
	gender NOT IN ('M', 'F')
	
--postal code check
SELECT *
FROM clean.users_base
WHERE postal_code !~ '^[0-9]+$'; -- Found postal codes with extended code. Total count 151

--Checking postal codes with extension for Japan
SELECT *
FROM clean.users_base
WHERE POSITION('-' IN postal_code) < 5 AND POSITION('-' IN postal_code) > 0; -- Japan 6 

-- Updaing the postal code with base format other than Japan 
UPDATE clean.users_base
SET postal_code = SPLIT_PART(postal_code, '-', 1)
WHERE postal_code LIKE '%-%'
  AND country <> 'Japan'; -- Updated record/row count 151 - 6 = 145

  
-- clean.orders_base table data validation
-- User level order details (Orders Table Sanity Checks)
SELECT user_id, COUNT(num_of_item) AS order_count
FROM clean.orders_base
GROUP BY user_id
ORDER BY order_count DESC

-- Item count check
SELECT *
FROM 
clean.orders_base
WHERE num_of_item > 0

-- order status
SELECT status
FROM clean.orders_base
WHERE status NOT IN ('Processing','Shipped','Complete','Returned','Cancelled')

-- Check for any orders where timestamps are inconsistent
SELECT *
FROM clean.orders_base
WHERE created_at > shipped_at
   OR shipped_at > delivered_at;
	 
-- Check for future dates
SELECT order_id, created_at, shipped_at, delivered_at
FROM clean.orders_base
WHERE created_at > CURRENT_DATE
   OR shipped_at > CURRENT_DATE
   OR delivered_at > CURRENT_DATE
   OR returned_at > CURRENT_DATE;

-- Status vs timestamp logical checks (example: Processing orders should not have shipped/delivered)
SELECT *
FROM clean.orders_base
WHERE 
	(status = 'Processing' AND (shipped_at IS NOT NULL OR returned_at IS NOT NULL OR delivered_at IS NOT NULL)) OR
	(status = 'Shipped' AND (returned_at IS NOT NULL OR delivered_at IS NOT NULL)) OR
	(status = 'Complete' AND (returned_at IS NOT NULL)) OR
	(status = 'Returned' AND (shipped_at IS NULL OR returned_at IS NULL OR delivered_at IS NULL)) OR
	(status = 'Cancelled' AND (shipped_at IS NOT NULL OR returned_at IS NOT NULL OR delivered_at IS NOT NULL));

	
-- clean.products_base table data validation
--Primary Key (product_id) validation checks 
SELECT 
	product_id
FROM
	clean.products_base
GROUP BY product_id
HAVING COUNT(*) > 1

-- Cost and retails_price validation
SELECT 
	Product_id, cost, retail_price
FROM clean.products_base
WHERE cost <= 0 OR retail_price <= 0 OR retail_price < cost 

--Department, brand and sku value check 
SELECT DISTINCT department
FROM clean.products_base
ORDER BY department ASC

SELECT brand, COUNT(*) 
FROM clean.products_base
GROUP BY brand
ORDER BY brand ASC

SELECT sku, COUNT(*)
FROM clean.products_base
GROUP BY sku
HAVING COUNT(*) > 1

-- NUll checks
SELECT product_id, category, department, brand
FROM clean.products_base
WHERE (department IS NULL or lower(department) = 'null') OR
	(category IS NULL or lower(category) = 'null') OR
	(brand IS NULL or lower(brand) = 'null')

-- Distribution Center detail check
SELECT *
FROM clean.products_base p
WHERE distribution_center_id NOT IN (
    SELECT id
    FROM clean.distribution_centers_base
)

-- clean.distribution_centers_base table data validation
SELECT * 
FROM clean.distribution_centers_base

-- clean.order_items_base table data validation
-- Primary Key validation 
SELECT id, COUNT(*)
FROM clean.order_items_base
GROUP BY id
HAVING COUNT(*) > 1

SELECT *
FROM clean.order_items_base
WHERE id IS NULL

-- Duplicate Line Items check (Logical Check)
SELECT order_id, product_id, COUNT(*)
FROM clean.order_items_base
GROUP BY 1, 2
HAVING count(*) > 1

SELECT user_id, order_id, COUNT(*) 
FROM clean.order_items_base 
GROUP BY 1, 2 
HAVING COUNT(*) > 1

SELECT product_id, COUNT(DISTINCT order_id)
FROM order_items
GROUP BY product_id
HAVING COUNT(DISTINCT order_id) > 1;


-- Foreign Key Integrity
SELECT *
FROM clean.order_items_base oi
LEFT JOIN clean.orders_base o
  ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

SELECT *
FROM clean.order_items_base oi
LEFT JOIN clean.products_base p
  ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

SELECT *
FROM clean.order_items_base oi
LEFT JOIN clean.users_base p
  ON oi.user_id = p.user_id
WHERE p.user_id IS NULL

-- Sale price check
SELECT *
FROM clean.order_items_base
WHERE sale_price < 0;

-- Status vs timestamp logical checks (example: Processing orders should not have shipped/delivered)
SELECT *
FROM clean.order_items_base
WHERE created_at > CURRENT_TIMESTAMP OR
	shipped_at > CURRENT_TIMESTAMP OR
	delivered_at > CURRENT_TIMESTAMP OR
	returned_at > CURRENT_TIMESTAMP

SELECT *
FROM clean.order_items_base
WHERE 
	(status = 'Processing' AND (shipped_at IS NOT NULL OR returned_at IS NOT NULL OR delivered_at IS NOT NULL)) OR
	(status = 'Shipped' AND (returned_at IS NOT NULL OR delivered_at IS NOT NULL)) OR
	(status = 'Complete' AND (returned_at IS NOT NULL)) OR
	(status = 'Returned' AND (shipped_at IS NULL OR returned_at IS NULL OR delivered_at IS NULL)) OR
	(status = 'Cancelled' AND (shipped_at IS NOT NULL OR returned_at IS NOT NULL OR delivered_at IS NOT NULL));


SELECT product_id, COUNT(DISTINCT order_id)
FROM order_items
GROUP BY product_id
HAVING COUNT(DISTINCT order_id) > 1;
