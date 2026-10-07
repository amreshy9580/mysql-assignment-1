USE Assignment_1;

-- Data Modification (DML)
-- Questions 212-241

-- Q212. Insert a new employee into the employees table with specified values.
INSERT INTO employees (emp_id,first_name,last_name,email,hire_date,salary,dept_id,manager_id) VALUES (111,'Daniel','Clark','daniel.clark@email.com','2024-02-15',58000,2,102);

-- Q213. Insert multiple rows into the products table in a single statement.
INSERT INTO products (product_id,product_name,category_id,price,stock_quantity) VALUES (11,'Wireless Mouse',1,35,85),(12,'Bluetooth Speaker',1,120,45),(13,'Jeans',2,45.50,90);

-- Q214. Update the salary of all employees in department 3 by 10%.
UPDATE employees SET salary=salary*1.10 WHERE dept_id=3;

-- Q215. Delete all orders placed before 2020.
DELETE FROM orders WHERE order_date<'2020-01-01';

-- Q216. Use INSERT ... SELECT to copy customers from a temporary table into the main customers table.
-- customer_temp is not in the supplied schema.
INSERT INTO customers SELECT * FROM customer_temp;

-- Q217. Update the stock quantity of a product by subtracting the quantity ordered from a specific order.
UPDATE products p JOIN (SELECT product_id,SUM(quantity) AS ordered_qty FROM order_items WHERE order_id=1001 GROUP BY product_id) x ON x.product_id=p.product_id SET p.stock_quantity=p.stock_quantity-x.ordered_qty;

-- Q218. Set the manager_id of an employee to NULL when they become top-level.
UPDATE employees SET manager_id=NULL WHERE emp_id=102;

-- Q219. Delete customers who haven't placed any orders (using a subquery or join).
DELETE FROM customers WHERE NOT EXISTS (SELECT 1 FROM orders WHERE orders.customer_id=customers.customer_id);

-- Q220. Insert into a table only if a record with the same unique key doesn't exist (INSERT IGNORE or ON DUPLICATE KEY UPDATE).
INSERT INTO employees (emp_id,dept_id,manager_id,first_name,last_name,email,hire_date,salary) VALUES (110,2,102,'Manial','Spark','maniel.spaark@email.com','2024-02-15',68000) ON DUPLICATE KEY UPDATE first_name=VALUES(first_name),last_name=VALUES(last_name),email=VALUES(email),salary=VALUES(salary);

-- Q221. Use ON DUPLICATE KEY UPDATE to increment a counter in a daily_sales_summary table.
-- daily_sales_summary is not part of the supplied schema.
INSERT INTO daily_sales_summary (sale_date,order_count) VALUES (CURDATE(),1) ON DUPLICATE KEY UPDATE order_count=order_count+1;

-- Q222. Update multiple columns in the employees table (e.g., salary and department) based on a condition.
UPDATE employees SET salary=50000, dept_id=3 WHERE emp_id=111;

-- Q223. Delete all records from a log table older than 30 days.
-- log_table is not part of the supplied schema.
DELETE FROM log_table WHERE created_at < NOW()-INTERVAL 30 DAY;

-- Q224. Insert a new order and related order_items using a transaction (explain transaction steps).
START TRANSACTION;
INSERT INTO orders(order_id,customer_id,order_date,total_amount,status) VALUES (1011,5,CURDATE(),975,'Pending');
INSERT INTO order_items(order_item_id,order_id,product_id,quantity,unit_price) VALUES (11,1011,1,1,950),(12,1011,6,1,25);
COMMIT;

-- Q225. Update the price of all products in a category by multiplying by 1.05, then log the changes in a price_change_log table (use a trigger or manual? For DML, just do update and then insert into log using a subquery).
-- price_change_log is not part of the supplied schema. Update the products first, then insert the old/new values into the log table when available.

-- Q226. Write a DELETE statement that removes duplicate rows from a table based on a subset of columns, keeping the one with the lowest ID.
DELETE e1 FROM employees e1 JOIN employees e2 ON e1.first_name=e2.first_name AND e1.last_name=e2.last_name AND e1.emp_id>e2.emp_id;

-- Q227. Replace (REPLACE INTO) an employee record entirely based on emp_id.
REPLACE INTO employees(emp_id,dept_id,manager_id,first_name,last_name,email,hire_date,salary) VALUES (110,4,103,'Sanial','Spark','maniel.spaark@email.com','2024-02-15',68000);

