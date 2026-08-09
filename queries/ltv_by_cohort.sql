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
SELECT *
FROM cohort_sales
WHERE date_paid < first_order_date + INTERVAL '6 months'
AND date_paid IS NOT null),
ltv_by_cohort AS (
select cohort_month,
COUNT(DISTINCT seller_id) AS sellers_in_cohort,
SUM(margin) AS total_margin_6m,
ROUND(SUM(margin) * 1.0 / NULLIF(COUNT(DISTINCT seller_id), 0),2) AS ltv_per_seller
FROM six_months_sales
GROUP BY cohort_month
)
SELECT cohort_month
FROM ltv_by_cohort
ORDER BY ltv_per_seller DESC
