-- Рост маржинальности неделя к неделе
select w_date, margin, gmv, lag(margin) over (order by w_date) as margin_prev_week,
round((margin/nullif(lag(margin) over (order by w_date),0) - 1) * 100, 1) as margin_growth_percent
from (
select w_date, margin as margin_prev, gmv as gmv_prev,
lead(margin) over(order by w_date) as margin_cur
from (
select date_trunc('week', date_paid)::date as w_date,
sum(quantity * price * commission) as margin,
sum(quantity * price) as gmv
from sandbox.orders as o
inner join sandbox.order_details as od on o.order_id = od.order_id
where date_paid is not null
group by date_trunc('week', date_paid)::date ) as weekly
order by w_date

-- margin_per_order версия по месяцам
select date_trunc('month', date_paid)::date as m_date,
sum(quantity * price * commission) as margin,
count(distinct o.order_id) as cnt_orders,
round(sum(quantity * price * commission) / count(distinct o.order_id), 2) as margin_per_order
from sandbox.orders as o
inner join sandbox.order_details as od on o.order_id = od.order_id
group by date_trunc('month', date_paid)::date
order by 4 desc
