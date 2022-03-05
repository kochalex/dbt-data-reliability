{% macro empty_column(column_name, data_type) %}

     {%- if data_type == 'boolean' %}
        cast (null as {{ elementary.type_bool()}}) as {{ column_name }}
     {%- elif data_type == 'timestamp' -%}
        cast (null as {{ dbt_utils.type_timestamp() }}) as {{ column_name }}
     {%- elif data_type == 'int' %}
        cast (null as {{ dbt_utils.type_int()}}) as {{ column_name }}
     {%- elif data_type == 'float' %}
        cast (null as {{ dbt_utils.type_float()}}) as {{ column_name }}
     {%- else %}
        cast (null as {{ dbt_utils.type_string()}}) as {{ column_name }}
     {%- endif %}

{% endmacro %}


{% macro empty_table(column_name_and_type_list) %}

    {%- set empty_table_query -%}
    with empty_table as (
        select
        {%- for column in column_name_and_type_list -%}
            {{ elementary.empty_column(column[0], column[1]) }} {%- if not loop.last -%},{%- endif %}
        {%- endfor -%}
    )
    select * from empty_table
    {%- endset -%}

    {{- return(empty_table_query)-}}

{% endmacro %}

{% macro empty_alerts_cte() %}
    {{ empty_table([('alert_id','str'),('detected_at','timestamp'),('database_name','str'),('schema_name','str'),('table_name','str'),('column_name','str'),('alert_type','str'),('sun_type','str'),('description','str'),('alert_sent','bollean')]) }}
{% endmacro %}