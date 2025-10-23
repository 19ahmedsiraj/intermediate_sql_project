
CREATE VIEW cohort_analysis AS 

WITH revenue_table AS (
SELECT 
	s.customerkey,
	s.orderdate, 
	SUM(s.quantity* s.netprice/s.exchangerate) AS total_net_revenue,
	COUNT(s.orderkey) AS no_of_orders
FROM sales s
GROUP BY 
	s.customerkey,
	s.orderdate
)
SELECT 
	rt.*,
	MIN(orderdate) OVER(PARTITION BY rt.customerkey) AS first_order_date,
	EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY rt.customerkey)) AS cohort_year,
	c.countryfull,
	c.age,
	c.givenname,
	c.surname
FROM revenue_table rt LEFT JOIN customer c ON rt.customerkey = c.customerkey