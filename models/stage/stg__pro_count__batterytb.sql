{{ config(materialized='view')}}

SELECT
    batterymerrickid,
    concat AS battery_name
FROM {{ source('public', 'stg__pro_count__batterytb') }}
