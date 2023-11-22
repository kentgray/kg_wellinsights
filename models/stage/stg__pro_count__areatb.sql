{{ config(materialized='view')}}

SELECT
    areamerrickid,
    concat AS area_name
FROM {{ source('public', 'stg__pro_count__areatb') }}
