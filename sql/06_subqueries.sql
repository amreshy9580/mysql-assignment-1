USE Assignment_1;

-- Subqueries
-- Questions 141-180

-- Q141. Find employees whose salary is greater than the overall average salary.
SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q142. Select the names of employees who work in the 'Sales' department (subquery to get dept_id).
SELECT * FROM employees WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Sales');

-- Q143. Retrieve products that have a price equal to the maximum price in the products table.
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);

-- Q144. List the employee with the highest salary in each department using a correlated subquery.
SELECT e.* FROM employees e WHERE salary = (SELECT MAX(e2.salary) FROM employees e2 WHERE e2.dept_id = e.dept_id);

-- Q145. Find customers who have placed orders with a total amount greater than 500 (using EXISTS).
SELECT c.* FROM customers c WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id AND o.total_amount > 500);

-- Q146. Show departments that have no employees (NOT EXISTS).
SELECT d.* FROM departments d WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);

-- Q147. Display employees who earn more than the average salary of any department (use > ANY).
SELECT * FROM employees WHERE salary > ANY (SELECT AVG(salary) FROM employees GROUP BY dept_id);

-- Q148. Retrieve products that are more expensive than all products in category 1 (use > ALL).
SELECT * FROM products WHERE price > ALL (SELECT price FROM products WHERE category_id = 1);

-- Q149. Find employees whose manager's salary is less than theirs (correlated subquery).
SELECT e.* FROM employees e WHERE e.manager_id IS NOT NULL AND e.salary > (SELECT m.salary FROM employees m WHERE m.emp_id = e.manager_id);

-- Q150. List the top 5 most recent orders per customer using a subquery.
SELECT o.* FROM orders o WHERE (SELECT COUNT(*) FROM orders newer WHERE newer.customer_id = o.customer_id AND newer.order_date > o.order_date) < 5 ORDER BY customer_id, order_date DESC;

-- Q151. Use a scalar subquery to display each employee's salary and the overall average salary in the same result set.
SELECT emp_id, salary, (SELECT AVG(salary) FROM employees) AS company_average_salary FROM employees;

-- Q152. Show products whose stock quantity is below the average stock quantity of their category.
SELECT p.* FROM products p WHERE p.stock_quantity < (SELECT AVG(p2.stock_quantity) FROM products p2 WHERE p2.category_id = p.category_id);

-- Q153. Retrieve orders where the total_amount is greater than the customer's average order amount.
SELECT o.* FROM orders o WHERE o.total_amount > (SELECT AVG(o2.total_amount) FROM orders o2 WHERE o2.customer_id = o.customer_id);

-- Q154. Find the department with the highest total salary (using a subquery in FROM).
SELECT dept_id, total_salary FROM (SELECT dept_id, SUM(salary) AS total_salary FROM employees GROUP BY dept_id) x ORDER BY total_salary DESC LIMIT 1;

-- Q155. List all employees who do not have any subordinate (NOT EXISTS on manager_id).
SELECT e.* FROM employees e WHERE NOT EXISTS (SELECT 1 FROM employees s WHERE s.manager_id = e.emp_id);

-- Q156. Display each product category and the product with the maximum price, using a subquery.
SELECT p.* FROM products p WHERE p.price = (SELECT MAX(p2.price) FROM products p2 WHERE p2.category_id = p.category_id);

-- Q157. Show customers who have never returned an item (assuming a returns table; subquery with NOT IN).
-- The supplied schema has no returns table.
-- Example when returns(order_id, ...) exists:
SELECT c.* FROM customers c WHERE NOT EXISTS (SELECT 1 FROM orders o JOIN returns r ON r.order_id = o.order_id WHERE o.customer_id = c.customer_id);

-- Q158. Retrieve employees whose salary is in the top 3 salaries within their department (subquery with LIMIT in a correlated way, or window function; here ask: "Find employees whose salary is in the top 3 of their department using a correlated subquery that counts how many have higher salary").
SELECT e.* FROM employees e WHERE (SELECT COUNT(DISTINCT e2.salary) FROM employees e2 WHERE e2.dept_id = e.dept_id AND e2.salary > e.salary) < 3 ORDER BY dept_id, salary DESC;

-- Q159. List orders that contain more than the average number of items per order (subquery to compute average count).
SELECT oi.order_id FROM order_items oi GROUP BY oi.order_id HAVING COUNT(*) > (SELECT AVG(item_count) FROM (SELECT order_id, COUNT(*) AS item_count FROM order_items GROUP BY order_id) x);

-- Q160. Find products that appear more than once in order_items on the same order (subquery with HAVING COUNT(*) > 1).
SELECT order_id, product_id FROM order_items GROUP BY order_id, product_id HAVING COUNT(*) > 1;

-- Q161. Use a subquery in the SELECT clause to add a column showing the number of employees in each employee's department.
SELECT e.emp_id, e.first_name, e.dept_id, (SELECT COUNT(*) FROM employees e2 WHERE e2.dept_id = e.dept_id) AS department_employee_count FROM employees e;

