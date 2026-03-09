{% macro unpack_json_field(column, path, alias, cast_as=none) %}
    {%- if cast_as -%}
        cast({{ column }}->>'$.{{ path }}' as {{ cast_as }})
    {%- else -%}
        {{ column }}->>'$.{{ path }}'
    {%- endif %} as {{ alias }}
{% endmacro %}
