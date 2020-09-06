--Provide a list of active passengers sorted descending by volume of rides.
----Active passengers are considered those who have at least 1 completed ride
----Incomplete rides are not included in the counts
select fs.id_passenger, count(1) as TotalCompleteRides
from fares fs inner join rides r on fs.id_request=r.id_request
where datepart(WEEK,r.created_at)='11' --Filter on week (week 11) -- filter on year is omitted because all data is from year 2018
	and r.actual_revenue>0 --Rides without revenue are considered to be incomplete/cancelled -- not included in rides count
group by fs.id_passenger
order by 2 desc;
GO