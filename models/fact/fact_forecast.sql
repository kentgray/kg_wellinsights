-- models/fact_forecast.sql

{{ config(materialized='table') }}

WITH economic_data AS (
    SELECT
        propnum,
        day_init,
        gas_rate_init,
        gas_b_factor,
        generate_series(day_init, '2023-12-31'::date, '1 day') AS forecast_date,
        gas_decline_init_daily_nom
    FROM {{ ref('stg__aries__ac_economic') }}
),


date_series AS (
    SELECT 
        propnum,
        day_init,
        gas_rate_init,
        gas_b_factor,
        gas_decline_init_daily_nom,
        generate_series(day_init, '2023-12-31'::date, '1 day') AS forecast_date
    FROM economic_data
),

forecast_calc AS (
    SELECT
        ds.propnum,
        ds.forecast_date,
        ds.gas_rate_init::numeric / (1 + (ds.gas_b_factor::numeric * ds.gas_decline_init_daily_nom::numeric * EXTRACT(EPOCH FROM (ds.forecast_date - ds.day_init)) / 86400))::numeric AS gas_forecast_volume
    FROM date_series ds
)

SELECT
    ROW_NUMBER() OVER (ORDER BY fc.propnum, fc.forecast_date) as forecast_id,
    fc.propnum::UUID AS well_id,
    dd.date_id,
    fc.gas_forecast_volume
FROM
    forecast_calc fc
JOIN {{ ref('dim_date') }} dd ON fc.forecast_date = dd.date
-- SELECT
--     ROW_NUMBER() OVER () AS forecast_id,
--     e.propnum::UUID as well_id,
--     d.date_id,
--     CASE
--         WHEN d.date >= e.day_init THEN
--             e.gas_rate_init::numeric / (1 + (e.gas_b_factor::numeric * e.gas_decline_init_daily_nom::numeric * EXTRACT(EPOCH FROM (d.date - e.day_init)) / 86400))
--         ELSE
--             NULL
--     END AS gas_forecast_volume
-- FROM    economic_data e
-- JOIN    dim_date d  ON d.date = e.day_init::date
-- --  e.day_init AND '2023-12-31'::date


