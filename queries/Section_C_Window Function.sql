USE cal_mart;

-- 7.For each user, calculate their running total of order amount .

SELECT 
		user_id,
        order_date,
        total_amount,
        SUM(total_amount) OVER(PARTITION BY user_id ORDER BY order_date DESC) AS order_amount
FROM orders;

-- 8. For each user, calculate the average order amount and compare it to their overall average using frames 

SELECT 
		user_id,
        order_date,
        total_amount,
        ROUND(AVG(total_amount) OVER(PARTITION BY user_id),2) AS customer_avg_order_amount,
         ROUND(AVG(total_amount) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),2) AS overall_avg
FROM orders;

-- 9.	Show each user’s first and last order date using FIRST_VALUE() and LAST_VALUE().

SELECT 
		user_id,
        order_date,
        FIRST_VALUE(order_date) OVER(PARTITION BY user_id ORDER BY order_date DESC)  AS first_order,
        LAST_VALUE(order_date) OVER(PARTITION BY user_id ORDER BY order_date DESC 
									ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_order
FROM orders;