-- Q162. Select departments where the minimum salary is greater than the maximum salary of department 5.
SELECT dept_id FROM employees GROUP BY dept_id HAVING MIN(salary) > (SELECT MAX(salary) FROM employees WHERE dept_id = 5);

-- Q163. Retrieve the second highest salary using a subquery.
SELECT MAX(salary) AS second_highest_salary FROM employees WHERE salary < (SELECT MAX(salary) FROM employees);

-- Q164. Display all employees who were hired on the same date as the first employee hired.
SELECT * FROM employees WHERE hire_date = (SELECT MIN(hire_date) FROM employees);

-- Q165. Show products with a price that is not within 10% of the average price.
SELECT * FROM products WHERE price NOT BETWEEN (SELECT AVG(price) * 0.90 FROM products) AND (SELECT AVG(price) * 1.10 FROM products);

-- Q166. Find customers whose total spending is above the average total spending of all customers.
WITH customer_totals AS (SELECT customer_id, SUM(total_amount) AS total_spending FROM orders GROUP BY customer_id) SELECT * FROM customer_totals WHERE total_spending > (SELECT AVG(total_spending) FROM customer_totals);

-- Q167. List employees whose email domain is the most common domain in the company (subquery to find most frequent domain).
WITH domains AS (SELECT SUBSTRING_INDEX(email, '@', -1) AS domain FROM employees), top_domain AS (SELECT domain FROM domains GROUP BY domain ORDER BY COUNT(*) DESC, domain LIMIT 1) SELECT e.* FROM employees e JOIN top_domain d ON d.domain = SUBSTRING_INDEX(e.email, '@', -1);

-- Q168. Retrieve the order with the highest number of distinct products.
WITH product_counts AS (SELECT order_id, COUNT(DISTINCT product_id) AS product_count FROM order_items GROUP BY order_id) SELECT * FROM product_counts WHERE product_count = (SELECT MAX(product_count) FROM product_counts);

-- Q169. Use a correlated subquery to find employees whose salary is less than the average salary of employees hired in the same year.
SELECT e.* FROM employees e WHERE e.salary < (SELECT AVG(e2.salary) FROM employees e2 WHERE YEAR(e2.hire_date) = YEAR(e.hire_date));

-- Q170. Show the employee with the longest tenure (earliest hire_date).
SELECT * FROM employees WHERE hire_date = (SELECT MIN(hire_date) FROM employees);

-- Q171. List all orders and a flag indicating if the order total exceeds the customer’s lifetime average order value (correlated subquery).
SELECT o.*, CASE WHEN o.total_amount > (SELECT AVG(o2.total_amount) FROM orders o2 WHERE o2.customer_id = o.customer_id) THEN 'Above average' ELSE 'Not above average' END AS comparison_flag FROM orders o;

-- Q172. Find departments that have at least one employee earning more than 100,000.
SELECT DISTINCT e.dept_id FROM employees e WHERE EXISTS (SELECT 1 FROM employees e2 WHERE e2.dept_id = e.dept_id AND e2.salary > 100000);

-- Q173. Retrieve all products whose price is greater than the price of any product in category 2.
SELECT * FROM products WHERE price > ANY (SELECT price FROM products WHERE category_id = 2);

-- Q174. Use a subquery to create a derived table that calculates the total sales per category, then join to categories to show category name and total.
SELECT c.category_name, COALESCE(s.total_sales, 0) AS total_sales FROM categories c LEFT JOIN (SELECT p.category_id, SUM(oi.quantity * oi.unit_price) AS total_sales FROM products p JOIN order_items oi ON oi.product_id = p.product_id GROUP BY p.category_id) s ON s.category_id = c.category_id;

-- Q175. Find the employee(s) with the 5th highest salary (without LIMIT/OFFSET, using subquery).
SELECT e.* FROM employees e WHERE (SELECT COUNT(DISTINCT e2.salary) FROM employees e2 WHERE e2.salary > e.salary) = 4;

-- Q176. Show customers who placed orders in every month of 2023 (subquery to get distinct months count).
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2023 GROUP BY customer_id HAVING COUNT(DISTINCT MONTH(order_date)) = 12;

-- Q177. List employees working in departments located in 'New York' (nested subquery).
SELECT * FROM employees WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'New York');

-- Q178. Retrieve employees and their salary rank within the company using a subquery that counts distinct higher salaries.
SELECT e.emp_id, e.first_name, e.salary, 1 + (SELECT COUNT(DISTINCT e2.salary) FROM employees e2 WHERE e2.salary > e.salary) AS salary_rank FROM employees e;

-- Q179. Display the product that has the largest total quantity sold, using a subquery to compute aggregate.
SELECT product_id, total_quantity FROM (SELECT product_id, SUM(quantity) AS total_quantity FROM order_items GROUP BY product_id) x WHERE total_quantity = (SELECT MAX(total_quantity) FROM (SELECT SUM(quantity) AS total_quantity FROM order_items GROUP BY product_id) y);

-- Q180. Find the department ID and name where the average salary is higher than the company-wide average.
SELECT d.dept_id, d.dept_name, AVG(e.salary) AS average_salary FROM departments d JOIN employees e ON e.dept_id = d.dept_id GROUP BY d.dept_id, d.dept_name HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);
