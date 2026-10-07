USE Assignment_1;

-- Set Operations
-- Questions 181-211

-- Q181. (Mysql supports UNION, UNION ALL; INTERSECT and EXCEPT can be simulated. Questions will use UNION, UNION ALL, and simulate INTERSECT/MINUS.)
-- MySQL 8.0.31+ supports INTERSECT/EXCEPT. For older versions, use JOIN/EXISTS/NOT EXISTS as shown in the later questions.

-- Q182. Combine the list of customer cities and employee cities into a single distinct list.
SELECT city FROM customers UNION SELECT d.location FROM departments d;

-- Q183. Union two queries that select product names from different categories (e.g., 'Electronics' and 'Books') and show all.
SELECT p.product_name FROM products p JOIN categories c ON c.category_id=p.category_id WHERE c.category_name='Electronics' UNION SELECT p.product_name FROM products p JOIN categories c ON c.category_id=p.category_id WHERE c.category_name='Books';

-- Q184. Merge the first and last names of employees and customers into one column of names (union all).
SELECT CONCAT(first_name,' ',last_name) AS full_name FROM employees UNION ALL SELECT CONCAT(first_name,' ',last_name) FROM customers;

-- Q185. Use UNION ALL to combine order IDs from orders in 2022 and 2023 and keep duplicates.
SELECT order_id FROM orders WHERE YEAR(order_date)=2022 UNION ALL SELECT order_id FROM orders WHERE YEAR(order_date)=2023;

-- Q186. Find employees who are also customers (same email) – use INTERSECT simulation (INNER JOIN or EXISTS).
SELECT e.* FROM employees e WHERE EXISTS (SELECT 1 FROM customers c WHERE c.email=e.email);

-- Q187. Retrieve products that are in category 1 but not in category 2 (simulate EXCEPT with NOT IN).
SELECT p.* FROM products p WHERE p.category_id=1 AND p.product_id NOT IN (SELECT product_id FROM products WHERE category_id=2);

-- Q188. Show the distinct combination of department ID and location from both departments and a legacy_departments table (UNION).
SELECT dept_id, location FROM departments UNION SELECT dept_id, location FROM legacy_departments; -- legacy_departments is not in the supplied schema.

-- Q189. Combine the top 5 expensive products and top 5 cheapest products into a single result set (UNION).
(SELECT * FROM products ORDER BY price DESC LIMIT 5) UNION (SELECT * FROM products ORDER BY price ASC LIMIT 5);

-- Q190. Write a query to mimic INTERSECT between two sets: employees in department 1 and employees earning >
SELECT * FROM employees WHERE dept_id=1 AND salary>70000;

-- Q191. Question text from assignment not extracted.
-- The supplied schema has no returns table. Use NOT EXISTS against returns when that table is available.

-- Q192. Union two queries that count employees and customers by city, showing city and a type indicator.
SELECT d.location AS city, COUNT(e.emp_id) AS people_count, 'Employee' AS source FROM departments d LEFT JOIN employees e ON e.dept_id=d.dept_id GROUP BY d.location UNION ALL SELECT city, COUNT(*), 'Customer' FROM customers GROUP BY city;

-- Q193. Use UNION to create a report that shows 'Employee' as source, emp_id as ID, name for employees, and similarly 'Customer' for customers.
SELECT emp_id AS id, CONCAT(first_name,' ',last_name) AS name, 'Employee' AS source FROM employees UNION ALL SELECT customer_id, CONCAT(first_name,' ',last_name), 'Customer' FROM customers;

-- Q194. Find products that are either out of stock (quantity=0) or have never been ordered (using UNION of two distinct sets).
SELECT product_id, product_name FROM products WHERE stock_quantity=0 UNION SELECT p.product_id,p.product_name FROM products p WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id=p.product_id);

-- Q195. Show all distinct email domains from employees and customers (UNION).
SELECT SUBSTRING_INDEX(email,'@',-1) AS email_domain FROM employees UNION SELECT SUBSTRING_INDEX(email,'@',-1) FROM customers;

-- Q196. Combine the results of three queries: active orders, pending orders, cancelled orders into one list with status column.
SELECT order_id,status FROM orders WHERE status='Shipped' UNION ALL SELECT order_id,status FROM orders WHERE status='Pending' UNION ALL SELECT order_id,status FROM orders WHERE status='Cancelled';

