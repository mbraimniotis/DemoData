-- Provide the latitude and longitude for each id_request.
select r.id_request, r.latitude, r.longitude
from requests r
where datepart(WEEK,r.created_at)='11'
AND substring(r.created_at,1,4)='2018'; --This filter can be omitted since all data are from 2018
go