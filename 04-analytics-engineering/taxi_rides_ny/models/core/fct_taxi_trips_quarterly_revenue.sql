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
),
trips_unioned_previous_quarter as (
    select * from {{ ref('fact_trips') }}
)
SELECT trips_unioned.service_type, dim_datetime.revenue_year, dim_datetime.revenue_quarter, 
    SUM(total_amount) as total_amount,
    100 * (tu.total_amount - tupq.total_amount) / (tu.total_amount) as yoy_revenue_growth

FROM 
    trips_unioned 
    inner join dim_datetime on trips_unioned.pickup_datetime = dim_datetime.pickup_datetime
    inner join trips_unioned_previous_quarter on EXTRACT(YEAR FROM trips_unioned_previous_quarter.pickup_datetime) = dim_datetime.revenue_year - 1
    and  EXTRACT(QUARTER FROM trips_unioned_previous_quarter.pickup_datetime) = dim_datetime.revenue_quarter
    where dim_datetime.revenue_year in (2019, 2020)
group by 1,2,3
order by 1,2,3