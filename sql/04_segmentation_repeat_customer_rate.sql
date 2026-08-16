SELECT
	ROUND(AVG(frequency > 1) * 100.0, 2) AS RCR
FROM olist_customer_rfm;