USE Assignment_1;

-- Window Functions
-- Questions 377-426

-- Q377. Assign row numbers to employees ordered by salary descending.
SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num FROM employees;

-- Q378. Rank employees by salary within each department (use RANK()).
SELECT *, RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank FROM employees;

-- Q379. Use DENSE_RANK() to rank products by price within each category.
SELECT *, DENSE_RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS price_rank FROM products;

-- Q380. Show the difference in salary from the previous employee when ordered by hire_date (LAG).
SELECT emp_id,hire_date,salary,salary-LAG(salary) OVER(ORDER BY hire_date) AS salary_change FROM employees;

-- Q381. Display the next order date for each customer using LEAD().
SELECT customer_id,order_date,LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date FROM orders;

-- Q382. Calculate the running total of sales amount over order date.
SELECT order_date,total_amount,SUM(total_amount) OVER(ORDER BY order_date) AS running_sales FROM orders;

-- Q383. Compute a moving average of the last 3 orders’ totals for each customer.
SELECT customer_id,order_date,total_amount,AVG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3 FROM orders;

-- Q384. Partition employees by department and assign a row number resetting per department.
SELECT *,ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS dept_row FROM employees;

-- Q385. Find the first value (earliest hire date) in each department using FIRST_VALUE().
SELECT DISTINCT dept_id,FIRST_VALUE(hire_date) OVER(PARTITION BY dept_id ORDER BY hire_date) AS first_hire_date FROM employees;

-- Q386. Get the last order date per customer using LAST_VALUE() with RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.
SELECT customer_id,order_date,LAST_VALUE(order_date) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_date FROM orders;

-- Q387. Use NTILE(4) to divide employees into quartiles based on salary.
SELECT *,NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile FROM employees;

-- Q388. Calculate the percentage of total salary that each employee earns within their department (ratio_to_report simulation using SUM).
SELECT emp_id,dept_id,salary,ROUND(100*salary/SUM(salary) OVER(PARTITION BY dept_id),2) AS salary_pct_of_dept FROM employees;

-- Q389. For each order, compute the difference between its total and the average total of the last 5 orders.
SELECT order_id,total_amount,total_amount-AVG(total_amount) OVER(ORDER BY order_date ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING) AS difference_from_previous_5_avg FROM orders;

-- Q390. Show cumulative distribution of salaries using CUME_DIST().
SELECT emp_id,salary,CUME_DIST() OVER(ORDER BY salary) AS cumulative_distribution FROM employees;

-- Q391. Use PERCENT_RANK() to find percentile rank of each product's price.
SELECT product_id,price,PERCENT_RANK() OVER(ORDER BY price) AS price_percent_rank FROM products;

-- Q392. Write a query that numbers rows in the result set without ordering (ORDER BY (SELECT NULL)).
SELECT ROW_NUMBER() OVER() AS row_num, e.* FROM employees e;

-- Q393. Find the highest salary in each department using MAX() as a window function.
SELECT emp_id,dept_id,salary,MAX(salary) OVER(PARTITION BY dept_id) AS dept_max_salary FROM employees;

-- Q394. Display each sale along with the running count of sales per product.
SELECT product_id,order_id,quantity,COUNT(*) OVER(PARTITION BY product_id ORDER BY order_id) AS running_sale_count FROM order_items;

-- Q395. Compare each employee's salary with the department average using a window aggregate.
SELECT emp_id,salary,AVG(salary) OVER(PARTITION BY dept_id) AS dept_avg_salary FROM employees;

-- Q396. Assign a unique sequential ID to orders per customer ordered by date.
SELECT customer_id,order_id,order_date,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS customer_order_no FROM orders;

-- Q397. Show the year-over-year growth of sales using LAG on yearly totals.
WITH yearly AS (SELECT YEAR(order_date) y,SUM(total_amount) sales FROM orders GROUP BY YEAR(order_date)) SELECT y,sales,sales-LAG(sales) OVER(ORDER BY y) AS change_from_previous_year,ROUND(100*(sales-LAG(sales) OVER(ORDER BY y))/NULLIF(LAG(sales) OVER(ORDER BY y),0),2) AS growth_pct FROM yearly;