-- Q197. Demonstrate UNION with ordering: select top 5 employees by salary and top 5 by hire_date, sorted globally by name.
(SELECT emp_id, CONCAT(first_name,' ',last_name) AS name, salary, hire_date FROM employees ORDER BY salary DESC LIMIT 5) UNION ALL (SELECT emp_id, CONCAT(first_name,' ',last_name), salary, hire_date FROM employees ORDER BY hire_date DESC LIMIT 5) ORDER BY name;

-- Q198. Retrieve IDs that exist in both a temp_table and products table (INTERSECT using IN).
-- temp_table is not part of the supplied schema. Example: SELECT p.id FROM products p JOIN temp_table t ON t.id=p.product_id;

-- Q199. Find customer IDs that are in the customers table but not in the blacklist table (EXCEPT using NOT IN).
-- blacklist is not part of the supplied schema. Example: SELECT c.customer_id FROM customers c WHERE NOT EXISTS (SELECT 1 FROM blacklist b WHERE b.customer_id=c.customer_id);

-- Q200. Merge the results of monthly sales for 2022 and 2023 into a single dataset for comparison (UNION ALL with year column).
SELECT YEAR(order_date) AS sales_year, MONTH(order_date) AS sales_month, SUM(total_amount) AS sales FROM orders WHERE YEAR(order_date) IN (2022,2023) GROUP BY YEAR(order_date),MONTH(order_date);

-- Q201. Create a full list of all dates from an orders table and a returns table (UNION of order_date and return_date).
-- returns table is not part of the supplied schema. Example: SELECT order_date AS activity_date FROM orders UNION SELECT return_date FROM returns;

-- Q202. Simulate EXCEPT using LEFT JOIN IS NULL: get employees who are not managers.
SELECT e.* FROM employees e LEFT JOIN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL) m ON m.manager_id=e.emp_id WHERE m.manager_id IS NULL;

-- Q203. Union three different product lines (by category) and add a constant column indicating the line.
SELECT product_name, category_id, 'Line 1' AS line FROM products WHERE category_id=1 UNION ALL SELECT product_name, category_id, 'Line 2' FROM products WHERE category_id=2 UNION ALL SELECT product_name, category_id, 'Line 3' FROM products WHERE category_id=3;

-- Q204. Show the union of all first names from employees and customers, but with a count of occurrences (group after UNION ALL).
SELECT first_name, COUNT(*) AS occurrences FROM (SELECT first_name FROM employees UNION ALL SELECT first_name FROM customers) x GROUP BY first_name ORDER BY occurrences DESC, first_name;

-- Q205. Use UNION to consolidate multiple tables with similar structure (e.g., sales2019, sales2020) into one result.
-- The supplied schema has only orders/order_items. If sales2019 and sales2020 exist, use SELECT ... FROM sales2019 UNION ALL SELECT ... FROM sales2020.

-- Q206. Retrieve a list of IDs that are in table A or table B but not both (symmetric difference) using UNION of EXCEPTs.
SELECT customer_id AS id FROM customers WHERE customer_id NOT IN (SELECT customer_id FROM orders) UNION SELECT customer_id FROM orders WHERE customer_id NOT IN (SELECT customer_id FROM customers);

-- Q207. Find products that have had a price increase and also a price decrease (from a price_changes table) using UNION of two conditions.
-- price_changes is not part of the supplied schema. Example: SELECT product_id FROM price_changes WHERE change_type='increase' UNION SELECT product_id FROM price_changes WHERE change_type='decrease';

-- Q208. Create a query that uses UNION to generate a sequence of numbers 1...10.
WITH RECURSIVE numbers AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM numbers WHERE n<10) SELECT n FROM numbers;

-- Q209. Combine employee names with a literal 'No Manager' row as a UNION.
SELECT CONCAT(first_name,' ',last_name) AS name FROM employees UNION SELECT 'No Manager';

-- Q210. List all order statuses from orders and also from archived_orders, with duplicates removed.
SELECT status FROM orders UNION SELECT status FROM archived_orders; -- archived_orders is not in the supplied schema.

-- Q211. Show distinct product_id values that appear either in order_items or in wishlist_items using UNION.
SELECT product_id FROM order_items UNION SELECT product_id FROM wishlist_items; -- wishlist_items is not in the supplied schema.
