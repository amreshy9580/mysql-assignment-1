USE Assignment_1;

-- Recursive CTEs
-- Questions 457-476

-- Q457. Generate a series of numbers from 1 to 100 using a recursive CTE.
WITH RECURSIVE numbers AS (SELECT 1 n UNION ALL SELECT n+1 FROM numbers WHERE n<100) SELECT n FROM numbers;

-- Q458. Create a recursive CTE to traverse an employee hierarchy (manager tree) and show the path from top manager to each employee.
WITH RECURSIVE employee_tree AS (SELECT emp_id,manager_id,CONCAT(first_name,' ',last_name) name,CAST(CONCAT(first_name,' ',last_name) AS CHAR(1000)) path,0 level FROM employees WHERE manager_id IS NULL UNION ALL SELECT e.emp_id,e.manager_id,CONCAT(e.first_name,' ',e.last_name),CONCAT(t.path,' -> ',e.first_name,' ',e.last_name),t.level+1 FROM employees e JOIN employee_tree t ON e.manager_id=t.emp_id) SELECT * FROM employee_tree ORDER BY path;

-- Q459. Write a recursive CTE that calculates the factorial of 10.
WITH RECURSIVE factorial AS (SELECT 1 n,1 fact UNION ALL SELECT n+1,fact*(n+1) FROM factorial WHERE n<10) SELECT * FROM factorial WHERE n=10;

-- Q460. Generate a date sequence for the current month, one row per day.
WITH RECURSIVE dates AS (SELECT DATE_FORMAT(CURDATE(),'%Y-%m-01') dt UNION ALL SELECT dt+INTERVAL 1 DAY FROM dates WHERE dt<LAST_DAY(CURDATE())) SELECT dt FROM dates;

-- Q461. Find all subordinates of a given manager down multiple levels.
WITH RECURSIVE subordinates AS (SELECT emp_id,manager_id FROM employees WHERE emp_id=101 UNION ALL SELECT e.emp_id,e.manager_id FROM employees e JOIN subordinates s ON e.manager_id=s.emp_id) SELECT * FROM subordinates;

-- Q462. Compute the total salary budget for a department including all sub-departments in a hierarchical org structure.
-- The supplied schema has no department_hierarchy table. If dept_id/parent_dept_id hierarchy exists, recursively collect descendants then SUM employee salaries across those departments.

-- Q463. Use a recursive CTE to explode a bill of materials (BOM) table (component, parent) to list all components of a product.
-- Requires bom(component,parent).
WITH RECURSIVE bom_tree AS (SELECT component,parent FROM bom WHERE parent='PRODUCT_X' UNION ALL SELECT b.component,b.parent FROM bom b JOIN bom_tree t ON b.parent=t.component) SELECT * FROM bom_tree;

-- Q464. Create a recursive query to solve the "Eight Queens" puzzle? (Too complex, maybe just: "Write a recursive CTE to generate all combinations of two letters A,B,C").
WITH RECURSIVE pairs AS (SELECT 'A' a,'A' b UNION ALL SELECT a,CHAR(ASCII(b)+1) FROM pairs WHERE ASCII(b)<67) SELECT * FROM pairs; -- Simplified recursion example; the original Eight Queens problem is beyond the supplied schema.

-- Q465. Traverse a category tree (parent category) to build a full path like 'Electronics/Computers/Laptops'.
-- Requires categories(category_id,parent_category_id).
WITH RECURSIVE tree AS (SELECT category_id,category_name,parent_category_id,CAST(category_name AS CHAR(500)) path FROM category_tree WHERE parent_category_id IS NULL UNION ALL SELECT c.category_id,c.category_name,c.parent_category_id,CONCAT(t.path,'/',c.category_name) FROM category_tree c JOIN tree t ON c.parent_category_id=t.category_id) SELECT * FROM tree;

-- Q466. Use recursion to perform a graph traversal (e.g., find all connected nodes in a network).
-- Requires graph_edges(from_node,to_node).
WITH RECURSIVE reach AS (SELECT from_node,to_node FROM graph_edges WHERE from_node=1 UNION ALL SELECT r.from_node,g.to_node FROM reach r JOIN graph_edges g ON g.from_node=r.to_node) SELECT DISTINCT to_node FROM reach;

