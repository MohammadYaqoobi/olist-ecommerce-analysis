SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS total_amount_sales
FROM olist_order_items oi
JOIN olist_sellers s ON oi.seller_id = s.seller_id
JOIN olist_orders o ON o.order_id = oi.order_id
WHERE o.order_status != 'canceled'
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_amount_sales DESC
LIMIT 5;