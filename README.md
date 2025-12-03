
# 📊 TheLook E-commerce Analytics Project #

## End-to-End SQL • Data Modeling • ETL • Analytics • Tableau Dashboard ##

   ### 📁 Project Overview ###
    This project is an end-to-end data analytics workflow built using TheLook Ecommerce dataset.

    It covers every stage of the analytics lifecycle:
        1.	Data ingestion & cleaning
        2.	Exploratory data analysis (EDA) with SQL
        3.	Building analytics-ready tables using joins, CTEs, aggregations, and window functions
        4.	Extracting insights on customers, orders, revenue, products, and fulfillment
        5.	Creating an interactive Tableau Dashboard (upcoming)

    This project demonstrates SQL proficiency, analytical thinking, and dashboard-building skills—all essential for Data Analyst roles.
### 🛠 Tools & Technologies ###
        •	SQL (PostgreSQL / BigQuery)
        •	Excel (for initial checks & cleaning)
        •	Tableau (dashboard visualization)
        •	GitHub (version control & documentation)

###  🧱 Project Architecture (Medallion Style) ###
    Bronze Layer (Raw Data)
        •	Import CSVs from BigQuery public dataset
        •	No transformations applied
    Silver Layer (Cleaned Data)
        •	Null handling
        •	Standardization (dates, currency, categories)
        •	Deduplication
        •	Format corrections
    Gold Layer (Analytics-Ready)
        •	Fact tables: fact_orders, fact_order_items, fact_inventory
        •	Dimensions: dim_users, dim_products, dim_distribution_center
        •	Enriched KPIs for dashboards