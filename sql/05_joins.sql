USE Assignment_1;

-- Joins
-- Questions 91-140

-- Q91. Write an INNER JOIN query to list employees with their department names.
SELECT e.emp_id, e.first_name, e.last_name, d.dept_name FROM employees e INNER JOIN departments d ON d.dept_id = e.dept_id;

-- Q92. Show all employees and their department names, including employees without a department.
SELECT e.*, d.dept_name FROM employees e LEFT JOIN departments d ON d.dept_id = e.dept_id;

-- Q93. Display all departments, even those with no employees.
SELECT d.*, e.emp_id, e.first_name FROM departments d LEFT JOIN employees e ON e.dept_id = d.dept_id;

-- Q94. Perform a CROSS JOIN between a small table of letters ('A','B','C') and numbers (1,2,3) to generate all combinations.
SELECT l.letter, n.number FROM (SELECT 'A' AS letter UNION ALL SELECT 'B' UNION ALL SELECT 'C') l CROSS JOIN (SELECT 1 AS number UNION ALL SELECT 2 UNION ALL SELECT 3) n ORDER BY l.letter, n.number;

-- Q95. List product names and their category names.
SELECT p.product_name, c.category_name FROM products p JOIN categories c ON c.category_id = p.category_id;

-- Q96. Retrieve all orders with customer full name, city, and order date.
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.city, o.order_date FROM orders o JOIN customers c ON c.customer_id = o.customer_id;

-- Q97. Show order items along with the product name and the order ID.
SELECT oi.order_id, oi.order_item_id, p.product_name, oi.quantity, oi.unit_price FROM order_items oi JOIN products p ON p.product_id = oi.product_id;

-- Q98. Find all employees and their managers (self-join on manager_id).
SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, CONCAT(m.first_name, ' ', m.last_name) AS manager_name FROM employees e LEFT JOIN employees m ON m.emp_id = e.manager_id;

-- Q99. List pairs of employees who work in the same department (exclude pairing an employee with themselves).
SELECT e1.emp_id AS employee_1, e2.emp_id AS employee_2, e1.dept_id FROM employees e1 JOIN employees e2 ON e2.dept_id = e1.dept_id AND e1.emp_id < e2.emp_id;

-- Q100. Display customers who have never placed an order.
SELECT c.* FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id WHERE o.order_id IS NULL;

-- Q101. Show products that have never been ordered.
SELECT p.* FROM products p LEFT JOIN order_items oi ON oi.product_id = p.product_id WHERE oi.product_id IS NULL;

-- Q102. For each employee, display their name and the name of their manager; if no manager, show 'Top Manager'.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name, COALESCE(CONCAT(m.first_name, ' ', m.last_name), 'Top Manager') AS manager_name FROM employees e LEFT JOIN employees m ON m.emp_id = e.manager_id;

-- Q103. List all students and the courses they are enrolled in, including students with no enrollments.
SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name FROM students s LEFT JOIN enrollments e ON e.student_id = s.student_id LEFT JOIN courses c ON c.course_id = e.course_id;

-- Q104. Retrieve courses and the number of enrolled students, even courses with zero students (use LEFT JOIN and GROUP BY).
SELECT c.course_id, c.course_name, COUNT(e.student_id) AS enrolled_students FROM courses c LEFT JOIN enrollments e ON e.course_id = c.course_id GROUP BY c.course_id, c.course_name;

-- Q105. Find all possible combinations of colors ('Red','Green','Blue') and sizes ('S','M','L') using CROSS JOIN.
SELECT colors.color, sizes.size FROM (SELECT 'Red' AS color UNION ALL SELECT 'Green' UNION ALL SELECT 'Blue') colors CROSS JOIN (SELECT 'S' AS size UNION ALL SELECT 'M' UNION ALL SELECT 'L') sizes;

-- Q106. Write a query to join three tables: orders, order_items, and products, to show order ID, product name, and quantity.
SELECT o.order_id, p.product_name, oi.quantity FROM orders o JOIN order_items oi ON oi.order_id = o.order_id JOIN products p ON p.product_id = oi.product_id;

-- Q107. Retrieve the names of employees who work in the same department as 'John Doe'.
SELECT e2.* FROM employees e1 JOIN employees e2 ON e2.dept_id = e1.dept_id WHERE e1.first_name = 'John' AND e1.last_name = 'Doe' AND e2.emp_id <> e1.emp_id;

-- Q108. List employees who earn more than their manager.
SELECT e.emp_id, e.first_name, e.salary, m.salary AS manager_salary FROM employees e JOIN employees m ON m.emp_id = e.manager_id WHERE e.salary > m.salary;

-- Q109. Show all orders placed by customers from 'California', along with the order total.
SELECT o.*, CONCAT(c.first_name, ' ', c.last_name) AS customer_name FROM orders o JOIN customers c ON c.customer_id = o.customer_id WHERE c.state = 'California';

