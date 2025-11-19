## <div align = "center"> Section F — Subquery Question </div>

### Objective

##

<b> Q21.	Find customers who have placed orders greater than the average order total using a subquery. </b>                                                   
### <i> Explanation </i> 
This question is focused on analyzing customer behavior in terms of their spending. Specifically, it aims to identify customers whose individual orders
are higher than the overall average order amount across all customers. To achieve this, we first calculate the overall average order amount using a subquery. 
Then, in the main query, we filter for customers whose order total_amount exceed this average. This approach helps highlight high-value customers, which is useful
for targeted marketing, loyalty programs, or personalized engagement strategies.

### <i> Query: </i>

    -- Main Query 
    SELECT 
    		DISTINCT(user_id)
    FROM orders
    WHERE total_amount > (-- subquery - to get the average of the total_amount
    						SELECT 
    							ROUND(AVG(total_amount),2) 
    						FROM orders
    						);
### <i> Insight: </i>
1. Customers with user_id 1, 3, 4, 6, and 7 consistently place orders above the average, indicating higher spending behavior
   compared to the general customer base.
2. These high-spending customers could be prioritized for promotions or loyalty programs to encourage repeat purchases.
### <i> Result: </i>
<img width="1359" height="617" alt="image" src="https://github.com/user-attachments/assets/f52ca726-aac5-4af4-ba5c-4f804a3b2f3e" /> <br>

<b> Q22. Retrieve all products that have never been ordered using a NOT EXISTS subquery. </b> 
### <i> Explanation </i> 
This question aims to identify products in the catalog that have never been ordered. 
The query uses a NOT EXISTS subquery: the subquery retrieves all product_ids from the orders table, and the main query selects all columns 
from the products table where the product ID does not exist in the subquery. This effectively returns products that have no associated orders.

### <i> Query: </i>

    SELECT 
    		*
    FROM products AS p
    WHERE NOT EXISTS (
    				SELECT product_id
                    FROM orders AS o
                    WHERE o.product_id = p.product_id 
    						);
### <i> Insight: </i>
1. Since the query returned NULL for all columns, it indicates that every product in the catalog has been ordered at least once. This implies that the inventory
   is being utilized efficiently, and there are no dormant products in terms of sales.
2. There are currently no products that are completely unsold, suggesting either high product engagement or comprehensive sales coverage.
### <i> Result: </i>
<img width="1356" height="557" alt="image" src="https://github.com/user-attachments/assets/eb2faf22-5f29-4751-8778-fb8e9f309b9a" /> <br>

<b> Q23. Find suppliers whose average product price is higher than any other supplier’s average (use > ANY). </b> 
### <i> Explanation </i> 
This question aims to discover which supplier(s) have an average price higher than any other supplier's price. To solve this, I used CTE and subquery. 
The CTE is to obtain the average price of of each supplier hence the avg_supplier_price CTE. Then the subquery is a repetition of the query in the avg_supplier_price
CTE. Now with the EXECUTION query 

### <i> Query: </i>

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
### <i> Insight: </i>
