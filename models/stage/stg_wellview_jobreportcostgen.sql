{{ config(materialized='view') }}

SELECT
    idwell,
    idrecparent,
    idrec,
    code1,
    code2,
    code3,
    code4,
    cost,
    des,
    vendor
FROM {{ source('public', 'stg__wellview__jobreportcostgen') }}
