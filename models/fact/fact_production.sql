{{ config(materialized='table') }}

WITH pro_count_completion_daily AS (
    SELECT * FROM {{ ref('stg__pro_count__completiondailytb') }}
),

dim_well AS (
    SELECT * FROM {{ ref('dim_well') }} 
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
)


SELECT
    ROW_NUMBER() OVER () AS production_id,
    w.wellviewid AS well_id,
    d.date_id,
    p.oilproduction AS oil_volume,
    p.allocestgasvolmcf AS gas_volume,
    p.waterproduction AS water_volume
FROM pro_count_completion_daily p
JOIN dim_well w ON p.merrickid = w.merrickid
JOIN dim_date d ON p.recorddate = d.date
