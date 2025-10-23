WITH total_sales AS (select customerkey,
SUM(netprice*exchangerate*quantity) as net_revenue
from sales
group by customerkey)

select
AVG(net_revenue) as spending_customers,
AVG(COALESCE(net_revenue,0)) as all_customers
from customer c left join total_sales t on c.customerkey=t.customerkey
