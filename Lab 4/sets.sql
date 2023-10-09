-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 9th October, 2023
-- Purpose: Lab 4 DBS301
-- ***********************

--1
SELECT department_id
FROM departments

MINUS

SELECT department_id
FROM employees
WHERE job_id IN ('ST_CLERK');


--2
SELECT 
    country_id,
    country_name
FROM countries

MINUS

SELECT
    c.country_id,
    c.country_name
FROM countries c
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON d.location_id = l.location_id
GROUP BY c.country_id, c.country_name;

--3
SELECT 
    job_id,
    department_id
FROM employees
WHERE department_id = 10

UNION ALL

SELECT 
    job_id,
    department_id
FROM employees
WHERE department_id = 50
GROUP BY 
    job_id,
    department_id

UNION ALL

SELECT 
    job_id,
    department_id
FROM employees
WHERE department_id = 20;

--4
SELECT employee_id, job_id
FROM employees

INTERSECT

SELECT employee_id, job_id
FROM job_history;

--5
SELECT 
    e.last_name,
    e.department_id,
    department_name
FROM employees e
    LEFT JOIN departments d on e.department_id = d.department_id

UNION

SELECT 
    e.last_name,
    d.department_id,
    d.department_name
FROM departments d
    LEFT JOIN employees e on e.department_id = d.department_id
ORDER BY last_name;