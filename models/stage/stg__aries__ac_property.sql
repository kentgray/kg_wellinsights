{{ config(materialized='view') }}

SELECT
    propnum,
    allocid,
    propname,
    apinum,
    nri
FROM {{ source('public', 'stg__aries__ac_property') }}
