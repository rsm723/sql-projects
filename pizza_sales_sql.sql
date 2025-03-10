SELECT * FROM bakery.pizza_sales;

UPDATE pizza_sales
SET order_date = TRIM(order_date);

ALTER TABLE pizza_sales ADD date_ordered DATE;

SELECT order_date, LENGTH(order_date)
FROM pizza_sales
LIMIT 10;

UPDATE pizza_sales
SET order_date = REPLACE(order_date, '/', '-');

SELECT order_date, STR_TO_DATE(order_date, '%d-%m-%Y') AS converted_date
FROM pizza_sales
LIMIT 10;

UPDATE pizza_sales
SET date_ordered = STR_TO_DATE(order_date, '%m-%d-%Y');

SELECT DATE_FORMAT(date_ordered, '%m-%d-%Y') AS converted_date
FROM pizza_sales;

UPDATE pizza_sales
Set order_date = date_ordered;

select date_format(order_date, '%m-%d-%Y') AS new_date
From pizza_sales;

UPDATE pizza_sales
Set order_date = converted_date;

-- Analysis -- 

Select COUNT( DISTINCT order_date) AS days_open
From pizza_sales;

-- this shows that the pizzeria was onlhy open 358 days out of the 365 --
-- this will be useful when doing averages --

-- Most pizzas made per day --

Select  order_date, COUNT(pizza_id) AS Pizzas_made
from pizza_sales
Group by order_date
Order by COUNT(pizza_id) DESC
;

-- average number of pizzas made per day -- 

Select COUNT(pizza_id)/ COUNT(DISTINCT order_date) AS average_daily_pizzas_made
From pizza_sales
;


-- What is the most Popular pizza? --

Select pizza_name_id, COUNT(pizza_id)
From pizza_sales
Group by pizza_name_id
Order by COUNT(pizza_id) DESC
;

Select pizza_name, COUNT(pizza_name) AS times_ordered
From pizza_sales
Group by pizza_name
Order by COUNT(pizza_name) DESC
;

-- top selling pizzas by hour -- 

Select DISTINCT Pizza_name, HOUR(order_time), COUNT(Pizza_id) OVER(PARTITION BY Pizza_name, HOUR(order_time)) AS pizzas_sold
From pizza_sales
order by Hour(order_time), pizzas_sold DESC
;

-- Best selling pizza by day of week --

Select DISTINCT Pizza_name, DAYNAME(order_date) AS _Day_of_week, COUNT(Pizza_id) OVER(PARTITION BY Pizza_name, DAYNAME(order_date)) AS pizzas_sold
From pizza_sales
order by DAYNAME(order_date), pizzas_sold DESC
;

Select DISTINCT Pizza_name, HOUR(order_time), COUNT(Pizza_id) OVER(PARTITION BY Pizza_name, HOUR(order_time)) AS pizzas_sold
From pizza_sales
order by Hour(order_time), pizzas_sold DESC
;

-- What is the most profitable Pizza? -- 

Select pizza_name_id, pizza_name, ROUND(SUM(total_price),2) AS total_revenue
From pizza_sales
Group by pizza_name_id, pizza_name
Order by ROUND(SUM(total_price),2) DESC
;

-- Number of orders by Pizza size --

Select pizza_size, COUNT(pizza_id)
From pizza_sales
Group by pizza_size
Order by Count(pizza_id) DESC
;

-- When were XXL Pizzas ordered? Big party days? --

Select*
From pizza_sales
Where pizza_size = 'XXL';

-- Not sure of any trends there -

-- Best selling day of the week --

Select DAYNAME(order_date) AS Day_of_week, COUNT(pizza_id) AS pizzas_sold
From pizza_sales
Group by DAYNAME(order_date)
Order by COUNT(pizza_id) DESC
;

-- Days of week by Revenue --

Select DAYNAME(order_date) AS Day_of_week, ROUND(SUM(total_price),0) AS Revenue
From pizza_sales
Group by DAYNAME(order_date)
Order by ROUND(SUM(total_price),0) DESC
;

-- interesting that they are selling more pizzas on saturdays but making more money on thursdays but not a huge difference in Rev / pizzas -- 

-- Month by Month sales and revenue -- 

Select MONTH(order_date) AS month, COUNT(pizza_id) AS Pizzas_sold, ROUND(SUM(unit_price),0) AS total_revenue
From pizza_sales
Group by MONTH(order_date)
Order by MONTH(order_date)
;

-- Average monthly pizza oders --

Select COUNT(Pizza_id) / 12 AS average_pizzas_sold_per_month
From pizza_sales
;
-- Monthly pizza sales compares to monthly average -- 

Select DISTINCT MONTH(order_date) AS month, COUNT(pizza_id) AS total_pizzas_sold, AVG(COUNT(pizza_id)) OVER() as avg_pizzas_sold_per_month
From pizza_sales
Group by MONTH(order_date)
Order by MONTH(order_date)
;

-- monthly Revenue compared to average monthly revenue -- 

Select DISTINCT MONTH(order_date) AS month, ROUND(SUM(unit_price),0) AS total_revenue, ROUND(AVG(SUM(unit_price)) OVER(),0) as AVG_Monthly_Revenue
From pizza_sales
Group by MONTH(order_date)
Order by MONTH(order_date)
;

