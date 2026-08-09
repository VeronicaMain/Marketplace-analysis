-- Дневная воронка событий
select date(event_time) as dt,
count(distinct user_session) as sessions,
count(distinct (case when event_type = 'purchase' then user_session end)) as sessions_with_purchase,
count(distinct user_id) as dau,
count(distinct (case when event_type = 'view' then user_id end)) as users_with_view,
count(distinct (case when event_type = 'cart' then user_id end)) as users_with_cart,
count(distinct (case when event_type = 'purchase' then user_id end)) as users_with_purchase,
sum(case when event_type = 'purchase' then price end) as gmv_created
from sandbox.events_201911
group by date(event_time)

-- MAU (monthly active users) 
select count(distinct user_id) as mac
from sandbox.events_201911
where event_time >= '2019-11-01'
and event_time <  '2019-12-01'
and event_type = 'purchase'

-- orders_count через составной ключ
select count(distinct (user_id, event_time)) as orders_count
from sandbox.events_201911
where event_type = 'purchase'
and event_time >= '2019-11-01'
and event_time <  '2019-12-01'

-- Конверсия по дням
select dt
from (
select date(event_time) as dt,
count(*) as total_sessions,
count(case when event_type = 'purchase' then 1 end) as purchase_sessions,
(count(case when event_type = 'purchase' then 1 end) * 1.0 / nullif(count(*), 0)) * 100 as conversion_percent
from sandbox.events_201912
group by date(event_time)
) as t
order by conversion_percent desc
