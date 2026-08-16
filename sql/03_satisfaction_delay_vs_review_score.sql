SELECT 
	rl.review_score,
    ROUND(
		AVG(DATEDIFF(o.order_delivered_customer_date, order_purchase_timestamp))
        , 0) AS avg_delay_days,
	COUNT(*) AS total_orders
FROM olist_orders o
JOIN olist_order_reviews_latest rl
	ON o.order_id = rl.order_id
WHERE o.order_status != 'canceled'
	AND o.order_delivered_customer_date IS NOT NULL
GROUP BY rl.review_score
ORDER BY avg_delay_days DESC;