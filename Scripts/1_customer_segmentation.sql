WITH 
customer_ltvs AS (
	SELECT ca.customerkey ,ca.cleaned_name,
	SUM(ca.total_net_revenue)AS customer_ltv
	FROM cohort_analysis ca
	GROUP BY ca.customerkey, ca.cleaned_name),

segmentation AS (
	SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY customer_ltv) AS ltv_25th_percentile,
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY customer_ltv) AS ltv_75th_percentile
	FROM customer_ltvs),
	
customers_seg AS (
SELECT l.*,
	CASE
	 WHEN l.customer_ltv <= s.ltv_25th_percentile THEN '1-LOW'
	 WHEN l.customer_ltv > s.ltv_75th_percentile THEN '3-HIGH'
	 ELSE '2-MID' END AS customer_segment
	FROM customer_ltvs l,
	segmentation s)

SELECT 
customer_segment, COUNT(customerkey) AS customers_count,
SUM(customer_ltv) AS total_ltv,
SUM(customer_ltv)/COUNT(customerkey) AS avg_ltv
FROM customers_seg
GROUP BY customer_segment
ORDER BY customer_segment
