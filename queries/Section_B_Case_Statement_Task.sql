USE cal_mart;

/* 5. Some customers haven’t saved in months. Create a query that classifies each customer 
	as:'Active Saver' if total savings > 2000 'Dormant Saver' otherwise. */

-- Main Query    
SELECT
		*,
			CASE
				WHEN total_savings > 2000 THEN 'Active Saver'
                ELSE 'Dormant Saver'
            END AS customer_saving_status
FROM
		(-- Subquery to get total savings for each customer
			SELECT 
				user_id,
				ROUND(SUM(saving_amount), 0) AS total_savings
			FROM savings
			GROUP BY user_id) AS t ;

/* 6.	Create a new column in your query to show: -'High spender' if total_amount > 3000  - 'Average spender' if between 1500 and 3000
		-'Low spender' otherwise. */

SELECT *,
		CASE 
			WHEN total_amount > 3000 THEN 'High Spender'
            WHEN total_amount BETWEEN 1500 AND 3000 THEN 'Average Spender'
            ELSE 'Low Spender'
		END AS customer_classification
FROM orders;