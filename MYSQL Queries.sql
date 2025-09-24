SELECT * FROM walmart;

--
SELECT COUNT(*) FROM walmart;

SELECT 
      payment_method,
      Count(*)
FROM walmart
GROUP BY payment_method;

select count(distinct Branch) from walmart;

SELECT MIN(quantity) FROM walmart;
SELECT MAX(quantity) FROM walmart;


-- -----------------------------------------------------------------
--       Bussiness Problems :-
-- -----------------------------------------------------------------

-- Q.1) Find the different payment methods, Number of transactions, and Number of quantity sold ?

SELECT
	  payment_method,
      COUNT(*) AS number_of_payments,
      SUM(quantity) AS no_of_quantity_sold
FROM walmart
GROUP BY payment_method;


-- Q.2) Identify the highest rated-category in each branch, displaying the branch, category, Average rating ?

SELECT *
FROM(
	 SELECT 
		  Branch,
		  category,
		  AVG(rating) AS avg_rating,
		  RANK() OVER (PARTITION BY Branch ORDER BY AVG(rating) DESC) AS ranks
	 FROM walmart
	 GROUP BY 1,2
) walmart
WHERE ranks = 1;


-- Q.3) Identify the busiest day for each branch based on the number of transactions ?

SELECT *
FROM
	(SELECT 
		Branch,
		DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
		COUNT(*) AS no_of_transactions,
		RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS ranking
	FROM walmart
	GROUP BY 1,2
    ) walmart
WHERE ranking = 1;


-- Q.4) Calculate the total quantity of items sold per payment method. List payment_method and total_quantity ?

SELECT
      payment_method,
      SUM(quantity) AS no_of_quantity_sold
FROM walmart
GROUP BY payment_method;


-- Q.5) Determine the average, minimum, and maximum ratings of category for each city.
-- List the city, avg_rating, min_rating, and max_rating.

SELECT
      City,
      category,
      MIN(rating) AS min_rating,
	  MAX(rating) AS max_rating,
      AVG(rating) AS avg_rating
FROM walmart
GROUP BY 1,2;


-- Q.6) 
-- Calculate the total profit for each category by considering total profit as
-- (unit_price * quantity * profit_margin). List category and total profit ordered from highest to lowest profit.

SELECT
      category,
      SUM(Total) AS total_revenue,
      SUM(Total * profit_margin) AS profit
FROM walmart
GROUP BY 1;


-- Q.7)
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred payment method.

WITH cte
AS
(
	SELECT 
		 Branch,
		 payment_method,
		 COUNT(*) AS no_of_transactions,
		 RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS rank_wise
	FROM walmart
	GROUP BY 1,2
) 
SELECT * 
FROM cte
WHERE rank_wise = 1;


-- Q.7) 
-- Categorize sales into three groups MORNING, AFTERNOON, EVENING.
-- Find out which of the shift and number of invoices.

SELECT
Branch,
	 CASE 
		 WHEN HOUR (STR_TO_DATE(`time`, '%H:%i:%s')) < 12 THEN 'Morning'
         WHEN HOUR (STR_TO_DATE(`time`, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
         ELSE 'Evening'
	 END AS time_of_day,
     COUNT(*)
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- Q.9)
-- Identify last 5 branch with highest decrease ratio insert
-- revenue compare to last year (current year 2023 last year 2022)

-- Top - 5: revenue decrease percentage.

SELECT *,
YEAR(STR_TO_DATE(date, '%d/%m/%y')) AS year
FROM walmart;

-- 2022 sales
WITH revenue_2022
AS
(
	SELECT 
		  Branch,
		  SUM(Total) AS revenue
	FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
	GROUP BY 1
),

-- 2023 sales
revenue_2023
AS
(
	SELECT 
		  Branch,
		  SUM(Total) AS revenue
	FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
	GROUP BY 1
)

SELECT 
      ls.Branch,
      ls.revenue AS last_year_revenue,
      cs.revenue AS current_year_revenue,
      ROUND(((ls.revenue - cs.revenue) / ls.revenue) * 100,2) AS revenue_decrease_ratio
      
FROM revenue_2022 AS ls
JOIN
revenue_2023 AS cs
ON ls.Branch = cs.Branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;


-- Q.10) 
-- Identify last 5 branch with highest increase ratio.
-- revenue compare to last year (current year 2023 last year 2022).

 -- Top - 5: revenue increase percentage.
 
-- 2022 sales
WITH revenue_2022
AS
(
	SELECT 
		  Branch,
		  SUM(Total) AS revenue
	FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
	GROUP BY 1
),

-- 2023 sales
revenue_2023
AS
(
	SELECT 
		  Branch,
		  SUM(Total) AS revenue
	FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
	GROUP BY 1
)

SELECT 
      ls.Branch,
      ls.revenue AS last_year_revenue,
      cs.revenue AS current_year_revenue,
      ROUND(((cs.revenue - ls.revenue) / ls.revenue) * 100,2) AS revenue_increase_ratio
      
FROM revenue_2022 AS ls
JOIN
revenue_2023 AS cs
ON ls.Branch = cs.Branch
WHERE ls.revenue < cs.revenue
ORDER BY 4 DESC
LIMIT 5;































      





























      