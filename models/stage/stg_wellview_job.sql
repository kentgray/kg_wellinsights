{{ config(materialized='view') }}

SELECT
    idwell,
    idrec,
    dttmend,
    dttmstart,
    jobsubtyp,
    jobtyp,
    status1,
    status2,
    targetform,
    usertxt1,
    wvtyp
FROM {{ source('public', 'stg__wellview__job') }}
