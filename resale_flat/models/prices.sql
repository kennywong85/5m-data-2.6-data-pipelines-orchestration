{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ source('resale', 'resale_flat_prices_from_jan_2017') }}

),

cleaned AS (

    SELECT
        id,
        month,
        town,
        flat_type,
        block,
        street_name,
        storey_range,
        SAFE_CAST(floor_area_sqm AS NUMERIC) AS floor_area_sqm,
        flat_model,
        SAFE_CAST(lease_commence_date AS INT64) AS lease_commence_date,
        remaining_lease,
        SAFE_CAST(resale_price AS NUMERIC) AS resale_price,
        SAFE_DIVIDE(
            SAFE_CAST(resale_price AS NUMERIC),
            SAFE_CAST(floor_area_sqm AS NUMERIC)
        ) AS price_per_sqm

    FROM source

)

SELECT *
FROM cleaned