{{
    config(
        materialized='table'
    )
}}
with fact_trips as (
    select * from {{ ref('fact_trips') }}
),
dim_datetime as (
    select * from {{ ref('dim_datetime') }} 
)
SELECT 
    DISTINCT service_type, revenue_year, revenue_month, p97_sale_amount, p95_sale_amount, p90_sale_amount
    FROM (
        SELECT 
            fact_trips.service_type, dim_datetime.revenue_year, dim_datetime.revenue_month,
            PERCENTILE_CONT(fact_trips.fare_amount, 0.9) OVER (PARTITION BY fact_trips.service_type, dim_datetime.revenue_year, dim_datetime.revenue_month) AS p90_sale_amount,
            PERCENTILE_CONT(fact_trips.fare_amount, 0.95) OVER (PARTITION BY fact_trips.service_type, dim_datetime.revenue_year, dim_datetime.revenue_month) AS p95_sale_amount,
            PERCENTILE_CONT(fact_trips.fare_amount, 0.97) OVER (PARTITION BY fact_trips.service_type, dim_datetime.revenue_year, dim_datetime.revenue_month) AS p97_sale_amount
        FROM fact_trips inner join dim_datetime on fact_trips.pickup_datetime = dim_datetime.pickup_datetime
        where fact_trips.fare_amount > 0 and fact_trips.trip_distance > 0 
            and lower(fact_trips.payment_type_description) in ('cash', 'credit card')
    )
