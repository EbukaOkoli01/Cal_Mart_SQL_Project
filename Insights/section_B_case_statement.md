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
<img width="1349" height="556" alt="image" src="https://github.com/user-attachments/assets/c73c939f-c16d-4fe2-ae70-026d8a740dbb" />
 <br> 
