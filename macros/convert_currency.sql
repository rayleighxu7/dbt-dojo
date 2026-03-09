{% macro convert_currency(amount_column, source_rate_to_usd, target_rate_to_usd=none) %}
    {%- if target_rate_to_usd -%}
        {{ amount_column }} * {{ source_rate_to_usd }} / nullif({{ target_rate_to_usd }}, 0)
    {%- else -%}
        {{ amount_column }} * {{ source_rate_to_usd }}
    {%- endif -%}
{% endmacro %}
