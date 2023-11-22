{{ config(materialized='view') }}

SELECT
    idwell,
    idrecparent,
    idrec,
    condhole,
    condlease,
    condroad,
    condwave,
    condweather,
    condwind,
    depthtvdendprojmethod,
    dttmend,
    dttmstart,
    rigtime
FROM {{ source('public', 'stg__wellview__jobreport') }}
