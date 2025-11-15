USE cal_mart;

-- 25.	Identify the top 3 performing customers based on total purchases.
SELECT 
		*
FROM
	(-- subquery to get rank the customers
	SELECT 
			user_id,
			SUM(total_amount) AS total_purchase,
			ROW_NUMBER() OVER(ORDER BY SUM(total_amount) DESC) AS ranking
	FROM orders
	GROUP BY user_id) AS r
WHERE r.ranking <=3;

-- 26.	Identify the lowest-selling product category.

SELECT 
        category,
        total_purchase
FROM 
(
SELECT 
		SUM(o.total_amount) AS total_purchase,
        category,
        RANK() OVER(ORDER BY SUM(o.total_amount)) as ranking
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
GROUP BY p.category
) AS s
WHERE ranking = 1;


-- 27.	Find customers who made a purchase every month in 2024.

SELECT 
	user_id,
    COUNT(*) AS orders_customers
FROM
	(
	SELECT 
			DISTINCT(MONTH(order_date)) AS `month`,
            user_id
	FROM orders
	WHERE order_date > 2023-12-31
    ORDER BY user_id) AS s
GROUP BY user_id
HAVING COUNT(*) = 12 ;


-- 28.	Calculate the average time between consecutive orders for each customer (advanced LAG challenge).

WITH orders_date AS (
  SELECT 
      user_id,
      order_date,
      LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM orders
)
SELECT 
    user_id,
    ROUND(AVG(DATEDIFF(order_date, prev_order_date)), 2) AS avg_days_between_orders
FROM orders_date
WHERE prev_order_date IS NOT NULL
GROUP BY user_id;