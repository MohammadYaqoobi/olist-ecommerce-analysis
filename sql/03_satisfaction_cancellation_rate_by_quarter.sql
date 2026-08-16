SELECT 
	YEAR(order_purchase_timestamp) AS year, 
	quarter(order_purchase_timestamp) AS quarter, 
    ROUND(
		SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) / 
		COUNT(*) * 100.0
	, 2) AS cancelation_rate, 
    COUNT(*) AS total_orders 
FROM olist_orders 
GROUP BY YEAR(order_purchase_timestamp), quarter(order_purchase_timestamp) 
ORDER BY cancelation_rate DESC, year, quarter;