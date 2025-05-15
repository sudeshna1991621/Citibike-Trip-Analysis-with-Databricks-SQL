-- SQL Challenge 1
create a view called vw_trip_duration in the course_project 
catalog of the citibike schema that shows the ride id, start station id, 
end station id and trip duration in minutes for all rides. You can alias the
columns names however you see fit.

create view vw_trp_duration as
select ride_id,start_station_id,end_station_id,datediff(minute,started_at,ended_at) as `Duration`
from jc_bike_data_22;
select * from vw_trp_duration limit 5;

-- SQL Challenge 2
create a view called vw_outliers in the course_project 
catalog of the citibike schema. The view should contains only records where the trip 
duration is less than 0 or greater than 2000 minutes, along with the ride id and 
start and end station ids.

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
Return a query that shows the total number of journeys for each month. Use the 
started_at column to reference when each journey occured.

Use the jc_bike_data_22 table.

select count(ride_id) as total_ride,date_format(started_at,"MM") as month
from  jc_bike_data_22 group by date_format(started_at,"MM") order by date_format(started_at,"MM");
-- SQL Challenge 4
 return results showing the number of total rides for short, medium
and long duration journeys.

A short journey lasts under 10 minutes
A medium journey lasts between 10 - 60 minutes (inclusive)
A long journey is over 60 minutes

Use the jc_bike_data_22 dataset

Use subqueries

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
return a query that shows the most popular combination of start 
and end stations in terms of the total number of journeys across the dataset.

The start and end stations should be in the format:
'start_station_name TO end_station_name'
e.g. 'Van Vorst Park TO Jersey & 3rd'

Use the jc_bike_data_22 and station_data tables.

Hint 1: Consider using the concat function and join operations
Hint 2: Consider using subqueries

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
