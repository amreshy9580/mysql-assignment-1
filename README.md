# MySQL Assignment 1

A practical MySQL workbook built from the supplied SQL assignment. The repository keeps the database setup, sample data and practice queries separate so each part can be run without turning the project into one large SQL dump.

## What is covered

- Basic SELECT and filtering
- Aggregate functions, GROUP BY and HAVING
- Joins and self joins
- Subqueries
- UNION and set-operation patterns
- DML and transactions
- DDL and constraints
- Views and indexes
- Stored procedures and functions
- Triggers and events
- Transactions and locking
- Window functions
- CTEs and recursive CTEs
- JSON, dynamic SQL and query-performance examples

## Repository layout

```text
mysql-assignment-1/
├── README.md
├── assignment/
│   └── MySQL_Assignment_Questions.pdf
├── sql/
│   ├── 01_database_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_basic_select_filtering.sql
│   ├── 04_aggregate_groupby.sql
│   ├── 05_joins.sql
│   ├── 06_subqueries.sql
│   ├── 07_set_operations.sql
│   ├── 08_dml.sql
│   ├── 09_ddl_constraints.sql
│   ├── 10_views.sql
│   ├── 11_indexes.sql
│   ├── 12_procedures_functions.sql
│   ├── 13_triggers_events.sql
│   ├── 14_transactions_locking.sql
│   ├── 15_window_functions.sql
│   ├── 16_ctes.sql
│   ├── 17_recursive_ctes.sql
│   └── 18_advanced_sql.sql
└── screenshots/
```

## Running the project

Use MySQL 8.0 or later.

1. Run `01_database_schema.sql`.
2. Run `02_sample_data.sql`.
3. Open any topic file and execute the questions you want to practice.

The DML, DDL, trigger, event and procedure files contain examples that change database objects or data. Run those selectively in a practice database rather than against production data.

## A note about the assignment

The original assignment includes several questions that deliberately refer to tables or columns outside the ten-table sample schema, such as `returns`, `wishlist_items`, `price_changes`, `salesperson_id`, hierarchy tables and queue tables. Those examples are marked inside the relevant SQL files instead of pretending that the missing objects exist.

## Goal

The main purpose of this repository is practice: write the query, run it, inspect the result, and then simplify it where possible. The files are organized by topic so the same repository can be used as a SQL revision notebook later.

## Author

Amresh Yadav

B.Tech Information Technology | SQL | Data Analytics
