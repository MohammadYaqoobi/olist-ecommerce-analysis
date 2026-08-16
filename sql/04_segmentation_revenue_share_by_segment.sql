SELECT 
	segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(monetary), 2) AS avg_total_spent
FROM olist_customer_rfm
GROUP BY segment
ORDER BY avg_total_spent DESC;