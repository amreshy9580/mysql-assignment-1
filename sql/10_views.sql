USE Assignment_1;

-- Views
-- Questions 282-301

-- Q282. Create a view that shows employee full name, department name, and salary.
CREATE OR REPLACE VIEW employee_department_salary AS SELECT CONCAT(e.first_name,' ',e.last_name) AS employee_name,d.dept_name,e.salary FROM employees e LEFT JOIN departments d ON d.dept_id=e.dept_id;

-- Q283. Create a view high_earners that includes employees with salary > 100,000.
CREATE OR REPLACE VIEW high_earners AS SELECT * FROM employees WHERE salary>100000;

-- Q284. Write a view that aggregates total sales per customer.
CREATE OR REPLACE VIEW customer_sales AS SELECT customer_id,SUM(total_amount) AS total_sales FROM orders GROUP BY customer_id;

-- Q285. Create a view with check option to ensure inserted rows meet a condition.
CREATE OR REPLACE VIEW active_orders AS SELECT order_id,customer_id,order_date,total_amount,status FROM orders WHERE status='Active' WITH CHECK OPTION;

-- Q286. Alter an existing view to add a new column.
CREATE OR REPLACE VIEW employee_department_salary AS SELECT CONCAT(e.first_name,' ',e.last_name) AS employee_name,d.dept_name,e.salary,e.hire_date FROM employees e LEFT JOIN departments d ON d.dept_id=e.dept_id;

-- Q287. Drop a view.
DROP VIEW IF EXISTS employee_department_salary;

-- Q288. Show the definition of a view (SHOW CREATE VIEW).
SHOW CREATE VIEW employee_department_salary;

-- Q289. Use a view to simplify a complex join of orders, customers, and order_items.
CREATE OR REPLACE VIEW order_details AS SELECT o.order_id,CONCAT(c.first_name,' ',c.last_name) AS customer_name,p.product_name,oi.quantity,oi.unit_price FROM orders o JOIN customers c ON c.customer_id=o.customer_id JOIN order_items oi ON oi.order_id=o.order_id JOIN products p ON p.product_id=oi.product_id;

-- Q290. Query a view that includes a window function (e.g., rank employees by salary).
CREATE OR REPLACE VIEW employee_salary_rank AS SELECT emp_id,first_name,salary,RANK() OVER(ORDER BY salary DESC) AS salary_rank FROM employees;

-- Q291. Insert data through a view into a base table (updatable view conditions).
-- A simple single-table view can be updatable: CREATE VIEW customer_names AS SELECT customer_id,first_name,last_name FROM customers;
INSERT INTO customer_names(customer_id,first_name,last_name) VALUES(11,'Nina','Shah');

-- Q292. Discuss when a view is not updatable and provide an example of a non-updatable view.
-- A view containing GROUP BY/aggregate is generally not updatable. Example: CREATE VIEW customer_sales AS SELECT customer_id,SUM(total_amount) total_sales FROM orders GROUP BY customer_id;

-- Q293. Create a view that uses a UNION.
CREATE OR REPLACE VIEW employee_customer_names AS SELECT first_name,last_name,'Employee' AS source FROM employees UNION ALL SELECT first_name,last_name,'Customer' FROM customers;

-- Q294. Use a view to restrict access to sensitive columns (e.g., hide salary from some users).
CREATE OR REPLACE VIEW employee_public AS SELECT emp_id,first_name,last_name,email,dept_id FROM employees;

-- Q295. Create a materialized view (simulate using a table and periodic refresh).
-- MySQL has no native materialized view. Simulate one with a table: CREATE TABLE customer_sales_mv AS SELECT customer_id,SUM(total_amount) total_sales FROM orders GROUP BY customer_id;

-- Q296. Write a view that calculates the running total of sales per day.
CREATE OR REPLACE VIEW daily_sales_running AS WITH daily AS (SELECT order_date,SUM(total_amount) total_sales FROM orders GROUP BY order_date) SELECT order_date,total_sales,SUM(total_sales) OVER(ORDER BY order_date) running_total FROM daily;

-- Q297. Use WITH LOCAL CHECK OPTION in a view hierarchy.
CREATE OR REPLACE VIEW active_sales AS SELECT * FROM orders WHERE status='Active' WITH LOCAL CHECK OPTION;

-- Q298. Create a view that shows top N products by sales, where N is a parameter (parameterized view using a function or session variable).
-- Views cannot accept parameters. Use a stored procedure for parameterized top-N reports.
SELECT * FROM (SELECT product_id,SUM(quantity*unit_price) sales FROM order_items GROUP BY product_id) s ORDER BY sales DESC LIMIT 5;

-- Q299. List all views in the current database from INFORMATION_SCHEMA.
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA=DATABASE();

-- Q300. Create a recursive view (MySQL doesn't support recursive views directly; assignment: "Discuss how to simulate a recursive view using a CTE in a stored procedure.").
-- MySQL does not support recursive views directly. Use a recursive CTE inside a stored procedure/query when the hierarchy is needed.

-- Q301. Test if a view exists before creating it (CREATE OR REPLACE VIEW).
CREATE OR REPLACE VIEW active_employees AS SELECT * FROM employees WHERE salary>0;
