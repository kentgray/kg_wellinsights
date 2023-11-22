{{ config(materialized='view') }}

SELECT
    fieldgroupmerrickid,
    concat AS fieldgroup_name
FROM {{ source('public', 'stg__pro_count__fieldgrouptb') }}
