{{ config(materialized='view')}}

SELECT
    propnum,
    qualifier,
    day_init,
    parameters->>'gas_b_factor' AS gas_b_factor,
    parameters->>'oil_b_factor' AS oil_b_factor,
    parameters->>'gas_rate_init' AS gas_rate_init,
    parameters->>'oil_rate_init' AS oil_rate_init,
    parameters->>'water_b_factor' AS water_b_factor,
    parameters->>'water_rate_init' AS water_rate_init,
    parameters->>'extra_inputs_data' AS extra_inputs_data,
    parameters->>'gas_decline_minimum' AS gas_decline_minimum,
    parameters->>'oil_decline_minimum' AS oil_decline_minimum,
    parameters->>'water_decline_minimum' AS water_decline_minimum,
    parameters->>'capacity_change_option_id' AS capacity_change_option_id,
    parameters->>'gas_decline_init_daily_nom' AS gas_decline_init_daily_nom,
    parameters->>'oil_decline_init_daily_nom' AS oil_decline_init_daily_nom,
    parameters->>'is_lock_slope_capacity_line' AS is_lock_slope_capacity_line,
    parameters->>'water_decline_init_daily_nom' AS water_decline_init_daily_nom
FROM 
    {{ source('public', 'stg__aries__ac_economic') }}