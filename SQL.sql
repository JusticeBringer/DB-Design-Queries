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