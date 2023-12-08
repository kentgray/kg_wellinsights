{{ config(materialized='table') }}

WITH wellview_wellheader AS (
    SELECT * FROM {{ ref('stg_wellview_wellheader') }}
),

pro_count_completion AS (
    SELECT * FROM {{ ref('stg__pro_count__completiontb') }}
),

aries_ac_property AS (
    SELECT * FROM {{ ref('stg__aries__ac_property') }}
),

pro_count_fieldgroup AS (
    SELECT * FROM {{ ref('stg__pro_count__fieldgrouptb') }}
),

pro_count_area AS (
    SELECT * FROM {{ ref('stg__pro_count__areatb') }}
),

pro_count_battery AS (
    SELECT * FROM {{ ref('stg__pro_count__batterytb') }}
),

pro_count_division AS (
    SELECT * FROM {{ ref('stg__pro_count__divisiontb') }}
),

pro_count_route AS (
    SELECT * FROM {{ ref('stg__pro_count__routetb') }}
),

pro_count_statecounty AS (
    SELECT * FROM {{ ref('stg__pro_count__statecountynamestb') }}
),

pro_count_producingmethod AS (
    SELECT * FROM {{ ref('stg__pro_count__producingmethodstb') }}
)

SELECT
    wvh.idwell AS well_id,
    wvh.basin,
    wvh.basincode,
    wvh.country,
    wvh.county,
    wvh.currentwellstatus1,
    wvh.district,
    wvh.dttmfirstprod,
    wvh.dttmspud,
    wvh.fieldname,
    wvh.fieldoffice,
    wvh.latitude,
    wvh.latlongdatum,
    wvh.lease,
    wvh.longitude,
    wvh.operated,
    wvh.operator,
    wvh.padname,
    wvh.stateprov,
    wvh.wellconfig,
    wvh.wellname,
    wvh.wellida,
    wvh.wellidb,
    wvh.wellidc,
    wvh.wellidd,
    wvh.wellide,
    aacp.propnum,
    aacp.allocid,
    aacp.propname,
    aacp.nri,
    pcc.completiontype,
    pcc.producingstatus,
    pcc.producingmethod,
    pmt.producingmethodsdescription,
    pcc.routeid,
    SPLIT_PART(SPLIT_PART(rt.concat, ',', 2), '"', 2) AS route, 
    pcc.groupid,
    pcc.divisionid,
    SPLIT_PART(SPLIT_PART(dt.concat, ',', 2), '"', 2) AS division, 
    pcc.fieldgroupid,
    SPLIT_PART(SPLIT_PART(fg.concat, ',', 2), '"', 2) AS field_group, 
    pcc.areaid,
    SPLIT_PART(SPLIT_PART(atb.concat, ',', 2), '"', 2) AS area, 
    pcc.batteryid,
    pcc.merrickid,
    SPLIT_PART(SPLIT_PART(bt.concat, ',', 2), '"', 2) AS battery, 
    pcc.stateid,
    SPLIT_PART(SPLIT_PART(scn.concat, ',', 2), '"', 2) AS state_county_name, 
    pcc.countyid,
    pcc.ariesid,
    pcc.wellviewid,
    pcc.activeflag,
    pcc.mmsapiwellnumber

FROM pro_count_completion pcc 
JOIN wellview_wellheader wvh ON wvh.idwell = pcc.wellviewid and wvh.wellname = 
JOIN aries_ac_property aacp ON pcc.apiwellnumber = aacp.apinum
JOIN pro_count_fieldgroup fg ON pcc.fieldgroupid = fg.fieldgroupmerrickid
JOIN pro_count_area atb ON pcc.areaid = atb.areamerrickid
JOIN pro_count_battery bt ON pcc.batteryid = bt.batterymerrickid
JOIN pro_count_division dt ON pcc.divisionid = dt.divisionmerrickid
JOIN pro_count_route rt ON pcc.routeid = rt.routemerrickid
JOIN pro_count_statecounty scn ON pcc.stateid = scn.statecode AND pcc.countyid = scn.countycode
JOIN pro_count_producingmethod pmt ON pcc.producingmethod = pmt.producingmethodsmerrickid
