SELECT * FROM salesdatawalmart.sales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


--------- Feature Engineering-------
--------------------------------------------------------------------------------------------------------
SELECT
	time,
    (CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		 WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         ELSE 'evening' END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_date VARCHAR(20) ;

UPDATE sales 
SET time_of_date = (CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		 WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         ELSE 'evening' END);

---- Adding_day_name_to_the_column
---------------------------------------------------------------------------------

SELECT date,
	DAYNAME(date) AS day_name
    from sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

---- creating_month_column
-------------------------------------------------------------------------------------------

SELECT DATE,
	MONTHNAME(date) as month_name
    FROM sales;
    
    ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-----------------------------------------------------------------------------------
---------------- GENERIC -------------
----------------------How Many Cities does the_data_have------

SELECT count(DISTINCT city) as cities
FROM sales;

---------- In_which city is_each branch?------

SELECT DISTINCT city, branch
FROM sales;


-------------PRODUCT--------
----------How many_unique product_lines does the_data have?------

SELECT COUNT(DISTINCT product_line) AS No_of_Product_Lines
FROM sales;

----------what_is the most common payment method ?----

SELECT payment_method, COUNT(payment_method) AS No_of_payment_methods
FROM sales
GROUP BY payment_method
ORDER BY No_of_payment_methods DESC

--------What_is the most selling product line?--

SELECT product_line, COUNT(product_line) AS Most_selling_product
FROM SALES
GROUP BY product_line
ORDER BY Most_selling_product DESC

-------------What_is_the_total_revenue_by_month?--

SELECT sum(total) AS total_revenue ,month_name
 FROM salesdatawalmart.sales
 GROUP BY month_name
 ORDER BY total_revenue DESC;

-----What_month had the largest COGS?---

SELECT month_name, sum(cogs) AS Largest_cogs
FROM sales
GROUP BY month_name
ORDER BY Largest_cogs DESC;

------------What product line had the largest revenue?-----

SELECT product_line, SUM(total) AS Total_revenue
 FROM sales
 GROUP BY product_line
 ORDER BY Total_revenue DESC
 
 --------------What_is the city_with the largest revenue?----
 
 SELECT city,branch, SUM(total) AS Largest_revenue
 FROM sales
 GROUP BY city, branch
 ORDER BY Largest_revenue DESC
 
 -------------What product line had the largest VAT?------
 
 SELECT product_line, AVG(tax_pct) AS largest_VAT
 FROM sales
 GROUP BY product_line
 ORDER BY largest_VAT DESC

----------- which branch sold more products than average product sold?------

SELECT branch, sum(quantity) AS qty
 FROM salesdatawalmart.sales
 GROUP BY branch
 HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
 
 -------what is the most commom product line by gender ?-------
 
 SELECT product_line, gender, count(gender) AS total_count 
FROM salesdatawalmart.sales
GROUP BY product_line, gender
ORDER BY total_count DESC;

-----------what is the avg rating of each product line?----

SELECT product_line,ROUND(AVG(rating), 2) AS avg_rating_of_product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating_of_product_line DESC

--------Sales---------
--------Number_of sales made in_each time_of_the_day_per_week_day?

SELECT time_of_day, count(quantity) AS total_sales
FROM salesdatawalmart.sales
WHERE day_name = 'monday'  ----we can just_change the_day what_day _we re trying to look ---
GROUP BY time_of_day
ORDER BY total_sales DESC;

----which of the customer types brings the most revenue?----

SELECT customer_type, sum(total) AS total_rev
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-------Which city has the largest tax percent/ VAT (Value Added TAx) ?

SELECT city, AVG(tax_pct) AS VAT
 FROM salesdatawalmart.sales
 GROUP BY city
 ORDER BY VAT DESC;
 
 -----Which_customer_type_pays_the_most_in_VAT ?
 
SELECT customer_type, AVG(tax_pct) AS most_tax_paid_member
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY most_tax_paid_member DESC;

--------CUSTOMER--------
-----How many_unique customer_types does the_data have?

SELECT count(DISTINCT customer_type) 
FROM salesdatawalmart.sales;

---------How many unique payment methods does the data have?---

SELECT DISTINCT payment_method
FROM salesdatawalmart.sales;

-----what_is the most common customer_type ?

 SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

----------Which customer_type buys the most?--

SELECT customer_type, COUNT(*) AS cstm_cnt
 FROM salesdatawalmart.sales
 group by customer_type
 
 ---what_is the gender_of most_of the customer ?
 
 SELECT gender, count(*) AS gender_count
 FROM salesdatawalmart.sales
 GROUP BY gender
 ORDER BY gender_count DESC;
 
 ----What is the gender distribution per branch?--
 
 
 SELECT gender, count(*) AS gender_count
 FROM salesdatawalmart.sales
 WHERE branch = 'c'
 GROUP BY gender
 ORDER BY gender_count DESC;
 
 ----what_time_of_the_day_do_customers_give_most_ratings?---
 
 SELECT time_of_day, AVG(rating) AS avg_rating
 FROM salesdatawalmart.sales
 GROUP BY time_of_day
 ORDER BY avg_rating DESC;
 
 ---Which_time of the day do customers give most ratings per branch?---
 
 SELECT time_of_day, AVG(rating) AS avg_rating
 FROM salesdatawalmart.sales
 WHERE branch = 'A'
 GROUP BY time_of_day
 ORDER BY avg_rating DESC;
 
 --------which day of the week has the best avg ratings ?----
 
 SELECT day_name, AVG(rating) AS 'avg rating per day'
 FROM salesdatawalmart.sales
 GROUP BY day_name
 ORDER BY 'avg rating per day' DESC
 
 -------Which day of the week has the best avg rating?----
 
 SELECT day_name, AVG(rating) AS rating
 FROM salesdatawalmart.sales
 WHERE branch = 'A'
 GROUP BY day_name
 ORDER BY rating DESC
 
 
 
 
 
 
 























