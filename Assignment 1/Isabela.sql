-- ***********************
-- Name: Isabela Hernandez
-- ID: 155679202
-- Date: October 2, 2023
-- Purpose: Assignment 1 - DBS301
-- ***********************

--1
SELECT
    employee_id,
    SUBSTR(last_name || ', ' || first_name, 1, 25) AS fullname,
    job_id,
    TO_CHAR(LAST_DAY(hire_date), 'FMMonth ddth "of" YYYY') AS "Start Date"
FROM employees
WHERE EXTRACT(MONTH FROM hire_date) IN (5, 11)
MINUS
SELECT
    employee_id,
    SUBSTR(last_name || ', ' || first_name, 1, 25) AS fullname,
    job_id,
    TO_CHAR(LAST_DAY(hire_date), 'FMMonth ddth "of" YYYY') AS "Start Date"
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) IN (2015, 2016)
ORDER BY "Start Date" DESC;


--2
--Heading
SELECT 'Employees with increased Pay' AS Heading FROM dual;
    
SELECT 
    'Emp# ' || employee_id || ' named ' || first_name || ' ' || last_name || 
    ' who is ' || job_id || ' will have a new salary of $' || 
    TO_CHAR(
        CASE 
            WHEN job_id = '%_VP' THEN salary * 1.25  -- 25% increase for Vice Presidents
            WHEN job_id LIKE '%_MGR' THEN salary * 1.18  -- 18% increase for Managers (assuming job_id starting with 'IT_')
            WHEN job_id LIKE '%_MAN' THEN salary * 1.18 --I assume MAN is manager too?
            ELSE salary
        END, 
        '9999.99'
    ) AS OutputLine
FROM employees
WHERE 
    (salary < 6500 OR salary > 11500)  -- Monthly earning outside the range $6,500 – $11,500
    AND (job_id = '%_VP' OR job_id LIKE '%_MGR' OR job_id LIKE '%_MAN')  -- Vice Presidents or Managers (assuming job_id starting with 'IT_%')
ORDER BY salary DESC;  
--the output shows $##### for Michael and Shelley, I only see money for Kevin


--3
SELECT last_name,
       salary,
       job_id,
       NVL(TO_CHAR(manager_id), 'NONE') AS Manager#,
    '$' || TO_CHAR(ROUND(salary * 12 + 1000, 2), '999,999.99') AS TotalIncome
FROM employees
WHERE (commission_pct IS NULL OR department_id = 
        (SELECT department_id
        FROM departments
        WHERE UPPER(department_name) = 'SALES'))
    AND (salary + (salary * nvl(commission_pct, 0))) + 1000 > 15000;
    
--4
--Rank function is to assign a rank to each salary per department_id and job_id
SELECT department_id,
       job_id,
       MIN(salary) AS "Lowest_Dept_Job_Pay"
FROM employees
GROUP BY department_id, job_id
HAVING MIN(salary) BETWEEN 6500 AND 16800

MINUS

SELECT e.department_id,
       job_id,
       MIN(salary)
FROM employees e
     LEFT JOIN departments d ON d.department_id = e.department_id
WHERE job_id LIKE '%REP%' 
             OR (d.department_name) = 'IT' 
             OR UPPER(d.department_name) = 'SALES'
GROUP BY e.department_id, job_id;          
             
 
--5
SELECT last_name,
       salary,
       job_id 
FROM employees 
WHERE salary > ALL
(
    SELECT MIN(salary)
    FROM employees e 
    LEFT JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN locations l ON d.location_id = l.location_id
    WHERE l.country_id != 'US'
    GROUP BY e.department_id )
    AND job_id NOT LIKE '%AD%' 
    AND job_id NOT LIKE '%PRES%'
ORDER BY job_id ASC;
    
--6
SELECT last_name,
       salary,
       job_id
FROM employees
WHERE (UPPER(job_id) LIKE '%IT%' OR UPPER(job_id) LIKE '%MK%')
      AND salary >
      (SELECT MIN(salary)
      FROM employees
      WHERE UPPER(job_id) LIKE '%AC%')
ORDER BY last_name ASC;

--7
--Left pad(LPAD), specifies the noOfChars to the left side of a string.
--This is to ensure that the result has a specified min length.
SELECT SUBSTR(first_name || ' ' || last_name, 0, 24) AS employee,
       job_id,
       LPAD(TO_CHAR(ROUND(salary), '999,999'), 15, '=') AS salary,
       department_id
FROM employees
WHERE salary <
      (SELECT MAX(salary)
      FROM employees
      WHERE employee_id NOT IN
        (SELECT DISTINCT NVL(manager_id, 0) 
        FROM employees))
    AND department_id IN
    (SELECT department_id
    FROM departments
    WHERE UPPER(department_name)
    IN ('SALES', 'MARKETING'))
ORDER BY employee ASC;
       
   
--8
SELECT department_name,
       NVL(SUBSTR(city, 0, 22), 'Not Assigned Yet') AS City,
    COUNT(UNIQUE job_id) AS "#ofJobs"
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id
GROUP BY department_name,
         city
UNION 

SELECT department_name,
       NVL(Substr(city, 0, 22), 'Not Assigned Yet') AS City,
       COUNT(UNIQUE job_id) AS "#ofJobs"
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
RIGHT JOIN locations l ON d.location_id = l.location_id
WHERE d.department_id IS NULL
GROUP BY department_name, city;
             
             
             




