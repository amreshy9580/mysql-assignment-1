USE Assignment_1;

-- Aggregate Functions and GROUP BY
-- Questions 51-90

-- Q51. Count the total number of employees.
SELECT COUNT(*) AS employee_count FROM employees;

-- Q52. Find the average salary of all employees.
SELECT AVG(salary) AS average_salary FROM employees;

-- Q53. Calculate the sum of all order total_amount values.
SELECT SUM(total_amount) AS total_sales FROM orders;

-- Q54. Retrieve the minimum and maximum product prices.
SELECT MIN(price) AS min_price, MAX(price) AS max_price FROM products;

-- Q55. Count the number of distinct cities in the customers table.
SELECT COUNT(DISTINCT city) AS city_count FROM customers;

-- Q56. Show the number of employees in each department.
SELECT dept_id, COUNT(*) AS employee_count FROM employees GROUP BY dept_id;

-- Q57. For each department, display the average salary.
SELECT dept_id, AVG(salary) AS average_salary FROM employees GROUP BY dept_id;

-- Q58. Find the total sales (sum of total_amount) per year.
SELECT YEAR(order_date) AS order_year, SUM(total_amount) AS total_sales FROM orders GROUP BY YEAR(order_date);

-- Q59. Retrieve the highest salary in each department, along with the department ID.
SELECT dept_id, MAX(salary) AS highest_salary FROM employees GROUP BY dept_id;

-- Q60. List categories with the total number of products in each.
SELECT category_id, COUNT(*) AS product_count FROM products GROUP BY category_id;

-- Q61. Calculate the average score per course from the enrollments table.
SELECT course_id, AVG(score) AS average_score FROM enrollments GROUP BY course_id;

-- Q62. Show each customer and the total amount they have spent (sum of order totals).
SELECT customer_id, SUM(total_amount) AS total_spent FROM orders GROUP BY customer_id;

-- Q63. Find departments with more than 5 employees.
SELECT dept_id, COUNT(*) AS employee_count FROM employees GROUP BY dept_id HAVING COUNT(*) > 5;

-- Q64. Display products with a stock quantity that is below the average stock quantity.
SELECT * FROM products WHERE stock_quantity < (SELECT AVG(stock_quantity) FROM products);

-- Q65. Count how many orders each customer has placed.
SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id;

-- Q66. For each product category, find the most expensive product price.
SELECT category_id, MAX(price) AS max_price FROM products GROUP BY category_id;

-- Q67. Show the month and total sales for each month of 2023.
SELECT MONTH(order_date) AS month_no, SUM(total_amount) AS total_sales FROM orders WHERE YEAR(order_date) = 2023 GROUP BY MONTH(order_date) ORDER BY month_no;

-- Q68. Retrieve the employee ID and the number of direct reports (where they are the manager).
SELECT manager_id, COUNT(*) AS direct_reports FROM employees WHERE manager_id IS NOT NULL GROUP BY manager_id;

-- Q69. List departments and the number of employees hired after 2021.
SELECT dept_id, COUNT(*) AS recent_hires FROM employees WHERE hire_date >= '2022-01-01' GROUP BY dept_id;

-- Q70. Find courses with at least 10 enrollments.
SELECT course_id, COUNT(*) AS enrollment_count FROM enrollments GROUP BY course_id HAVING COUNT(*) >= 10;

-- Q71. Display the average salary by department, but only for departments where the average is above 60,000.
SELECT dept_id, AVG(salary) AS average_salary FROM employees GROUP BY dept_id HAVING AVG(salary) > 60000;

-- Q72. Show the total quantity sold for each product (from order_items).
SELECT product_id, SUM(quantity) AS units_sold FROM order_items GROUP BY product_id;

-- Q73. Calculate the variance and standard deviation of salaries across the company.
SELECT VARIANCE(salary) AS salary_variance, STDDEV(salary) AS salary_stddev FROM employees;

-- Q74. For each department, find the difference between the highest and lowest salary.
SELECT dept_id, MAX(salary) - MIN(salary) AS salary_range FROM employees GROUP BY dept_id;

