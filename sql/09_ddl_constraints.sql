USE Assignment_1;

-- DDL and Constraints
-- Questions 242-281

-- Q242. Create a new table projects with columns: project_id INT PRIMARY KEY AUTO_INCREMENT, project_name VARCHAR(100) NOT NULL, start_date DATE, end_date DATE, budget DECIMAL(10,2).
CREATE TABLE projects (project_id INT PRIMARY KEY AUTO_INCREMENT, project_name VARCHAR(100) NOT NULL, start_date DATE, end_date DATE, budget DECIMAL(10,2));

-- Q243. Add a column phone VARCHAR(15) to the employees table.
ALTER TABLE employees ADD COLUMN phone VARCHAR(15);

-- Q244. Rename the table clients to customers.
RENAME TABLE clients TO customers; -- Run only when clients exists and customers does not.

-- Q245. Drop the column obsolete_column from a table.
ALTER TABLE some_table DROP COLUMN obsolete_column;

-- Q246. Define a composite primary key on order_id and product_id for the order_items table.
ALTER TABLE order_items DROP PRIMARY KEY, ADD PRIMARY KEY (order_id,product_id);

-- Q247. Add a foreign key constraint on dept_id in employees referencing dept_id in departments.
ALTER TABLE employees ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Q248. Create a UNIQUE constraint on the email column of employees.
ALTER TABLE employees ADD CONSTRAINT uq_employee_email UNIQUE (email);

-- Q249. Add a CHECK constraint to ensure salary is greater than 0.
ALTER TABLE employees ADD CONSTRAINT chk_salary_positive CHECK (salary>0);

-- Q250. Set a default value of 'Active' for the status column in orders.
ALTER TABLE orders MODIFY status VARCHAR(30) DEFAULT 'Active';

-- Q251. Alter a column to make it NOT NULL.
ALTER TABLE employees MODIFY last_name VARCHAR(50) NOT NULL;

-- Q252. Remove a foreign key constraint.
ALTER TABLE employees DROP FOREIGN KEY fk_employee_manager;

-- Q253. Create an index on last_name in employees.
CREATE INDEX idx_employees_last_name ON employees(last_name);

-- Q254. Create a full-text index on product_name and description.
-- The supplied products table has no description column. Add it first if the exercise requires it.
ALTER TABLE products ADD COLUMN description TEXT;
CREATE FULLTEXT INDEX idx_products_fulltext ON products(product_name,description);

-- Q255. Add a new column updated_at TIMESTAMP with automatic update on row modification.
ALTER TABLE products ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Q256. Use CREATE TABLE LIKE to create an empty copy of the employees table structure.
CREATE TABLE employees_copy LIKE employees;

-- Q257. Create a temporary table for session-specific data.
CREATE TEMPORARY TABLE session_data (id INT PRIMARY KEY,user_name VARCHAR(50),login_time DATETIME);

-- Q258. Define a table with an ENUM column for status values ('Pending','Processing','Completed').
CREATE TABLE order_status_demo (order_id INT PRIMARY KEY,status ENUM('Pending','Processing','Completed'));

-- Q259. Create a table with a JSON column to store extra attributes.
CREATE TABLE product_attributes (product_id INT PRIMARY KEY,extra_attributes JSON);

-- Q260. Add a constraint to restrict the allowed values of a column using CHECK (e.g., price >= 0).
ALTER TABLE products ADD CONSTRAINT chk_product_price CHECK (price>=0);

-- Q261. Drop a table if it exists.
DROP TABLE IF EXISTS some_table;

-- Q262. Truncate a table (DDL) and explain difference from DELETE.
TRUNCATE TABLE some_table;
-- TRUNCATE removes all rows; DELETE can remove selected rows with WHERE and is logged row-by-row.

-- Q263. Create a new schema/database.
CREATE DATABASE IF NOT EXISTS analytics_db;

-- Q264. Use ALTER to change the data type of a column from INT to BIGINT.
ALTER TABLE employees MODIFY emp_id BIGINT;

-- Q265. Set the character set and collation for a table.
ALTER TABLE employees CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- Q266. Create a view that selects active employees.
CREATE OR REPLACE VIEW active_employees AS SELECT emp_id,first_name,last_name,dept_id,salary FROM employees WHERE manager_id IS NOT NULL;

-- Q267. Drop a view if it exists.
DROP VIEW IF EXISTS active_employees;

-- Q268. Rename a database (if allowed) or just rename a table.
RENAME TABLE employees TO staff;
RENAME TABLE staff TO employees;

-- Q269. Add a COMMENT to a table and a column.
ALTER TABLE employees COMMENT='Employee master table';
ALTER TABLE employees MODIFY first_name VARCHAR(50) COMMENT 'Employee first name';

-- Q270. Disable foreign key checks temporarily for bulk loading.
SET FOREIGN_KEY_CHECKS=0;
-- bulk load here
SET FOREIGN_KEY_CHECKS=1;

-- Q271. Create a table with a generated column that concatenates first_name and last_name.
CREATE TABLE employee_names (first_name VARCHAR(50),last_name VARCHAR(50),full_name VARCHAR(101) GENERATED ALWAYS AS (CONCAT(first_name,' ',last_name)) STORED);

-- Q272. Add a primary key to an existing table without one.
ALTER TABLE some_table ADD PRIMARY KEY (id);

-- Q273. Use SHOW CREATE TABLE to retrieve the DDL of a table.
SHOW CREATE TABLE employees;

-- Q274. Create a sequence or use AUTO_INCREMENT with custom starting value.
ALTER TABLE employees AUTO_INCREMENT=1000;

-- Q275. Add a column with a specific position (FIRST or AFTER another column).
ALTER TABLE projects ADD COLUMN profit DECIMAL(12,2) AFTER project_name;

-- Q276. Drop an index.
DROP INDEX idx_employees_last_name ON employees;

-- Q277. Alter a table to add a UNIQUE composite constraint on (first_name, last_name).
ALTER TABLE customers ADD CONSTRAINT uq_customer_name UNIQUE(first_name,last_name);

-- Q278. Change the storage engine of a table to InnoDB.
ALTER TABLE employees ENGINE=InnoDB;

-- Q279. Create a table that inherits structure from another but with additional columns (CREATE TABLE ... AS SELECT with 0 rows).
CREATE TABLE employee_extra AS SELECT *,CAST(NULL AS DECIMAL(10,2)) AS bonus,CAST(NULL AS DECIMAL(5,2)) AS hike FROM employees WHERE 1=0;

-- Q280. Add a foreign key with ON DELETE CASCADE.
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer_cascade FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

-- Q281. Drop and recreate a primary key.
ALTER TABLE orders DROP PRIMARY KEY, ADD PRIMARY KEY(order_id);
