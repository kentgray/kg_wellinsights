{{ config(materialized='table') }}

WITH date_series AS (
    SELECT 
        generate_series('2020-01-01'::date, '2030-12-31'::date, '1 day'::interval) AS date
)

SELECT
    ROW_NUMBER() OVER (ORDER BY date) AS date_id,
    date,
    EXTRACT(DAY FROM date)::INTEGER AS day,
    EXTRACT(MONTH FROM date)::INTEGER AS month,
    EXTRACT(QUARTER FROM date)::INTEGER AS quarter,
    EXTRACT(YEAR FROM date)::INTEGER AS year,
    TO_CHAR(date, 'Day') AS weekday
FROM date_series
