{{ config(materialized='view') }}

SELECT
    merrickid,
    recorddate,
    productiondate,
    producingmethod,
    dailydowntime,
    allocestoilvol,
    oilproduction,
    allocestgasvolmcf,
    allocestinjgasvolmcf,
    allocestwatervol,
    waterproduction,
    chokesize,
    casingpressure,
    tubingpressure
FROM {{ source('public', 'stg__pro_count__completiondailytb') }}
