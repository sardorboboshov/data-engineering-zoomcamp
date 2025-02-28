{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
    select 
        pickup_datetime,
        {{ dbt.date_trunc("year", "pickup_datetime") }} as revenue_year,
        {{ dbt.date_trunc("quarter", "pickup_datetime") }} as revenue_quarter,
        {{ dbt.date_trunc('year', 'pickup_datetime') }} || '/Q' || {{ dbt.date_trunc('quarter', 'pickup_datetime') }} AS revenue_year_quarter,
        {{ dbt.date_trunc("month", "pickup_datetime") }} as revenue_month

    from trips_data