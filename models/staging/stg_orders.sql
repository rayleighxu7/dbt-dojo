with source as (

    select * from {{ source('raw', 'orders') }}
    where not _fivetran_deleted

),

unpacked as (

    select
        {{ unpack_json_field('data', 'id', 'order_id') }},
        {{ unpack_json_field('data', 'customer_id', 'customer_id') }},
        {{ unpack_json_field('data', 'amount', 'order_amount', 'decimal(18, 2)') }},
        {{ unpack_json_field('data', 'currency', 'currency') }},
        {{ unpack_json_field('data', 'status', 'status') }},
        {{ unpack_json_field('data', 'created_at', 'created_at', 'datetime') }},
        _fivetran_synced as synced_at
    from source

)

select * from unpacked
