/* Database Setup*/

CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);




/* Data Exploration & Cleaning*/

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
 
 
 
/* Data Analysis & Findings */

/* Write a SQL query to retrieve all columns for sales made on '2022-11-05 */

select * 
from retail_sales 
where sale_date='2022-11-05';



/*Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 2 in the month of Nov-2022:*/

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 2
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
order by sale_date;
    
    
    
/* Write a SQL query to calculate the total sales (total_sale) for each category */

select category, sum(total_sale) from retail_sales
group by category  
    
    

/* Write a SQL query to find the average age of customers who purchased items 
from the 'Beauty' category */

select category, avg(age)as AVG_Age from retail_sales
where category = 'Beauty'




/* Write a SQL query to find all transactions where the total_sale is greater than 1000 */

select * from retail_sales 
where total_sale>1000



/*Write a SQL query to find the total number of transactions (transaction_id) 
made by each gender in each category */

select category, gender, count(transactions_id) as transactions  from retail_sales
group by category, gender
order by category;



/* Write a SQL query to calculate the average sale for each month. Find out best selling month 
in each year */

select Sale_Year, Sale_Date,avgsale from
(select year(sale_date)as Sale_Year,month(sale_date)as Sale_Date,avg(total_sale)as avgsale,
rank() over(partition by year(sale_date) order by avg(total_sale)desc) as ranking 
 from retail_sales
group by 1,2
) as avg_sal_month
where ranking=1



/* Write a SQL query to find the top 5 customers based on the highest total sales */

select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5


/* Write a SQL query to find the number of unique customers who purchased items from each category */

select category, count(distinct(customer_id)) as Unique_Custo from retail_sales
group by category;



/*Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17) */

SELECT 
    shift,
    COUNT(*) AS total_orders   
 from (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
) as  hourly_sale
GROUP BY shift;