-- Q110. Display the top 5 products by total sales amount (using joins and aggregation).
SELECT p.product_id, p.product_name, SUM(oi.quantity * oi.unit_price) AS total_sales FROM products p JOIN order_items oi ON oi.product_id = p.product_id GROUP BY p.product_id, p.product_name ORDER BY total_sales DESC LIMIT 5;

-- Q111. Find employees who have the same hire date as another employee (self-join, different emp_id).
SELECT e1.emp_id AS employee_1, e2.emp_id AS employee_2, e1.hire_date FROM employees e1 JOIN employees e2 ON e1.hire_date = e2.hire_date AND e1.emp_id < e2.emp_id;

-- Q112. List the manager names and the count of employees reporting to them (zero if none).
SELECT m.emp_id, CONCAT(m.first_name, ' ', m.last_name) AS manager_name, COUNT(e.emp_id) AS direct_reports FROM employees m LEFT JOIN employees e ON e.manager_id = m.emp_id GROUP BY m.emp_id, m.first_name, m.last_name;

-- Q113. Show a full outer join simulation (LEFT JOIN UNION RIGHT JOIN) between two small tables.
-- MySQL has no FULL OUTER JOIN. This pattern simulates it.
SELECT a.*, b.* FROM table_a a LEFT JOIN table_b b ON b.id = a.id
UNION ALL
SELECT a.*, b.* FROM table_a a RIGHT JOIN table_b b ON b.id = a.id WHERE a.id IS NULL;
-- Replace table_a/table_b with the two tables used in the exercise.

-- Q114. Retrieve all employees and their department location.
SELECT e.emp_id, e.first_name, d.location FROM employees e JOIN departments d ON d.dept_id = e.dept_id;

-- Q115. Display products and their category, but only categories that have at least 1 product (INNER JOIN).
SELECT p.product_name, c.category_name FROM products p INNER JOIN categories c ON c.category_id = p.category_id;

-- Q116. Use a NATURAL JOIN (if applicable) to join employees and departments on dept_id.
SELECT * FROM employees NATURAL JOIN departments;

-- Q117. Join the orders table with a subquery that computes the average order amount per customer, and show orders above that average.
SELECT o.* FROM orders o JOIN (SELECT customer_id, AVG(total_amount) AS avg_order FROM orders GROUP BY customer_id) a ON a.customer_id = o.customer_id WHERE o.total_amount > a.avg_order;

-- Q118. List customers and their most recent order date (using LEFT JOIN with a subquery).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, MAX(o.order_date) AS latest_order_date FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q119. Find all employees who do not manage anyone (their emp_id not in manager_id list) using LEFT JOIN.
SELECT e.emp_id, e.first_name, e.last_name FROM employees e LEFT JOIN employees r ON r.manager_id = e.emp_id WHERE r.emp_id IS NULL;

-- Q120. For each product, show the name and the total number of units sold, using a join with order_items.
SELECT p.product_id, p.product_name, COALESCE(SUM(oi.quantity), 0) AS units_sold FROM products p LEFT JOIN order_items oi ON oi.product_id = p.product_id GROUP BY p.product_id, p.product_name;

-- Q121. Retrieve employees whose manager is in a different department.
SELECT e.emp_id, e.first_name, e.dept_id, m.emp_id AS manager_id, m.dept_id AS manager_dept_id FROM employees e JOIN employees m ON m.emp_id = e.manager_id WHERE e.dept_id <> m.dept_id;

-- Q122. Show a matrix of employee-manager relationships using a self-join.
SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, m.emp_id AS manager_id, CONCAT(m.first_name, ' ', m.last_name) AS manager_name FROM employees e LEFT JOIN employees m ON m.emp_id = e.manager_id;

-- Q123. List all orders, the customer name, and the sum of item quantities per order.
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(oi.quantity) AS total_item_quantity FROM orders o JOIN customers c ON c.customer_id = o.customer_id LEFT JOIN order_items oi ON oi.order_id = o.order_id GROUP BY o.order_id, c.first_name, c.last_name;

-- Q124. Find customers who placed orders in all months of 2023 (harder: join with month series).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name FROM customers c JOIN orders o ON o.customer_id = c.customer_id WHERE YEAR(o.order_date) = 2023 GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT MONTH(o.order_date)) = 12;

-- Q125. Write a query to join the employees table with itself to find pairs of employees hired within 30 days of each other.
SELECT e1.emp_id AS employee_1, e2.emp_id AS employee_2, e1.hire_date AS hire_date_1, e2.hire_date AS hire_date_2 FROM employees e1 JOIN employees e2 ON e1.emp_id < e2.emp_id WHERE ABS(DATEDIFF(e1.hire_date, e2.hire_date)) <= 30;

