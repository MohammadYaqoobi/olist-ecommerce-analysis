SELECT 
	crmf.segment,
    ROUND( 
		AVG(o.order_status = 'canceled') * 100.0
	, 2) AS avg_orders_canceled,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS total_orders_canceled,
    COUNT(*) AS total_orders
FROM olist_customer_rfm crmf
JOIN olist_customers c 
	ON crmf.customer_unique_id = c.customer_unique_id
JOIN olist_orders o 
	ON o.customer_id = c.customer_id
GROUP BY crmf.segment
ORDER BY avg_orders_canceled DESC;