# Citibike Trip Analysis with SQL on Databricks

## Project Overview
This project analyzes Citibike trip data to uncover ridership patterns, differences between casual riders and annual members, popular stations, and ride duration trends. The analysis is performed using SQL on Databricks, with results visualized to highlight key insights.

---

## Datasets
- **Primary Datasets**:
  - `jc_bike_data_22`: Contains ride details (start/end times, member type, rideable type, and station IDs).
  - `jc_station_data_22`: Maps station IDs to human-readable station names.
- **Derived Datasets**:
  - `most_common_stations`: Frequently used start/end stations.
  - `vw_jc_bike_data_22`: Enhanced view combining trip data with station names (see [SQL Analysis](#sql-analysis)).
  - Custom tables created via SQL queries (e.g., duration calculations).

---

## Key Features
- **Parameters**: 
  - `Start_date` and `End_date` (e.g., May 25, 2022 – Dec 08, 2023).
- **Data Enrichment**:
  - Station names mapped to IDs for readability.
  - Trip duration calculated in minutes.
- **Filters**:
  - Excludes `docked_bike` rides and trips with missing `end_station_id`.
- **Visualizations**: 
  - Ride trends over time (July 2022 snapshot) comparing `member` and `casual` users.

---

## SQL Analysis
### Core Queries
**Basic Trip Analysis Query:**

SELECT  
  member_casual,  
  rideable_type,  
  started_at,  
  ended_at,  
  DATEDIFF(MINUTE, started_at, ended_at) AS 'Total Duration'  
FROM jc_slice_data_22;


