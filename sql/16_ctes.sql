USE Assignment_1;

-- Common Table Expressions
-- Questions 427-456

-- Q427. Write a CTE to list employees with salary > 80000, then select from it.
WITH high_paid AS (SELECT * FROM employees WHERE salary>80000) SELECT * FROM high_paid;

-- Q428. Create a CTE that defines the top 5 products by sales and join with products table.
WITH top_products AS (SELECT product_id,SUM(quantity*unit_price) total_sales FROM order_items GROUP BY product_id ORDER BY total_sales DESC LIMIT 5) SELECT p.product_name,t.total_sales FROM top_products t JOIN products p ON p.product_id=t.product_id;

-- Q429. Use multiple CTEs in a single query to break down a complex query (e.g., order_summary, customer_summary, then join).
WITH order_summary AS (SELECT customer_id,SUM(total_amount) total_spend FROM orders GROUP BY customer_id), customer_summary AS (SELECT customer_id,CONCAT(first_name,' ',last_name) customer_name FROM customers) SELECT c.customer_name,o.total_spend FROM customer_summary c JOIN order_summary o ON o.customer_id=c.customer_id;

-- Q430. Define a CTE that calculates average salary per department, then use it to list employees above their dept average.
WITH dept_avg AS (SELECT dept_id,AVG(salary) avg_salary FROM employees GROUP BY dept_id) SELECT e.* FROM employees e JOIN dept_avg d ON d.dept_id=e.dept_id WHERE e.salary>d.avg_salary;

-- Q431. Write a CTE that simulates a temporary view for a monthly sales report.
WITH monthly_sales AS (SELECT DATE_FORMAT(order_date,'%Y-%m-01') month_start,SUM(total_amount) total_sales FROM orders GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')) SELECT * FROM monthly_sales ORDER BY month_start;

-- Q432. Use a CTE with a window function to rank employees, then filter to rank <= 3.
WITH ranked AS (SELECT e.*,RANK() OVER(ORDER BY salary DESC) rnk FROM employees e) SELECT * FROM ranked WHERE rnk<=3;

-- Q433. Chain CTEs: first CTE computes totals, second CTE adds rankings, final select filters.
WITH totals AS (SELECT dept_id,SUM(salary) total_salary FROM employees GROUP BY dept_id), ranked AS (SELECT *,RANK() OVER(ORDER BY total_salary DESC) rnk FROM totals) SELECT * FROM ranked WHERE rnk<=5;

-- Q434. Write a recursive CTE? (No, keep non-recursive; for this section, just use a CTE to generate series via UNION but not recursive. For example, a series of numbers using row_number() from an existing large table.)
WITH number_series AS (SELECT ROW_NUMBER() OVER(ORDER BY emp_id) n FROM employees) SELECT n FROM number_series;

-- Q435. Create a CTE that pivots sales data by year (conditional aggregation in CTE, then select).
WITH sales AS (SELECT p.category_id,YEAR(o.order_date) sales_year,SUM(oi.quantity*oi.unit_price) total_sales FROM products p JOIN order_items oi ON oi.product_id=p.product_id JOIN orders o ON o.order_id=oi.order_id GROUP BY p.category_id,YEAR(o.order_date)) SELECT category_id,SUM(CASE WHEN sales_year=2023 THEN total_sales ELSE 0 END) sales_2023,SUM(CASE WHEN sales_year=2024 THEN total_sales ELSE 0 END) sales_2024 FROM sales GROUP BY category_id;

-- Q436. Use a CTE to delete duplicate rows (with ROW_NUMBER) and then DELETE using the CTE (if updatable).
-- MySQL does not allow a CTE to be referenced directly by DELETE in every form. A common pattern is DELETE ... WHERE id IN (SELECT id FROM (WITH ... SELECT ...) x).

-- Q437. Build a CTE that computes the year-to-date sales.
WITH daily AS (SELECT order_date,SUM(total_amount) total_sales FROM orders GROUP BY order_date) SELECT order_date,total_sales,SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) ytd_sales FROM daily;

-- Q438. Use a CTE to isolate expensive products and then find the total stock value of those products.
WITH expensive AS (SELECT product_id,product_name,price,stock_quantity FROM products WHERE price>(SELECT AVG(price) FROM products)) SELECT SUM(price*stock_quantity) total_stock_value FROM expensive;

-- Q439. Create a CTE that calculates the median price per category using PERCENTILE_CONT or NTILE.
WITH ranked AS (SELECT category_id,price,ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price) rn,COUNT(*) OVER(PARTITION BY category_id) cnt FROM products) SELECT category_id,AVG(price) median_price FROM ranked WHERE rn IN(FLOOR((cnt+1)/2),FLOOR((cnt+2)/2)) GROUP BY category_id;

-- Q440. Write a query with a CTE that returns the most recent order for each customer.
WITH ranked AS (SELECT o.*,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC,order_id DESC) rn FROM orders o) SELECT * FROM ranked WHERE rn=1;

-- Q441. Define a CTE that holds a list of blacklisted customer IDs, then exclude them from a sales report.
WITH blacklist AS (SELECT 3 customer_id UNION ALL SELECT 5 UNION ALL SELECT 6) SELECT o.customer_id,SUM(o.total_amount) total_sales FROM orders o WHERE NOT EXISTS(SELECT 1 FROM blacklist b WHERE b.customer_id=o.customer_id) GROUP BY o.customer_id;