-- Q75. List the top 3 customers by total order amount.
SELECT customer_id, SUM(total_amount) AS total_spent FROM orders GROUP BY customer_id ORDER BY total_spent DESC LIMIT 3;

-- Q76. Display the number of orders per status (e.g., 'Pending', 'Shipped', 'Delivered').
SELECT status, COUNT(*) AS order_count FROM orders GROUP BY status;

-- Q77. Show the department ID and the median salary (using PERCENTILE_CONT if MySQL 8+; otherwise suggest using a subquery approach) – Write a query to find the median salary per department (hint: using GROUP BY and window functions).
SELECT dept_id, AVG(salary) AS median_salary FROM (SELECT dept_id, salary, ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary) AS rn, COUNT(*) OVER (PARTITION BY dept_id) AS cnt FROM employees) s WHERE rn IN (FLOOR((cnt + 1)/2), FLOOR((cnt + 2)/2)) GROUP BY dept_id;

-- Q78. Find employees who earn more than the average salary of their own department.
SELECT * FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees d WHERE d.dept_id = e.dept_id);

-- Q79. Count the number of products that have never been ordered (using LEFT JOIN and GROUP BY).
SELECT COUNT(*) AS never_ordered_products FROM products p LEFT JOIN order_items oi ON oi.product_id = p.product_id WHERE oi.product_id IS NULL;

-- Q80. Calculate the running total of sales per month (you may use window function here, but if placed in aggregate section, suggest using variables; for assignment, just ask: "Calculate monthly sales and the cumulative sum across months.").
WITH monthly_sales AS (SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS month_start, SUM(total_amount) AS monthly_sales FROM orders GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')) SELECT month_start, monthly_sales, SUM(monthly_sales) OVER (ORDER BY month_start) AS cumulative_sales FROM monthly_sales ORDER BY month_start;

-- Q81. Show the highest single-day order total for each customer.
SELECT customer_id, order_date, MAX(total_amount) AS highest_daily_order FROM orders GROUP BY customer_id, order_date ORDER BY customer_id, order_date;

-- Q82. Retrieve products that are priced above the average price of their category.
SELECT p.* FROM products p JOIN (SELECT category_id, AVG(price) AS avg_price FROM products GROUP BY category_id) a ON a.category_id = p.category_id WHERE p.price > a.avg_price;

-- Q83. For each city, find the number of customers and the average order amount per customer.
SELECT c.city, COUNT(DISTINCT c.customer_id) AS customer_count, AVG(o.total_amount) AS average_order_amount FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.city;

-- Q84. List the department with the highest total salary expenditure.
SELECT dept_id, SUM(salary) AS total_salary FROM employees GROUP BY dept_id ORDER BY total_salary DESC LIMIT 1;

-- Q85. Display the percentage of employees in each department relative to the total company employees.
SELECT dept_id, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS employee_percentage FROM employees GROUP BY dept_id;

-- Q86. Find the average quantity of items per order.
SELECT AVG(order_quantity) AS average_items_per_order FROM (SELECT order_id, SUM(quantity) AS order_quantity FROM order_items GROUP BY order_id) x;

-- Q87. Show the year of hire and the count of employees hired in that year, only for years with more than 2 hires.
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS hires FROM employees GROUP BY YEAR(hire_date) HAVING COUNT(*) > 2;

-- Q88. Calculate the total revenue generated per product category.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_revenue FROM categories c LEFT JOIN products p ON p.category_id = c.category_id LEFT JOIN order_items oi ON oi.product_id = p.product_id GROUP BY c.category_id, c.category_name;

-- Q89. Retrieve the employee ID and their rank by salary within the company (use window function here if allowed; can be part of aggregate section as challenge). (If strictly aggregates, ask: "Use a derived table to rank employees by salary without window functions.")
SELECT emp_id, first_name, salary, RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM employees;

-- Q90. Find the department(s) with the maximum number of employees.
SELECT dept_id, COUNT(*) AS employee_count FROM employees GROUP BY dept_id ORDER BY employee_count DESC LIMIT 1;
