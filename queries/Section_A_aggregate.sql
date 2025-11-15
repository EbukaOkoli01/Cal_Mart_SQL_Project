USE cal_mart;

-- SECTION A - AGGREGATE FUNCTION

-- 1. Find the total, average, minimum, and maximum order amount made by each customer.

SELECT 
		user_id,
        SUM(total_amount) AS total_order_amount,
        ROUND(AVG(total_amount),2) AS avg_order_amount,
        MIN(total_amount) AS min_order_amount,
        MAX(total_amount) AS max_order_amount
FROM orders
GROUP BY user_id;


-- 2.	Get the total quantity sold and average product price for each category.

-- orders table have quantity while products table have product price. This means we wil be joining orders and products table
SELECT 
		p.category,
        SUM(o.quantity) AS total_quantity_sold_per_category,
        ROUND(AVG(p.price),2) AS avg_price_per_category
FROM orders AS o
LEFT JOIN products AS p
ON o.product_id = p.product_id
GROUP BY category;

-- 3. Find the number of customers who have made more than 1 orders.

-- Main Query to get the number of customers in the subquery
SELECT 
	COUNT(*) AS number_of_customers_morethan_1_orders
FROM
	(-- Subquery to get customers with morethan 1 orders
	SELECT 
			 user_id,
			 COUNT(*) AS number_of_orders
	FROM orders
	GROUP BY user_id
	HAVING COUNT(*) > 1) AS t;
    

-- 4.	Show the total savings amount contributed by each user.

SELECT 
		user_id,
        SUM(saving_amount) AS total_savings_amount
FROM savings
GROUP BY user_id;
