with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        customers.customer_name,
        customers.email,
        orders.order_amount,
        orders.currency,
        orders.status,
        orders.created_at as ordered_at,
        customers.created_at as customer_created_at
    from orders
    left join customers
        on orders.customer_id = customers.customer_id

)

select * from joined
