{{ config(materialized='view') }}

SELECT
    merrickid,
    wellname,
    completiontype,
    producingstatus,
    producingmethod,
    apiwellnumber,
    routeid,
    groupid,
    divisionid,
    fieldgroupid,
    areaid,
    batteryid,
    stateid,
    countyid,
    ariesid,
    wellviewid,
    activeflag,
    mmsapiwellnumber
FROM {{ source('public', 'stg__pro_count__completiontb') }}
