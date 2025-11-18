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
<img width="1280" height="569" alt="image" src="https://github.com/user-attachments/assets/0108d6be-61df-4916-b3a9-625c3af5c011" />

<b> Q13. Identify customers whose spending has increased or decreased compared to their previous purchase. </b>   
### <i> Explanation </i>