-- Q398. Determine the median salary per department using PERCENTILE_DISC or simulation with window functions.
SELECT dept_id,AVG(salary) AS median_salary FROM (SELECT dept_id,salary,ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary) rn,COUNT(*) OVER(PARTITION BY dept_id) cnt FROM employees) x WHERE rn IN(FLOOR((cnt+1)/2),FLOOR((cnt+2)/2)) GROUP BY dept_id;

-- Q399. Use ROW_NUMBER() to delete duplicate rows keeping the first occurrence.
DELETE FROM employees WHERE emp_id IN (SELECT emp_id FROM (SELECT emp_id,ROW_NUMBER() OVER(PARTITION BY first_name,last_name,email ORDER BY emp_id) rn FROM employees) x WHERE rn>1);

-- Q400. Compute the sum of a column over a rolling 7-day window (RANGE INTERVAL).
SELECT order_date,SUM(total_amount) OVER(ORDER BY order_date RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS rolling_7_day_sales FROM orders;

-- Q401. Identify islands of consecutive dates in attendance data using ROW_NUMBER() difference technique.
-- Consecutive-date island pattern: date - ROW_NUMBER() creates a stable group key.
SELECT user_id,MIN(login_date) start_date,MAX(login_date) end_date FROM (SELECT user_id,login_date,login_date-INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) DAY grp FROM attendance) x GROUP BY user_id,grp;

-- Q402. Rank orders by amount within each month.
SELECT order_id,order_date,total_amount,RANK() OVER(PARTITION BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY total_amount DESC) AS monthly_rank FROM orders;

-- Q403. Retrieve the second highest salary in each department using DENSE_RANK and a subquery.
SELECT * FROM (SELECT e.*,DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) rnk FROM employees e) x WHERE rnk=2;

-- Q404. Show each transaction and the balance as a running total.
SELECT transaction_id,transaction_date,amount,SUM(amount) OVER(ORDER BY transaction_date,transaction_id) AS running_balance FROM transactions; -- transactions table is not in supplied schema.

-- Q405. Find the average price of products within the same category and compare each product’s price to it.
SELECT product_id,price,AVG(price) OVER(PARTITION BY category_id) AS category_avg,price-AVG(price) OVER(PARTITION BY category_id) AS difference FROM products;

-- Q406. Use LEAD to compute the time between consecutive orders for each customer.
SELECT customer_id,order_date,LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)-order_date AS days_to_next_order FROM orders;

-- Q407. Partition by customer and order by date, number the orders, then filter to just the first 3 orders per customer.
SELECT * FROM (SELECT o.*,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) rn FROM orders o) x WHERE rn<=3;

-- Q408. For each department, show the employee with the highest salary, and the difference to the next highest (using LEAD/LAG after ranking).
WITH ranked AS (SELECT e.*,ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) rn FROM employees e) SELECT r.*,LEAD(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS next_salary,salary-LEAD(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS gap_to_next FROM ranked r WHERE rn=1;

-- Q409. Compute a weighted moving average (e.g., last 3 with weights 0.5, 0.3, 0.2) using window functions and manual calculation.
SELECT customer_id,order_date,total_amount,(0.5*COALESCE(LAG(total_amount,0) OVER(PARTITION BY customer_id ORDER BY order_date),0)+0.3*COALESCE(LAG(total_amount,1) OVER(PARTITION BY customer_id ORDER BY order_date),0)+0.2*COALESCE(LAG(total_amount,2) OVER(PARTITION BY customer_id ORDER BY order_date),0)) AS weighted_value FROM orders;

-- Q410. Create a "gaps and islands" solution for identifying consecutive login streaks for users.
WITH logins AS (SELECT user_id,login_date,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) rn FROM user_logins), islands AS (SELECT user_id,login_date,login_date-INTERVAL rn DAY grp FROM logins) SELECT user_id,MIN(login_date) start_date,MAX(login_date) end_date,COUNT(*) streak_length FROM islands GROUP BY user_id,grp; -- user_logins is not in supplied schema.

-- Q411. Show each employee's salary and the cumulative distribution of salaries across the whole company.
SELECT emp_id,salary,CUME_DIST() OVER(ORDER BY salary) AS cumulative_distribution FROM employees;

-- Q412. Use ROW_NUMBER() to paginate results (fetch rows 21-40).
SELECT * FROM (SELECT e.*,ROW_NUMBER() OVER(ORDER BY emp_id) rn FROM employees e) x WHERE rn BETWEEN 21 AND 40;

-- Q413. Find the top N records per group using ROW_NUMBER() (e.g., top 2 products per category by sales).
SELECT * FROM (SELECT p.*,ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) rn FROM products p) x WHERE rn<=2;

