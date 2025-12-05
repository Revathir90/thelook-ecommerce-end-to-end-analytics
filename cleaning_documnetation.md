## 1. Table Name ##
    clean.users_base
## 2. Overview ##
    This table stores user profile information such as user_id, name (first and last), age, email, demographics, and location. 
    Cleaning ensures data consistency and removes duplicate or incorrect records.
## 3. Before Cleaning Summary ##
    Total number of records (rows) before cleaning: 645
    Number of duplicate records found: 2
    Number of rows with missing values:
    Other issues identified:
## 4. Cleaning Steps & Rules Used

    Issue 1: Duplicate Records**
        How duplicates were identified: first_name, last_name + email - taylorreed@example.net appeared twice with same first_name and last_name
        Rows affected: 2
        Rule used: Keeping the highest age - keeping the record with age 40
        Action taken: Deleted 1 row)

    Issue 2: Invalid / Missing Values
        Field(s):
        Rows affected:
        Rule used: (e.g., drop rows, impute value, leave as NULL)  
        Action taken:
    
    Issue 3: Standardization / Formatting
        Fields standardized: (e.g., country names, city names, gender codes)
        Rule used:
        Action taken: