USE Assignment_1;

-- Advanced Topics
-- Questions 477-501

-- Q477. Write a query to pivot the sum of sales per year for each product category (static pivot using CASE).
SELECT c.category_name,SUM(CASE WHEN YEAR(o.order_date)=2022 THEN oi.quantity*oi.unit_price ELSE 0 END) sales_2022,SUM(CASE WHEN YEAR(o.order_date)=2023 THEN oi.quantity*oi.unit_price ELSE 0 END) sales_2023,SUM(CASE WHEN YEAR(o.order_date)=2024 THEN oi.quantity*oi.unit_price ELSE 0 END) sales_2024 FROM categories c LEFT JOIN products p ON p.category_id=c.category_id LEFT JOIN order_items oi ON oi.product_id=p.product_id LEFT JOIN orders o ON o.order_id=oi.order_id GROUP BY c.category_id,c.category_name;

-- Q478. Use the JSON functions to extract a value from a JSON column.
SELECT JSON_EXTRACT('{"name":"Laptop","price":950}', '$.name') AS product_name;

-- Q479. Create a query that returns a JSON array of all employees in a department.
SELECT dept_id, JSON_ARRAYAGG(JSON_OBJECT('emp_id',emp_id,'name',CONCAT(first_name,' ',last_name))) AS employees FROM employees GROUP BY dept_id;

-- Q480. Use JSON_TABLE to convert a JSON array into relational rows.
SELECT jt.value FROM JSON_TABLE('[{"name":"A"},{"name":"B"}]','$[*]' COLUMNS(value VARCHAR(50) PATH '$.name')) jt;

-- Q481. Write a query that produces a JSON object containing department name and employee count.
SELECT JSON_OBJECT('department',d.dept_name,'employee_count',COUNT(e.emp_id)) AS department_summary FROM departments d LEFT JOIN employees e ON e.dept_id=d.dept_id GROUP BY d.dept_id,d.dept_name;

-- Q482. Update a specific key in a JSON document using JSON_SET.
UPDATE product_attributes SET extra_attributes=JSON_SET(extra_attributes,'$.RAM','16 GB') WHERE product_id=1;

