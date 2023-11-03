-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 3rd November, 2023
-- Purpose: Lab 5 DBS301
-- ***********************



SET SERVEROUTPUT ON;

-- Question 1
-- ODD or EVEN
CREATE OR REPLACE PROCEDURE odd_even (
    user_number IN NUMBER
) AS
BEGIN
    IF MOD(user_number, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd');
    END IF;
EXCEPTION
    WHEN OTHERS 
        THEN DBMS_OUTPUT.PUT_LINE('Error!');
END odd_even;

DECLARE
    user_number NUMBER := 10;
BEGIN
    odd_even(user_number);
END;


--Question 2
CREATE OR REPLACE PROCEDURE find_employee (
    empID IN NUMBER,
    first_name OUT VARCHAR2,
    last_name OUT VARCHAR2,
    email OUT VARCHAR2,
    phone_number OUT VARCHAR2,
    hire_date OUT DATE,
    job_id OUT VARCHAR2
) AS
BEGIN
    SELECT first_name, last_name, email, phone_number, hire_date, job_id
    INTO first_name, last_name, email, phone_number, hire_date, job_id
    FROM employees
    WHERE employee_id = empID;
END find_employee;

DECLARE
    user_number NUMBER := 107; -- Replace 10 with your desired number
    emp_first_name VARCHAR2(50);
    emp_last_name VARCHAR2(50);
    emp_email VARCHAR2(100);
    emp_phone_number VARCHAR2(20);
    emp_hire_date DATE;
    emp_job_id VARCHAR2(10);
BEGIN
    find_employee(user_number, emp_first_name, emp_last_name, emp_email, 
        emp_phone_number, emp_hire_date, emp_job_id);
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || emp_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || emp_email);
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || emp_phone_number);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(emp_hire_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Job ID: ' || emp_job_id);
END;

-- Question 3
CREATE OR REPLACE PROCEDURE update_salary_by_dept (
    p_department_id IN employees.department_id%TYPE,
    p_percentage_increase NUMBER,
    p_row_updated OUT NUMBER
) AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * (p_percentage_increase / 100))
    WHERE 
        department_id = p_department_id AND
        salary > 0;

    p_row_updated := SQL%ROWCOUNT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
            -- Handle the case where no employees were found in the specified department.
        p_row_updated := 0;
    WHEN OTHERS THEN
            -- Handle any other exceptions as needed.
        p_row_updated := -1;   
END update_salary_by_dept;

DECLARE
    department_id NUMBER := 90; -- Replace 10 with the desired department_id
    percentage_increase NUMBER := 2.5; -- Replace with the desired percentage increase
    num_updated NUMBER;
BEGIN
    update_salary_by_dept(department_id, percentage_increase, num_updated);
    DBMS_OUTPUT.PUT_LINE('Number of Updated Rows: ' || num_updated);
END;


--Question 4
CREATE OR REPLACE PROCEDURE spUpdateSalary_UnderAvg AS
    avg_salary NUMBER;
    perc_increase NUMBER;
    p_row_updated NUMBER;
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM employees;

    IF avg_salary <= 9000 THEN
        perc_increase := 2;
    ELSIF avg_salary > 9000 THEN
        perc_increase := 1;
    END IF;

    UPDATE employees
    SET salary = salary + (salary * (perc_increase / 100))
    WHERE salary < avg_salary;

    p_row_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of Updated Rows: ' || p_row_updated);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No row updated');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');

END spUpdateSalary_UnderAvg;

BEGIN
    spUpdateSalary_UnderAvg;
END;

--Question 5
CREATE OR REPLACE PROCEDURE spSalaryReport AS
    CURSOR emp_cursor IS
        SELECT salary FROM employees;
    emp_salary NUMBER;
    avg_salary NUMBER;
    min_salary NUMBER;
    max_salary NUMBER;
    count_low NUMBER := 0;
    count_fair NUMBER := 0;
    count_high NUMBER := 0;

BEGIN
    SELECT AVG(salary), MIN(salary), MAX(salary) INTO avg_salary, min_salary, max_salary
    FROM employees;

    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO emp_salary;
            EXIT WHEN emp_cursor%NOTFOUND;
            IF emp_salary < ((avg_salary - min_salary)/2) THEN
                count_low := count_low + 1;
            ELSIF emp_salary > ((max_salary - avg_salary)/2) THEN
                count_high := count_high + 1;
            ELSIF emp_salary >= ((avg_salary - min_salary)/2) AND emp_salary <= ((max_salary - avg_salary)/2) THEN
                count_fair := count_fair + 1;
            END IF;

        END LOOP;
    CLOSE emp_cursor;
    DBMS_OUTPUT.PUT_LINE('Low: ' || count_low);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || count_fair);
    DBMS_OUTPUT.PUT_LINE('High: ' || count_high);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No row updated');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');

END spSalaryReport;

BEGIN
    spSalaryReport;
END;