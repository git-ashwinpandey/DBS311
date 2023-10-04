-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 25th September, 2023
-- Purpose: Lab 2 DBS301
-- ***********************

--1
SELECT AVG(NVL(salary, 0)) - MIN(salary) "Average - Lowest Pay"
FROM employees;


--2
SELECT
    d.department_id,
    TO_CHAR(MAX(NVL(e.salary, 0)), '$999,999,999.99') AS "Highest Pay",
    TO_CHAR(MIN(NVL(e.salary, 0)), '$999,999,999.99') AS "Lowest Pay",
    TO_CHAR(AVG(NVL(e.salary, 0)), '$999,999,999.99') AS "Average Pay"
FROM
    departments d
LEFT JOIN
    employees e ON d.department_id = e.department_id
GROUP BY
    d.department_id
ORDER BY
    "Average Pay" DESC;

--3
SELECT 
    d.department_id AS Dept#,
    e.job_id Job,
    COUNT(e.job_id) "How Many"
FROM departments d 
    JOIN employees e ON d.department_id = e.department_id
GROUP BY 
    d.department_id, e.job_id
HAVING
    COUNT(e.job_id) > 1
ORDER BY
    "How Many" DESC;


--4
SELECT 
    job_id "Job",
    SUM((salary + NVL(commission_pct, 0)*salary)) "Monthly"
FROM employees
WHERE job_id NOT IN ('AD_PRES', 'AD_VP')
GROUP BY
    job_id
HAVING 
    SUM((salary + NVL(commission_pct, 0)*salary)) > 11000
ORDER BY
    "Monthly" DESC;


--5
SELECT 
    manager_id "Manager",
    COUNT(manager_id) "Supervising"
FROM employees
WHERE manager_id NOT IN (100, 101, 102)
GROUP BY 
    manager_id
HAVING
    COUNT(manager_id) > 0
ORDER BY 
    "Supervising";

--6
SELECT 
    department_name Department,
    MIN(hire_date) "Earliest Hire Date",
    MAX(hire_date) "Latest Hire Date"
FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
WHERE 
    d.department_id NOT IN (10,20)
GROUP BY
    department_name
HAVING
    MAX(hire_date) < TO_DATE('2021-01-01', 'YYYY-MM-DD')
ORDER BY
    MAX(hire_date);