-- Q228. Use an UPDATE with a JOIN to set the department name in a denormalized column for reporting.
ALTER TABLE employees ADD COLUMN dept_name VARCHAR(50);
UPDATE employees e JOIN departments d ON d.dept_id=e.dept_id SET e.dept_name=d.dept_name;

-- Q229. Insert 100 random rows into a test_numbers table using a recursive CTE or INSERT ... SELECT with a series generator.
CREATE TABLE test_numbers(id INT PRIMARY KEY, random_number INT);
INSERT INTO test_numbers(id,random_number) WITH RECURSIVE n AS (SELECT 1 UNION ALL SELECT n+1 FROM n WHERE n<100) SELECT n,FLOOR(1+RAND()*1000) FROM n;

-- Q230. Update the total_amount of an order by summing its order_items' quantity*unit_price.
UPDATE orders o SET total_amount=(SELECT COALESCE(SUM(quantity*unit_price),0) FROM order_items oi WHERE oi.order_id=o.order_id);

-- Q231. Perform a bulk update by setting the status to 'Archived' for all orders older than 5 years.
UPDATE orders SET status='Archived' WHERE order_date < DATE_SUB(CURDATE(),INTERVAL 5 YEAR);

-- Q232. Use a correlated update to set the manager's salary by adding a bonus column from a managers table.
-- Requires a managers table containing manager_id and bonus.
UPDATE employees e JOIN managers m ON m.manager_id=e.manager_id SET e.salary=e.salary+m.bonus;

-- Q233. Delete from a table where a foreign key constraint might fail; use queries to delete child rows first.
START TRANSACTION;
DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE customer_id=5);
DELETE FROM orders WHERE customer_id=5;
DELETE FROM customers WHERE customer_id=5;
COMMIT;

-- Q234. Insert a new product and automatically set its creation timestamp using DEFAULT.
ALTER TABLE products ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
INSERT INTO products(product_id,product_name,category_id,price,stock_quantity) VALUES (25,'Keyboard',1,45,30);

-- Q235. Write a multi-table DELETE to remove customers and their related orders when the customer is deleted.
DELETE oi FROM order_items oi JOIN orders o ON o.order_id=oi.order_id WHERE o.customer_id=5;
DELETE FROM orders WHERE customer_id=5;
DELETE FROM customers WHERE customer_id=5;

-- Q236. Use INSERT INTO ... VALUES with a subquery that returns a single computed value.
CREATE TABLE summary_table(id INT PRIMARY KEY,total DECIMAL(12,2));
INSERT INTO summary_table(id,total) VALUES (1,(SELECT COALESCE(SUM(quantity*unit_price),0) FROM order_items));

-- Q237. Update employee emails to a new format: firstname.lastname@newcompany.com.
UPDATE employees SET email=LOWER(CONCAT(first_name,'.',last_name,'@newcompany.com'));

-- Q238. Delete all rows from a table and reset auto-increment (TRUNCATE).
TRUNCATE TABLE test_numbers;

-- Q239. Simulate an upsert operation by attempting to update, and if no row affected, then insert (use a stored procedure or conditional logic; for DML, just mention technique).
DELIMITER $$
CREATE PROCEDURE upsert_product()
BEGIN
  UPDATE products SET price=799 WHERE product_id=101;
  IF ROW_COUNT()=0 THEN
    INSERT INTO products(product_id,product_name,category_id,price,stock_quantity) VALUES (101,'Wireless Mouse',1,799,0);
  END IF;
END$$
DELIMITER ;

-- Q240. Copy selected columns from one table to a new table (CREATE TABLE ... AS SELECT).
CREATE TABLE temp_employee AS SELECT first_name,last_name FROM employees;

-- Q241. Set the salary of the lowest-paid employee in each department to the department's average salary.
UPDATE employees e JOIN (SELECT dept_id,AVG(salary) AS avg_salary FROM employees GROUP BY dept_id) a ON a.dept_id=e.dept_id JOIN (SELECT dept_id,MIN(salary) AS min_salary FROM employees GROUP BY dept_id) m ON m.dept_id=e.dept_id SET e.salary=a.avg_salary WHERE e.salary=m.min_salary;
