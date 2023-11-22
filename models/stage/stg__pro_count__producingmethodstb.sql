{{ config(materialized='view') }}

SELECT
    producingmethodsmerrickid,
    producingmethodsdescription
FROM {{ source('public', 'stg__pro_count__producingmethodstb') }}
