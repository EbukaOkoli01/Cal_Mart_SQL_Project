## <div align = "center"> Section B — Case Statement</div>

### Objective

To apply CASE statements for classifying customers based on their saving and spending behavior. 
This section focuses on deriving meaningful customer categories from transactional data.
##

<b> Q5.Some customers haven’t saved in months. Create a query that classifies each customer as:
'Active Saver' if total savings > 2000 | 'Dormant Saver' otherwise.</b>                                                   
### <i> Explanation </i> 
The goal here was to classify customers based on how much they’ve saved over time. By creating categories such as Active Saver and Dormant 
Saver, the business can easily identify loyal customers who engage frequently versus those who are inactive and may need reactivation
campaigns. In the code below, there were two queries: suquery and main query. The subquery was to form a new table which is total savings
for each customer then the main query is to work with this new table from the subquery to categorise the customers amount into the two categories.

### <i> Query: </i>

    -- Main Query    
    SELECT
    		*,
    			CASE
    				WHEN total_savings > 2000 THEN 'Active Saver'
                    ELSE 'Dormant Saver'
                END AS customer_saving_status
    FROM
    		(-- Subquery to get total savings for each customer
    			SELECT 
    				user_id,
    				ROUND(SUM(saving_amount), 0) AS total_savings
    			FROM savings
    			GROUP BY user_id) AS t ;
### <i> Insight: </i>
1. 81.25% of customers were classified as Active Savers, contributing approximately 19,500 in total savings.
2. The remaining 18.75% (Dormant Savers) have either reduced or stopped saving, indicating lower platform engagement.
3. Encouraging Dormant Savers through personalized offers or bonus incentives could boost savings activity and customer retention.         
### <i> Result: </i>
<img width="1349" height="556" alt="image" src="https://github.com/user-attachments/assets/c73c939f-c16d-4fe2-ae70-026d8a740dbb" /><br> 

<b> Q6. Create a new column in your query to show: -'High spender' if total_amount > 3000  - 'Average spender' if between 1500 and 3000
		-'Low spender' otherwise. </b> 
### <i> Explanation </i> 
Similar to question 5, the goal here was to segment customers. However, now we also want to understand customer performance and specifically, which customers spend more or less. The code below has two queries. The subquery has a window function which is to get the sum of the overall amount for each user without reducing the level of details. Then the main query categorises the overall_amount column from the subquery result table.
### <i> Query: </i>

    SELECT *,
    		CASE 
    			WHEN overall_amount > 3000 THEN 'High Spender'
                WHEN overall_amount BETWEEN 1500 AND 3000 THEN 'Average Spender'
                ELSE 'Low Spender'
            END AS customer_classification
    FROM
    	(-- Subquery 
    	SELECT 
    			user_id,
    			total_amount,
    			SUM(total_amount) OVER(PARTITION BY user_id) AS overall_amount
    	FROM orders ) AS c;
### <i> Insight: </i>
1. Users 1, 3, 4, and 6 contribute the largest share of total spending, making them key revenue drivers.
2. Users 2, 5, and 7 spend moderately, indicating an opportunity to increase their spending through targeted promotions.
3. User 8 spends the least, suggesting low engagement or potential price sensitivity.
4. We should Focus on retaining high spenders with loyalty programs, encourage average spenders to increase purchases via promotions, and re-engage low spenders through personalized campaigns.
### <i> Result: </i>
<img width="1356" height="615" alt="image" src="https://github.com/user-attachments/assets/cd644d6e-2b12-47fe-a563-4eb94bfc8827" />
