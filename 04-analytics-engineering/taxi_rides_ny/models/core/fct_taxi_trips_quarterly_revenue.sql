{{
    config(
        materialized='table'
    )
}}

with trips_unioned as (
    select * from fact_trips
), 
dim_datetime as (
    select * from {{ ref('dim_datetime') }}
    where borough != 'Unknown'
)
SELECT trips_unioned.service_type, dim_datetime.year, dim_datetime.quarter, 
    SUM(total_amount)

FROM trips_unioned inner join dim_datetime on trips_unioned.pickup_datetime = dim_datetime.pickup_datetime
group by 1,2,3