{{ config(materialized='table') }}

WITH completiondaily as (
    SELECT * FROM {{ ref('stg__pro_count__completiondailytb') }} 
),

dim_well AS (
    SELECT * FROM {{ ref('dim_well') }} 
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
),

measurements_data AS (
    SELECT
        dw.well_id,
        dd.date_id,
        pcd.dailydowntime,
        pcd.oilproduction,
        pcd.allocestgasvolmcf,
        pcd.allocestinjgasvolmcf,
        pcd.allocestwatervol,
        pcd.waterproduction,
        pcd.chokesize,
        pcd.casingpressure,
        pcd.tubingpressure
    FROM completiondaily pcd
    JOIN dim_date dd ON pcd.recorddate::date = dd.date
    JOIN dim_well dw ON pcd.merrickid = dw.merrickid
)

SELECT
    ROW_NUMBER() OVER () AS measurement_id,
    well_id,
    date_id,
    dailydowntime,
    allocestinjgasvolmcf AS injected_gas_volume,
    casingpressure AS casing_pressure,
    tubingpressure AS tubing_pressure,
    chokesize AS choke_size
FROM measurements_data
