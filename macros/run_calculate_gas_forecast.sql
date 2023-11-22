-- macros/call_calculate_gas_forecast.sql
{% macro run_calculate_gas_forecast() %}
    {{ return(adapter.execute('SELECT kg_wellinsights.calculate_gas_forecast();')) }}
{% endmacro %}
