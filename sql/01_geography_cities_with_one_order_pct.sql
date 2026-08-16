WITH cities_orders AS (
    SELECT 
        gc.city,
        COUNT(o.order_id) AS total_orders
    FROM olist_orders o
    JOIN olist_customers c
        ON o.customer_id = c.customer_id
    JOIN olist_geolocation_clean gc
        ON c.customer_zip_code_prefix = gc.geolocation_zip_code_prefix
    WHERE o.order_status != 'canceled'
        AND gc.city IS NOT NULL 
        AND gc.city != ''
    GROUP BY gc.city
)
SELECT
    ROUND(
        SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100.0
    , 2) AS cities_pct_with_one_order
FROM cities_orders;