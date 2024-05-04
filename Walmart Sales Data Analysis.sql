# Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

USE waLmartSales;

# Creating Tables
CREATE TABLE Sales (
invoice_id VARCHAR(40) NOT NULL PRIMARY KEY,
branch VARCHAR(10) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender	VARCHAR(6) NOT NULL,
product_line VARCHAR(120) NOT NULL,
unit_price	DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
tax_pct FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4),
rating FLOAT(2,1)
);


# Data Cleaning

SELECT * FROM SALES;

# ADDING THE TIME OF DAY COLUMN
SELECT
time,
(CASE
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
ELSE 'Evening'
END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);

UPDATE sales SET time_of_day = (
CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

# ADD day_name COLUMN
SELECT date, DAYNAME(date) FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

# Add month_name column
SELECT date, MONTHNAME(date) FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET 
    month_name = MONTHNAME(date);
------------------------------------------------------------


# How many unique cities does the data have?
SELECT DISTINCT CITY FROM SALES;

# In which city is each branch?
SELECT DISTINCT CITY, BRANCH FROM SALES;

# How many unique product lines does the data have?
SELECT DISTINCT product_line FROM SALES;

# What is the most selling product line?
SELECT SUM(QUANTITY) AS QTY, PRODUCT_LINE
FROM SALES 
GROUP BY PRODUCT_LINE
ORDER BY QTY DESC;

# What is the total revenue by month
SELECT month_name AS MONTH, SUM(TOTAL) AS TOTAL_REVENUE
FROM SALES 
GROUP BY month_name
ORDER BY TOTAL_REVENUE;

# What month had the largest COGS?
SELECT MONTH_NAME AS MONTH, SUM(COGS) AS COGS
FROM SALES
GROUP BY MONTH_NAME
ORDER BY COGS;

# What product line had the largest revenue?
SELECT PRODUCT_LINE, SUM(TOTAL) AS TOTAL_REVENUE
FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY TOTAL_REVENUE DESC;

# Which city has a largest revenue?
SELECT CITY, SUM(TOTAL) AS REVENUE
FROM SALES 
GROUP BY CITY
ORDER BY REVENUE;

# WHICH PRODUCT LINE HAS LARGEST VAT?
SELECT PRODUCT_LINE, AVG(TAX_PCT) AS AVG_VAT
FROM SALES 
GROUP BY PRODUCT_LINE
ORDER BY AVG_VAT DESC;

# Fetch each product line and add a column to those product 
# line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

# Which branch sold more products than average product sold?
SELECT BRANCH, SUM(QUANTITY) AS QTY
FROM SALES 
GROUP BY BRANCH
HAVING SUM(QUANTITY)>(SELECT AVG(QUANTITY) FROM SALES);

# What is the most common product line by gender
SELECT GENDER, PRODUCT_LINE, COUNT(GENDER) AS TOTAL 
FROM SALES 
GROUP BY GENDER, PRODUCT_LINE
ORDER BY TOTAL DESC; 

# What is the average rating of each product line?
SELECT ROUND(AVG(RATING),2) AS AVG_RATING, PRODUCT_LINE
FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY AVG_RATING DESC;

# How many unique customer types does the data have?
SELECT DISTINCT CUSTOMER_TYPE FROM SALES;

# How many unique payment methods does the data have?
SELECT DISTINCT PAYMENT FROM SALES;

# What is the most common customer type?
SELECT CUSTOMER_TYPE, count(*) AS COUNT
FROM SALES
GROUP BY CUSTOMER_TYPE;

# Which customer type buys the most?
SELECT CUSTOMER_TYPE, COUNT(*)
FROM SALES GROUP BY CUSTOMER_TYPE; 

# What is the gender of most of the customers?
SELECT GENDER, count(*) AS GENDER_COUNT
FROM SALES
GROUP BY GENDER
ORDER BY GENDER_COUNT DESC;

# What is the gender distribution per branch?
SELECT GENDER, COUNT(*) AS GENDER_COUNT
FROM SALES WHERE BRANCH = 'C'
GROUP BY GENDER 
ORDER BY GENDER_COUNT DESC;
# Gender per branch is more or less the same

# Which time of the day do customers give most ratings?
SELECT TIME_OF_DAY,
AVG(RATING) AS AVG_RATING
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
# Looks like time of the day does not really affect the rating

# Which time of the day do customers give most ratings per branch?
SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
#Branch A and C are doing well in ratings, branch B needs to do a 
# little more to get better ratings.

# Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
#Mon, Tue and Friday are the top best days for good ratings
#why is that the case, how many sales are made on these days?

# Which day of the week has the best average ratings per branch?
SELECT day_name, COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

# Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
# Evenings experience most sales, the stores are filled during the evening hours

# Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

# Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

# Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;









