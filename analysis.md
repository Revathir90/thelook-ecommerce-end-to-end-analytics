## Objective
1. Identify **top customers by revenue** and understand what drives high revenue.

### Data & Grain
- **Grain:** One row per customer per order per product
- **Filters:** Completed orders only

### Approach
- Aggregated revenue at customer level using **SQL view**
- Used Tableau to visualize top customers

### Key Insights
**Tableau Dashboard:** [Top Customers by Revenue](https://public.tableau.com/views/Top10CustomersbyRevenue_17672030387250/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
- Majority of top customers placed only one order
- High revenue is driven by bulk purchases, not repeat orders

### Tools
PostgreSQL | Tableau Public