-- Q442. Use a CTE as a source for an INSERT statement (INSERT INTO ... WITH ...).
WITH new_rows AS (SELECT * FROM source_customers) INSERT INTO customers SELECT * FROM new_rows; -- Replace source_customers with the source table.

-- Q443. Create a CTE that generates a calendar table for the current year (using series generation without recursion: using UNION of fixed quarters maybe). And then use it to fill missing dates in a sales report.
-- A calendar CTE can be built recursively in MySQL. The assignment asks for a non-recursive series; with the supplied schema there is no calendar table to safely use as a row generator.

-- Q444. Refactor a correlated subquery into a CTE for better readability.
WITH dept_avg AS (SELECT dept_id,AVG(salary) avg_salary FROM employees GROUP BY dept_id) SELECT e.* FROM employees e JOIN dept_avg d ON d.dept_id=e.dept_id WHERE e.salary>d.avg_salary;

-- Q445. Use a CTE to store the result of a GROUP BY and then apply another GROUP BY on top (resume aggregation).
WITH customer_year AS (SELECT customer_id,YEAR(order_date) y,SUM(total_amount) sales FROM orders GROUP BY customer_id,YEAR(order_date)) SELECT customer_id,SUM(sales) total_sales FROM customer_year GROUP BY customer_id;

-- Q446. Combine two CTEs with UNION.
WITH a AS (SELECT dept_id FROM departments), b AS (SELECT dept_id FROM employees) SELECT dept_id FROM a UNION SELECT dept_id FROM b;

-- Q447. Use a CTE in a CREATE VIEW statement (CREATE VIEW AS WITH ...).
CREATE OR REPLACE VIEW employee_names AS WITH e AS (SELECT emp_id,CONCAT(first_name,' ',last_name) name FROM employees) SELECT * FROM e;

-- Q448. Write a CTE that adds row numbers to all employees, then self-join the CTE to pair employees with adjacent row numbers.
WITH numbered AS (SELECT emp_id,first_name,ROW_NUMBER() OVER(ORDER BY emp_id) rn FROM employees) SELECT a.emp_id,a.first_name,b.emp_id next_emp_id,b.first_name next_name FROM numbered a LEFT JOIN numbered b ON b.rn=a.rn+1;

-- Q449. Create a CTE to split a comma-separated string into rows using JSON_TABLE or a stored function; then use it in a query.
WITH parts AS (SELECT JSON_TABLE('["SQL","MySQL","Analytics"]', '$[*]' COLUMNS(value VARCHAR(50) PATH '$')) jt) SELECT * FROM parts;

-- Q450. Use CTEs to implement a step-by-step data cleaning pipeline: trim whitespace, standardize dates, remove invalid rows.
WITH trimmed AS (SELECT customer_id,TRIM(first_name) first_name,TRIM(last_name) last_name,TRIM(email) email,TRIM(city) city,signup_date FROM customers), cleaned AS (SELECT * FROM trimmed WHERE customer_id IS NOT NULL AND email<>'' AND signup_date IS NOT NULL) SELECT * FROM cleaned;

-- Q451. Benchmark: take a complex subquery and rewrite it using CTEs; provide both versions (assignment question: "Rewrite the following subquery using a CTE...").
-- Subquery version:
SELECT e.* FROM employees e WHERE salary>(SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id=e.dept_id);
-- CTE version:
WITH dept_avg AS (SELECT dept_id,AVG(salary) avg_salary FROM employees GROUP BY dept_id) SELECT e.* FROM employees e JOIN dept_avg d ON d.dept_id=e.dept_id WHERE e.salary>d.avg_salary;

-- Q452. Write a CTE that uses a window function and is referenced twice in the final query.
WITH numbered AS (SELECT emp_id,first_name,ROW_NUMBER() OVER(ORDER BY emp_id) rn FROM employees) SELECT a.first_name,b.first_name FROM numbered a JOIN numbered b ON b.rn=a.rn+1;

-- Q453. Create a CTE to compute the running total of orders per day.
WITH daily AS (SELECT order_date,COUNT(*) order_count FROM orders GROUP BY order_date) SELECT order_date,order_count,SUM(order_count) OVER(ORDER BY order_date) running_order_count FROM daily;

-- Q454. Use CTE to isolate groups with HAVING and then join back to detail.
WITH dept_totals AS (SELECT dept_id,SUM(salary) total_salary FROM employees GROUP BY dept_id HAVING SUM(salary)>50000) SELECT d.dept_name,t.total_salary FROM dept_totals t JOIN departments d ON d.dept_id=t.dept_id;

-- Q455. Demonstrate how CTEs can improve readability by naming intermediate results.
-- Naming intermediate results such as daily_sales, customer_sales and ranked_products makes a long query easier to read, test and maintain.

-- Q456. Write a CTE that prepares data for a chart (e.g., cohort analysis).
WITH cohort AS (SELECT customer_id,DATE_FORMAT(signup_date,'%Y-%m') cohort_month FROM customers), activity AS (SELECT c.cohort_month,o.customer_id,DATE_FORMAT(o.order_date,'%Y-%m') activity_month FROM cohort c JOIN orders o ON o.customer_id=c.customer_id) SELECT cohort_month,activity_month,COUNT(DISTINCT customer_id) active_customers FROM activity GROUP BY cohort_month,activity_month ORDER BY cohort_month,activity_month;