-- Q414. Show the running total of quantity sold per product over time.
SELECT product_id,order_id,quantity,SUM(quantity) OVER(PARTITION BY product_id ORDER BY order_id) AS running_quantity FROM order_items;

-- Q415. For each order, include the previous and next order dates of the same customer.
SELECT customer_id,order_date,LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date FROM orders;

-- Q416. Compute the mode (most frequent value) of a column using window functions (count and rank).
WITH counts AS (SELECT status,COUNT(*) cnt FROM orders GROUP BY status), ranked AS (SELECT *,DENSE_RANK() OVER(ORDER BY cnt DESC) rnk FROM counts) SELECT status,cnt FROM ranked WHERE rnk=1;

-- Q417. Identify the point where cumulative sales exceed a threshold.
WITH x AS (SELECT order_date,SUM(total_amount) daily_sales,SUM(SUM(total_amount)) OVER(ORDER BY order_date) cumulative_sales FROM orders GROUP BY order_date) SELECT * FROM x WHERE cumulative_sales>1000 ORDER BY order_date LIMIT 1;

-- Q418. Use FIRST_VALUE() with a filter to get the first non-null next value.
-- FIRST_VALUE ignores no NULLs by default in MySQL. A common workaround is FIRST_VALUE(CASE WHEN value IS NOT NULL THEN value END) over an ordered window, or a filtered derived table.

-- Q419. Compare current month sales with previous month using LAG on a monthly summary CTE.
WITH monthly AS (SELECT DATE_FORMAT(order_date,'%Y-%m-01') month_start,SUM(total_amount) sales FROM orders GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')) SELECT month_start,sales,sales-LAG(sales) OVER(ORDER BY month_start) AS month_change FROM monthly;

-- Q420. Use window functions to fill down the last non-null value in a column (e.g., carry forward last known price).
-- MySQL does not support IGNORE NULLS for LAST_VALUE. Use MAX() OVER an appropriate ROWS frame when values are carried forward and never decrease, or a correlated lookup for general cases.

-- Q421. Display the percentage of orders that are each customer's orders, using COUNT(*) OVER.
SELECT customer_id,COUNT(*) AS customer_orders,ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS order_share_pct FROM orders GROUP BY customer_id;

-- Q422. Find employees whose salary is above the 90th percentile within their department (NTILE or PERCENT_RANK).
SELECT * FROM (SELECT e.*,PERCENT_RANK() OVER(PARTITION BY dept_id ORDER BY salary) pct_rank FROM employees e) x WHERE pct_rank>=0.90;

-- Q423. Assign a unique "batch number" to every 10 rows.
SELECT emp_id,CEIL(ROW_NUMBER() OVER(ORDER BY emp_id)/10) AS batch_no FROM employees;

-- Q424. Use CUME_DIST to find the top 20% of customers by total spending.
WITH customer_sales AS (SELECT customer_id,SUM(total_amount) total_sales FROM orders GROUP BY customer_id), ranked AS (SELECT *,CUME_DIST() OVER(ORDER BY total_sales DESC) cd FROM customer_sales) SELECT * FROM ranked WHERE cd<=0.20;

-- Q425. Implement a query that returns the difference from the overall average salary without subquery (using window AVG).
SELECT emp_id,salary,salary-AVG(salary) OVER() AS difference_from_company_average FROM employees;

-- Q426. For each employee, calculate the difference between their salary and the average salary of the department they belong to.
SELECT emp_id,salary,AVG(salary) OVER(PARTITION BY dept_id) AS dept_avg_salary,salary-AVG(salary) OVER(PARTITION BY dept_id) AS difference_from_dept_average FROM employees;
