USE Assignment_1;

-- Stored Procedures and Functions
-- Questions 317-346

-- Q317. Write a stored procedure that takes a department ID and returns the number of employees.
DELIMITER $$
CREATE PROCEDURE employee_count_by_department(IN p_dept_id INT, OUT p_count INT)
BEGIN SELECT COUNT(*) INTO p_count FROM employees WHERE dept_id=p_dept_id; END$$
DELIMITER ;

-- Q318. Create a procedure that gives a raise to all employees in a given department by a specified percentage.
DELIMITER $$
CREATE PROCEDURE give_department_raise(IN p_dept_id INT, IN p_percent DECIMAL(5,2))
BEGIN UPDATE employees SET salary=salary*(1+p_percent/100) WHERE dept_id=p_dept_id; END$$
DELIMITER ;

-- Q319. Write a function that calculates the age of an employee given their birth date.
DELIMITER $$
CREATE FUNCTION employee_age(p_birth_date DATE) RETURNS INT DETERMINISTIC
RETURN TIMESTAMPDIFF(YEAR,p_birth_date,CURDATE())$$
DELIMITER ;

-- Q320. Create a procedure that inserts a new order and all its items, handling rollback on error.
DELIMITER $$
CREATE PROCEDURE create_order_with_items()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO orders(order_id,customer_id,order_date,total_amount,status) VALUES(2001,1,CURDATE(),0,'Pending');
  INSERT INTO order_items(order_item_id,order_id,product_id,quantity,unit_price) VALUES(20001,2001,1,1,950);
  UPDATE orders SET total_amount=(SELECT SUM(quantity*unit_price) FROM order_items WHERE order_id=2001) WHERE order_id=2001;
  COMMIT;
END$$
DELIMITER ;

-- Q321. Write a function that returns the full name of an employee given their ID.
DELIMITER $$
CREATE FUNCTION employee_full_name(p_emp_id INT) RETURNS VARCHAR(101) DETERMINISTIC
RETURN (SELECT CONCAT(first_name,' ',last_name) FROM employees WHERE emp_id=p_emp_id)$$
DELIMITER ;

-- Q322. Develop a procedure that outputs the top N customers by total sales.
DELIMITER $$
CREATE PROCEDURE top_customers(IN p_limit INT)
BEGIN SELECT customer_id,SUM(total_amount) total_sales FROM orders GROUP BY customer_id ORDER BY total_sales DESC LIMIT p_limit; END$$
DELIMITER ;

-- Q323. Use a cursor inside a procedure to iterate over a result set and perform updates.
-- Cursor example: DECLARE cur CURSOR FOR SELECT emp_id FROM employees; FETCH each id and apply the required update inside the loop.

-- Q324. Create a function that determines the discount category based on total purchases (e.g., >10000 'Gold').
DELIMITER $$
CREATE FUNCTION discount_category(p_total DECIMAL(12,2)) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN RETURN CASE WHEN p_total>10000 THEN 'Gold' WHEN p_total>5000 THEN 'Silver' ELSE 'Standard' END; END$$
DELIMITER ;

-- Q325. Write a procedure that archives old orders (move to archive table) and deletes from main.
DELIMITER $$
CREATE PROCEDURE archive_old_orders()
BEGIN START TRANSACTION; INSERT INTO archived_orders SELECT * FROM orders WHERE order_date<DATE_SUB(CURDATE(),INTERVAL 5 YEAR); DELETE FROM orders WHERE order_date<DATE_SUB(CURDATE(),INTERVAL 5 YEAR); COMMIT; END$$
DELIMITER ;
-- archived_orders must exist first.

-- Q326. Create a function that calculates the factorial of a number iteratively.
DELIMITER $$
CREATE FUNCTION factorial(n INT) RETURNS BIGINT DETERMINISTIC
BEGIN DECLARE result BIGINT DEFAULT 1; WHILE n>1 DO SET result=result*n; SET n=n-1; END WHILE; RETURN result; END$$
DELIMITER ;

-- Q327. Write a procedure with an OUT parameter that returns the average salary of a department.
DELIMITER $$
CREATE PROCEDURE department_average_salary(IN p_dept_id INT, OUT p_avg DECIMAL(10,2))
BEGIN SELECT AVG(salary) INTO p_avg FROM employees WHERE dept_id=p_dept_id; END$$
DELIMITER ;

-- Q328. Use a WHILE loop in a procedure to insert a sequence of dates into a table.
DELIMITER $$
CREATE PROCEDURE fill_dates(IN p_start DATE, IN p_end DATE)
BEGIN DECLARE d DATE DEFAULT p_start; WHILE d<=p_end DO INSERT INTO calendar_dates(calendar_date) VALUES(d); SET d=d+INTERVAL 1 DAY; END WHILE; END$$
DELIMITER ;
-- calendar_dates must exist first.

-- Q329. Create a function that validates an email format using REGEXP.
DELIMITER $$
CREATE FUNCTION valid_email(p_email VARCHAR(255)) RETURNS BOOLEAN DETERMINISTIC RETURN p_email REGEXP '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'$$
DELIMITER ;

-- Q330. Develop a procedure that generates a sales report between two dates and inserts into a report table.
DELIMITER $$
CREATE PROCEDURE sales_report(p_start DATE,p_end DATE)
BEGIN INSERT INTO sales_report_table(report_date,total_sales) SELECT order_date,SUM(total_amount) FROM orders WHERE order_date BETWEEN p_start AND p_end GROUP BY order_date; END$$
DELIMITER ;
-- sales_report_table must exist first.

