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

**Status & integrity check**
The status column contains 5 distinct, valid values:<br>
'Processing', 'Shipped', 'Complete', 'Returned', and 'Cancelled'.<br> 

All order_ids are unique, and no null or abnormal values were detected. This confirms that the table is structurally clean and ready for analysis.

**Chronological / timestamp consistency** <br>
All orders were verified to ensure created_at ≤ shipped_at ≤ delivered_at, and no future dates were present.<br>
Status-based timestamp checks were also performed to validate logical consistency with the order lifecycle. No violations were observed.


### **_3. clean.products_base_**
## Overview
The products_base table contains descriptive information for each product available in the e-commerce dataset. Each row represents a unique product identified by product_id. The table includes pricing, categorization, branding, and distribution details. It serves as a dimension table that provides context for sales, order, and margin analysis.

**Department Coverage Validation**
The products_base table contains only the Women department. No products from the Men department are present in the dataset. This is a source-level limitation and not a data quality error. Any analysis involving department-level comparisons should note this restriction. No null or unlabeled department values were found.

All product_ids are unique. Cost and retail price values were validated; no negative or zero values exist, and retail price ≥ cost. Department contains only Women products. Distribution center IDs were cross-checked with the distribution table. Categories, brands, and SKUs were reviewed for missing or inconsistent values. No major data quality issues were found, and the table is ready for analysis.

### **_4. clean.distribution_centers_base_**
The distribution_centers table contains master data for **warehouse and fulfillment locations** used in the e-commerce operation. Each row represents a unique distribution center responsible for storing and shipping products.

This is a dimension table with a **small, fixed number of records** (10 rows) and is used to link products and orders to their physical fulfillment locations.

### **_5. clean.order_items_base_**

The order_items table represents **line-level transaction data** for customer orders. Each row corresponds to a single product included in an order, making this table the **core fact table for sales and revenue analysis**.

It links customer orders to individual products and enables detailed analysis at the product, order, and customer levels.

**Data limitations:**
Since no product-level repeat purchases exist, customer retention metrics are evaluated at the order or category level rather than SKU level.

**Order Items Table Validation**<br>
The order_items table was validated as a transactional fact table. Primary key uniqueness and foreign key relationships to orders and products were confirmed. Product duplication across orders is expected. Pricing and timestamp fields were reviewed for invalid or illogical values. No critical data quality issues were found.