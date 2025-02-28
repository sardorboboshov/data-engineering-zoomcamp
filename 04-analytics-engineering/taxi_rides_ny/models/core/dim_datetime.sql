{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
    select 
        pickup_datetime,
        EXTRACT(YEAR FROM {{ dbt.date_trunc("year", "pickup_datetime") }}) AS revenue_year,
        EXTRACT(QUARTER FROM pickup_datetime) AS revenue_quarter,
        EXTRACT(YEAR FROM {{ dbt.date_trunc("year", "pickup_datetime") }}) || '/Q' || EXTRACT(QUARTER FROM pickup_datetime) AS revenue_year_quarter,
        EXTRACT(MONTH FROM {{ dbt.date_trunc("year", "pickup_datetime") }}) AS revenue_month
    from trips_data