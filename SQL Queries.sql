-- SQL Challenge 1
create view vw_trp_duration as
select ride_id,start_station_id,end_station_id,datediff(minute,started_at,ended_at) as `Duration`
from jc_bike_data_22;
select * from vw_trp_duration limit 5;
-- SQL Challenge 2
DROP VIEW IF EXISTS vw_outliers;

CREATE VIEW vw_outliers AS
SELECT 
  ride_id,
  start_station_id,
  end_station_id,
  Datediff(MINUTE, started_at, ended_at) AS Duration
FROM jc_bike_data_22
WHERE TIMESTAMPDIFF(MINUTE, started_at, ended_at) > 2000 
   OR TIMESTAMPDIFF(MINUTE, started_at, ended_at) < 0;

SELECT * FROM vw_outliers;

-- SQL Challenge 3
select count(ride_id) as total_ride,date_format(started_at,"MM") as month
from  jc_bike_data_22 group by date_format(started_at,"MM") order by date_format(started_at,"MM");
-- SQL Challenge 4
select trip_category,count(ride_id) as total_ride from (select 
 ride_id,Duration, 
Case when Duration>60 then "long"
 when Duration>30 then "medium"
else "short" 
end as trip_category
from trip_duration) group by trip_category;

-- using jc_bike-data

select trip_category,count(ride_id) as total_ride from (select 
 ride_id,Duration, 
Case when Duration>60 then "long"
 when Duration>=10 then "medium"
else "short" 
end as trip_category
from (select ride_id, datediff(minute,started_at,ended_at) as `Duration` from jc_bike_data_22)) group by trip_category;

-- SQL Challenge 5
select concat(start_station," to ",end_station_name) as Route, count(ride_id) as total_ride from (
SELECT sub.ride_id, sub.start_station, end_station.station_name AS end_station_name
FROM (
    SELECT 
        j.ride_id, 
        s.station_name AS start_station, 
        j.end_station_id
    FROM jc_bike_data_22 j
    JOIN jc_station_data_22 s
        ON j.start_station_id = s.station_id
) AS sub
JOIN jc_station_data_22 end_station
    ON sub.end_station_id = end_station.station_id) group by concat(start_station," to ",end_station_name) order by total_ride desc;