-- models/fact_workover.sq
{{ config(materialized='table') }}

WITH job_data AS (
    SELECT
        idwell,
        idrec,
        dttmstart,
        dttmend,
        jobtyp
    FROM {{ ref('stg_wellview_job') }}
),

jobreport_data AS (
    SELECT
        idwell,
        idrec,
        idrecparent
    FROM {{ ref('stg_wellview_jobreport') }}
),

jobreportcostgen_data AS (
    SELECT
        idwell,
        idrec,
        idrecparent,
        cost
    FROM {{ ref('stg_wellview_jobreportcostgen') }}
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
),

dim_job_type AS (
    SELECT * FROM {{ ref('dim_job_type') }}
)

SELECT
    ROW_NUMBER() OVER () AS workover_id,
    j.idwell,
    j.idrec AS job_id,
    d_start.date_id AS start_date_id,
    d_end.date_id AS end_date_id,
    djt.job_type_id,
    COALESCE(SUM(c.cost), 0) AS total_cost 
FROM job_data j
LEFT JOIN    jobreport_data jr ON j.idwell = jr.idwell AND j.idrec = jr.idrecparent
LEFT JOIN    jobreportcostgen_data c ON jr.idwell = c.idwell AND jr.idrec = c.idrecparent
JOIN    dim_date d_start ON j.dttmstart::date = d_start.date
JOIN    dim_date d_end ON j.dttmend::date = d_end.date
JOIN    dim_job_type djt ON j.jobtyp = djt.job_type_name
GROUP BY    j.idwell, j.idrec, d_start.date_id, d_end.date_id, djt.job_type_id

