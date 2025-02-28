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
quarterly_revenue as (
    select trips_unioned.service_type, dim_datetime.revenue_year, dim_datetime.revenue_quarter, 
    SUM(total_amount) as quarterly_revenue
    from trips_unioned 
    inner join dim_datetime on trips_unioned.pickup_datetime = dim_datetime.pickup_datetime
    group by 1,2,3
)

SELECT 
    q1.revenue_year,
    q1.revenue_quarter,
    q1.quarterly_revenue,
    q2.quarterly_revenue AS last_year_revenue,
    ROUND(
        ((q1.quarterly_revenue - q2.quarterly_revenue) / NULLIF(q2.quarterly_revenue, 0)) * 100, 2
    ) AS yoy_growth_percentage
FROM quarterly_revenue q1
LEFT JOIN quarterly_revenue q2 
    ON q1.revenue_year = q2.revenue_year + 1 
    AND q1.revenue_quarter = q2.revenue_quarter
ORDER BY q1.revenue_year, q1.revenue_quarter