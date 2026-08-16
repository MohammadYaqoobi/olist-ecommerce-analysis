SELECT 
	gc.city AS city,
    COUNT(o.order_id) AS total_orders
FROM olist_orders o 
JOIN olist_customers c
	ON o.customer_id = c.customer_id
JOIN olist_geolocation_clean gc
	ON gc.geolocation_zip_code_prefix = c.customer_zip_code_prefix
WHERE o.order_status != 'canceled'
GROUP BY gc.city
ORDER BY total_orders DESC
LIMIT 5;