## <div align = "center"> Section E — Month_Over_Month Analysis </div>

### Objective
To analyze monthly sales performance trends by comparing revenue changes between consecutive months. This helps evaluate 
growth rate, detect seasonal dips, and identify high-performing periods that drive business momentum.

##

<b> Q18. Calculate the month-over-month percentage growth  in total sales.  </b>                                                   
### <i> Explanation </i> 
This analysis measures the month-over-month percentage change in total sales — showing whether revenue is increasing or decreasing compared to the previous month.
The query below uses CTE to solve this particular question. There are two CTEs in the code: "previous_month" and "month_over_month_change ". The previous_month CTE helps
extract the needed column from orders table which is the order_date then we use MONTH(order_date) to get month from the date. After then, we got the sum of the total
amount per month with the help of GROUP BY using the SUM() function. The Lag() function obtains the sum(total_amount) for previous month. Now to the next CTE, this
is where we performed the percentage change which is ((current_month_sales - previous_month_sales) / (previous_month_sales)) *100. This formula helps us to know how each
month performed when compared to the previous month. A negative percentage means decrease in sales and posititve change means an increase in sales. 
### <i> Query: </i>

    WITH previous_month AS 
    (
    SELECT 
        MONTH(order_date) AS `month`,
        SUM(total_amount) AS total_sales_per_month,
        LAG(SUM(total_amount)) OVER(ORDER BY MONTH(order_date) ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_month_sales
    FROM orders
    GROUP BY MONTH(order_date)
    ),
    month_over_month_change AS
    (
    SELECT 
    		`month`,
             total_sales_per_month,
             previous_month_sales,
             ROUND(((total_sales_per_month - previous_month_sales)/ previous_month_sales),2) * 100 AS MoM_change
    FROM previous_month
    )
     SELECT
    		`month`,
             total_sales_per_month,
             previous_month_sales,
              CONCAT(MoM_change, '%') AS MoM_percentage_change,
             CASE
    			WHEN MoM_change < 0 THEN CONCAT('decreased by ', MoM_change, '%'  )
    			WHEN MoM_change > 0 THEN CONCAT('increased by ', MoM_change, '%' )
    			ELSE 'No previous sales'
             END AS increase_or_decrease_monthly_sales
    FROM month_over_month_change;
### <i> Insight: </i>
1. The company experienced strong growth in March (+78%) and April (+22%), marking the best-performing months in the year.
2. There was a sharp decline in February (-41%), followed by consecutive drops in May (-28%) and June (-22%), which signals mid-year sales volatility. A mild
  recovery was observed in July (+14%), suggesting the start of a possible rebound.
3. An Investigation should be carried out for February, May, and June declines. It coudld possibly be linked to demand drops, marketing gaps, or product
   availability also, we should reinforce campaigns or promotions during months that consistently show dips.
### <i> Result: </i>
<img width="1358" height="622" alt="image" src="https://github.com/user-attachments/assets/646180b6-ac09-4016-af8c-487c9ab408a7" /><br>


<b> Q19. Calculate the month-over-month growth in total savings.  </b>       
### <i> Explanation </i> 
Similar to the question 18, this also helps to determine how each month's savings amount performs compares to the previous month. This analysis aims at understanding 
growth, trends and performance of each month. 
### <i> Query: </i>
    WITH details_needed AS
    (
    SELECT 
    	user_id,
    	MONTH(saving_date) AS `month`,
        saving_amount
    FROM savings
    ),
    monthly_amount AS 
    (
    SELECT 
    	`month`,
        SUM(saving_amount) total_saving_permonth
    FROM details_needed
    GROUP BY `month`
    ),
    previous_month_amount AS
    (
    SELECT *,
    		LAG(total_saving_permonth) OVER(ORDER BY `month` ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS amount_previous_month
    FROM monthly_amount
    )
    SELECT *,
    	CONCAT(ROUND(((total_saving_permonth - amount_previous_month)/amount_previous_month)*100,2), '%') AS MoM_analysis
    FROM previous_month_amount;
### <i> Insight: </i>
1. Savings remained stable in February (0%) and April (0%), showing months of no new growth compared to the previous month.
2. March (+42.86%) and July (+100%) recorded the strongest growth in savings, indicating a spike in user contributions or successful engagement
   efforts during these months. May (-50%) and June (-40%) experienced sharp declines, meaning total user savings dropped significantly — possibly
   due to withdrawals, lower deposits, or inactive users.
3. Savings performance shows periodic volatility, alternating between sharp increases and steep declines. To build long-term consistency, the company
    should implement strategies that stabilize user saving behavior and maintain engagement throughout the year.
### <i> Result: </i>
<img width="1354" height="595" alt="image" src="https://github.com/user-attachments/assets/d0a602f3-d5d0-4727-8faf-f3a5ce15d18b" /> <br>


<b> Q20. Find which month had the highest revenue growth rate.  </b> 
### <i> Explanation </i> 
In this question, we only want to identify the month with the highest revenue. From the already established query in Q19, we will add a new line of code which the is the WHERE clause and a subquery. The purpose of this subquery (SELECT MAX(MoM_change) FROM month_over_month_change) is to get only the highest MoM_change then the WHERE function filter the result of the month_over_month_change table and outputs the rows where there is a match (highest MoM change).

### <i> Query: </i>

    WITH previous_month AS 
    (
    SELECT 
        DATE_FORMAT(order_date, '%m')  AS months,
        DATE_FORMAT(order_date, '%b')  AS `month`,
        SUM(total_amount) AS total_sales_per_month,
        LAG(SUM(total_amount)) OVER(ORDER BY DATE_FORMAT(order_date, '%m') ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_month_sales
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%m'), DATE_FORMAT(order_date, '%b') 
    ),
    month_over_month_change AS
    (
    SELECT 
    		`month`,
            months,
    		total_sales_per_month,
    		previous_month_sales,
    		ROUND(((total_sales_per_month - previous_month_sales)/ previous_month_sales),2) * 100 AS MoM_change
    FROM previous_month
    )
     SELECT
            `month`,
             total_sales_per_month,
             previous_month_sales,
             MoM_change
    FROM month_over_month_change
    WHERE MoM_change = (SELECT MAX(MoM_change)
    					FROM month_over_month_change);
### <i> Insight: </i>
1. March recorded the highest revenue growth rate of 78%, increasing from 2,300 in February to 4,100.
2. This sharp rise represents the strongest month-over-month performance, indicating high sales momentum and possibly the result of an effective campaign or       product push.
3. We should investigate the factors that drove the 78% growth in March and replicate those strategies in low-performing months to sustain growth consistency.
### <i> Result: </i>
<img width="1356" height="614" alt="image" src="https://github.com/user-attachments/assets/c96f141e-b784-45ff-bf9c-c9c3dd6b3fc0" />

