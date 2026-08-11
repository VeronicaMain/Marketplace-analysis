-- Полная LTV-модель за 6 месяцев
with cohort_sellers as (
select od.seller_id, date(date_trunc('month', min(date_paid))) as cohort_month,
min(o.date_paid) as first_order_date
from orders o join order_details od on o.order_id = od.order_id 
group by od.seller_id), 
cohort_sales as (
select cs.cohort_month, cs.first_order_date ,o.date_paid, od.seller_id, od.quantity*od.price*od.commission as margin 
from orders o join order_details od on o.order_id = od.order_id 
join cohort_sellers cs on cs.seller_id = od.seller_id),
six_months_sales as (
select *
from cohort_sales
where date_paid < first_order_date + interval '6 months'
and date_paid is not null),
ltv_by_cohort as (
select cohort_month,
count(distinct seller_id) as sellers_in_cohort,
sum(margin) as total_margin_6m,
round(sum(margin) * 1.0 / nullif(count(distinct seller_id), 0),2) as ltv_per_seller
from six_months_sales
group by cohort_month
)
select cohort_month, sellers_in_cohort, ltv_per_seller
from ltv_by_cohort
order by ltv_per_seller desc
