select cohort_year,
COUNT(DISTINCT customerkey) as total_customers,
SUM(total_net_revenue) as total_revenue,
SUM(total_net_revenue)/COUNT(DISTINCT customerkey) as customer_revenue
from cohort_analysis
where orderdate = first_order_date
GROUP BY cohort_year
