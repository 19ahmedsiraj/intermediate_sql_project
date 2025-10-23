SELECT
date_trunc('month', ca.orderdate)::date year_month,
SUM(total_net_revenue) AS revenue,
COUNT(DISTINCT customerkey) AS total_customers,
SUM(total_net_revenue)/COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis ca 
GROUP BY year_month
ORDER BY year_month 