-- Q483. Use dynamic SQL to create a pivot where the column values are not known in advance.
SET @cols=NULL; SELECT GROUP_CONCAT(DISTINCT CONCAT('SUM(CASE WHEN YEAR(order_date)=',YEAR(order_date),' THEN total_amount ELSE 0 END) AS sales_',YEAR(order_date))) INTO @cols FROM orders; SET @sql=CONCAT('SELECT ',@cols,' FROM orders'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Q484. Write a prepared statement that accepts a table name as parameter and returns its row count.
SET @table_name='employees'; SET @sql=CONCAT('SELECT COUNT(*) AS row_count FROM `',REPLACE(@table_name,'`','``'),'`'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Q485. Use EXPLAIN ANALYZE (MySQL 8.0.18+) to analyze a slow query.
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id=1 ORDER BY order_date DESC;

-- Q486. Profile a query using SHOW PROFILES (if enabled) and identify bottlenecks.
SHOW PROFILES; -- Available only when profiling is enabled in the MySQL version/configuration being used.

-- Q487. Optimize a query by adding appropriate indexes; measure with EXPLAIN.
CREATE INDEX idx_orders_customer_date ON orders(customer_id,order_date); EXPLAIN SELECT * FROM orders WHERE customer_id=1 ORDER BY order_date DESC;

-- Q488. Use the optimizer hints (e.g., JOIN_ORDER, INDEX) to influence execution plan.
SELECT /*+ INDEX(o idx_orders_customer_date) */ * FROM orders o WHERE o.customer_id=1 ORDER BY o.order_date DESC;

-- Q489. Write a query that identifies missing indexes using the sys.schema_unused_indexes or performance_schema.
SELECT * FROM sys.schema_unused_indexes WHERE object_schema=DATABASE();

-- Q490. Use window functions to create a cohort retention analysis (users by signup month and activity month).
WITH cohort AS (SELECT customer_id,DATE_FORMAT(signup_date,'%Y-%m') cohort_month FROM customers), activity AS (SELECT c.cohort_month,DATE_FORMAT(o.order_date,'%Y-%m') activity_month,c.customer_id FROM cohort c JOIN orders o ON o.customer_id=c.customer_id) SELECT cohort_month,activity_month,COUNT(DISTINCT customer_id) active_customers FROM activity GROUP BY cohort_month,activity_month ORDER BY cohort_month,activity_month;

-- Q491. Write a query that calculates the distance between geographic points using ST_Distance_Sphere.
-- Requires spatial coordinates. Example: SELECT ST_Distance_Sphere(POINT(-73.99,40.73),POINT(-74.00,40.72)) AS distance_meters;

-- Q492. Use FULLTEXT search with MATCH and relevance ranking.
ALTER TABLE products ADD FULLTEXT INDEX idx_product_search(product_name); SELECT product_id,product_name,MATCH(product_name) AGAINST('+Laptop' IN BOOLEAN MODE) relevance FROM products WHERE MATCH(product_name) AGAINST('+Laptop' IN BOOLEAN MODE);

-- Q493. Create a generated column that extracts a year from a DATE column.
ALTER TABLE employees ADD COLUMN hire_year INT GENERATED ALWAYS AS (YEAR(hire_date)) STORED;

-- Q494. Use a recursive CTE combined with JSON_ARRAYAGG to build a hierarchical JSON output.
-- Requires a hierarchy table. A recursive CTE can build paths, and JSON_ARRAYAGG/JSON_OBJECT can then serialize each level into JSON.

-- Q495. Write a query that uses a lateral derived table (MySQL 8.0.14+) to join a subquery that references columns from preceding tables.
SELECT c.customer_id,x.latest_order_id,x.latest_order_date FROM customers c JOIN LATERAL (SELECT o.order_id latest_order_id,o.order_date latest_order_date FROM orders o WHERE o.customer_id=c.customer_id ORDER BY o.order_date DESC,o.order_id DESC LIMIT 1) x ON TRUE;

-- Q496. Use the RANK() function in a subquery to answer "How many customers have total sales in the top 10%?".
WITH totals AS (SELECT customer_id,SUM(total_amount) total_sales FROM orders GROUP BY customer_id), ranked AS (SELECT *,PERCENT_RANK() OVER(ORDER BY total_sales DESC) pct FROM totals) SELECT COUNT(*) FROM ranked WHERE pct<=0.10;

-- Q497. Write a query that combines INTERSECT and EXCEPT with CTEs for a complex set operation.
WITH a AS (SELECT customer_id FROM customers WHERE state='TX'), b AS (SELECT customer_id FROM orders WHERE total_amount>100) SELECT customer_id FROM a WHERE customer_id IN (SELECT customer_id FROM b) AND customer_id NOT IN (SELECT customer_id FROM customers WHERE city='Dallas');

-- Q498. Implement a queue using SKIP LOCKED for processing items without overlap.
START TRANSACTION; SELECT * FROM job_queue WHERE status='ready' ORDER BY job_id LIMIT 1 FOR UPDATE SKIP LOCKED; -- process the returned row, update its status, then COMMIT.

-- Q499. Write a query that uses a window frame with RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW.
SELECT order_date,SUM(total_amount) OVER(ORDER BY order_date RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS rolling_7_day_sales FROM orders;

-- Q500. Use the REGEXP_REPLACE function to clean phone numbers.
SELECT REGEXP_REPLACE('+91-98765-43210','[^0-9]','') AS cleaned_phone;

-- Q501. Final challenge: Design a complete sales dashboard query that uses CTEs, window functions, JSON aggregation, and conditional pivots to output a summary of daily sales, top products, and percent change from previous day, all in a single query.
WITH daily_sales AS (SELECT order_date,SUM(total_amount) total_sales FROM orders GROUP BY order_date), daily AS (SELECT order_date,total_sales,LAG(total_sales) OVER(ORDER BY order_date) previous_sales FROM daily_sales), top_products AS (SELECT p.product_name,SUM(oi.quantity*oi.unit_price) sales FROM products p JOIN order_items oi ON oi.product_id=p.product_id GROUP BY p.product_id,p.product_name ORDER BY sales DESC LIMIT 5), product_json AS (SELECT JSON_ARRAYAGG(JSON_OBJECT('product',product_name,'sales',sales)) top_products FROM top_products) SELECT d.order_date,d.total_sales,d.previous_sales,ROUND(100*(d.total_sales-d.previous_sales)/NULLIF(d.previous_sales,0),2) pct_change,pj.top_products FROM daily d CROSS JOIN product_json pj ORDER BY d.order_date;
