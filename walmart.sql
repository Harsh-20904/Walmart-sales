SELECT * FROM walmart;

SELECT payment_method, COUNT(*)
FROM walmart
GROUP BY payment_method;

SELECT COUNT(DISTINCT Branch) FROM walmart;

-- bussiness problems 
-- 1.Find different payment methods and number of transactions, number of qnty sold

SELECT payment_method, COUNT(*) AS no_of_payments, SUM(quantity) AS no_of_qunty_sold
FROM walmart
GROUP BY payment_method;

-- 2.Identify the highest rated category in each branch, displaying the branch and category
-- AVG rating
SELECT * 
FROM 
(  SELECT branch, category, AVG(rating) AS avg_rating,
RANK() OVER(partition by branch ORDER BY AVG(rating) DESC) AS rating_rank
FROM walmart
GROUP BY branch, category
) AS rank_categories
WHERE rating_rank = 1;

-- 3.Identify the busiest day for each branch based on number of transactions

SELECT 
    branch,
    DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS Day_name,
    COUNT(*) as no_transactions
FROM walmart
GROUP BY branch, Day_name
ORDER BY branch, no_transactions DESC;

-- 4. calculate the total quantity of items per payment methods 

SELECT payment_method, SUM(quantity) AS no_quantity
FROM walmart
GROUP BY payment_method;

-- 5. Determine the avg, min and max rating of category for each city. list the city, avg_rating, min_rating and max_rating

SELECT city, category,
MIN(rating) AS min_rating, MAX(rating) AS max_rating, AVG(rating) AS avg_rating 
FROM walmart
GROUP BY city, category;

-- 6. Calculate the total profit for each category by considering total profit as (unit price * quantity * profit margin), List category and total profit, ordered from highest to lowest profit

SELECT category, SUM(total) AS revenue, SUM(total * profit_margin) AS profit
FROM walmart
GROUP BY category;

-- 7. Detrmine the most common method of payment for each branch
WITH cte AS 
(SELECT branch, payment_method, COUNT(*) AS total_transactions,
RANK() OVER(partition by branch order by count(*) DESC ) AS ranking
FROM walmart
GROUP BY branch, payment_method)

SELECT * FROM cte 
WHERE ranking = 1;