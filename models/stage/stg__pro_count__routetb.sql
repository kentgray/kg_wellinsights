{{ config(materialized='view') }}

SELECT
    routemerrickid,
    concat AS route_name
FROM {{ source('public', 'stg__pro_count__routetb') }}
