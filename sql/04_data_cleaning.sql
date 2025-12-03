--Validating PRIMARY KEY values for all the clean.base tables
SELECT 
	* 
FROM 
	clean.users_base 
WHERE 
	user_id = NULL 

SELECT DISTINCT
	COUNT(*) 
FROM 
	clean.users_base --Results matched with and without DISTINCT



