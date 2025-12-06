--clean.users_base table data cleaning

--Validating PRIMARY KEY values for all the clean.base tables
SELECT 
	* 
FROM 
	clean.users_base
WHERE 
	order_id = NULL 

--PRIMARY KEY duplicates check 
SELECT 
	order_id
FROM
	clean.orders_base
GROUP BY order_id
HAVING COUNT(*) > 1

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

--Taking action for the duplicate record (In this case, deleting old record)
DELETE FROM 
	clean.users_base
WHERE 
	email = 'taylorreed@example.net' AND age = 38

--Chaking for missing or NULL values
SELECT
	*
FROM 
	clean.users_base AS u
WHERE created_at is NULL 

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

SELECT *
FROM clean.users_base
WHERE postal_code !~ '^[0-9]+$';

--Cleaning/data validation process for orders_base table
SELECT 
	*
FROM 
	clean.orders_base
WHERE 
	status NOT IN ('Shipped', 'Delivered','Processing','Cancelled','complete')