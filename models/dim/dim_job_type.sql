{{ config(materialized='table') }}

WITH job_data AS (
    SELECT DISTINCT
        jobtyp AS job_type_name,
        jobsubtyp AS job_subtype_name
    FROM {{ ref('stg_wellview_job') }}
    WHERE
        jobtyp IS NOT NULL AND
        jobsubtyp IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY job_type_name, job_subtype_name) AS job_type_id,
    job_type_name,
    job_subtype_name
FROM job_data