Select DISTINCT MONTH(order_date) AS month, ROUND(SUM(unit_price),0) AS total_revenue, ROUND(AVG(SUM(unit_price)) OVER(),0) as AVG_Monthly_Revenue,
CASE 
	WHEN ROUND(SUM(unit_price),0) > ROUND(AVG(SUM(unit_price)) OVER(),0) THEN 'Above average'
    WHEN ROUND(SUM(unit_price),0) < ROUND(AVG(SUM(unit_price)) OVER(),0) THEN 'Below average'
END AS 'Performance'
From pizza_sales
Group by MONTH(order_date)
Order by MONTH(order_date)
;

-- Monthly pizza sales compared to average monthly pizza sales

Select DISTINCT MONTH(order_date) AS month, COUNT(pizza_id) AS pizzas_sold, AVG(COUNT(pizza_id)) OVER() as AVG_Monthly_pizza_sales,
CASE 
	WHEN COUNT(pizza_id)  > AVG(COUNT(pizza_id)) OVER() THEN 'Above average'
    WHEN COUNT(pizza_id) < AVG(COUNT(pizza_id)) OVER()THEN 'Below average'
END AS 'Performance'
From pizza_sales
Group by MONTH(order_date)
Order by MONTH(order_date)
;

-- numnber of pizzas sold by season --

Select COUNT(pizza_id) AS Pizzas_sold,
	CASE
WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
WHEN MONTH(order_date) IN (12,1,2) THEN 'Winter'
END AS 'Season'
From pizza_sales
Group by 
	CASE
WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
WHEN MONTH(order_date) IN (12,1,2) THEN 'Winter'
END
;

-- Revenue by Seasons --

Select ROUND(SUM(total_price),0) AS Revenue,
	CASE
WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
WHEN MONTH(order_date) IN (12,1,2) THEN 'Winter'
END AS 'Season'
From pizza_sales
Group by 
	CASE
WHEN MONTH(order_date) IN (3,4,5) THEN 'Spring'
WHEN MONTH(order_date) IN (6,7,8) THEN 'Summer'
WHEN MONTH(order_date) IN (9,10,11) THEN 'Fall'
WHEN MONTH(order_date) IN (12,1,2) THEN 'Winter'
END
;

-- Pizzas sold by hour -- 

Select HOUR(order_time) AS hour, COUNT(pizza_id) AS pizzas_sold
From pizza_sales
Group by HOUR(order_time)
Order by COUNT(Pizza_id) DESC
;

-- Revenue by hour -- 

Select HOUR(order_time) AS hour, ROUND(SUM(total_price),0) AS Revenue
From pizza_sales
Group by HOUR(order_time)
Order by ROUND(SUM(total_price),0) DESC
;

-- Lunch vs dinner pizzas sold

Select COUNT(pizza_id) AS pizzas_sold,
	CASE
WHEN HOUR(order_time) IN (11,12,1) THEN 'Lunch'
WHEN HOUR(order_time) IN (17,18,19) THEN 'Dinner'
ELSE 'Other'
END AS 'time_of_day'
FROM pizza_sales
Group by CASE
WHEN HOUR(order_time) IN (11,12,1) THEN 'Lunch'
WHEN HOUR(order_time) IN (17,18,19) THEN 'Dinner'
ELSE 'Other'
END
;

-- Lunch vs Dinner Revenue --

Select ROUND(SUM(total_price),0) AS Revenue,
	CASE
WHEN HOUR(order_time) IN (11,12,1) THEN 'Lunch'
WHEN HOUR(order_time) IN (17,18,19) THEN 'Dinner'
ELSE 'Other'
END AS 'time_of_day'
FROM pizza_sales
Group by CASE
WHEN HOUR(order_time) IN (11,12,1) THEN 'Lunch'
WHEN HOUR(order_time) IN (17,18,19) THEN 'Dinner'
ELSE 'Other'
END
;

-- most expensive pizzas --

SELECT DISTINCT pizza_name_id, Pizza_name, unit_price
FROM pizza_sales
ORDER BY unit_price DESC
;

-- number of orders broken into order total categories -- 

SELECT 
    CASE 
        WHEN total_price < 20 THEN 'small order'
        WHEN total_price BETWEEN 20 AND 50 THEN 'Average order'
        WHEN total_price > 50 THEN 'Large order'
    END AS order_size,
    COUNT(*) AS order_count
FROM pizza_sales
Group by CASE 
        WHEN total_price < 20 THEN 'small order'
        WHEN total_price BETWEEN 20 AND 50 THEN 'Average order'
        WHEN total_price > 50 THEN 'Large order'
    END
;

-- Sales to Revenue Ratio -- 

Select DISTINCT pizza_name, COUNT(pizza_id) AS Pizzas_sold, ROUND(SUM(total_price),0) AS Revenue, ROUND(SUM(total_price),0) / COUNT(pizza_id) AS ratio
From pizza_sales
Group by pizza_name
Order by Ratio DESC;

-- orders with multiple pizzas-- 

SELECT COUNT(*) AS orders_with_multiple_pizzas
FROM (
    SELECT order_id
    FROM pizza_sales
    GROUP BY order_id
    HAVING COUNT(pizza_id) > 1
) AS multi_pizza_orders
;
