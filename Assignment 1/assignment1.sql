-- ***********************
-- Name:
--      1. Ashwin Pandey (156027211)
--      2. Isabela Hernandez (155679202)
--      3. Francesco Elizalde (117258210)
-- Group: 10
-- Date: 13th October, 2023
-- Purpose: Assignment 1 - DBS301
-- ***********************



--Question 1
/* 
• Display the employee number, full employee name, job and hire date of all employees hired in May or November of any year, 
  with the most recently hired employees displayed first. 
• Also, exclude people hired in 2015 and 2016.  
• Full name should be in the form “Lastname, Firstname”  with an alias called “FullName”.
• Hire date should point to the last day in May or November of that year with the heading Start Date. 
• Do NOT use LIKE operator. 
*/

--Q1 Solution
SELECT
    employee_id, 
    SUBSTR(last_name || ', ' || first_name, 1, 25) as Fullname,
    job_id,
    TO_CHAR(LAST_DAY(hire_date), 'FMMonth ddth "of" YYYY') "Start Date"
FROM employees
WHERE 
    EXTRACT(YEAR from hire_date) NOT IN (2015, 2016) AND
    EXTRACT(MONTH from hire_date) IN (5, 11)
ORDER BY "Start Date" DESC;


--Question 2
/*
• Employees with increased Pay:
• Employee Number, Full Name, Job, Modified Salary
• Monthly earning outside $6,500 - $11,500 range
• Job titles considered: Vice President, Manager
• Salary increase for VP: 25%, Manager: 18%
• Sort output by top salaries (before increase)
• Use Wild Card characters for matching.
*/

--Q2 Solution
SELECT
    'EMP# ' || employee_id || ' named ' ||
    first_name || ' ' || last_name || ' who is ' ||
    job_id || ' will have a new salary of ' ||
    TO_CHAR((salary * 1.18), 'fm$999999') AS "Employees with increased Pay"
FROM employees
WHERE 
    (salary NOT BETWEEN 6500 AND 11500) AND
    job_id NOT LIKE '%PRES' AND job_id NOT LIKE '%VP' AND
    employee_id IN (
        SELECT manager_id
        FROM employees
    )

UNION

SELECT
    'EMP# ' || employee_id || ' named ' ||
    first_name || ' ' || last_name || ' who is ' ||
    job_id || ' will have a new salary of ' ||
    TO_CHAR((salary * 1.25), 'fm$999999') AS "Employees with increased Pay"
FROM employees
WHERE 
    (salary NOT BETWEEN 6500 AND 11500) AND
    job_id LIKE '%VP';


--Question 3
/*
• Display the employee last name, salary, job title, and manager# of employees meeting the criteria.
• Criteria:
    Employees not earning a commission OR working in the SALES department
• Total monthly salary with $1000 bonus and commission (if earned) > $15,000
• Assume all employees receive a $1000 bonus.
• If an employee does not have a manager, display "NONE" as Manager# with an alias.
• Display Total Income in the format $135,600.00.
• Sort the result by best-paid employees first.

*/
--Q3 Solution
SELECT
    last_name,
    salary,
    job_id,
    NVL(TO_CHAR(manager_id), 'NONE') AS Manager#,
    TO_CHAR(((salary + salary * nvl(commission_pct, 0)) * 12 + 1000), '$999,999.99') AS "Total Income"
FROM employees
WHERE
    (commission_pct IS NULL OR department_id = 80) AND
    (salary + (salary * nvl(commission_pct, 0)) + 1000) > 15000
ORDER BY "Total Income" DESC;

--Question 4
/*
• Display Department_id, Job_id, and the Lowest salary for this combination.
• Alias the Lowest salary as "Lowest Dept/Job Pay."
• Exclude employees with job titles containing "Representative."
• Exclude departments IT and SALES.
• Filter the results to include only salaries in the range $6,500 - $16,800.
• Sort the output by Department_id, and then by Job_id.
• Avoid using subquery method.
*/
--Q4 Solution
SELECT
    department_id,
    job_id,
    MIN(salary) AS "Lowest Dept/Job Pay"
