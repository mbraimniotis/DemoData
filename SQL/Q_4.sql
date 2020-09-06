--What was the request to ride ratio per weekday and per hour?
--Ride to request conversions which span along different hour slots
--will be considered in the aggregations of the hour slot when request initiated.
SELECT datename(WEEKDAY,rq.created_at) AS DayOfWeek
,convert(varchar(2), format(datepart(HOUR,rq.created_at),'00') + ':00:00-' + convert(varchar(2), format(datepart(HOUR,rq.created_at),'00'))) + ':59:59' as HourOfDay
,SUM(CASE WHEN isnull(rd.actual_revenue,0)=0 THEN 0.00 ELSE 1.00 END)/COUNT(1) AS RideToRequestRatio
FROM requests rq 
LEFT JOIN rides rd ON rq.id_request = rd.id_request AND rd.actual_revenue>0.0
WHERE datepart(WEEK,rq.created_at)='11'
GROUP BY datename(WEEKDAY,rq.created_at),datepart(HOUR,rq.created_at)
ORDER BY case datename(WEEKDAY,rq.created_at)
                      when 'Monday' then 1
                      when 'Tuesday' then 2
                      when 'Wednesday' then 3
                      when 'Thursday' then 4
                      when 'Friday' then 5
                      when 'Saturday' then 6
                      when 'Sunday' then 7
                      end, datepart(HOUR,rq.created_at);
GO