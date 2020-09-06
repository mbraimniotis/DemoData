--How many rides per day were completed using cash and how many using a credit card?
--A payment is made by credit card if at least one credit card is active at the time a ride is created
with cash_pmnt as(
select datename(WEEKDAY,r.created_at) AS DayOfWeek, count(1) as cnt
from rides r inner join fares s on r.id_request=s.id_request
where datepart(WEEK,r.created_at)='11' --Filter on week (week 11) -- filter on year is omitted because all data is from year 2018
and r.actual_revenue>0 --Rides without revenue are considered to be incomplete/cancelled by definition
and NOT EXISTS(SELECT 1 
		   FROM payment_mean p
		   WHERE p.id_passenger=s.id_passenger
				and r.created_at BETWEEN p.created_at and isnull(p.deleted_at, GETDATE()))
group by datename(WEEKDAY,r.created_at)),
credit_card_pmnt as (
select datename(WEEKDAY,r.created_at) DayOfWeek,
count(1) as cnt
from rides r inner join fares s on r.id_request=s.id_request
where datepart(WEEK,r.created_at)='11' --week 11, 2018
and r.actual_revenue>0 --Rides without revenue are considered to be incomplete/cancelled by definition
and EXISTS(SELECT 1 
		   FROM payment_mean p
		   WHERE p.id_passenger=s.id_passenger
				and r.created_at BETWEEN p.created_at and isnull(p.deleted_at, GETDATE()))
group by datename(WEEKDAY,r.created_at)),
all_payments as(
select c.DayOfWeek, 'Cash' as paid_by, c.cnt from cash_pmnt c
UNION ALL
select cc.DayOfWeek, 'Credit Card' as paid_by, cc.cnt from credit_card_pmnt cc)
select * from all_payments a
ORDER BY case a.DayOfWeek
         when 'Monday' then 1
         when 'Tuesday' then 2
         when 'Wednesday' then 3
         when 'Thursday' then 4
         when 'Friday' then 5
         when 'Saturday' then 6
         when 'Sunday' then 7
         end;
GO