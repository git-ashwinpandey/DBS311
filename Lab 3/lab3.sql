-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 2nd October, 2023
-- Purpose: Lab 3 DBS301
-- ***********************

--1
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, department_id, manager_id, salary, commission_pct)
VALUES (207, 'Ashwin', 'Pandey', 'apandey21@myseneca.ca', SYSDATE, 'IT_PROG', 90, 100, NULL, 0.21);

--2
UPDATE employees
SET salary = 2500
WHERE LOWER(last_name) IN ('matos', 'whalen');

--3
COMMIT;


--4
SELECT last_name
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE LOWER(last_name) LIKE 'abel'
    )
ORDER BY last_name ASC;


--5
SELECT last_name
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
)
ORDER BY last_name ASC;

--6
SELECT city
FROM locations
WHERE location_id IN (
    SELECT location_id
    FROM departments
    WHERE department_id IN (
        SELECT department_id
        FROM employees
        WHERE SALARY = (
            SELECT MIN(salary)
            FROM employees
        )
    )
)
ORDER BY city ASC;

--7
SELECT
    last_name,
    department_id,
    salary
FROM employees
WHERE (department_id, salary) IN (
    SELECT department_id, MIN(salary)
    FROM employees
    WHERE department_id IN (
        SELECT DISTINCT(department_id)
        FROM employees
    )
    GROUP BY department_id
);


--8
SELECT
    city,
    last_name,
    salary
FROM employees
WHERE;

SELECT *
FROM locations
WHERE (location_id, city) IN (
    SELECT location_id, city
    FROM locations
    WHERE location_id IN (
        SELECT *
        FROM departments
        WHERE (department_id, last_name, salary) IN (
            SELECT department_id, last_name, salary
            FROM employees
        )
    )
);


select location_id from DEPARTMENTS;

SELECT city
FROM locations
WHERE (location_id) IN (
    SELECT location_id
    FROM departments
);

SELECT DISTINCT city, (
    SELECT last_name
    FROM employees e2
    WHERE e2.city = e1.city
    AND e2.salary = (
        SELECT MIN(salary)
        FROM employees
        WHERE city = e1.city
    )
) AS lowest_paid_employee_last_name
FROM employees e1;


--10
SELECT
    last_name,
    job_id,
    salary
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    WHERE job_id = 
)
