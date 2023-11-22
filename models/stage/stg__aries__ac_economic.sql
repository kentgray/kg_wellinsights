{{ config(materialized='view')}}

SELECT
    propnum,
    qualifier,
    day_init,
    parameters
FROM 
    {{ source('public', 'stg__aries__ac_economic') }}
