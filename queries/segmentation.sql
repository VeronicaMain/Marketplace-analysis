-- GMV по категориям
select category_name,
sum(quantity*price) as gmv_created
from sandbox.orders as o join sandbox.order_details as od on o.order_id = od.order_id
where date_created::date between '2018-07-09' and '2018-07-15'
group by category_name
order by gmv_created desc
