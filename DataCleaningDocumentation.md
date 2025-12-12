## Table Name ##
### **_1. clean.users_base_**
## Overview ##
This table stores user profile information such as user_id, name (first and last), age, email, demographics, and location. 
    Cleaning ensures data consistency and removes duplicate or incorrect records.
## Before Cleaning Summary ##
Total number of records (rows) before cleaning: 645 <br>
Number of duplicate records found: 2 **(email based duplication)** <br>
Number of rows with missing values: 27 **(NULL values in city field)** <br>
Other issues identified: **Inconsistent postal code** format (with and without extended codes)

## Cleaning Steps & Rules Used

### **Duplicate Records**

**How duplicates were identified:** Duplicates were identified using a two-step approach:<br>**Name-level scan:** First and last names were grouped to identify potential duplicate users (GROUP BY first_name, last_name HAVING COUNT(*) > 1).
<br>**Confirmation using unique identifier:** Email address was then used to confirm true duplicates, as email is treated as the primary unique identifier for users.

    -- Identify duplicate users
    SELECT first_name, last_name, email, COUNT(*) AS duplicate_user_count
    FROM clean.users_base
    GROUP BY first_name, last_name, email
    HAVING COUNT(*) > 1;

**Rows affected:** 2<br>
**Rule used:** Retained the record with the higher age, assuming it represents the most recent profile update.<br>
**Action taken:** 1 duplicate record removed

### **Invalid / Missing Values**

**How NULL values are checked and identified:** Some records contained the **string representations of missing values** (e.g., 'null') in the city column rather than actual SQL NULL values.<br>
These values were **standardized to proper NULLs** to ensure accurate filtering, aggregation, and analysis.

    -- Checking for null value count
    SELECT
        SUM(CASE WHEN first_name ILIKE 'null' THEN 1 ELSE 0 END) AS first_name_null_count, --count=0
        SUM(CASE WHEN last_name ILIKE 'null' THEN 1 ELSE 0 END) AS last_name_null_count, --count=0
        SUM(CASE WHEN city ILIKE 'null' THEN 1 ELSE 0 END) AS city_null_strings, --count=27
        SUM(CASE WHEN state ILIKE 'null' THEN 1 ELSE 0 END) AS state_null_strings, --count=0
        SUM(CASE WHEN country ILIKE 'null' THEN 1 ELSE 0 END) AS country_null_strings --count=0
    FROM clean.users_base;
    
    -- Updating the string nulls to proper SQL NULLs
    UPDATE clean.users_base
    SET city = NULL
    WHERE city ILIKE 'null';

**Field(s):** clean.users_base.city<br>
**Rows affected:** 27<br>
**Rule used:** City values were left as NULL to avoid introducing inaccurate or assumed data<br>
**Action taken:** standardized to proper SQL NULLs and,<br>
Since there are no reliable rule existed to infer city values without external reference data,
"city" values were left as NULL.
    
### **Data Validation & Standardization**
Performed format, completeness, and domain validation checks on key fields including email, postal code, gender, and location attributes to ensure data quality prior to analysis.
        
**Field(s):** clean.users_base.postal_code<br>
**Issue Identified:** Postal codes appeared in mixed formats (e.g., 57018 vs 57018-1234).<br>
**Impact:** Inconsistent postal code formats could affect grouping, filtering, and regional analysis.
    
    -- Postal code check
    SELECT *
    FROM clean.users_base
    WHERE postal_code !~ '^[0-9]+$'; -- Found postal codes with extended code. Total count 151
    
    -- Checking postal codes with extension for Japan
    SELECT *
    FROM clean.users_base
    WHERE POSITION('-' IN postal_code) < 5 AND POSITION('-' IN postal_code) > 0; -- Japan country count 6

**Rows Affected:** 151 rows<br>
**Rule used:** Standardize the postal code to the base format where legitimate information won't be losed<br>

**NOTE:** Postal code **formats vary by country**. For **Japan, the standard format is NNN-NNNN**<br>

**Action taken:** For Japan the standard format is retained, as both segments are required for postal accuracy.<br>
For other countries where the suffix did not add analytical value, postal codes were standardized to the base format.<br>

    -- Updaing postal code with base format other than Japan.
    UPDATE clean.users_base
    SET postal_code = SPLIT_PART(postal_code, '-', 1)
    WHERE postal_code LIKE '%-%'
    AND country <> 'Japan'; -- Updated record/row count 151 - 6 = 145

**Updated Rows Count:** 151 - 6 = 145


### **_2. clean.orders_base_**
## Overview 
The clean.orders_base table contains order-level descriptive information related to each customer order, such as order status, timestamps, and fulfillment-related attributes. It is used as a supporting dimension that provides contextual order details to downstream fact tables.

The table is linked to users and order items through unique identifiers and does not store payment or transaction-level metrics.<br>

**Data Source Considerations:**<br>
The dataset was sourced from BigQuery (TheLook Ecommerce). Attribute completeness and category representation were validated during analysis. Where source-level limitations were identified, alternative dimension tables were used and limitations were documented.

**Orders Table Sanity Check**
User-level order counts were computed to validate completeness and consistency. No missing user_ids or anomalous counts were observed.

    -- orders_base Table Sanity Check
    SELECT user_id, COUNT(num_of_item) AS order_count
    FROM clean.orders_base
    GROUP BY user_id
    ORDER BY order_count DESC

The status column contains 5 distinct, valid values: 'Processing', 'Shipped', 'Complete', 'Returned', and 'Cancelled'. All order_ids are unique, and no null or abnormal values were detected. This confirms that the table is structurally clean and ready for analysis.
