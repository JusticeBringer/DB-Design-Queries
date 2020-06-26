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

**NOTE:** Results of the queries from the ”SQL” script can be seen [here](https://github.com/JusticeBringer/DB-Design-Queries/blob/master/queries.pdf).

## Solution

1. Brief presentation of the database (its use).
   - The design of the chosen database describes a store, which also has locations in the real world, but you can also shop online. 
2. Realization of the entity-relationship diagram (ERD).
   - ![ERD](https://github.com/JusticeBringer/DB-Design-Queries/blob/master/erd.png)
   - The design is interpreted as follows: The store has real world locations located in the "OFFICE_GAR" table. Customers from the "EMPLOYEE_GAR" table work in those stores. Various customers can shop at these stores. Each customer is managed by an employee, ie the customer's order is verified by an employee. A customer's orders are located in the "ORDER_GAR" table. Details about the customer's payment method are in the "PAYMENT_GAR" table. There are 2 cases when making the payment: when it is made online, the customer is bound to a bank and pays by card, and when it is actually paid, the customer is not necessarily tied to a bank, being able to pay "cash", in this case which is the convention that the bank name will be set to “NO BANK”, and the attributes last name, first name, phone, address, email are set to null for that record.
3. Realization of the conceptual diagram, integrating all the necessary attributes.
   - ![Conceputal diagram](https://github.com/JusticeBringer/DB-Design-Queries/blob/master/conceptual.png)
4. Define tables in Oracle, implementing all necessary integrity constraints (primary keys, external keys, etc.). 

```
CREATE TABLE "EMPLOYEE_GAR" (
	"EMP_ID" INT NOT NULL,
	"ODD_WEEK_OFFICE_ID" INT NOT NULL,
	"EVEN_WEEK_OFFICE_ID" INT NOT NULL,
	"LAST_NAME" VARCHAR2(255) NOT NULL,
	"FIRST_NAME" VARCHAR2(255) NOT NULL,
	"EMAIL" VARCHAR2(255) NOT NULL,
	"JOB_TITLE" VARCHAR2(50) NOT NULL,
	CONSTRAINT EMPLOYEE_GAR_PK PRIMARY KEY ("EMP_ID"));


CREATE TABLE "OFFICE_GAR" (
	"CODE" INT NOT NULL,
	"CITY" VARCHAR2(255) NOT NULL,
	"PHONE" VARCHAR2(255) NOT NULL,
	"ADDRESS" VARCHAR2(255) NOT NULL,
	"COUNTRY" VARCHAR2(255) NOT NULL,
	CONSTRAINT OFFICE_GAR_PK PRIMARY KEY ("CODE"));


CREATE TABLE "CUSTOMER_GAR" (
	"CUST_ID" INT NOT NULL,
	"SALES_EMP_ID" INT NOT NULL,
	"LAST_NAME" VARCHAR2(255),
	"FIRST_NAME" VARCHAR2(255),
	"PHONE" VARCHAR2(20),
	"ADDRESS" VARCHAR2(255),
	"EMAIL" VARCHAR2(255) UNIQUE,
	CONSTRAINT CUSTOMER_GAR_PK PRIMARY KEY ("CUST_ID"));


CREATE TABLE "PAYMENT_GAR" (
	"BANK_NAME" VARCHAR2(255) NOT NULL,
	"PAY_CUST_ID" INT NOT NULL,
	"PAY_METHOD" VARCHAR2(20) NOT NULL,
	"PAYMENT_DATE" DATE NOT NULL,
	"AMOUNT" NUMERIC NOT NULL);


CREATE TABLE "BANK_GAR" (
	"BANK_NAME" VARCHAR2(20),
	"SWIFT_CODE" VARCHAR2(8) NOT NULL,
	"COMISSION" FLOAT NOT NULL,
	CONSTRAINT BANK_GAR_PK PRIMARY KEY ("BANK_NAME"));


CREATE TABLE "ORDER_GAR" (
	"ORDER_ID" INT NOT NULL,
	"CUST_ID" INT NOT NULL,
	"ORDER_DATE" DATE NOT NULL,
	"REQUIRED_DATE" DATE NOT NULL,
	"STATUS" VARCHAR2(255) NOT NULL,
	CONSTRAINT ORDER_GAR_PK PRIMARY KEY ("ORDER_ID"));
   
-- Adding constraints

ALTER TABLE "EMPLOYEE_GAR" ADD CONSTRAINT "EMPLOYEE_GAR_FK0" FOREIGN KEY ("ODD_WEEK_OFFICE_ID") REFERENCES "OFFICE_GAR"("CODE");
ALTER TABLE "EMPLOYEE_GAR" ADD CONSTRAINT "EMPLOYEE_GAR_FK1" FOREIGN KEY ("EVEN_WEEK_OFFICE_ID") REFERENCES "OFFICE_GAR"("CODE");
ALTER TABLE "CUSTOMER_GAR" ADD CONSTRAINT "CUSTOMER_GAR_FK0" FOREIGN KEY ("SALES_EMP_ID") REFERENCES "EMPLOYEE_GAR"("EMP_ID");
ALTER TABLE "PAYMENT_GAR" ADD CONSTRAINT "PAYMENT_GAR_FK0" FOREIGN KEY ("BANK_NAME") REFERENCES "BANK_GAR"("BANK_NAME");
ALTER TABLE "PAYMENT_GAR" ADD CONSTRAINT "PAYMENT_GAR_FK1" FOREIGN KEY ("PAY_CUST_ID") REFERENCES "CUSTOMER_GAR"("CUST_ID");
ALTER TABLE "ORDER_GAR" ADD CONSTRAINT "ORDER_GAR_FK0" FOREIGN KEY ("CUST_ID") REFERENCES "CUSTOMER_GAR"("CUST_ID");
```

5. Adding consistent information to the created tables (minimum 3-5 records for each independent entity; minimum 10 records for the associative table).

```
-- Inserting data
    
-- Into BANK_GAR
INSERT ALL
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BRD', 'BRDEROBU', 0.1)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('ALPHA BANK', 'ALBPROBU', 0.2)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BANC POST S.A.', 'BPOSROBU', 0.3)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BCR', 'RNCBROBU', 0.05)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BT', 'BTRLROBU', 0.0)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BR', 'BRMAROBU', 0.25)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BANK OF CYPRUS', 'BCYPROBU', 0.35)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('CEC BANK', 'CECEROBU', 0.1)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('CTIBANK', 'CITIROBU', 0.2)
   INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('BANK LEUMI', 'DAFBROBU', 0.15)
		-- If client buys cash 
		INTO BANK_GAR (BANK_NAME, SWIFT_CODE, COMISSION) VALUES ('NO BANK', '00000000', 0.0)
SELECT 1 FROM DUAL;

-- Into OFFICE_GAR
INSERT ALL
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (1, 'BUDAPESTA', '10745566981', 'ORHIDEEA STREET', 'HUNGARY')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (2, 'ATHENS', '20745566982', 'ANTIGONIS STREET', 'GREECE')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (3, 'MOSCOW', '30745566983', 'KOLOKOTRONI STREET', 'RUSSIA')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (4, 'BUCHAREST', '40745566984', '1ST DECEMBER 1918 STREET', 'ROMANIA')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (5, 'BERLIN', '50745566985', 'LEGIENDAMM', 'GERMANY')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (6, 'PARIS', '10743766186', 'LA VIOLET STREET', 'FRANCE')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (7, 'MADRID', '40747366987', 'SERRATE STREET', 'SPAIN')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (8, 'ROME', '70745123988', 'EL PIZZERRIE STREET', 'ITALY')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (9, 'LONDON', '207454278989', 'VICTORY STREET', 'GREAT BRITAIN')
    INTO OFFICE_GAR (CODE, CITY, PHONE, ADDRESS, COUNTRY)
            VALUES (10, 'KIEV', '80745258910', 'KRAKATUN STREET', 'UKRAINE')
SELECT 1 FROM DUAL;

-- Into EMPLOYEE_GAR
INSERT ALL
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (1, 3, 1, 'SMITH', 'JHON', 'JHON@GMAIL.COM', 'SELLER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (2, 2, 3, 'ALLAN', 'KERRY', 'ALLAN@GMAIL.COM', 'MANAGER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (3, 2, 8, 'JELLY', 'YOU', 'JELLY@GMAIL.COM', 'SELLER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (4, 1, 9, 'MERTY', 'KLAUS', 'MERTY@GMAIL.COM', 'CEO')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (5, 3, 6, 'TRENY', 'DAN', 'TRENY@GMAIL.COM', 'SELLER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (6, 4, 5, 'JAMES', 'ROBER', 'JAMESRB@YAHOO.COM', 'SELLER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (7, 7, 6, 'MICHAEL', 'WILLIAM', 'WILLMICHA@GMAIL.COM', 'MANAGER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (8, 5, 8, 'DAVID', 'RICHARD', 'DAVARD@OUTLOOK.COM', 'SELLER')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (9, 3, 9, 'JOSEPH', 'THOMAS', 'JSPHTOM@GMAIL.COM', 'CEO')
    INTO EMPLOYEE_GAR (EMP_ID, ODD_WEEK_OFFICE_ID, EVEN_WEEK_OFFICE_ID, LAST_NAME, FIRST_NAME, EMAIL, JOB_TITLE)
        VALUES (10, 10, 6, 'DANIEL', 'ANTHONY', 'DANITONY@YAHOO.COM', 'SELLER')
SELECT 1 FROM DUAL;

-- Into CUSTOMER_GAR
INSERT ALL
    INTO CUSTOMER_GAR (CUST_ID, SALES_EMP_ID, LAST_NAME, FIRST_NAME, PHONE, ADDRESS, EMAIL)
        VALUES (1, 2, 'SMITH', 'KATE', '14087859131', 'AVENUE OF THE ARMY', 'SMITHKATE@GMAIL.COM')
    INTO CUSTOMER_GAR (CUST_ID, SALES_EMP_ID, LAST_NAME, FIRST_NAME, PHONE, ADDRESS, EMAIL)
        VALUES (2, 4, 'ALLAN', 'JHON', '02071839232', 'DEVONSHIRE STREET', 'ALLANJH@GMAIL.COM')
    INTO CUSTOMER_GAR (CUST_ID, SALES_EMP_ID, LAST_NAME, FIRST_NAME, PHONE, ADDRESS, EMAIL)
        VALUES (3, 1, 'MERELY', 'JOSH', '14087859333', 'ST. JOHN STREET',  'MERJOSH@GMAIL.COM')
    INTO CUSTOMER_GAR (CUST_ID, SALES_EMP_ID, LAST_NAME, FIRST_NAME, PHONE, ADDRESS, EMAIL)
        VALUES (4, 3, 'POPA', 'ALIN', '40748599330', 'ORHIDEEA STREET',  'ALINPOPA@GMAIL.COM')
SELECT 1 FROM DUAL;

-- Into PAYMENT_GAR
INSERT ALL
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('BRD', 1, 'CARD', TO_DATE('2020-06-02','YYYY-MM-DD'), 15)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('CTIBANK', 2, 'CARD', TO_DATE('2020-06-03','YYYY-MM-DD'), 5)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('BCR', 3, 'CARD', TO_DATE('2020-06-03','YYYY-MM-DD'), 35)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('BT', 2, 'CARD', TO_DATE('2020-06-04','YYYY-MM-DD'), 23)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('BRD', 4, 'CARD', TO_DATE('2020-06-05','YYYY-MM-DD'), 12)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('ALPHA BANK', 1, 'CARD',TO_DATE('2020-06-07','YYYY-MM-DD'), 37)
    INTO PAYMENT_GAR (BANK_NAME, PAY_CUST_ID, PAY_METHOD, PAYMENT_DATE, AMOUNT)
        VALUES ('BR', 3, 'CARD', TO_DATE('2020-06-09','YYYY-MM-DD'), 19)
SELECT 1 FROM DUAL;

-- Into ORDER_GAR
INSERT ALL
    INTO ORDER_GAR  (ORDER_ID, CUST_ID, ORDER_DATE, REQUIRED_DATE, STATUS)
        VALUES (1, 2, TO_DATE('2020-05-02','YYYY-MM-DD'), TO_DATE('2020-05-05','YYYY-MM-DD'), 'SHIPPING')
    INTO ORDER_GAR  (ORDER_ID, CUST_ID, ORDER_DATE, REQUIRED_DATE, STATUS)
        VALUES (2, 1, TO_DATE('2020-06-03','YYYY-MM-DD'), TO_DATE('2020-06-08','YYYY-MM-DD'), 'SHIPPING')
    INTO ORDER_GAR  (ORDER_ID, CUST_ID, ORDER_DATE, REQUIRED_DATE, STATUS)
        VALUES (3, 3,TO_DATE('2020-05-07','YYYY-MM-DD'), TO_DATE('2020-05-11','YYYY-MM-DD'), 'DELIVERED')
    INTO ORDER_GAR  (ORDER_ID, CUST_ID, ORDER_DATE, REQUIRED_DATE, STATUS)
        VALUES (4, 2, TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-05-21','YYYY-MM-DD'), 'SHIPPING')
    INTO ORDER_GAR  (ORDER_ID, CUST_ID, ORDER_DATE, REQUIRED_DATE, STATUS)
        VALUES (5, 4,TO_DATE('2020-06-04','YYYY-MM-DD'), TO_DATE('2020-06-09','YYYY-MM-DD'), 'DELIVERED')
SELECT 1 FROM DUAL;
```

6. Write 15 queries, as complex as possible, to illustrate the following learned aspects:
   - the clauses GROUP BY, HAVING, START WITH, CONNECT BY, ORDER BY;
   - functions for working with strings and calendar data (LOWER, UPPER, SUBSTR, INSTR, TO_CHAR, TO_DATE, ADD_MONTHS, MONTHS_BETWEEN etc.);
   - various functions (DECODE, NVL, NULLIF, CASE, etc.);
   - INNER, LEFT, RIGHT, FULL JOIN;
   - operators on sets;
   - multiple-row / aggregate functions (AVG, SUM, MIN, MAX, COUNT);
   - subqueries in the clauses: SELECT, FROM, WHERE, HAVING;
   - DIVISION operator.
   
```
-- 1. GROUP BY, HAVING, COUNT

-- Count all the employees who are sellers, grouped by their job title.

SELECT COUNT(EMP_ID), JOB_TITLE
FROM EMPLOYEE_GAR
GROUP BY JOB_TITLE
HAVING JOB_TITLE LIKE 'SELLER';

-- 2. GROUP BY, HAVING, ORDER BY

-- Display, in descending order, 
-- all the offices, grouped by the country they are in.
-- (Only include offices in east european countries)

SELECT COUNT(CODE), COUNTRY
FROM OFFICE_GAR
GROUP BY COUNTRY
HAVING COUNTRY IN ('ROMANIA', 'RUSSIA', 'UKRAINE')
ORDER BY COUNT(CODE) DESC;

-- 3. SUBSTR, WHERE

-- Display all the orders that were requested in 2020 and also delivered.

SELECT *
FROM ORDER_GAR
WHERE SUBSTR(ORDER_DATE, 7, 4) = '2020' 
        AND STATUS = 'DELIVERED';

-- 4. DECODE

-- Check which bank SWIFT code is BRDEROBU.

SELECT BANK_NAME,
DECODE (SWIFT_CODE, 'BRDEROBU', SWIFT_CODE,
                   'NO RESULT') RESULT
FROM BANK_GAR;

-- 5. CASE, NULL

-- Order customers by their address. 
-- If address is null, order by their last name

SELECT *
FROM CUSTOMER_GAR
ORDER BY
(CASE
    WHEN ADDRESS IS NULL THEN LAST_NAME
    ELSE ADDRESS
END);

-- 6. INNER JOIN

-- Display which order belongs to which customer,
-- ordered by most recent orders.

SELECT *
FROM ORDER_GAR OG
INNER JOIN CUSTOMER_GAR CG ON OG.CUST_ID = CG.CUST_ID
ORDER BY OG.ORDER_DATE DESC;

-- 7. RIGHT JOIN

-- Display all the employees that had or not customers

SELECT *
FROM CUSTOMER_GAR CG
RIGHT JOIN EMPLOYEE_GAR EG ON CG.SALES_EMP_ID = EG.EMP_ID;

-- 8. UNION

-- Display all the distinct last names from both customers and employee tables
-- ordered in ascending order by their last name

SELECT LAST_NAME FROM CUSTOMER_GAR
UNION
SELECT LAST_NAME FROM EMPLOYEE_GAR
ORDER BY LAST_NAME;

-- 9. INTERSECT

-- Display all the identical last names from both customers and employee tables

SELECT LAST_NAME FROM CUSTOMER_GAR
INTERSECT
SELECT LAST_NAME FROM EMPLOYEE_GAR;

-- 10. AVG, SUBQUERY, WHERE

-- Display all the payments, where the paid amount is greater 
-- than the average paid amount, ordered by amount.

SELECT *
FROM PAYMENT_GAR
WHERE AMOUNT > (
      SELECT AVG(AMOUNT)
        FROM PAYMENT_GAR
)
ORDER BY AMOUNT DESC;

-- 11. COUNT, GROUP BY, HAVING

-- Count all the employees whose last name start with letter A,
-- grouped by their last name.

SELECT COUNT(EMP_ID), LAST_NAME
FROM EMPLOYEE_GAR
GROUP BY LAST_NAME
HAVING LAST_NAME LIKE 'A%';

-- 12. MIN, MAX, UNION ALL

-- Display the minimum paid amount in the history of the shop
-- and the maximum, also, even it is the same value.

SELECT MIN(AMOUNT)
FROM PAYMENT_GAR
UNION ALL
SELECT MAX(AMOUNT)
FROM PAYMENT_GAR;

-- 13. SELECT, FROM, WHERE, IN SUBQUERY

-- Display all employees who have the same last name
-- as the customers.

SELECT *
FROM EMPLOYEE_GAR
WHERE LAST_NAME IN (
    SELECT LAST_NAME
    FROM CUSTOMER_GAR
);

-- 14. SELECT, FROM, WHERE, IN SUBQUERY

-- Display all the banks who are used in payments by customers.

SELECT *
FROM PAYMENT_GAR
WHERE BANK_NAME IN (
    SELECT BANK_NAME
    FROM BANK_GAR
);

-- 15. DIVISION (NOT EXISTS) OPERATOR (with subquery)

-- Display all the employers that do not have yet customers

SELECT EG.EMP_ID, EG.LAST_NAME, EG.FIRST_NAME
FROM EMPLOYEE_GAR EG
WHERE NOT EXISTS (
    SELECT *
    FROM CUSTOMER_GAR CG
    WHERE EG.EMP_ID = CG.SALES_EMP_ID
);
```

**NOTE:** Results of the queries from the ”SQL” script can be seen [here](https://github.com/JusticeBringer/DB-Design-Queries/blob/master/queries.pdf).
