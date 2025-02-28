{{
    config(
        materialized='table'
    )
}}

with trips_unioned as (
    select * from {{ ref('fact_trips') }}
), 
dim_datetime as (
    select * from {{ ref('dim_datetime') }}
)
SELECT trips_unioned.service_type, dim_datetime.revenue_year, dim_datetime.revenue_quarter, 
    SUM(total_amount) as total_amount

FROM trips_unioned inner join dim_datetime on trips_unioned.pickup_datetime = dim_datetime.pickup_datetime
where dim_datetime.revenue_year in (2019, 2020)
group by 1,2,3