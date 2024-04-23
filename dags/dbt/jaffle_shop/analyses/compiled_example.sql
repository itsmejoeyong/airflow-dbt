[0m09:47:19  Running with dbt=1.7.13
[0m09:47:20  Registered adapter: bigquery=1.7.7
[0m09:47:21  Found 5 models, 12 tests, 2 analyses, 3 sources, 0 exposures, 0 metrics, 454 macros, 0 groups, 0 semantic models
[0m09:47:21  
[0m09:47:22  Concurrency: 1 threads (target='dev')
[0m09:47:22  
[0m09:47:22  Compiled node 'orders_by_day' is:
-- can run 'dbt compile --select orders_by_day' to see what it compiles to

with orders as (

    select * from `silicon-alchemy-420606`.`dbt_us`.`stg_orders`

),

daily as (

    select
        order_date,
        count(*) as order_name,

        
            sum(case when status = 'returned' then 1 else 0) as returned_total ,
        
            sum(case when status = 'completed' then 1 else 0) as completed_total ,
        
            sum(case when status = 'return_pending' then 1 else 0) as return_pending_total ,
        
            sum(case when status = 'shipped' then 1 else 0) as shipped_total ,
        
            sum(case when status = 'placed' then 1 else 0) as placed_total 
        
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
