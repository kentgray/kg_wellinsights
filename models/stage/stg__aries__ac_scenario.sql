{{ config(materialized='view')}}

SELECT
    propnum,
    qual0,
    qual1,
    qual2,
    qual3,
    qual4,
    qual5,
    qual6,
    qual7,
    qual8,
    qual9
FROM {{ source('public', 'stg__aries__ac_scenario') }}
