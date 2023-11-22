{{ config(materialized='incremental') }}

WITH forecast_data AS (
    SELECT
        aac.propnum::UUID AS well_id,
        d.date_id,
        aac.parameters ->> 'gas_rate_init'::DOUBLE PRECISION AS rate_init,
        aac.parameters ->> 'gas_b_factor'::DOUBLE PRECISION AS b_factor,
        aac.parameters ->> 'gas_decline_init_daily_nom'::DOUBLE PRECISION AS decline_init_daily_nom,
        generate_series(aac.day_init, '2023-12-31'::date, '1 day') AS forecast_date
    FROM {{ ref('stg__aries__ac_economic') }} aac
    CROSS JOIN {{ ref('dim_date') }} d
    WHERE d.date BETWEEN aac.day_init AND '2023-12-31'
)

SELECT
    ROW_NUMBER() OVER (PARTITION BY well_id ORDER BY forecast_date) AS forecast_id,
    well_id,
    date_id,
    rate_init / (1 + (b_factor * decline_init_daily_nom * EXTRACT(EPOCH FROM (forecast_date - day_init)) / 86400)) AS gas_forecast_volume
FROM forecast_data
