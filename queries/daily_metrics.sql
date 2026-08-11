-- Дневной дашборд ключевых метрик
select date(date_created) as date_created,
sum(quantity*price) as gmv_created, 
count(distinct o.order_id) as orders_created,
sum(quantity*price)/count(distinct o.order_id) as AOV_created, 
count(distinct o.customer_id) as DAC_created,
count(distinct o.order_id)/count(distinct o.customer_id) as Frequency_created,
sum(quantity*price)/sum(quantity) as AIV_created, 
sum(quantity)/count(distinct o.order_id) as Items_per_Order_created
from sandbox.orders o join sandbox.order_details od on o.order_id = od.order_id
group by date(date_created) 
limit 100

-- AOV за конкретную неделю
select round(sum(quantity * price)::numeric / count(distinct o.order_id), 1) as AOV_created
from sandbox.orders o
join sandbox.order_details od on o.order_id = od.order_id
where date_created::date between '2018-07-09' and '2018-07-15'
  

-- AOV/active_customers/ARPPU за ту же неделю
  
select sum(quantity*price)/count(distinct o.order_id) as AOV_created,
count(distinct o.customer_id) as active_customers,
sum(quantity*price)/count(distinct o.customer_id) as arppu
from sandbox.orders o join sandbox.order_details od on o.order_id = od.order_id
where date_created::date between '2018-07-09' and '2018-07-15'