-- Q331. Write a function that splits a comma-separated string and returns the number of elements.
DELIMITER $$
CREATE FUNCTION comma_count(p_text TEXT) RETURNS INT DETERMINISTIC RETURN CASE WHEN p_text IS NULL OR p_text='' THEN 0 ELSE 1+LENGTH(p_text)-LENGTH(REPLACE(p_text,',','')) END$$
DELIMITER ;

-- Q332. Create a procedure with conditional logic to update salary based on performance rating.
DELIMITER $$
CREATE PROCEDURE update_salary_by_rating(IN p_emp_id INT,IN p_rating INT)
BEGIN UPDATE employees SET salary=salary*CASE WHEN p_rating>=5 THEN 1.15 WHEN p_rating=4 THEN 1.10 WHEN p_rating=3 THEN 1.05 ELSE 1 END WHERE emp_id=p_emp_id; END$$
DELIMITER ;

-- Q333. Use SIGNAL to raise a custom error in a procedure if invalid input.
DELIMITER $$
CREATE PROCEDURE validate_department(IN p_dept_id INT)
BEGIN IF NOT EXISTS(SELECT 1 FROM departments WHERE dept_id=p_dept_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid department'; END IF; END$$
DELIMITER ;

-- Q334. Write a procedure that uses a transaction to transfer funds between two accounts (custom table).
-- Transfer pattern: START TRANSACTION; SELECT ... FOR UPDATE on both accounts; UPDATE sender; UPDATE receiver; COMMIT; ROLLBACK from an EXIT HANDLER for SQLEXCEPTION.

-- Q335. Create a recursive stored procedure to traverse a tree (e.g., employee hierarchy).
DELIMITER $$
CREATE PROCEDURE employee_tree(IN p_manager INT)
BEGIN WITH RECURSIVE tree AS (SELECT emp_id,manager_id,first_name FROM employees WHERE emp_id=p_manager UNION ALL SELECT e.emp_id,e.manager_id,e.first_name FROM employees e JOIN tree t ON e.manager_id=t.emp_id) SELECT * FROM tree; END$$
DELIMITER ;

-- Q336. Write a function that returns the nth highest salary (n as parameter).
DELIMITER $$
CREATE FUNCTION nth_highest_salary(p_n INT) RETURNS DECIMAL(10,2) DETERMINISTIC RETURN (SELECT salary FROM (SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT p_n) s ORDER BY salary LIMIT 1)$$
DELIMITER ;

-- Q337. Create a procedure that uses PREPARE and EXECUTE to run a dynamic SQL query.
SET @sql='SELECT COUNT(*) FROM employees'; PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Q338. Write a function that computes the distance between two zip codes (assuming a formula).
-- Requires coordinates or another distance formula input. Use ST_Distance_Sphere(point1,point2) when geographic points are available.

-- Q339. Develop a procedure that bulk inserts random test data.
DELIMITER $$
CREATE PROCEDURE seed_test_data(IN p_rows INT)
BEGIN DECLARE i INT DEFAULT 1; WHILE i<=p_rows DO INSERT INTO test_numbers(id,random_number) VALUES(i,FLOOR(RAND()*1000)); SET i=i+1; END WHILE; END$$
DELIMITER ;

-- Q340. Create a function that masks an email (e.g., j***@domain.com).
DELIMITER $$
CREATE FUNCTION mask_email(p_email VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC RETURN CONCAT(LEFT(SUBSTRING_INDEX(p_email,'@',1),1),'***@',SUBSTRING_INDEX(p_email,'@',-1))$$
DELIMITER ;

-- Q341. Write a procedure that synchronizes two tables, inserting new records and updating existing ones.
-- Use INSERT ... ON DUPLICATE KEY UPDATE for a natural-key based synchronization between source and target tables.

-- Q342. Use GET DIAGNOSTICS to capture the number of rows affected by the previous statement.
DELIMITER $$
CREATE PROCEDURE show_affected_rows()
BEGIN GET DIAGNOSTICS CONDITION 1 @sqlstate=RETURNED_SQLSTATE; SELECT ROW_COUNT() AS affected_rows; END$$
DELIMITER ;

-- Q343. Create a stored procedure that returns multiple result sets.
DELIMITER $$
CREATE PROCEDURE employee_report()
BEGIN SELECT * FROM employees; SELECT * FROM departments; END$$
DELIMITER ;

-- Q344. Write a function that converts a datetime to a human-readable "time ago" string.
DELIMITER $$
CREATE FUNCTION time_ago(p_date DATETIME) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN DECLARE s INT; SET s=TIMESTAMPDIFF(SECOND,p_date,NOW()); RETURN CASE WHEN s<60 THEN CONCAT(s,' seconds ago') WHEN s<3600 THEN CONCAT(FLOOR(s/60),' minutes ago') WHEN s<86400 THEN CONCAT(FLOOR(s/3600),' hours ago') ELSE CONCAT(FLOOR(s/86400),' days ago') END; END$$
DELIMITER ;

-- Q345. Create a procedure that applies a complex business logic: reorder products that fall below stock threshold by inserting into a purchase_orders table.
-- Reorder pattern: INSERT INTO purchase_orders(product_id,quantity) SELECT product_id, reorder_quantity FROM products WHERE stock_quantity < reorder_threshold; -- requires purchase_orders and threshold columns.

-- Q346. Build a logging framework using a procedure that writes to a log table with timestamp.
CREATE TABLE IF NOT EXISTS procedure_log(log_id INT AUTO_INCREMENT PRIMARY KEY,message VARCHAR(255),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
-- A procedure can INSERT INTO procedure_log(message) VALUES ('step completed');
