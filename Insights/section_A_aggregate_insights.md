## <div align = "center"> Section A — Aggregate Functions </div>

### Objective

To understand sales and customer distribution by calculating total, average, minimum, and maximum order metrics.
This section focuses on descriptive and performance analysis — summarizing customer and product activity.
##

<b> Q1. Find the total, average, minimum, and maximum order amount made by each customer. </b>                                                   
### <i> Explanation </i> 
 To begin my analysis, I started by understanding the customers' spending patterns in the data. This was so I could know who our top customers were and our least buying customers. 
In the code below, Aggregation was done across each customer to know the total amount each customer has spent, the average amount each customer has spent, the minimum amount and maximum amount spent in total.

### <i> Query: </i>

    USE cal_mart;
    SELECT 
    		user_id,
            SUM(total_amount) AS total_order_amount,
            ROUND(AVG(total_amount),2) AS avg_order_amount,
            MIN(total_amount) AS min_order_amount,
            MAX(total_amount) AS max_order_amount
    FROM orders
    GROUP BY user_id;
### <i> Insight: </i>
1. The average total amount was 2,075 while the top spender was 5,000
2. 37.5% (3 of 8) of total customer accounted for over 50% (13,600) of total sales value
### <i> Result: </i>
<img width="1365" height="616" alt="image" src="https://github.com/user-attachments/assets/a75594c9-096c-4286-a65b-683fffc862b4" /> <br>            
                                                                                                                                                   
<b> Q2.	Get the total quantity sold and average product price for each category. </b>      
### <i> Explanation </i>
In this section, I wanted to understand which product category was performing better or badly as well as the pricing. 

### <i> Query: </i>

    -- orders table have quantity while products table have product price. This means we wil be joining orders and products table
    SELECT 
    		p.category,
            SUM(o.quantity) AS total_quantity_sold_per_category,
            ROUND(AVG(p.price),2) AS avg_price_per_category
    FROM orders AS o
    LEFT JOIN products AS p
    ON o.product_id = p.product_id
    GROUP BY category;
### <i> Insight: </i>
1. Food category had the highest quantity sold, while beverage category had the highest average price.
2. Categories with low price tends to sell more confirming price elasticity demand in sales
### <i> Result: </i>
<img width="1202" height="559" alt="image" src="https://github.com/user-attachments/assets/b7aeff35-136f-4efe-a715-7bf8e8d69429" /> <br>       
                                                                                                                                          
<b> Q3.	Find the number of customers who have made more than 1 orders. </b>      
### <i> Explanation </i>
This is to understand customers behaviour. A measure of customer engagement, and loyalty. In the code blow, we have a subquery and main query. The subquery was for us to know customers who have made morethan 1 order, then the main query counted all the customers who have more than one order.

### <i> Query: </i>

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
### <i> Insight: </i>
1. Only 50% of customers placed more than 1 orders.
2. Repeat customers contribute significantly to recurring revenue which shows retention opportunity.
### <i> Result: </i>
subquery result
<img width="1356" height="584" alt="image" src="https://github.com/user-attachments/assets/39d8e9b4-d8a3-49e5-8ee7-d851a4e7cb42" />
main query result
<img width="1360" height="613" alt="image" src="https://github.com/user-attachments/assets/17fda4f2-ba9d-495c-9453-8dcfee8bdc43" />

<b> Q4.	Show the total savings amount contributed by each user. </b>   
### <i> Explanation </i>                                               
This is a preforance question. It helps us to compare customers and know who is doing well and who is not.                              
### <i> Query: </i>
    SELECT 
    		user_id,
            SUM(saving_amount) AS total_savings_amount
    FROM savings
    GROUP BY user_id
    ORDER BY total_savings_amount DESC;
### <i> Insight: </i>
1. The top 3 performing customers are customers with ID 1,7,3 contributed a combined total of 14,000, representing 58.3% of total revenue.
This highlights a concentration of sales among a small customer group, suggesting that customer loyalty programs targeted at these high-value customers could significantly influence revenue retention.
2. The least performing customer (Customer ID 4) contributed the lowest total order value, indicating either low engagement or a potential churn risk.                                                                                                                              
For this least performing customer, targeted loyalty campaigns or savings incentives should be carried out to re-engage the customer.
### <i> Result: </i>
<img width="1357" height="560" alt="image" src="https://github.com/user-attachments/assets/26d2ac2f-77ee-45ac-84d3-ca6339af3012" />


