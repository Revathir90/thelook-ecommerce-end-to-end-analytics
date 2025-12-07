## 1. Table Name ##
**clean.users_base**
## 2. Overview ##
This table stores user profile information such as user_id, name (first and last), age, email, demographics, and location. 
    Cleaning ensures data consistency and removes duplicate or incorrect records.
## 3. Before Cleaning Summary ##
Total number of records (rows) before cleaning: 645 <br>Number of duplicate records found: 2 **(email based duplication)** <br>Number of rows with missing values: 27 **(NULL values in city field)** <br>Other issues identified: NULL

## 4. Cleaning Steps & Rules Used

### **Issue 1: Duplicate Records**

**How duplicates were identified:** Duplicates were identified using a two-step approach:<br>**Name-level scan:** First and last names were grouped to identify potential duplicate users (GROUP BY first_name, last_name HAVING COUNT(*) > 1).
<br>**Confirmation using unique identifier:** Email address was then used to confirm true duplicates, as email is treated as the primary unique identifier for users.

    -- Identify duplicate users
    SELECT first_name, last_name, email, COUNT(*) AS duplicate_user_count
    FROM clean.users_base
    GROUP BY first_name, last_name, email
    HAVING COUNT(*) > 1;

**Rows affected:** 2 <br>**Rule used:** Retained the record with the higher age, assuming it represents the most recent profile update <br>**Action taken:** 1 duplicate record removed

### **Issue 2: Invalid / Missing Values**
        
    Field(s): city 
    Rows affected: 27
    Rule used: 
    Action taken: N/A
    
### **Issue 3: Standardization / Formatting**
        
    Fields standardized: (e.g., country names, city names, gender codes)
    Rule used:
    Action taken: