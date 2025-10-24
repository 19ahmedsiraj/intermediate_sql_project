WITH last_orders as 
    (select 
        customerkey,
        orderdate,
        first_order_date,
        cleaned_name,
        cohort_year,
        ROW_NUMBER() OVER(PARTITION BY customerkey ORDER BY orderdate DESC) as rn
    from cohort_analysis),

customer_status AS (
SELECT 
    customerkey,
    cleaned_name,
    orderdate,
CASE WHEN orderdate <(select MAX(orderdate)from sales)::date- INTERVAL'6 months' THEN 'Churned'
        ELSE 'Active' END AS status,
        cohort_year
from last_orders
where rn = 1
    AND first_order_date <(select MAX(orderdate)from sales)::date - INTERVAL '6 months'
)

SELECT cohort_year,status, COUNT(customerkey) as number_of_customers,
SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) as customers_total,
ROUND(COUNT(customerkey)/SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year),2) as customers_percentage
from customer_status
group by cohort_year,status 