FROM employees
WHERE salary BETWEEN 6500 AND 16800
GROUP BY
    department_id,
    job_id

MINUS

SELECT
    department_id,
    job_id,
    salary
FROM employees
WHERE 
    department_id IN (60, 80) OR
    UPPER(job_id) LIKE '%REP'

ORDER BY "Lowest Dept/Job Pay" DESC;

--Question 5
/*
• Display last_name, salary, and job for employees who earn more than the lowest paid employees per department (outside US locations).
• Exclude employees with job titles President and Vice President.
• Sort the output by job title in ascending order.
• Use a Subquery and Joining to achieve this.
*/
--Q5 Solution
SELECT
    e.last_name,
    e.salary,
    e.job_id
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE 
    l.country_id != 'US' 
    AND e.job_id NOT IN ('AD_PRES', 'AD_VP')
    AND e.salary > (
        SELECT MIN(salary)
        FROM employees e2
        WHERE 
            e2.department_id = e.department_id
    )
ORDER BY e.job_id;


--Question 6
/*
• Display last_name, salary, and job of employees in the IT or MARKETING department.
• These employees should earn more than the worst paid person in the ACCOUNTING department.
• Sort the output by last name alphabetically.
• Use ONLY the Subquery method (NO joins allowed).
*/
--Q6 Solution
SELECT
    *
FROM (
    SELECT
        last_name,
        salary,
        job_id
    FROM employees
    WHERE department_id IN (20, 60)
)
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 110
)
ORDER BY last_name ASC;

-- Question 7
/*
• Display full name (formatted as "Firstname Lastname" with the heading "Employee").
• Display job, salary (formatted as currency amount with thousand separators and no decimals, with alias "Salary").
• Display department number.
• Filter employees who earn less than the best paid unionized employee (excluding President, Managers, and VPs).
• Include employees from the SALES or MARKETING department.
• Limit the width of the "Employee" column to 24 characters.
• Sort the output alphabetically.
*/

--Q7 Solution
SELECT
    SUBSTR(first_name || ' ' || last_name, 1, 24) as Employee,
    job_id,
    RPAD('=', 15, '=') || TO_CHAR(salary, '$999,999') as salary,
    department_id
FROM (
    SELECT *
    FROM employees
    WHERE department_id IN (20, 80)
)
WHERE salary < (
    SELECT MAX(salary)
    FROM (
        select *
        FROM 
            employees
        WHERE employee_id NOT IN (
            SELECT DISTINCT(NVL(manager_id, 0))
            FROM employees
        )
    )
)
ORDER BY Employee, job_id, salary;

-- Question 8
/*
• Display department name, city (with "Not Assigned Yet" for null values and alias "City"), 
    and the number of different jobs in each department (with the heading "# of Jobs").
• Include employees who work for NO department but exclude empty departments.
• Also, include cities without departments.
• Limit the width of the "City" column to 22 characters.
• Provide a complete situation from the EMPLOYEE point of view.
• Provide a complete situation from the CITY point of view.
*/

--Q8 Solution
SELECT *
FROM
    (SELECT 
        department_name,
        NVL(SUBSTR(city, 1, 22), 'Not Assigned Yet') AS city,
        COUNT(DISTINCT(job_id)) AS "# of Jobs"
    FROM
        employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN locations l ON d.location_id = l.location_id
    GROUP BY department_name, city

    UNION

    SELECT 
        department_name,
        NVL(SUBSTR(city, 1, 22), 'Not Assigned Yet') AS city,
        COUNT(DISTINCT(job_id)) AS "# of Jobs"
    FROM
        locations l
        LEFT JOIN departments d ON l.location_id = d.location_id
        LEFT JOIN employees e ON d.department_id = e.department_id
    WHERE d.department_id IS NULL
    GROUP BY department_name, city)
ORDER BY "# of Jobs" DESC;