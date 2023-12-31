-------------------------------------------------------
-- Lab 2 Solution files
-----------------------------------------------------------------
-- Question 1
SELECT 
    to_char(
        round(
            avg(salary + salary * nvl(commission_pct,0)) 
            - min(salary + salary * nvl(commission_pct,0))
            ,2)
        , '$99,999.99') AS RealAmount 
FROM employees;
-----------------------------------------------------------------
-- Question 2
SELECT  
	department_ID AS DeptID,
	max(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct,0)) AS High,
	min(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct,0)) AS Low,
	avg(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct,0)) AS Avg
FROM employees
GROUP BY department_id
ORDER BY round(avg(salary + salary * nvl(commission_pct,0)),2) DESC;  
	-- note, do not sort using the alias as it is now a string

-----------------------------------------------------------------
-- Question 3
SELECT
	department_id,
    job_id,
    count(employee_id) AS HowMany
FROM employees
GROUP BY department_id, job_id
HAVING Count(employee_id) > 1
ORDER BY HowMany DESC;
-----------------------------------------------------------------
-- Question 4
SELECT
	job_id,
    SUM(salary + salary * nvl(commission_pct,0)) AS AmountPaid
FROM employees
WHERE upper(job_id) NOT IN ('AD_PRES','AD_VP')
GROUP BY job_id
HAVING SUM(salary + salary * nvl(commission_pct,0)) > 11000
ORDER BY AmountPaid DESC;
-----------------------------------------------------------------
-- Question 5
SELECT
	manager_id,
    count(employee_id) AS numEmployees
FROM employees
WHERE manager_id NOT IN (100,101,102)
GROUP BY manager_id
HAVING count(employee_id) > 2
ORDER BY numEmployees DESC;
-----------------------------------------------------------------
-- Question 6
SELECT  
	department_id,
    max(hire_date) AS LastHireDate,
    min(hire_date) AS EarliestHireDate
FROM employees
WHERE department_id NOT IN (10, 20)
GROUP BY department_id
HAVING  
	extract(year from max(hire_date)) < 2021
	--OR extract(year from max(hire_date)) >= 2031
ORDER BY LastHireDate DESC;
