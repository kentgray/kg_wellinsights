{{ config(materialized='table') }}

SELECT
    0 AS forecast_id, -- Placeholder, as SERIAL type is not directly supported in dbt
    '00000000-0000-0000-0000-000000000000'::UUID AS well_id, -- Placeholder UUID
    0 AS date_id, -- Placeholder date ID
    0.0 AS gas_forecast_volume -- Placeholder forecast volume
LIMIT 0
