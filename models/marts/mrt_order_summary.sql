with orders_with_customers as (

    select * from {{ ref('int_orders_with_customers') }}

),

exchange_rates as (

    select
        currency_code,
        rate_to_usd
    from {{ ref('exchange_rates') }}

),

with_rates as (

    select
        o.order_id,
        o.customer_id,
        o.customer_name,
        o.email,
        o.order_amount,
        o.currency,
        o.status,
        o.ordered_at,
        o.customer_created_at,
        r.rate_to_usd
    from orders_with_customers as o
    left join exchange_rates as r
        on o.currency = r.currency_code

),

final as (

    select
        order_id,
        customer_id,
        customer_name,
        email,
        order_amount,
        currency,
        {{ convert_currency('order_amount', 'rate_to_usd') }} as amount_usd,
        status,
        ordered_at,
        cast(ordered_at as date) as order_date,
        customer_created_at,
        datediff(ordered_at, customer_created_at) as days_since_customer_signup
    from with_rates

)

select * from final
