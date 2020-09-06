-- How many requests per day happened during week 11, 2018 and during previous week?
WITH req_week_day as (
select datepart(WEEK,r.created_at) AS WeekofYear, datename(WEEKDAY, r.created_at) AS DayOfWeek
from requests r
where datepart(WEEK,r.created_at) in ('10','11') --filter on week (week 10,11) -- filter on year is omitted because all data is from year 2018
)
SELECT WeekOfYear,DayOfWeek, count(*) as DailyRequests
from req_week_day
group by WeekofYear, DayOfWeek
order by WeekofYear, case DayOfWeek
                      when 'Monday' then 1
                      when 'Tuesday' then 2
                      when 'Wednesday' then 3
                      when 'Thursday' then 4
                      when 'Friday' then 5
                      when 'Saturday' then 6
                      when 'Sunday' then 7
                      end;
GO
