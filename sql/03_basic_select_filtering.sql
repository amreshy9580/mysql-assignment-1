USE Assignment_1;

-- Basic SELECT and Filtering
-- Questions 1-50

-- Q1. Write a query to retrieve all columns from the employees table.
SELECT * FROM employees;

-- Q2. Aggregate Functions and GROUP BY (40 Questions)
SELECT first_name, last_name, email FROM employees;

-- Q3. Joins (50 Questions)
SELECT DISTINCT dept_id FROM employees;

-- Q4. Subqueries (40 Questions)
SELECT first_name, salary FROM employees WHERE salary > 60000;

-- Q5. Set Operations (30 Questions)
SELECT * FROM employees WHERE hire_date > '2020-01-01';

-- Q6. Data Modification (DML) (30 Questions)
SELECT * FROM employees WHERE last_name = 'Smith';

-- Q7. DDL and Constraints (40 Questions)
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 80000;

-- Q8. Views (20 Questions)
SELECT * FROM employees WHERE first_name LIKE 'J%';

-- Q9. Indexes (15 Questions)
SELECT * FROM employees WHERE email LIKE '%company.com%';

-- Q10. Stored Procedures and Functions (30 Questions)
SELECT * FROM employees WHERE manager_id IS NULL;

-- Q11. Triggers and Events (15 Questions)
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

-- Q12. Transactions and Locking (15 Questions)
SELECT * FROM employees ORDER BY hire_date DESC LIMIT 10;

-- Q13. Window Functions (50 Questions)
SELECT * FROM employees ORDER BY last_name, first_name;

-- Q14. Common Table Expressions (Non-Recursive) (30 Questions)
SELECT * FROM employees WHERE dept_id IN (1, 2, 3);

-- Q15. Recursive CTEs (20 Questions)
SELECT * FROM products WHERE price < 100 OR stock_quantity > 500;

-- Q16. Advanced Topics: Pivot, JSON, Dynamic SQL, Performance (25 Questions)
SELECT * FROM customers WHERE city IN ('New York', 'Los Angeles');

-- Q17. Retrieve orders placed in the year 2022.
SELECT * FROM orders WHERE YEAR(order_date) = 2022;

-- Q18. Show all orders with a total amount greater than 1000, sorted by total_amount descending.
SELECT * FROM orders WHERE total_amount > 1000 ORDER BY total_amount DESC;

-- Q19. Find products where the product name contains 'Pro' (case-insensitive).
SELECT * FROM products WHERE LOWER(product_name) LIKE '%pro%';

-- Q20. List employees whose first name is exactly 5 characters long.
SELECT * FROM employees WHERE CHAR_LENGTH(first_name) = 5;

-- Q21. Display the concatenated full name (first_name + ' ' + last_name) as full_name for all employees.
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;

-- Q22. Write a query that returns the current date and time.
SELECT CURRENT_TIMESTAMP AS current_date_time;

-- Q23. For each product, show the product name, price, and a 10% discounted price.
SELECT product_name, price, ROUND(price * 0.90, 2) AS discounted_price FROM products;

-- Q24. Retrieve employees whose hire date is a Monday.
SELECT * FROM employees WHERE DAYNAME(hire_date) = 'Monday';

-- Q25. Select orders placed in the last 30 days.
SELECT * FROM orders WHERE order_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND CURDATE();

-- Q26. Find products with NULL in the category_id column.
SELECT * FROM products WHERE category_id IS NULL;

-- Q27. List customers who signed up between '2021-01-01' and '2021-12-31'.
SELECT * FROM customers WHERE signup_date BETWEEN '2021-01-01' AND '2021-12-31';

-- Q28. Show distinct cities from the customers table.
SELECT DISTINCT city FROM customers;

-- Q29. Retrieve all employees ordered by salary desc, but skip the first 5 and return the next 10.
SELECT * FROM employees ORDER BY salary DESC LIMIT 10 OFFSET 5;

-- Q30. Display employees whose employee ID is an even number.
SELECT * FROM employees WHERE MOD(emp_id, 2) = 0;

-- Q31. Find orders where the status is not 'Delivered'.
SELECT * FROM orders WHERE status <> 'Delivered';

-- Q32. Select employees with a salary not equal to 70,000.
SELECT * FROM employees WHERE salary <> 70000;

-- Q33. List products where the name begins with 'A' and ends with 's'.
SELECT * FROM products WHERE product_name LIKE 'A%s';

-- Q34. Retrieve employees hired in the month of March.
SELECT * FROM employees WHERE MONTH(hire_date) = 3;

-- Q35. Show the top 3 most expensive products.
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- Q36. Display employees sorted by department ID ascending, and within each department by salary descending.
SELECT * FROM employees ORDER BY dept_id, salary DESC;

-- Q37. Find all customers whose last name is NULL.
SELECT * FROM customers WHERE last_name IS NULL;

-- Q38. Select employees whose email is not from 'company.com' (i.e., does not contain it).
SELECT * FROM employees WHERE email NOT LIKE '%company.com%';

-- Q39. Write a query to fetch the current user and database name.
SELECT USER() AS current_user, DATABASE() AS current_database;

-- Q40. List all products with a stock quantity between 10 and 50 (inclusive).
SELECT * FROM products WHERE stock_quantity BETWEEN 10 AND 50;

-- Q41. Show orders placed on a weekend (Saturday or Sunday).
SELECT * FROM orders WHERE DAYOFWEEK(order_date) IN (1, 7);

-- Q42. Retrieve distinct combinations of city and state from customers.
SELECT DISTINCT city, state FROM customers;

-- Q43. Display employees with more than 5 years of service from today.
SELECT * FROM employees WHERE hire_date <= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- Q44. Find orders where the order ID is in a given list: 1001, 1005, 1010.
SELECT * FROM orders WHERE order_id IN (1001, 1005, 1010);

-- Q45. Show the first 15% of rows from the employees table (using LIMIT with count).
SELECT * FROM employees ORDER BY emp_id LIMIT GREATEST(1, CEIL((SELECT COUNT(*) FROM employees) * 0.15));

-- Q46. List all columns for the 3 most recent orders.
SELECT * FROM orders ORDER BY order_date DESC LIMIT 3;

-- Q47. Select employees whose first name has 'a' as the second letter.
SELECT * FROM employees WHERE first_name LIKE '_a%';

-- Q48. Retrieve products that have a price ending with .99.
SELECT * FROM products WHERE MOD(ROUND(price * 100), 100) = 99;

-- Q49. Display a list of all table names in the current database (using INFORMATION_SCHEMA).
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE();

-- Q50. Show the version of MySQL.
SELECT VERSION();
