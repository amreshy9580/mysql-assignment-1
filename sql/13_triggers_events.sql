USE Assignment_1;

-- Triggers and Events
-- Questions 347-361

-- Q347. Create a BEFORE INSERT trigger that automatically sets the created_at timestamp.
DELIMITER $$
CREATE TRIGGER before_order_insert BEFORE INSERT ON orders FOR EACH ROW SET NEW.order_date=COALESCE(NEW.order_date,CURDATE())$$
DELIMITER ;

-- Q348. Write an AFTER UPDATE trigger that logs changes to employee salary into an audit table.
DELIMITER $$
CREATE TRIGGER employee_salary_audit AFTER UPDATE ON employees FOR EACH ROW BEGIN IF OLD.salary<>NEW.salary THEN INSERT INTO employee_salary_audit(emp_id,old_salary,new_salary,changed_at) VALUES(NEW.emp_id,OLD.salary,NEW.salary,NOW()); END IF; END$$
DELIMITER ;
-- Create employee_salary_audit first.

-- Q349. Create a trigger that prevents deletion of a customer if they have active orders.
DELIMITER $$
CREATE TRIGGER prevent_customer_delete BEFORE DELETE ON customers FOR EACH ROW BEGIN IF EXISTS(SELECT 1 FROM orders WHERE customer_id=OLD.customer_id AND status IN ('Pending','Processing')) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Customer has active orders'; END IF; END$$
DELIMITER ;

-- Q350. Build a BEFORE DELETE trigger that archives the row into a backup table.
DELIMITER $$
CREATE TRIGGER archive_customer_before_delete BEFORE DELETE ON customers FOR EACH ROW INSERT INTO customers_backup SELECT OLD.*$$
DELIMITER ;
-- customers_backup must match customers.

-- Q351. Write an AFTER INSERT trigger on order_items that decreases product stock.
DELIMITER $$
CREATE TRIGGER reduce_stock_after_item AFTER INSERT ON order_items FOR EACH ROW UPDATE products SET stock_quantity=stock_quantity-NEW.quantity WHERE product_id=NEW.product_id$$
DELIMITER ;

-- Q352. Create a trigger that validates that an order total is positive before insert/update.
DELIMITER $$
CREATE TRIGGER validate_order_total BEFORE INSERT ON orders FOR EACH ROW BEGIN IF NEW.total_amount<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Order total must be positive'; END IF; END$$
DELIMITER ;

-- Q353. Develop a trigger that updates a last_modified column on the parent table when a child row is modified.
-- Child-table changes do not automatically know which parent row to update; create AFTER INSERT/UPDATE/DELETE triggers on the child table and update the parent timestamp.

-- Q354. Use a trigger to maintain a denormalized total_amount in the orders table whenever order_items are inserted, updated, or deleted.
-- Maintain orders.total_amount with AFTER INSERT/UPDATE/DELETE triggers on order_items, recalculating SUM(quantity*unit_price) for NEW.order_id/OLD.order_id.

-- Q355. Create an event that runs daily to delete expired sessions.
CREATE EVENT IF NOT EXISTS delete_expired_sessions ON SCHEDULE EVERY 1 DAY DO DELETE FROM sessions WHERE expires_at<CURRENT_TIMESTAMP;

-- Q356. Write an event that aggregates daily sales and inserts into a summary table.
CREATE EVENT IF NOT EXISTS daily_sales_summary ON SCHEDULE EVERY 1 DAY DO INSERT INTO daily_sales_summary(sale_date,total_sales) SELECT CURDATE()-INTERVAL 1 DAY,SUM(total_amount) FROM orders WHERE order_date=CURDATE()-INTERVAL 1 DAY;

-- Q357. Schedule an event that runs every hour to optimize/reindex a table.
CREATE EVENT IF NOT EXISTS hourly_optimize ON SCHEDULE EVERY 1 HOUR DO OPTIMIZE TABLE orders;

-- Q358. Create a trigger that automatically assigns a customer to a sales representative based on region.
-- BEFORE INSERT trigger pattern: SELECT region into NEW.sales_rep_id from a region mapping table, then assign the value.

-- Q359. Build a trigger that prevents a salary decrease beyond 10% on update.
DELIMITER $$
CREATE TRIGGER prevent_large_salary_cut BEFORE UPDATE ON employees FOR EACH ROW BEGIN IF NEW.salary<OLD.salary*0.90 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Salary decrease exceeds 10%'; END IF; END$$
DELIMITER ;

-- Q360. Use SIGNAL in a trigger to abort an operation with a custom error message.
DELIMITER $$
CREATE TRIGGER validate_salary BEFORE INSERT ON employees FOR EACH ROW BEGIN IF NEW.salary<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Salary cannot be negative'; END IF; END$$
DELIMITER ;

-- Q361. Create an event that executes a stored procedure every Monday at 8 AM.
CREATE EVENT IF NOT EXISTS monday_employee_report ON SCHEDULE EVERY 1 WEEK STARTS '2026-10-12 08:00:00' DO CALL employee_report();
