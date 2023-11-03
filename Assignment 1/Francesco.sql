-- ***************************************
-- DBS311 - Fall 2023
-- Assignment 1
--
-- <Francesco Elizalde>
-- <117258210>
-- <oct 13 2023>
-- ***************************************

-- Question 1
SELECT
    employee_id,
    Substr(last_name || ', ' || first_name, 0, 25 ) AS fullName,
    job_id,
    TO_CHAR(Last_Day(hire_date), '[fmMonth ddth "of" YYYY]') AS hire_date
FROM employees;

-- Question 2
SELECT
    'Emp# ' || employee_id ||
    ' named ' || fullName ||
    ' who is ' || job_id ||
    ' will have a new salary of $ ' || salaryNew AS EmployeesWithIncreasedPay
FROM (
    SELECT
        employee_id,
        job_id,
        first_name || ' ' || last_name AS fullName,
        CASE
            WHEN Upper(job_id) LIKE '%VP%' THEN salary + (salary * .25)
            WHEN Upper(job_id) LIKE '%MAN%' THEN salary + (salary * .18)
            WHEN Upper(job_id) LIKE '%MGR%' THEN salary + (salary * .18)
            ELSE salary
            END AS salaryNew
        FROM employees
        WHERE salary NOT BETWEEN 6500 AND 11500
            )
WHERE UPPER(job_id) LIKE '%VP%' OR UPPER(job_id) LIKE '%MAN%';

-- Question 3
SELECT
    last_name,
    salary,
    job_id,
    NVL(TO_CHAR(manager_id), 'NONE') AS Manager#,
    '$' || To_char(Round(salary * 12 + 1000, 2), '999,999.99') AS TotalIncome
FROM employees
WHERE (commission_pct IS NULL OR department_id = (SELECT department_id FROM departments WHERE UPPER(department_name) LIKE 'SALES'))
AND
(salary + (salary * nvl(commission_pct, 0))) + 1000 > 15000;

-- Question 4
SELECT
   department_id,
    job_id,
    MIN(salary) AS "lowestDept/jobPay"
FROM employees
GROUP BY department_id, job_id
HAVING MIN(salary) BETWEEN 6500 AND 16800
MINUS
SELECT
    e.department_id,
    job_id,
    MIN(salary)
FROM
    employees e LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE
    UPPER(job_id) LIKE '%REP%'
    OR Upper(d.department_name) = 'IT'
    OR Upper(d.department_name) = 'SALES'
GROUP BY e.department_id, job_id;

-- Question 5
SELECT
    last_name,
    salary,
    job_id
FROM employees
WHERE salary > ALL(
    SELECT MIN(salary)
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN locations l ON d.location_id = l.location_id
    WHERE l.country_id NOT LIKE 'US'
    GROUP BY e.department_id
    )
    AND job_id NOT LIKE '%AD%'
    AND job_id NOT LIKE '%PRES%'
ORDER BY job_id ASC;

-- Question 6
SELECT
    last_name,
    salary,
    job_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE
        UPPER(department_name) LIKE 'IT'
        OR UPPER(department_name) LIKE 'MARKETING'
)
AND salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE
        UPPER(department_name) LIKE 'ACCOUNTING'
));

-- Question 7
SELECT
    SUBSTR(first_name || ' ' || last_name, 0, 24) AS Employee,
    job_id,
    LPAD(TO_CHAR(ROUND(salary), '$999,999'), 15, '=') AS Salary,
    department_id
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE
        job_id NOT LIKE '%PRES%' AND
        job_id NOT LIKE '%MAN%' AND
        job_id NOT LIKE '%VP%'
)
AND department_id IN (
    SELECT department_id
    FROM departments
    WHERE UPPER(department_name) IN ('SALES', 'MARKETING')
)
ORDER BY employee;

-- Question 8
    SELECT
    department_name,
    SUBSTR(NVL(city, 'Not Assigned Yet'), 0, 22) AS City,
    COUNT(DISTINCT job_id) AS "# of Jobs"
FROM (
    SELECT 
        department_name, 
        city, 
        job_id
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN locations l ON d.location_id = l.location_id
    UNION
    SELECT 
        department_name, 
        city, 
        job_id
    FROM employees e
    RIGHT JOIN departments d ON e.department_id = d.department_id
    RIGHT JOIN locations l ON d.location_id = l.location_id
    WHERE d.department_id IS NULL
)
GROUP BY department_name, City
ORDER BY department_name;