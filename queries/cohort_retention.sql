-- Полная Retention-модель по продавцам
with t1 as(
select seller_id, date(date_trunc('month', min(date_paid))) as cohort_month
from sandbox.orders as o join sandbox.order_details as od on o.order_id = od.order_id
group by seller_id)
select t1.cohort_month,
date(date_trunc('month', date_paid)) as purchase_month,
row_number()over(partition by t1.cohort_month order by date(date_trunc('month',date_paid))) purchase_month_number,
count(distinct od.seller_id) as sellers_paid,
count(distinct od.seller_id)*1.0/min(cohort_size) as retention,
sum(quantity*price) as gmv_paid,
sum(quantity*price*commission) as margin_paid,
sum(quantity*price)/count(distinct od.seller_id) as arpps_paid
from sandbox.orders as o join sandbox.order_details as od on o.order_id = od.order_id
join t1 on od.seller_id = t1.seller_id
join (
select cohort_month, count(*) as cohort_size
from t1 
group by cohort_month
) as t2 on t1.cohort_month = t2.cohort_month
group by t1.cohort_month, date(date_trunc('month', date_paid))
order by t1.cohort_month, date(date_trunc('month', date_paid))

-- Усреднённая кривая retention по всем когортам (для графика)
with t1 as(
select seller_id, date(date_trunc('month', min(date_paid))) as cohort_month
from sandbox.orders as o join sandbox.order_details as od on o.order_id = od.order_id
group by seller_id),
cohort_data as (
select t1.cohort_month,
row_number()over(partition by t1.cohort_month order by date(date_trunc('month',date_paid))) purchase_month_number,
count(distinct od.seller_id)*1.0/min(cohort_size) as retention
from sandbox.orders as o join sandbox.order_details as od on o.order_id = od.order_id
join t1 on od.seller_id = t1.seller_id
join (
select cohort_month, count(*) as cohort_size
from t1 
group by cohort_month
) as t2 on t1.cohort_month = t2.cohort_month
group by t1.cohort_month, date(date_trunc('month', date_paid)))
select purchase_month_number, 
round(avg(retention)*100, 1) as avg_retention_percent, 
count(distinct cohort_month) as cohorts_count
from cohort_data
group by purchase_month_number
order by purchase_month_number
