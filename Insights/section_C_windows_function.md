## <div align = "center"> Section C — Window Function</div>

### Objective

This section focuses on analyzing customer purchase behavior using SQL Window Functions.  
The goal is to track how customer spending changes over time and measure engagement through running totals, averages, and order history.
##

<b> Q7. For each user, calculate their running total of order amount.</b>                                                   
### <i> Explanation </i> 
A running total is the cumulative sum of a customer’s spending across multiple orders, calculated row by row.
This helps track how each customer’s total spending grows over time, offering insight into customer revenue contribution and purchase consistency. In the code below, the Window function OVER has two properties: the PARTITION BY and ORDER BY. The partition by was used to  groups the SUM calculation for each customer individually.This ensures the cumulative total is reset for every new customer. The order by is what a determines the order in which the running total is calculated. It allows the SUM to include the previous row’s value plus the current order amount.                    
Together, they make it possible to calculate a progressive sum for each customer’s transaction history, showing how revenue accumulates over time.
### <i> Query: </i>

    SELECT 
		user_id,
        order_date,
        total_amount,
        SUM(total_amount) OVER(PARTITION BY user_id ORDER BY order_date DESC) AS order_amount
    FROM orders;
### <i> Insight: </i>
1. The running total reveals that customers 1, 2, 3, and 4 made multiple purchases over time, showing repeat buying behavior, while others made single transactions.
2. This pattern indicates that a small number of customers are responsible for a significant portion of total revenue suggesting strong customer retention and loyalty within that group. On the other hand, Customers 5, 6, 7, and 8 made only one purchase each, signaling potential low engagement or first-time buyers.
3. Customers with increasing running totals are likely loyal buyers worth nurturing through personalized offers or loyalty rewards. One-time buyers should be targeted for reactivation campaigns to encourage repeat purchases.         
### <i> Result: </i>
<img width="1354" height="614" alt="image" src="https://github.com/user-attachments/assets/beb52d57-bcb8-485c-9ac7-b70ebdab7833" />
<br>

<b> Q8. For each user, calculate the average order amount and compare it to their overall average using frames</b>  
### <i> Explanation </i> 
The goal of this task was to identify which customers spend above or below the overall platform average.
By comparing each user’s average order amount to the overall customer average, we can segment customers based on spending behavior — helping identify high-value customers and those with lower purchasing power.                                                          
Using window functions with frames (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), the query is able to calculate the overall average of the entire customer's total amount.
### <i> Query: </i>
    
    SELECT 
    		user_id,
            order_date,
            total_amount,
            ROUND(AVG(total_amount) OVER(PARTITION BY user_id),2) AS customer_avg_order_amount,
    		ROUND(AVG(total_amount) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),2) AS overall_avg
    FROM orders;
### <i> Insight: </i>
1. 50% of customers have an average order amount below the overall platform average of ₦2,075, while the other 50% are above it.
This balance shows a diverse customer base. Some are high-value buyers, while others spend modestly.
2. Customer 6 had the highest average order value (₦5,000), followed by Customers 1 and 7 (around 2,300 - 2,400), indicating they are the top spenders on the platform. Customers 2, 3, and 4 consistently placed smaller order amounts below the overall average, suggesting they are budget-conscious or low-value buyers.
3. High-value customers (above average) should be prioritized for retention and loyalty rewards. While, low-spending customers can be targeted with promotional discounts or personalized offers to increase their order value.
### <i> Result: </i>
<img width="1358" height="609" alt="image" src="https://github.com/user-attachments/assets/e121109c-1ae1-44e0-9fac-e0e1dbb651c4" /><br>


<b> Q9. Show each user’s first and last order date using FIRST_VALUE() and LAST_VALUE(). </b>   
### <i> Explanation </i> 
The goal of this query was to determine each customer’s first and most recent purchase date. This helps measure how long customers have been active and identify those who may be at risk of churning. The FIRST_VALUE() function captures the earliest purchase date for each user, using ORDER BY ASC. The LAST_VALUE() function retrieves the most recent purchase date, made possible by the window frame clause ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING. Together, these two functions provide visibility into customer tenure and recency of activity, both of which are key metrics for retention analysis.   

### <i> Query: </i>

    SELECT 
    		user_id,
            order_date,
            FIRST_VALUE(order_date) OVER(PARTITION BY user_id ORDER BY order_date ASC)  AS first_order,
            LAST_VALUE(order_date) OVER(PARTITION BY user_id ORDER BY order_date
    									ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_order
    FROM orders;
### <i> Insight: </i>
1. The reference latest order date in the dataset is 2024-07-12. Customers 5, 6, 7, and 8 made only one purchase, and their last activity was over two months ago, suggesting they are at risk of churning if no recent engagement has occurred.
2. Customers 1 and 4 appear to be the most active users, showing more recent purchases and ongoing engagement. Customers 2 and 3 have moderate activity. They could be targeted with loyalty or bonus programs to encourage more frequent purchases.
3. Send reactivation reminders or small discounts to one-time buyers (5–8) to bring them back. Also, we can maintain engagement with active customers (1 & 4) through exclusive loyalty offers.
### <i> Result: </i>
<img width="1355" height="608" alt="image" src="https://github.com/user-attachments/assets/62f84015-c119-4743-a1d5-0cd68bab4890" />


