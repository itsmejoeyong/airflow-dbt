-- can run 'dbt compile --select orders_by_day' to see what it compiles to

with orders as (

    select * from {{ ref('stg_orders') }}

),

daily as (

    select
        order_date,
        count(*) as order_name,

        {% for order_status in ['returned', 'completed', 'return_pending', 'shipped', 'placed'] %}
            sum(case when status = '{{ order_status }}' then 1 else 0) as {{ order_status }}_total {{ ',' if not loop.last }}
        {% endfor %}
    from
        orders
    group by 1

),

compared as (

    select
        *,
        lag(order_num) over(order by order_date) as previous_day_orders
    from
        daily

)

select * from compared