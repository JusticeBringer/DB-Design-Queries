# Database design & queries
This repository is about a DB design and some queries asociated to it. 
It is a project within the course "Database" from my faculty, in the 2nd semester in 2nd year.

# Task

Design and implement using Oracle 11g / 12c a relational database (minimum 5 independent entities and an associative table).

## Requirements

1. Brief presentation of the database (its use).
2. Realization of the entity-relationship diagram (ERD).
3. Realization of the conceptual diagram, integrating all the necessary attributes.
4. Define tables in Oracle, implementing all necessary integrity constraints
(primary keys, external keys, etc.).
5. Adding consistent information to the created tables (minimum 3-5 records for each
independent entity; minimum 10 records for the associative table).
6. Write 15 queries, as complex as possible, to illustrate the following learned aspects:
   - the clauses GROUP BY, HAVING, START WITH, CONNECT BY, ORDER BY;
   - functions for working with strings and calendar data (LOWER, UPPER, SUBSTR, INSTR, TO_CHAR, TO_DATE, ADD_MONTHS, MONTHS_BETWEEN etc.);
   - various functions (DECODE, NVL, NULLIF, CASE, etc.);
   - INNER, LEFT, RIGHT, FULL JOIN;
   - operators on sets;
   - multiple-row / aggregate functions (AVG, SUM, MIN, MAX, COUNT);
   - subqueries in the clauses: SELECT, FROM, WHERE, HAVING;
   - DIVISION operator.

Observation: The database must be in the third normal form (3NF).

## Solution

1. Brief presentation of the database (its use).
   - The design of the chosen database describes a store, which also has locations in the real world, but you can also shop online. 
   
2. Realization of the entity-relationship diagram (ERD).
   - ![ERD](https://github.com/JusticeBringer/DB-Design-Queries/blob/master/erd.png)
   
   - The store has real world locations located in the "OFFICE_GAR" table. Customers from the "EMPLOYEE_GAR" table work in those stores. Various customers can shop at these stores. Each customer is managed by an employee, ie the customer's order is verified by an employee. A customer's orders are located in the "ORDER_GAR" table. Details about the customer's payment method are in the "PAYMENT_GAR" table. There are 2 cases when making the payment: when it is made online, the customer is bound to a bank and pays by card, and when it is actually paid, the customer is not necessarily tied to a bank, being able to pay "cash", in this case which is the convention that the bank name will be set to “NO BANK”, and the attributes last name, first name, phone, address, email are set to null for that record.
