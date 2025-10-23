# 🧩 Contoso Sales Analytics Project
## 🧠 Overview

This project explores the Contoso Sales dataset — a simulated business dataset commonly used by Microsoft for analytics demos.
The goal is to analyze sales performance, customer behavior, and regional profitability using PostgreSQL for data processing and ChatGPT-assisted visualization for insights presentation.

By combining SQL-based analytics with AI-assisted visualization, this project demonstrates how business intelligence workflows can be efficiently executed using open-source tools.

## 📊 Business Questions

### 1. Customer Segmentation:
Customer segmentation based on total net revenue (LTV – Lifetime Value) using percentile thresholds.

### 🧩 Query Breakdown

#### Step 1 – Base View: cohort_analysis

```sql
CREATE OR REPLACE VIEW public.cohort_analysis AS
WITH revenue_table AS (
  SELECT
    s.customerkey,
    s.orderdate,
    SUM(s.quantity::double precision * s.netprice / s.exchangerate) AS total_net_revenue,
    COUNT(s.orderkey) AS no_of_orders
  FROM sales s
  GROUP BY s.customerkey, s.orderdate
)
SELECT
  rt.customerkey,
  rt.orderdate,
  rt.total_net_revenue,
  rt.no_of_orders,
  MIN(rt.orderdate) OVER (PARTITION BY rt.customerkey) AS first_order_date,
  EXTRACT(YEAR FROM MIN(rt.orderdate) OVER (PARTITION BY rt.customerkey)) AS cohort_year,
  c.countryfull,
  c.age,
  c.givenname,
  c.surname
FROM revenue_table rt
LEFT JOIN customer c ON rt.customerkey = c.customerkey;
```
#### Purpose:

Builds a customer-level dataset linking each customer’s transactions and their first purchase date (used for cohort identification).

#### Step 2 – Compute LTV per Customer
```sql
customer_ltvs AS (
  SELECT 
    ca.customerkey,
    ca.cleaned_name,
    SUM(ca.total_net_revenue) AS customer_ltv
  FROM cohort_analysis ca
  GROUP BY ca.customerkey, ca.cleaned_name
)
```
#### Purpose:

Aggregates all transactions for each customer into their Lifetime Value (LTV) = total net revenue generated.

#### Step 3 – Determine Percentile Thresholds
```sql
segmentation AS (
  SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY customer_ltv) AS ltv_25th_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY customer_ltv) AS ltv_75th_percentile
  FROM customer_ltvs
)
```
#### Purpose:

* Uses SQL’s PERCENTILE_CONT to compute the 25th and 75th percentiles of customer LTV.

* These thresholds will define the LOW, MID, and HIGH segments.
#### Step 4 – Segment Customers
```sql
customers_seg AS (
  SELECT 
    l.*,
    CASE
      WHEN l.customer_ltv <= s.ltv_25th_percentile THEN '1-LOW'
      WHEN l.customer_ltv > s.ltv_75th_percentile THEN '3-HIGH'
      ELSE '2-MID'
    END AS customer_segment
  FROM customer_ltvs l, segmentation s
)
```
#### Purpose:

Categorizes each customer into:

* 1-LOW → bottom 25%

* 2-MID → middle 50%

* 3-HIGH → top 25%

#### Step 5 – Aggregate Segment Insights
```sql
SELECT 
  customer_segment,
  COUNT(customerkey) AS customers_count,
  SUM(customer_ltv) AS total_ltv,
  SUM(customer_ltv)/COUNT(customerkey) AS avg_ltv
FROM customers_seg
GROUP BY customer_segment
ORDER BY customer_segment;
```
#### Purpose:

* Summarizes key metrics per segment:

* Customers count per tier

* Total LTV contribution

| Segment    | Customers Count | Total LTV (Sales) | Average LTV |
| ---------- | --------------: | ----------------: | ----------: |
| **1-LOW**  |          12,372 |         4,298,367 |         347 |
| **2-MID**  |          24,743 |        66,367,810 |       2,682 |
| **3-HIGH** |          12,372 |       135,606,969 |      10,961 |

#### 📈 Revenue Contribution by Customer Segment

![Customer Segment Revenue Share](visuals/segment_revenue_share.png)


### 📊 Analysis

#### 1️⃣ Low-Value Customers (1-LOW)

* Represents: ~25% of total customer base (12,372 out of ~49,000).

* Revenue Contribution: ~2% of total LTV.

* Average LTV: Only $347 per customer — very low spenders.

* Insight: Large in number, but minimal contribution. Possibly one-time or low-engagement buyers.

#### 2️⃣ Mid-Value Customers (2-MID)

* Represents: ~50% of customers (24,743).

* Revenue Contribution: ~32% of total LTV.

* Average LTV: $2,682, meaning moderate engagement and purchasing consistency.

* Insight: This segment drives consistent sales volume — great potential for upselling and loyalty conversion.

#### 3️⃣ High-Value Customers (3-HIGH)

* Represents: ~25% of customers (12,372).

* Revenue Contribution: ~66% of total LTV!

* Average LTV: $10,961 per customer — nearly 32× higher than low-value customers.

* Insight: Classic Pareto principle (80/20 rule) — a small group generates the majority of revenue.

* Losing even a small portion of these customers would significantly impact revenue.

### 🧭 Strategic Recommendations

#### 🎯 For High-Value Customers (Top 25%)

* Implement exclusive loyalty programs (priority service, rewards, early access).

* Use personalized retention campaigns — predictive churn analysis can help identify drop risks.

* Maintain premium experiences — avoid price sensitivity.

#### ⚡ For Mid-Value Customers (Middle 50%)

* Focus on upselling and cross-selling (e.g., complementary products).

* Offer tier-based rewards to incentivize higher spending.

* Send personalized product recommendations based on past behavior.

#### 🪄 For Low-Value Customers (Bottom 25%)

* Run re-engagement campaigns (discounts, first-time bundles).

* Simplify checkout or subscription plans to reduce drop-offs.

* Identify whether they are new or churned users — tailor communication accordingly.

