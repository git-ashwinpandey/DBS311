-- ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 10th November, 2023
-- Purpose: Lab 6 DBS301
-- ***********************



SET SERVEROUTPUT ON;

-- Question 1
CREATE OR REPLACE FUNCTION fncCalcFactorial(num1 INT)
    RETURN INT IS
    result NUMBER := 1;
BEGIN
    IF num1 < 0 THEN
        RAISE VALUE_ERROR;
    END IF;

    FOR i IN 1..num1 LOOP 
        result := result * i;
    END LOOP;

    RETURN result;

    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Number cannot be less than 0');
END fncCalcFactorial;

--USE
BEGIN
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(0) );
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(4) ); 
    DBMS_OUTPUT.PUT_LINE( fncCalcFactorial(5) );
END;



--Question 2
CREATE OR REPLACE PROCEDURE spCalcCurrentSalary (
    empID NUMBER,
    first_name OUT VARCHAR2,
    last_name OUT VARCHAR2,
    hire_date OUT DATE,
    salary OUT NUMBER,
    vacation_week OUT NUMBER
) AS
    date_now DATE;
    years_worked NUMBER;
BEGIN
    SELECT first_name, last_name, hire_date, NVL(salary,0) 
    INTO first_name, last_name, hire_date, salary
    FROM employees
    WHERE employee_id = empID;

    vacation_week := 2;
    date_now := sysdate;
    years_worked := TRUNC(MONTHS_BETWEEN(date_now, hire_date) / 12);

    FOR i IN 1..years_worked LOOP
        salary := salary * 1.04;
        IF i > 3 AND vacation_week < 6 THEN
            vacation_week := vacation_week + 1;
        END IF;
    END LOOP;

END spCalcCurrentSalary;

--USE
DECLARE
    employee_id NUMBER := 102;
    out_first_name VARCHAR2(50);
    out_last_name VARCHAR2(50);
    out_hire_date DATE;
    out_salary NUMBER;
    out_vacation_weeks NUMBER;

BEGIN
    spCalcCurrentSalary(employee_id, out_first_name, out_last_name, out_hire_date, out_salary, out_vacation_weeks);
    
    DBMS_OUTPUT.PUT_LINE(RPAD('First Name: ', 22, ' ') || out_first_name);
    DBMS_OUTPUT.PUT_LINE(RPAD('Last Name: ', 22, ' ') || out_last_name);
    DBMS_OUTPUT.PUT_LINE(RPAD('Hire Date: ', 22, ' ') || TO_CHAR(out_hire_date, 'fmDD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('Calculated Salary: ', 22, ' ') || TO_CHAR(out_salary, 'fm$99999.99'));
    DBMS_OUTPUT.PUT_LINE(RPAD('Vacation Weeks: ', 22, ' ') || out_vacation_weeks);
END;



--Question 3
CREATE OR REPLACE PROCEDURE spDepartmentsReport
AS
    CURSOR dept_cursor IS 
        SELECT d.department_id, d.department_name, city, COUNT(employee_id)
        FROM departments d
            LEFT JOIN locations l ON d.location_id = l.location_id
            LEFT JOIN employees e ON d.department_id = e.department_id
        GROUP BY d.department_id, d.department_name, city
        ORDER BY d.department_name;
    department_id NUMBER;
    department VARCHAR2(50);
    city VARCHAR2(50);
    num_employee NUMBER;
BEGIN
    OPEN dept_cursor;

    DBMS_OUTPUT.PUT_LINE(RPAD('DeptID', 15, ' ') || RPAD('Department', 20, ' ') || RPAD('City', 25, ' ') || 'NumEmp');
    LOOP
        FETCH dept_cursor INTO department_id, department, city, num_employee;
        EXIT WHEN dept_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(department_id, 15, ' ') || 
            RPAD(department, 20, ' ') || 
            RPAD(city, 25, ' ') || 
            num_employee
        );
    END LOOP;

    CLOSE dept_cursor;
END spDepartmentsReport;

--USE
BEGIN
    spDepartmentsReport;
END;

--Question 4(a)
CREATE OR REPLACE FUNCTION spDetermineWinningTeam(gameNumber NUMBER)
    RETURN NUMBER IS
    result NUMBER := -1;
    homeScore NUMBER;
    visitScore NUMBER;
    visitTeam NUMBER;
    homeTeam NUMBER;
    gamePlayed NUMBER;
BEGIN
    SELECT hometeam, visitteam, homescore, visitscore, isplayed
    INTO homeTeam, visitTeam, homeScore, visitScore , gamePlayed
    FROM games
    WHERE gameid = gameNumber;

    IF gamePlayed = 0 THEN
        result := -1;
    ELSIF visitScore > homeScore THEN
        result := visitTeam;
    ELSIF homescore > visitScore THEN
        result := homeTeam;
    ELSE 
        result := 0;
    END IF;

    RETURN result;

    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Too many rows found');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Cannot find gameid: ' || result);
    
END spDetermineWinningTeam;

--USE
BEGIN
    DBMS_OUTPUT.PUT_LINE( 'Result: ' || spDetermineWinningTeam(10) );
    DBMS_OUTPUT.PUT_LINE( 'Result: ' || spDetermineWinningTeam(87) );
    DBMS_OUTPUT.PUT_LINE( 'Result: ' || spDetermineWinningTeam(88) );
END;


--Question 4(b)
SELECT spDetermineWinningTeam(GAMEID), count(spDetermineWinningTeam(GAMEID))
from games
group by spDetermineWinningTeam(GAMEID);

--OR 

SELECT
    teamid,
    teamname,
    COUNT(*) AS total_games_played,
    SUM(CASE WHEN spDetermineWinningTeam(gameid) = teamid THEN 1 ELSE 0 END) AS total_games_won
FROM
    teams
    LEFT JOIN games ON teams.teamid = games.hometeam OR teams.teamid = games.visitteam
GROUP BY
    teamid, teamname;
