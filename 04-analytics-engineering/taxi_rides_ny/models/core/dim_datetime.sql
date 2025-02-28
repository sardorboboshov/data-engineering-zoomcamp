{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
    select 
        pickup_datetime,
        {{ dbt.date_part("year", "pickup_datetime") }} as revenue_year,
        {{ dbt.date_part("quarter", "pickup_datetime") }} as revenue_quarter,
        {{ dbt.date_part('year', 'pickup_datetime') }} || '/Q' || {{ dbt.date_trunc('quarter', 'pickup_datetime') }} AS revenue_year_quarter,
        {{ dbt.date_part("month", "pickup_datetime") }} as revenue_month

    from trips_data