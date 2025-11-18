## <div align = "center"> Section D — Windows Function 2 </div>

### Objective
This section focuses on identifying top-performing customers, spending distribution, and behavioral changes using advanced SQL window functions such as RANK(), NTILE(), LAG(), and LEAD().
##

<b> Q10. Rank customers by their total spending using RANK() and DENSE_RANK().</b>                                                   
### <i> Explanation </i> 
This task helps to understand how customers are performing in terms of spending and essentially, who contributes most or least to total revenue.Two functions were used: RANK() which assigns rank values, but skips numbers if there are ties in the ranking and DENSE_RANK() which assigns consecutive rank values even when there are ties. Although both produced identical results in this dataset (no duplicate spending totals), in real-world data, DENSE_RANK ensures rankings remain consecutive without gaps.
This analysis helps identify top performers (high spenders) and low performers, supporting customer value segmentation and retention strategy.
### <i> Query: </i>

    SELECT 
    		user_id,
            SUM(total_amount) AS total_spending,
            RANK() OVER(ORDER BY SUM(total_amount) DESC) AS customer_rank,
            DENSE_RANK() OVER(ORDER BY SUM(total_amount) DESC) AS customer_dense_rank
    FROM orders
    GROUP BY user_id;
### <i> Insight: </i>
1. The top three performing customers are Customers 6, 1, and 3, contributing the highest total spending.
2. The bottom three customers are 8, 5, and 7 having the lowest total spending and can be considered low-engagement customers.
3. we should retain and reward top spenders (6, 1, 3) through loyalty or VIP programs and re-engage low spenders (8, 5, 7) with personalized offers or discount incentives.
### <i> Result: </i>
<img width="1355" height="617" alt="image" src="https://github.com/user-attachments/assets/e10cfcfa-27fe-4c89-928e-5f8c8e4c85e7" /><br>

<b> Q11. Divide customers into 4 groups based on total spending </b>
This task aims to group customers into performance tiers based on their total spending. By using the NTILE(4) window function, customers are divided into four equal groups (quartiles). From highest spenders (Group 1) to lowest spenders (Group 4). This segmentation helps management understand which customers drive the most revenue and which fall into lower-value categories, making it easier to target campaigns and incentives effectively.
### <i> Query: </i>

    SELECT 
    		user_id,
    		SUM(total_amount) AS total_spending,
            NTILE(4) OVER(ORDER BY SUM(total_amount) DESC) AS customer_group
    FROM orders
    GROUP BY user_id;
### <i> Insight: </i>
1. Group 1 (Top 25%) - Customers 6 and 1 are the top spenders, contributing the largest share of total sales. Group 2 (Upper-Mid Tier) - Customers     3 and 4 are moderately high spenders who show consistent engagement. 
2. Group 3 (Lower-Mid Tier) - Customers 2 and 7 have average spending levels, indicating potential for growth. Group 4 (Bottom 25%) - Customers 5      and 8 are the lowest spenders and represent the group most likely to churn or need reactivation campaigns.
3. we should Focus retention efforts on Groups 1 and 2, these are loyal, high-value customers. Target Groups 3 and 4 with promotional campaigns,       personalized offers, or bundle discounts to encourage higher spending.
### <i> Result: </i>
<img width="1355" height="614" alt="image" src="https://github.com/user-attachments/assets/bf20b03f-70f5-45ae-bbef-fdb7da3ed924" />


<b> Q12. Use LAG() and LEAD() to show each user’s previous and next order amount. </b>        
### <i> Explanation </i> 
This analysis aims to understand customer retention and spending patterns by comparing each order with the one before and after it. LAG() returns the amount from the previous order, showing whether a customer is spending more or less compared to before. LEAD() returns the amount from the next order, allowing a look ahead to spot trends in spending behavior. Together, these functions help assess customer consistency, identify declining engagement, and detect potential churn indicators.
### <i> Query: </i>

    SELECT 
    		user_id,
            order_date,
            total_amount,
            LAG(total_amount) OVER(PARTITION BY user_id ORDER BY order_date ) AS previous_order_amount,
            LEAD(total_amount) OVER(PARTITION BY user_id ORDER BY order_date) AS next_order_amount
    FROM orders;
