-- Неоплаченные заказы (сколько заказов имеют дату создания (date_created), но не имеют даты оплаты (date_paid), то есть они были созданы, но не выкуплены)
select count(distinct o.order_id)
from sandbox.orders o join sandbox.order_details od on o.order_id = od.order_id
where o.date_created is not null and o.date_paid is null

-- GMV_paid/margin за неделю (считалось по дате выкупа date_paid)
select sum(quantity*price) as gmv_paid,
sum(quantity*price*commission) as margin
from sandbox.orders o join sandbox.order_details od on o.order_id = od.order_id
where date_paid::date between '2018-07-09' and '2018-07-15'

-- Версия margin_per_order по дням
select date(date_paid) as date_paid,
count(distinct od.order_id) as paid_orders,
sum(quantity*price) as gmv_paid,
sum(quantity*price*commission) as margin,
sum(quantity*price*commission)/count(distinct od.order_id) as margin_per_order
from sandbox.orders o join sandbox.order_details od on o.order_id = od.order_id
group by date(date_paid)
order by margin_per_order desc 
