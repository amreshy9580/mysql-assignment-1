USE Assignment_1;

-- Indexes
-- Questions 302-316

-- Q302. Explain the difference between a clustered and secondary index in InnoDB.
-- InnoDB stores table rows in the clustered primary-key index. Secondary indexes store indexed columns plus the primary-key value used to locate the row.

-- Q303. Create a composite index on (dept_id, hire_date).
CREATE INDEX idx_employee_dept_hire ON employees(dept_id,hire_date);

-- Q304. Use EXPLAIN to analyze a query and identify if an index is used.
EXPLAIN SELECT * FROM employees WHERE dept_id=3 AND hire_date>='2022-01-01';

-- Q305. Drop a redundant index.
DROP INDEX idx_employee_dept_hire ON employees;

-- Q306. Create a unique index on the email column.
CREATE UNIQUE INDEX idx_employee_email_unique ON employees(email);

-- Q307. How to create a prefix index on a TEXT column?
CREATE INDEX idx_product_name_prefix ON products(product_name(20)); -- Prefix length must fit the column type/charset limits.

-- Q308. Show all indexes on a table using SHOW INDEX.
SHOW INDEX FROM employees;

-- Q309. Create a descending index on order_date (MySQL 8+).
CREATE INDEX idx_orders_order_date_desc ON orders(order_date DESC);

-- Q310. Discuss the impact of too many indexes on write performance.
-- Every index consumes storage and makes INSERT/UPDATE/DELETE work harder because index entries also need maintenance.

-- Q311. Write a query that forces the use of a specific index using FORCE INDEX.
SELECT * FROM employees FORCE INDEX(idx_employee_dept_hire) WHERE dept_id=3 ORDER BY hire_date;

-- Q312. Create a spatial index on a geometry column.
-- Example: ALTER TABLE places ADD SPATIAL INDEX idx_location(location); -- requires a spatial/geometry column.

-- Q313. Identify unused indexes using the sys.schema_unused_indexes view.
SELECT * FROM sys.schema_unused_indexes WHERE object_schema=DATABASE();

-- Q314. Rebuild or optimize an index (ALTER TABLE ... ENGINE=InnoDB).
ALTER TABLE employees ENGINE=InnoDB;

-- Q315. Create a full-text index and a query using MATCH AGAINST.
ALTER TABLE products ADD FULLTEXT INDEX idx_products_ft(product_name);
SELECT product_id,product_name,MATCH(product_name) AGAINST('Laptop') AS relevance FROM products WHERE MATCH(product_name) AGAINST('Laptop');

-- Q316. Use invisible indexes (MySQL 8+) to test performance before dropping.
ALTER TABLE employees ALTER INDEX idx_employee_dept_hire INVISIBLE; -- MySQL 8+. Restore with ALTER TABLE employees ALTER INDEX idx_employee_dept_hire VISIBLE;
