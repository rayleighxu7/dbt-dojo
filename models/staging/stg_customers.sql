with source as (

    select * from {{ source('raw', 'customers') }}
    where not _fivetran_deleted

),

unpacked as (

    select
        {{ unpack_json_field('data', 'id', 'customer_id') }},
        {{ unpack_json_field('data', 'name', 'customer_name') }},
        {{ unpack_json_field('data', 'email', 'email') }},
        {{ unpack_json_field('data', 'created_at', 'created_at', 'datetime') }},
        _fivetran_synced as synced_at
    from source

)

select * from unpacked
