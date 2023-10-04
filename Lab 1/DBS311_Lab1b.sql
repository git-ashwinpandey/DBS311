-- ***************************************
-- DBS311 - Fall 2022
-- Lab 1b
-- Review of JOIN statements
-- 
-- Ashwin Pandey
-- 156027211
-- 18th September, 2023
-- ***************************************

/* 
NOTES
-- Make sure you follow the course style guide for SQL as posted on blackboard.
-- Data should always be sorted in a logical way, for the question, even if the 
   question does not specify to sort it.
*/

-- Q1
/* 
Provide a list of ALL departments, what city they are located in, and the name
of the current manager, if there is one.  
*/
SELECT department_name, city, first_name || ' ' || last_name "Manager"
FROM departments d
   LEFT JOIN employees e
      ON d.manager_id = e.employee_id
   LEFT JOIN locations l
      ON d.location_id = l.location_id
ORDER BY department_name, city;

-- Q2
/*
Allow the user to enter the name of a country, or any part of the name, and 
then list all employees, with their job title, currently working in that country.
*/

SELECT first_name || ' ' || last_name "Name", job_id, country_name Country
FROM employees e
   LEFT JOIN departments d
      ON e.department_id = d.department_id
   LEFT JOIN locations l
      ON d.location_id = l.location_id
   LEFT JOIN countries c
      ON l.country_id = c.country_id
WHERE upper(country_name) LIKE upper('&userInput') || '%'
ORDER BY "Name", country_name;

-- Q3
/*
Provide a contact list of all employees, and if they have a manager, 
the name of their direct manager.
*/
SELECT e.first_name || ' ' || e.last_name "Employee Name", e.email, e.phone_number Phone , m.first_name || ' ' || m.last_name "Manager"
FROM employees e
   LEFT JOIN employees m  
      ON e.manager_id = m.employee_id
ORDER BY "Employee Name", "Manager";

-- Q4
/*
Provide a list of locations in the database, that currently do not have 
any employees working there.
*/
SELECT l.location_id "Location ID", street_address "Address", city
FROM locations l
   LEFT JOIN departments d
      ON l.location_id = d.location_id
   LEFT JOIN employees e
      ON d.department_id = e.department_id
WHERE e.employee_id IS NULL
ORDER BY city, "Location ID";

-- Q5
/*
Provide a list of employees whom are currently still in the same job that they
started in (i.e. they have never changed job titles).
*/

SELECT e.first_name || ' ' || e.last_name "Employee Name", e.job_id
FROM employees e
   LEFT JOIN job_history J
      ON e.employee_id = j.employee_id
WHERE j.department_id IS NULL
ORDER BY "Employee Name";
