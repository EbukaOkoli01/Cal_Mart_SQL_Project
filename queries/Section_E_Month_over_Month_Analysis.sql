USE cal_mart;


-- 18.	Calculate the month-over-month percentage growth  in total sales.

WITH previous_month AS 
(
SELECT 
    DATE_FORMAT(order_date, '%m')  AS `month`,
    SUM(total_amount) AS total_sales_per_month,
    LAG(SUM(total_amount)) OVER(ORDER BY DATE_FORMAT(order_date, '%m') ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_month_sales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%m')
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


-- 19.	Calculate the month-over-month growth in total savings.

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


-- 19.	Find which month had the highest revenue growth rate.

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


