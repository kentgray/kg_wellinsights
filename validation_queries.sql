set search_path to kg_wellinsights;

-- 1. Number of Wells per Operator
SELECT
    operator,
    COUNT(DISTINCT well_id) AS number_of_wells
FROM    dim_well
GROUP BY    operator;

-- 2. Total Lost Gas Production for Well with API = 0000000485 in 2020
SELECT    SUM(ABS(forecast.gas_forecast_volume - production.gas_volume)) AS total_lost_gas
FROM    fact_forecast forecast
        JOIN    fact_production production ON forecast.well_id = production.well_id AND forecast.date_id = production.date_id
        JOIN    dim_date d ON production.date_id = d.date_id
        JOIN    dim_well w ON forecast.well_id = w.well_id
WHERE        w.apiwellnumber = '0000000485' AND EXTRACT(YEAR FROM d.date) = 2020;

-- 3. Total Lost Gas Production for All Wells, Grouped by Area, for 2021
SELECT
    w.area,
    SUM(ABS(forecast.gas_forecast_volume - production.gas_volume)) AS total_lost_gas
FROM    fact_forecast forecast
        JOIN    fact_production production ON forecast.well_id = production.well_id AND forecast.date_id = production.date_id
        JOIN    dim_date d ON production.date_id = d.date_id
        JOIN    dim_well w ON forecast.well_id = w.well_id
WHERE        EXTRACT(YEAR FROM d.date) = 2021
GROUP BY    w.area;

-- 4. Pad with Most Net Gas on 07/14/2022
SELECT
    w.padname,
    SUM(production.gas_volume * w.nri) AS net_gas
FROM    fact_production production
        JOIN    dim_date d ON production.date_id = d.date_id
        JOIN    dim_well w ON production.well_id = w.well_id
WHERE        d.date = '2022-07-14'
GROUP BY    w.padname
ORDER BY    net_gas DESC
LIMIT 1;

-- 5. Total Cost of Workover Events by Field Group for June 2022
SELECT
    w.fieldgroup,
    SUM(workover.total_cost) AS total_cost
FROM    fact_workover workover
        JOIN    dim_date start_date ON workover.start_date_id = start_date.date_id
        JOIN    dim_date end_date ON workover.end_date_id = end_date.date_id
        JOIN    dim_well w ON workover.well_id = w.well_id
WHERE        EXTRACT(MONTH FROM start_date.date) = 6 AND EXTRACT(YEAR FROM start_date.date) = 2022
GROUP BY    w.fieldgroup;

-- 6. Wells with Highest Deviation of Gas from Forecast in July 2023
SELECT
    forecast.well_id,
    ABS(forecast.gas_forecast_volume - production.gas_volume) AS deviation
FROM    fact_forecast forecast
        JOIN    fact_production production ON forecast.well_id = production.well_id AND forecast.date_id = production.date_id
        JOIN    dim_date d ON production.date_id = d.date_id
WHERE        EXTRACT(MONTH FROM d.date) = 7 AND EXTRACT(YEAR FROM d.date) = 2023
ORDER BY    deviation DESC;
