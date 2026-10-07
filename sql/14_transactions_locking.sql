USE Assignment_1;

-- Transactions and Locking
-- Questions 362-376

-- Q362. Explain ACID properties and how MySQL InnoDB ensures them.
-- ACID: Atomicity, Consistency, Isolation, Durability. InnoDB uses transactions, redo/undo logging, locking/MVCC and crash recovery to support these properties.

-- Q363. Write a transaction that transfers money between accounts, with COMMIT and ROLLBACK.
START TRANSACTION;
UPDATE accounts SET balance=balance-100 WHERE account_id=1;
UPDATE accounts SET balance=balance+100 WHERE account_id=2;
COMMIT;
-- Use ROLLBACK if either update fails.

-- Q364. Use SAVEPOINT within a transaction to roll back to a specific point.
START TRANSACTION; UPDATE accounts SET balance=balance-100 WHERE account_id=1; SAVEPOINT after_debit; UPDATE accounts SET balance=balance+100 WHERE account_id=2; ROLLBACK TO SAVEPOINT after_debit; COMMIT;

-- Q365. Demonstrate a deadlock scenario with two sessions and explain how to resolve.
-- Session A locks row 1 then waits for row 2; Session B locks row 2 then waits for row 1. Keep transactions short and acquire locks in a consistent order to reduce deadlocks.

-- Q366. Set transaction isolation level to REPEATABLE READ and show an example avoiding phantom reads.
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; START TRANSACTION; SELECT * FROM orders WHERE customer_id=1; SELECT * FROM orders WHERE customer_id=1; COMMIT;

-- Q367. Use SELECT ... FOR UPDATE to lock rows for a subsequent update.
START TRANSACTION; SELECT * FROM products WHERE product_id=1 FOR UPDATE; UPDATE products SET stock_quantity=stock_quantity-1 WHERE product_id=1; COMMIT;

-- Q368. Create a transaction that reads the same row twice and demonstrates non-repeatable read if isolation is READ COMMITTED.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; START TRANSACTION; SELECT * FROM products WHERE product_id=1; -- another session changes it and commits; SELECT * FROM products WHERE product_id=1; COMMIT;

-- Q369. Query to show current transaction isolation level.
SELECT @@transaction_isolation AS transaction_isolation_level;

-- Q370. Use LOCK TABLES to prevent writes while performing a bulk read.
LOCK TABLES orders READ; SELECT * FROM orders; UNLOCK TABLES;

-- Q371. Explain optimistic vs pessimistic locking with example (version column).
-- Optimistic locking checks a version column in UPDATE. Pessimistic locking uses SELECT ... FOR UPDATE while holding a transaction.

-- Q372. Write a query with SKIP LOCKED (MySQL 8+) to process jobs from a queue without waiting.
START TRANSACTION; SELECT * FROM job_queue WHERE status='ready' ORDER BY job_id LIMIT 1 FOR UPDATE SKIP LOCKED; COMMIT;

-- Q373. Demonstrate a transaction that uses NOWAIT to fail immediately if a row is locked.
START TRANSACTION; SELECT * FROM jobs WHERE job_id=1 FOR UPDATE NOWAIT; COMMIT;

-- Q374. Show how to set autocommit off and manually control commits.
SET autocommit=0; UPDATE products SET price=price*1.05 WHERE category_id=1; COMMIT; SET autocommit=1;

-- Q375. Create a stored procedure that handles deadlock retry logic.
-- Retry deadlocks by catching SQLSTATE 40001 in application/procedure code, rolling back, waiting briefly, and retrying a limited number of times.

-- Q376. Use SHOW ENGINE INNODB STATUS to analyze lock waits.
SHOW ENGINE INNODB STATUS;
