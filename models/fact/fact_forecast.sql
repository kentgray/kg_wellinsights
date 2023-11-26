-- models/fact_forecast.sql

{{ config(materialized='table') }}

WITH economic_data AS (
    SELECT
        propnum,
        day_init,
        gas_rate_init,
        gas_b_factor,
        gas_decline_init_daily_nom
    FROM {{ ref('stg__aries__ac_economic') }}
),

dim_date AS (
    SELECT
        date_id,
        date
    FROM {{ ref('dim_date') }}
)

SELECT
    ROW_NUMBER() OVER () AS forecast_id,
    e.propnum::UUID as well_id,
    d.date_id,
    CASE
        WHEN d.date >= e.day_init THEN
            e.gas_rate_init::numeric / (1 + (e.gas_b_factor::numeric * e.gas_decline_init_daily_nom::numeric * EXTRACT(EPOCH FROM (d.date - e.day_init)) / 86400))
        ELSE
            NULL
    END AS gas_forecast_volume
FROM    economic_data e
JOIN    dim_date d  ON d.date = e.day_init::date
--  e.day_init AND '2023-12-31'::date