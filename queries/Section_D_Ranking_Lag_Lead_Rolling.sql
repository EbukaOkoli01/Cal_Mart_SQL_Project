USE cal_mart;


-- 10	Rank customers by their total spending using RANK() and DENSE_RANK().

SELECT 
		user_id,
        SUM(total_amount) AS total_spending,
        RANK() OVER(ORDER BY SUM(total_amount)) AS customer_rank,
        DENSE_RANK() OVER(ORDER BY SUM(total_amount)) AS customer_dense_rank
FROM orders
GROUP BY user_id;

-- 11.	Divide customers into 4 groups based on total spending 
 
 -- Using function NTILE(n), we can divide customers into groups
 
SELECT 
		user_id,
		SUM(total_amount) AS total_spending,
        NTILE(4) OVER(ORDER BY SUM(total_amount) DESC) AS customer_group
FROM orders
GROUP BY user_id;

-- 12.	Use LAG() and LEAD() to show each user’s previous and next order amount.

SELECT 
		user_id,
        order_date,
        total_amount,
        LAG(total_amount) OVER(PARTITION BY user_id ORDER BY order_date ) AS previous_order_amount,
        LEAD(total_amount) OVER(PARTITION BY user_id ORDER BY order_date) AS next_order_amount
FROM orders;

-- 13. Identify customers whose spending has increased or decreased compared to their previous purchase.

SELECT 
	   user_id,
       previous_order,
       current_order,
       CASE 
			WHEN current_order IS NULL THEN 'Last Purchase'
			WHEN previous_order > current_order THEN 'Decreased'
            WHEN previous_order <  current_order THEN 'Increased'
            ELSE 'Not Specified'
       END AS spending_habit
FROM
(
SELECT 
	user_id,
    total_amount AS previous_order,
    LEAD(total_amount) OVER(PARTITION BY user_id ORDER BY order_date 
							ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS current_order
FROM orders
) AS t ;

-- 14.	Calculate the cumulative total of sales by month for the entire store.

-- Using CTE

WITH desired_columns AS
(
SELECT 
		order_date,
        total_amount
FROM orders 
),
total_by_month AS
(
SELECT 
		MONTH(order_date) AS `month`,
        SUM(total_amount) AS total_sales_per_month
FROM desired_columns
GROUP BY MONTH(order_date)
)
-- finally, we can get the cumulative total sales by month
SELECT 
	`month`,
    total_sales_per_month,
    SUM(total_sales_per_month) OVER(ORDER BY `month`) AS cummulative_total_sales
FROM total_by_month;


-- 15.	Find each order’s percentage rank of total amount compared to all orders in that month.

SELECT 
		order_id,
        MONTH(order_date) AS `month`,
        total_amount,
        CONCAT(PERCENT_RANK() OVER(PARTITION BY MONTH(order_date) ORDER BY total_amount), '%') AS perc_rank_total_amount_per_month,
        CONCAT(CUME_DIST() OVER(PARTITION BY MONTH(order_date) ORDER BY total_amount), '%') AS cummulative_distr_total_amount_per_month
FROM orders;

-- 16. what percentage of total sales does each order represents per month
SELECT 
		order_id,
        MONTH(order_date) AS `month`,
        total_amount,
        SUM(total_amount) OVER(PARTITION BY MONTH(order_date)) AS total_sales_per_month,
        CONCAT(ROUND(((total_amount)/SUM(total_amount) OVER(PARTITION BY MONTH(order_date)))*100,2),'%') AS percentage_total_sales_per_month
FROM orders;

-- 17. what percentage does each month total sales contribute to the total sales per month

SELECT
		`month`,
		 total_sales_per_month,
        CONCAT(ROUND((total_sales_per_month/(SUM(total_sales_per_month) OVER())) *100,2), '%') AS percentage_of_overall_sales
FROM
(
 SELECT 
        MONTH(order_date) AS `month`,
        SUM(total_amount) AS total_sales_per_month
FROM orders
GROUP BY MONTH(order_date)
) AS p;