## Overall Customer Behaviour insights

### Objective
Identify **top customers by revenue** and understand what drives high revenue.

### Data & Grain
- **Grain:** One row per customer per order per product
- **Filters:** Completed orders only

### Key Insights
**Tableau Dashboard:** [Top Customers by Revenue](https://public.tableau.com/views/Top10CustomersbyRevenue_17672030387250/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
- Majority of top customers placed only one order
- High revenue is driven by bulk purchases, not repeat orders

### Tools
PostgreSQL | Tableau Public

## 1. Customer Behavior & Retention Analysis

### Objective
Analyze customer purchasing behavior to understand retention patterns, revenue dependency, and customer value distribution.

### Data & Grain
- Customer-level aggregation derived from cleaned sales dataset (vw_customer_summary)
- Each row represents one customer with total revenue and order count
- **Filters:** Only 'completed' orders were included in analysis

### Approach
- Aggregated revenue at customer level using **SQL view**
- Classified customers as One-Time or Repeat based on order count
- Calculated customer distribution and revenue contribution by purchase behavior
- Measured revenue concentration among top customers 
- Visualized behavioral patterns using Tableau dashboards

### Key Insights
- **Tableau Dashboard:** [Cusotmer Behavior & Retention Analysis](https://public.tableau.com/app/profile/revathi.ravichandran/viz/TheLookECommerceDashboard/Dashboard1)
- **Customer Retention**
  - 90.7% of customers made only one purchase. 
  - Repeat customers represent only 9.3% of total customers.

- **Revenue Contribution**
  - One-time customers contribute approximately 80% of total revenue. 
  - Repeat customers contribute 20%, indicating higher value per returning customer.

- **Revenue Concentration**
  - Top 10 customers generate 45.5% of total revenue, showing dependency on a small customer segment.

### Business Recommendations
- Implement **retention strategies** such as **loyalty programs** and personalized engagement campaigns. 
- Protect **high-value customers** through **targeted promotions and VIP experiences**. 
- Encourage **repeat purchasing** through **bundled offers and reorder incentives**. 
- Reduce revenue risk by **expanding repeat customer base**.

### Tools
PostgreSQL | Tableau Public