-- Q126. Display products that belong to categories that have more than 10 products.
SELECT p.* FROM products p JOIN (SELECT category_id FROM products GROUP BY category_id HAVING COUNT(*) > 10) c ON c.category_id = p.category_id;

-- Q127. Show the cartesian product of a set of priorities ('High','Medium','Low') and a set of statuses ('Open','Closed') using CROSS JOIN, and assign a dummy ID.
SELECT p.priority, s.status, ROW_NUMBER() OVER (ORDER BY p.priority, s.status) AS dummy_id FROM (SELECT 'High' priority UNION ALL SELECT 'Medium' UNION ALL SELECT 'Low') p CROSS JOIN (SELECT 'Open' status UNION ALL SELECT 'Closed') s;

-- Q128. Join employees with departments using USING clause.
SELECT e.*, d.dept_name, d.location FROM employees e JOIN departments d USING (dept_id);

-- Q129. Retrieve employees along with the number of orders they have processed (if there's a salesperson_id in orders, assume it links to employees).
-- The supplied schema does not contain salesperson_id in orders, so this cannot be executed as written.
-- If orders.salesperson_id references employees.emp_id:
SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, COUNT(o.order_id) AS orders_processed FROM employees e LEFT JOIN orders o ON o.salesperson_id = e.emp_id GROUP BY e.emp_id, e.first_name, e.last_name;

-- Q130. Use a LEFT JOIN to find customers with no orders and their signup date.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.signup_date FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id WHERE o.order_id IS NULL;

-- Q131. List all possible supervisor-subordinate pairs from a flat table that only has emp_id and supervisor_id (recursive structure handled later; for now just direct).
SELECT e.emp_id AS employee_id, m.emp_id AS supervisor_id FROM employees e JOIN employees m ON m.emp_id = e.manager_id;

-- Q132. Find products whose price is higher than the average price of products in the same category (using a join with derived table).
SELECT p.product_id, p.product_name, p.price FROM products p JOIN (SELECT category_id, AVG(price) AS avg_price FROM products GROUP BY category_id) a ON a.category_id = p.category_id WHERE p.price > a.avg_price;

-- Q133. Show each order and the running count of items in that order (join order_items and use row numbering later; here just join).
SELECT o.order_id, oi.order_item_id, oi.product_id, oi.quantity, ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY oi.order_item_id) AS item_number FROM orders o JOIN order_items oi ON oi.order_id = o.order_id;

-- Q134. Demonstrate a join with an ON clause that includes multiple conditions (e.g., not only key match but also date range).
SELECT o.order_id, c.customer_id, o.order_date, o.total_amount FROM orders o JOIN customers c ON c.customer_id = o.customer_id AND o.order_date >= c.signup_date;

-- Q135. Join employees table with a static range table (e.g., salary brackets) to categorize each employee.
SELECT e.emp_id, e.first_name, e.salary, b.bracket FROM employees e JOIN (SELECT 'Low' bracket, 0 min_salary, 49999.99 max_salary UNION ALL SELECT 'Medium', 50000, 69999.99 UNION ALL SELECT 'High', 70000, 99999999) b ON e.salary BETWEEN b.min_salary AND b.max_salary;

-- Q136. Write a query that joins a table to itself twice (e.g., employee -> manager -> senior manager).
SELECT e.emp_id AS employee_id, m.emp_id AS manager_id, sm.emp_id AS senior_manager_id FROM employees e LEFT JOIN employees m ON m.emp_id = e.manager_id LEFT JOIN employees sm ON sm.emp_id = m.manager_id;

-- Q137. Retrieve customers and their latest order details (customer name, order ID, order date) using a join with a subquery that finds max order date per customer.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id, o.order_date FROM customers c JOIN orders o ON o.customer_id = c.customer_id JOIN (SELECT customer_id, MAX(order_date) AS max_order_date FROM orders GROUP BY customer_id) x ON x.customer_id = o.customer_id AND x.max_order_date = o.order_date;

-- Q138. List employees and whether they are a manager or not (flag) using LEFT JOIN and CASE.
SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, CASE WHEN m.emp_id IS NULL THEN 'No' ELSE 'Yes' END AS is_manager FROM employees e LEFT JOIN (SELECT DISTINCT manager_id AS emp_id FROM employees WHERE manager_id IS NOT NULL) m ON m.emp_id = e.emp_id;

-- Q139. Show order items with product name and also the category name (three-table join).
SELECT oi.order_item_id, p.product_name, c.category_name, oi.quantity, oi.unit_price FROM order_items oi JOIN products p ON p.product_id = oi.product_id JOIN categories c ON c.category_id = p.category_id;

-- Q140. Display employees and the total revenue they generated (if salesperson), also include those with no sales.
-- The supplied orders schema has no salesperson_id column. If that column is added, join orders.salesperson_id to employees.emp_id and aggregate total_amount by employee.
