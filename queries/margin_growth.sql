-- Рост маржинальности неделя к неделе
select *, round((margin_cur/margin_prev - 1) * 100, 1) as margin_growth
from (
select w_date, margin as margin_prev, gmv as gmv_prev,
lead(margin) over(order by w_date) as margin_cur
from (
select date_trunc('week', date_paid)::date as w_date,
sum(quantity * price * commission) as margin,
sum(quantity * price) as gmv
from sandbox.orders as o
inner join sandbox.order_details as od on o.order_id = od.order_id
group by date_trunc('week', date_paid)) as t1 ) as t2
where w_date = '2018-07-02'

-- margin_per_order версия по месяцам
select date_trunc('month', date_paid)::date as m_date,
sum(quantity * price * commission) as margin,
count(distinct o.order_id) as cnt_orders,
round(sum(quantity * price * commission) / count(distinct o.order_id), 2) as margin_per_order
from sandbox.orders as o
inner join sandbox.order_details as od on o.order_id = od.order_id
group by date_trunc('month', date_paid)::date
order by 4 desc
