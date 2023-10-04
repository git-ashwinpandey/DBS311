/*
1.	Display the employee number, full employee name, job and hire date of all employees hired in May or November of any year, with the most recently hired employees displayed first. 
•	Also, exclude people hired in 2015 and 2016.  
•	Full name should be in the form “Lastname, Firstname”  with an alias called “FullName”.
•	Hire date should point to the last day in May or November of that year (NOT to the exact day) and be in the form of [May 31<st,nd,rd,th> of 2016] with the heading Start Date. Do NOT use LIKE operator. 
•	<st,nd,rd,th> means days that end in a 1, should have “st”, days that end in a 2 should have “nd”, days that end in a 3 should have “rd” and all others should have “th”
•	You should display ONE row per output line by limiting the width of the Full Name to 25 characters. The output lines should look like this line (4 columns):
174	Abel, Ellen	SA_REP	[May 31st of 2016]
*/

--1
SELECT
    employee_id, 
    SUBSTR(last_name || ', ' || first_name, 1, 25) as Fullname,
    job_id,
    TO_CHAR(hire_date, 'FMMonth FMDdspth "of " YYYY') "Hire Day"
FROM employees
WHERE 
    EXTRACT(YEAR from hire_date) NOT IN (2015, 2016) AND
    EXTRACT(MONTH from hire_date) IN (5, 11)
ORDER BY hire_date DESC;



/*Display department name, city and number of different jobs in each department. If city is null, you should print Not Assigned Yet.
•	This column should have alias City.
•	Column that shows # of different jobs in a department should have the heading # of Jobs
•	You should display ONE row per output line by limiting the width of the City to 22 characters.
•	You need to show complete situation from the EMPLOYEE point of view, meaning include also employees who work for NO department (but do NOT display empty departments) and from the CITY point of view meaning you need to display all cities without departments as well.
*/

--8
SELECT *
FROM
    (SELECT 
        department_name,
        NVL(SUBSTR(city, 1, 22), 'Not Assigned Yet') AS city,
        COUNT(DISTINCT(employee_id)) AS "# of Jobs"
    FROM
        employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN locations l ON d.location_id = l.location_id
    GROUP BY department_name, city

    UNION

    SELECT 
        department_name,
        NVL(SUBSTR(city, 1, 22), 'Not Assigned Yet') AS city,
        COUNT(DISTINCT(employee_id)) AS "# of Jobs"
    FROM
        locations l
        LEFT JOIN departments d ON l.location_id = d.location_id
        LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY department_name, city)
ORDER BY "# of Jobs" DESC
;