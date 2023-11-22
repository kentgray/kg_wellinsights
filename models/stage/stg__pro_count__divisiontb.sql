{{ config(materialized='view') }}

SELECT
    divisionmerrickid,
    concat AS division_name
FROM {{ source('public', 'stg__pro_count__divisiontb') }}
