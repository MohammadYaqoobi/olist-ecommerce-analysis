SELECT 
    ct.product_category_name_english AS category,
    COUNT(*) AS units_sold
FROM olist_order_items oi
JOIN olist_products p ON p.product_id = oi.product_id
JOIN product_category_translation ct ON p.product_category_name = ct.product_category_name
JOIN olist_orders o ON o.order_id = oi.order_id
WHERE o.order_status != 'canceled'
GROUP BY ct.product_category_name_english
ORDER BY units_sold DESC
LIMIT 5;