--clean.users_base table data cleaning

--Validating PRIMARY KEY values for all the clean.base tables
SELECT 
	* 
FROM 
	clean.users_base
WHERE 
	user_id = NULL 

--PRIMARY KEY duplicates check 
SELECT 
	user_id
FROM 
	clean.users_base
GROUP BY user_id
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



