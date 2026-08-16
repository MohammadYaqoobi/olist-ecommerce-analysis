WITH seller_sales AS (
    SELECT s.seller_id, s.seller_city, s.seller_state, SUM(oi.price) AS total_sales
    FROM olist_order_items oi
    JOIN olist_sellers s ON oi.seller_id = s.seller_id
    JOIN olist_orders o ON o.order_id = oi.order_id
    WHERE o.order_status != 'canceled'
    GROUP BY s.seller_id, s.seller_city, s.seller_state
)
SELECT seller_city, seller_state, COUNT(*) AS seller_count, ROUND(AVG(total_sales), 2) AS avg_seller_revenue
FROM seller_sales
GROUP BY seller_city, seller_state
ORDER BY avg_seller_revenue DESC;