{{ config(materialized='view') }}

SELECT
    statecode,
    countycode,
    concat AS state_county_name
FROM {{ source('public', 'stg__pro_count__statecountynamestb') }}
