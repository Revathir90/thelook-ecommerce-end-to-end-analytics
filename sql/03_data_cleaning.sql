--Validating PRIMARY KEY values for all the clean.base tables
SELECT 
	* 
FROM 
	clean.users_base 
WHERE 
	order_id = NULL 

--PRIMARY KEY duplicates check 
SELECT 
	user_id
FROM
	clean.users_base
GROUP BY order_id
HAVING COUNT(*) > 1

--"clean.users_base" table data cleaning

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

--Checking for missing or NULL values
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
  SUM(CASE WHEN first_name ILIKE 'null' THEN 1 ELSE 0 END) AS first_name_null_count,
  SUM(CASE WHEN last_name ILIKE 'null' THEN 1 ELSE 0 END) AS last_name_null_count,
  SUM(CASE WHEN city ILIKE 'null' THEN 1 ELSE 0 END) AS city_null_strings,
  SUM(CASE WHEN state ILIKE 'null' THEN 1 ELSE 0 END) AS state_null_strings,
  SUM(CASE WHEN country ILIKE 'null' THEN 1 ELSE 0 END) AS country_null_strings
FROM clean.users_base;

SELECT DISTINCT city
FROM clean.users_base
Order BY city ASC
WHERE city ILIKE 'null';

-- Email  validation
SELECT 
	email
FROM 
	clean.users_base
WHERE 
	email LIKE '%_@__%.__%'

-- Gender field validation
SELECT 
	*
FROM 
	clean.users_base
WHERE 
	gender IN ('M', 'F','Other')
	
--postal code check and standardizing the postal code without extended/supplemental code
SELECT *
FROM clean.users_base
WHERE postal_code !~ '^[0-9]+$';

SELECT *
FROM clean.users_base
WHERE POSITION('-' IN postal_code) > 0;

UPDATE clean.users_base
SET postal_code = SPLIT_PART(postal_code, '-', 1)
WHERE postal_code LIKE '%-%';

UPDATE clean.users_base
SET postal_code = SPLIT_PART(postal_code, '-', 1)
WHERE postal_code LIKE '%-%'
  AND country <> 'Japan';

--Cleaning/data validation process for orders_base table
SELECT 
	*
FROM 
	clean.orders_base
WHERE 
	status NOT IN ('Shipped', 'Delivered','Processing','Cancelled','Complete','Returned')