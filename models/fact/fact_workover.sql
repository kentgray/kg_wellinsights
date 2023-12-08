-- models/fact_workover.sq
{{ config(materialized='table') }}

WITH job_data AS (
    SELECT
        idwell,
        idrec as jobid,
        dttmstart,
        dttmend,
        jobtyp
    FROM {{ ref('stg_wellview_job') }}
),

jobreport_data AS (
    SELECT
        idwell,
        idrec as jobreportid,
        idrecparent as jobid,
    FROM {{ ref('stg_wellview_jobreport') }}
),

jobreportcostgen_data AS (
    SELECT
        idwell,
        idrec as jobreportcostid,
        idrecparent as jobreportid,
        cost
    FROM {{ ref('stg_wellview_jobreportcostgen') }}
),

-- Aggregate cost of jobreport
job_cost AS (
    Select 
        sum(cost) as job_cost, 
        jobreportid
    from jobreportcostgen_data
    group by jobreportid 
),


-- Aggregate cost of job
jobreport_cost as (
    select 
        j.jobid, 
        sum(job_cost) as jobreport_cost
    from jobreport_data j
    join job_cost jp on jp.jobreportid = j.jobreportid
    group by j.jobid
),

-- jobid = uid for each job
-- jobreportid = uid for each jobreport
-- idrec is the uid for each job report
-- idrecparent is the uid for each job
-- rolling out the cost to each job report
dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
),

dim_job_type AS (
    SELECT * FROM {{ ref('dim_job_type') }}
),

-- Aggregate by jobid to get the start and stop of each job 
dailydowntime as (
    select 
        j.jobid,
        sum(m.dailydowntime) as dailydowntime
    from {{ref('fact_measurements') }} m
    join job_data j on j.idwell = m.idwell 
    where date between j.dttmstart and j.dttmend
    group by j.jobid

)

SELECT
    -- ROW_NUMBER() OVER () AS workover_id,
    j.idwell,
    j.idrec AS job_id,
    d_start.date_id AS start_date_id,
    d_end.date_id AS end_date_id,
    djt.job_type_id,
    dd.dailydowntime,
    COALESCE(c.cost), 0 AS total_cost 
FROM job_data j
LEFT JOIN    jobreport_cost jr ON j.jobid = jr.jobid
LEFT JOIN    dim_date d_start ON j.dttmstart::date = d_start.date
LEFT JOIN    dim_date d_end ON j.dttmend::date = d_end.date
LEFT JOIN    dim_job_type djt ON j.jobtyp = djt.job_type_name
LEFT JOIN    dailydowntime dd on dd.jobid = j.jobid

-- Workover events by job with downtime
-- Workover events
