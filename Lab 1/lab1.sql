-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 11th September, 2023
-- Purpose: Lab 1 DBS301
-- ***********************


-- Question 1
/*
The statement doesn't execute because the column name "Hire_Date" is being used with a space between the names.
SQL column names cannot have space between them. 
*/

-- Correct Statement
SELECT last_name "LName",
       job_id "Job Title",
       Hire_Date "Job Start"
FROM employees;


--Question 2

SELECT employee_id,
       last_name LastName,
       TO_CHAR(salary, '$99,999.99') Income
FROM employees
WHERE salary BETWEEN 8000 AND 11000
ORDER BY salary DESC,
         last_name; 

--Question 3

SELECT employee_id ,
       last_name LastName,
       salary
FROM employees
WHERE salary BETWEEN 8000 AND 11000
ORDER BY salary DESC,
         last_name; 

-- Question 4

SELECT job_id "Job Title",
       first_name || ' ' || last_name "Full Name"
FROM employees
WHERE REGEXP_LIKE(first_name, 'e|E')
ORDER BY "Full Name", job_id;

-- Question 5
select location_id ID,
       street_address "Office Address",
       city City 
FROM locations
WHERE upper(city) LIKE upper('&userInput') || '%'
ORDER BY id,
         city;

--Question 6
SELECT TO_CHAR((CURRENT_DATE+1), 'Month Ddth "of the year" YYYY') Tomorrow
FROM DUAL;

-- Question 7
select last_name, 
       first_name,
       d.department_name,
       salary,
       (salary*1.04) "Good Salary", 
       ((salary*1.04-salary)*12) "Annual Pay Increase"
FROM employees e
INNER JOIN DEPARTMENTS d
    ON e.department_id = d.department_id
WHERE e.department_id IN (20, 50, 60)
ORDER BY last_name,
         first_name,
         department_name;

--Question 8
select last_name LName,
       hire_date "Hire Date",
       TRUNC(MONTHS_BETWEEN(current_date, hire_date)/12) "Years Worked"
FROM employees
WHERE EXTRACT(YEAR FROM (hire_date)) < 2014
ORDER BY "Years Worked" DESC;

--Question 9
SELECT city,
       country_id,
       NVL(state_province, 'Unknown Province')
FROM locations
WHERE LOWER(city) LIKE 's_______%'
ORDER BY city, 
         country_id,
         state_province;

--Question 10
SELECT last_name,
       TO_CHAR(hire_date, 'FMDAY') || ', ' || TO_CHAR(hire_date, 'FMMONTH "the" FMDdspth "of the year" YYYY') "Hire Day", 
       TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'Thursday'), 'DAY, FMMONTH "the" Ddspth "of the year" YYYY') "Review Day"
FROM employees
WHERE EXTRACT(YEAR FROM (hire_date)) > 2017
ORDER BY "Review Day";