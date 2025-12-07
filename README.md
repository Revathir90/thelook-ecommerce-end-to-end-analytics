
# 📊 TheLook E-commerce Analytics Project #

## End-to-End SQL • Data Modeling • ETL • Analytics • Tableau Dashboard ##

### 📁 Project Overview ###
   This project is an end-to-end data analytics workflow built using TheLook Ecommerce dataset.

**It covers every stage of the analytics lifecycle:** <br>
1. Identifying Business Objectives <br>
2. Data ingestion & cleaning <br>
3. Exploratory data analysis (EDA) with SQL <br>
4. Building analytics-ready tables using joins, CTEs, aggregations, and window functions <br>
5. Extracting insights on customers, orders, revenue, products, and fulfillment <br>
6. Creating an interactive Tableau Dashboard (upcoming)

This project demonstrates **SQL proficiency, analytical thinking, and dashboard-building skills**—all essential for Data Analyst roles.

### 🛠 Tools & Technologies ###

- SQL (PostgreSQL / BigQuery) <br>
- Excel (for initial checks & cleaning) <br>
- Tableau (dashboard visualization) <br>
- GitHub (version control & documentation)

### 🎯 Business Objective
The goal of this analysis is to support business decision-making for an e-commerce company by answering key questions related to customer behavior, revenue performance, product trends, and order fulfillment. This project assumes the role of a Data Analyst working with internal e-commerce data to provide actionable insights for stakeholders such as Marketing, Operations, and Leadership teams.

**Note**: This is an ongoing project, and insights and dashboards will be expanded as the analysis progresses.


###  🧱 Project Architecture (Medallion Style) ###

- **Bronze Layer (Raw Data)**
  - Import CSVs from BigQuery public dataset 
  - No transformations applied
- **Silver Layer (Cleaned Data)**
  - Null handling 
  - Standardization (dates, currency, categories)
  - Deduplication 
  - Format corrections
- **Gold Layer (Analytics-Ready)**
  - Fact tables: fact_orders, fact_order_items, fact_inventory 
  - Dimensions: dim_users, dim_products, dim_distribution_center 
  - Enriched KPIs for dashboards