-- Q467. Generate a Fibonacci sequence up to 100 using a recursive CTE.
WITH RECURSIVE fib AS (SELECT 0 a,1 b UNION ALL SELECT b,a+b FROM fib WHERE b<100) SELECT a AS fibonacci_value FROM fib;

-- Q468. Write a CTE that calculates the level of each node in a tree and builds an indented list.
-- Requires tree_nodes(id,parent_id,name).
WITH RECURSIVE tree AS (SELECT id,parent_id,name,0 level FROM tree_nodes WHERE parent_id IS NULL UNION ALL SELECT n.id,n.parent_id,n.name,t.level+1 FROM tree_nodes n JOIN tree t ON n.parent_id=t.id) SELECT CONCAT(REPEAT('  ',level),name) AS indented_name FROM tree ORDER BY level,id;

-- Q469. Find all descendants of a particular category, including the category itself.
-- Requires category_tree(category_id,parent_category_id).
WITH RECURSIVE descendants AS (SELECT category_id,parent_category_id FROM category_tree WHERE category_id=1 UNION ALL SELECT c.category_id,c.parent_category_id FROM category_tree c JOIN descendants d ON c.parent_category_id=d.category_id) SELECT * FROM descendants;

-- Q470. Create a recursive CTE that calculates the running total without window functions (using recursion with carry forward).
WITH RECURSIVE running AS (SELECT order_id,order_date,total_amount,total_amount running_total FROM orders WHERE order_id=(SELECT MIN(order_id) FROM orders) UNION ALL SELECT o.order_id,o.order_date,o.total_amount,r.running_total+o.total_amount FROM orders o JOIN running r ON o.order_id=(SELECT MIN(o2.order_id) FROM orders o2 WHERE o2.order_id>r.order_id)) SELECT * FROM running;

-- Q471. Detect cycles in a hierarchical table using recursion with a cycle detection column.
-- MySQL recursive CTEs can track a visited path. Example: WHERE FIND_IN_SET(next_id,path_ids)=0 prevents revisiting a node.

-- Q472. Use a recursive CTE to split a comma-separated string into rows (alternative to numbers table).
WITH RECURSIVE split AS (SELECT 'A,B,C' source,SUBSTRING_INDEX('A,B,C',',',1) value,1 pos UNION ALL SELECT source,SUBSTRING_INDEX(SUBSTRING_INDEX(source,',',pos+1),',',-1),pos+1 FROM split WHERE pos<LENGTH(source)-LENGTH(REPLACE(source,',',''))+1) SELECT value FROM split;

-- Q473. Write a recursive query that returns the transitive closure of a "friendship" table.
-- Requires friendship(user_id,friend_id).
WITH RECURSIVE closure AS (SELECT user_id,friend_id FROM friendship UNION ALL SELECT c.user_id,f.friend_id FROM closure c JOIN friendship f ON f.user_id=c.friend_id) SELECT DISTINCT * FROM closure;

-- Q474. Generate all months between two dates using a recursive CTE.
WITH RECURSIVE months AS (SELECT CAST('2024-01-01' AS DATE) month_start UNION ALL SELECT month_start+INTERVAL 1 MONTH FROM months WHERE month_start<'2024-12-01') SELECT month_start FROM months;

-- Q475. Implement a recursive query to perform a division operation as repeated subtraction (integer division).
WITH RECURSIVE division AS (SELECT 100 dividend,7 divisor,0 quotient UNION ALL SELECT dividend-divisor,divisor,quotient+1 FROM division WHERE dividend>=divisor) SELECT quotient FROM division ORDER BY quotient DESC LIMIT 1;

-- Q476. Create a recursive CTE that simulates the expansion of a grouped bill (e.g., each level adds tax).
WITH RECURSIVE bill AS (SELECT 1 level,100.00 amount UNION ALL SELECT level+1,amount*1.18 FROM bill WHERE level<5) SELECT * FROM bill;