### <i> Insight: </i>
1. Customers 1–4 made multiple purchases, showing ongoing engagement. However, their later orders were lower than their previous ones suggesting a decline in spending or potential drop in interest.
2. Customers 5–8 made only one purchase, meaning there is no next order, which indicates possible churn or new customers with no repeat activity yet.
3. The trend shows decreasing order amounts among returning customers, which may require engagement or retention strategies to boost repeat value. Offer re-engagement promotions to customers whose recent purchases declined.
4. We should offer re-engagement promotions to customers whose recent purchases declined and also send follow-up reminders to one-time buyers (5–8) to encourage repeat purchases.
### <i> Result: </i>
<img width="1280" height="569" alt="image" src="https://github.com/user-attachments/assets/0108d6be-61df-4916-b3a9-625c3af5c011" /> <br>

<b> Q13. Identify customers whose spending has increased or decreased compared to their previous purchase. </b>   
### <i> Explanation </i>
The goal of this task is to identify changes in customer spending habits over time, whether their order value is increasing or decreasing.
This helps detect declining engagement or positive growth trends among repeat buyers. Using the LEAD() window function, each order amount is compared to the next order for the same customer. A CASE statement then classifies each customer’s spending pattern as:
Increased if spending rose compared to the previous order, Decreased if spending dropped, and Last Purchase — the customer’s most recent order (no subsequent record). This approach provides early indicators of customer churn or growth opportunities.
### <i> Query: </i>

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
### <i> Insight: </i>
1. All customers with multiple purchases (1–4) show a decrease in spending compared to their previous orders. This may signal reduced engagement or lower purchasing power.
2. Customers 5–8 made only one purchase, so they are tagged as “Last Purchase”, which may indicate new customers or potential churn.
3. No customer in this dataset showed an increase in spending, which suggests that overall customer value is declining and requires attention.
4. We can investigate the cause of decreased spending among repeat customers. It could possibly be pricing, satisfaction, or product mix. Also, we should introduce retention campaigns or loyalty points for consistent buyers to encourage higher-value repeat purchases.
### <i> Result: </i>
<img width="1339" height="556" alt="image" src="https://github.com/user-attachments/assets/46b7185f-16f7-455b-9897-a61d21b9eacc" /> <br>

<b> Q14. Calculate the cumulative total of sales by month for the entire store./ </b>
### <i> Explanation </i>
The purpose of this analysis is to understand the growth of total sales over time by calculating the cumulative total month by month.
I solved it using Common Table Expression (CTE). The first CTE with name desired_columns is used to get the relevant columns (order_date and total_amount). Then the second CTE total_by_month gets the aggregate of the amount for each month. Finally, a window function (SUM() OVER(ORDER BY month)) is used to calculate the running total, which shows how sales accumulate throughout the year.
### <i> Query: </i>

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
### <i> Insight: </i>
1. Sales have grown steadily from 3,900 in January to 24,900 by July, showing consistent month-over-month growth.
2. The highest monthly sales occurred in April (5,000), suggesting a possible peak season or successful campaign during that period.
3.A slight dip in June (2,800) indicates slower sales activity that could be investigated further.
4. Overall, the trend suggests a positive growth pattern, meaning the store is experiencing stable performance with moderate seasonal variation.
5. Also, we need to analyze June’s drop to determine if it was due to fewer orders, stock issues, or reduced customer engagement.
### <i> Result: </i>
<img width="1356" height="611" alt="image" src="https://github.com/user-attachments/assets/59d92a45-462e-49bf-a507-a31922e2dca9" /> <br>
