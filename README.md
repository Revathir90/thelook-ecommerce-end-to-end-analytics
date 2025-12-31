
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

**Analytical Considerations & Data Limitations**

- The dataset contains only Women’s products; no Men’s department data is available.

- Order records reflect purchases made by female users only, which limits gender-based comparative analysis.

- No repeat purchases of the same product by the same user were observed; therefore, SKU-level repeat purchase analysis is not applicable.

These constraints are inherent to the dataset and were considered when defining analysis scope and KPIs.

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
  - Fact table: fact_order_items 
  - Dimensions: dim_users, dim_orders, dim_products, dim_distribution_center 
  - Enriched KPIs for dashboards

### 📊 Dashboard
This project includes an interactive Tableau dashboard answering:<br>
**Who are the top customers by revenue?**

🔗 Tableau Public Link: [Top Customers by Revenue](https://public.tableau.com/views/Top10CustomersbyRevenue_17672030387250/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

**📌 Key visuals:**
- Top 10 customers by total revenue
- Revenue distribution by customer
- Tooltip details: User_id, Revenue, Order Count, Product Count

**🔍 Key Insights**
- Majority of top customers placed only one order
- High revenue is driven by bulk purchases, not repeat orders
- Revenue concentration is skewed toward top customers