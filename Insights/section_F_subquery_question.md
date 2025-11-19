## <div align = "center"> Section F — Subquery Question </div>

### Objective
This section demonstrates how subqueries can be used to perform comparisons, detect missing data, and identify top performers across different business dimensions.
It covers scalar, correlated, and multi-row subqueries to answer questions such as:

Which customers spend more than the average?

Which products have never been ordered?

Which suppliers have the highest average prices?

These techniques enable deeper insight into customer performance, product activity, and supplier pricing trends, supporting data-driven business decisions.
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
This question aims to identify suppliers whose average product price is higher than the average price of other suppliers. To achieve this, a CTE (Common Table Expression) is used to calculate the average price for each supplier (avg_supplier_price). Then, a subquery is used in the WHERE clause with > ANY to compare each supplier’s average price against the averages of all suppliers. Only suppliers whose average price is higher than at least one other supplier’s average are returned.

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
1. Suppliers with supplier_id 1, 2, 4, and 5 have higher average product prices compared to some other suppliers.
2. Supplier 2 has the highest average price (2300.00), which indicates premium pricing for their products.
3. From this information, we can carry out supplier evaluation, pricing strategy, and identify high-cost suppliers for negotiations or cost analysis.
### <i> Result: </i>
<img width="1350" height="555" alt="image" src="https://github.com/user-attachments/assets/92787b23-17d7-4eef-a74d-c3e70c8752bc" /> <br>

-- 24.	Find suppliers whose average product price is greater than all other suppliers (use > ALL).
### <i> Explanation </i> 
This task aims to identify the supplier(s) with the highest average product price across all suppliers.
Using a Common Table Expression (CTE), the query first calculates the average price per supplier from the products table.
Then, it uses the > ALL operator in the main query to filter suppliers whose average price is greater than every other supplier’s average.
If no supplier meets this condition, it means that no supplier stands out distinctly above the rest in terms of pricing.
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
            WHERE avg_product_price > ALL (-- subquery to determine AVG prices
    										SELECT ROUND(AVG(price),2)
                                            FROM products
                                            GROUP BY supplier_id
    										);
### <i> Insight: </i>
1.The result shows no supplier has a distinctly higher average price than every other supplier. This indicates a competitive or uniform pricing structure among suppliers, where average product prices are relatively similar.
2. The lack of outliers suggests that no supplier dominates the premium pricing segment, and pricing strategies are likely aligned across the supply base.
2.
### <i> Result: </i>
<img width="1348" height="559" alt="image" src="https://github.com/user-attachments/assets/363d1675-ed22-4aad-bf0f-6cc0d073836d" />
