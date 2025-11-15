USE cal_mart;

-- 21.	Find customers who have placed orders greater than the average order total using a subquery.

-- let's get the average of the total_amount
SELECT 
	ROUND(AVG(total_amount),2) 
FROM orders;

-- Main Query

SELECT 
		DISTINCT(user_id)
FROM orders
WHERE total_amount > (-- subquery - to get the average of the total_amount
						SELECT 
							ROUND(AVG(total_amount),2) 
						FROM orders
						);
                        
-- 22.	Retrieve all products that have never been ordered using a NOT EXISTS subquery.

SELECT 
		*
FROM products AS p
WHERE NOT EXISTS (
				SELECT product_id
                FROM orders AS o
                WHERE o.product_id = p.product_id 
						);

-- 23.	Find suppliers whose average product price is higher than any other supplier’s average (use > ANY).

WITH avg_supplier_price AS
		(
		SELECT
			supplier_id,
			ROUND(AVG(price), 2) AS avg_product_price
		FROM products 
		GROUP BY supplier_id
		)
	    SELECT *
        FROM avg_supplier_price
        WHERE avg_product_price > ANY (-- subquery to determine AVG prices
										SELECT ROUND(AVG(price),2)
                                        FROM products
                                        GROUP BY supplier_id
										);

-- 24.	Find suppliers whose average product price is greater than all other suppliers (use > ALL).

WITH avg_supplier_price AS
		(
		SELECT
			supplier_id,
			ROUND(AVG(price), 2) AS avg_product_price
		FROM products 
		GROUP BY supplier_id
		)
	    SELECT *
        FROM avg_supplier_price
        WHERE avg_product_price > ALL (-- subquery to determine AVG prices
										SELECT ROUND(AVG(price),2)
                                        FROM products
                                        GROUP BY supplier_id
										);
