-- ------------------------------
-- DBS311 - Lab 6 (PL/SQL part 2)
-- Clint MacDonald
-- Nov 2021
-- SOLUTIONS
-- ------------------------------
SET SERVEROUTPUT ON;

-- Question 1
CREATE OR REPLACE FUNCTION fncCalcFactorial (numIn IN int) RETURN int IS
    retVal int := 1;
BEGIN
    FOR i IN 2..numIn LOOP
        retVal := retVal * i;
    END LOOP;
    RETURN retVal;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error has occured!');
        RETURN 0;
END fncCalcFactorial;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Factorial of 2 is: ' || fncCalcFactorial(2));
    DBMS_OUTPUT.PUT_LINE('Factorial of 5 is: ' || fncCalcFactorial(5));
    DBMS_OUTPUT.PUT_LINE('Factorial of 8 is: ' || fncCalcFactorial(8));
END;
/
-- Question 2
CREATE OR REPLACE PROCEDURE spCalcCurrentSalary (
    empID IN int, 
    firstName OUT employees.first_name%type,
    lastName OUT employees.last_name%type,
    hiredate OUT employees.hire_date%type,
    salary OUT decimal, 
    vacWeeks OUT int) AS
    startingSalary decimal := 0;
    yearsWorked int := 0;
BEGIN
    SELECT 
        first_name, last_name, hire_date,
        salary, 
        abs(trunc(months_between(sysdate, hire_date) / 12))
        INTO firstName, lastName, hireDate, startingSalary, yearsWorked
    FROM employees 
    WHERE employee_id = empID;
    
    salary := startingSalary;
    FOR i IN 1..yearsWorked LOOP
        salary := salary * 1.04;
    END LOOP;
    
    IF (yearsWorked < 3) THEN
        vacWeeks := 2;
    ELSIF (yearsWorked < 6) THEN
        vacWeeks := yearsWorked;
    ELSE
        vacWeeks := 6;
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('The individual employee could not be determined!');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The employee was not found!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An undetermined error occured!');
END spCalcCurrentSalary;
/

-- Execute 2
    DECLARE
        salaryOut employees.salary%type := 0.0;
        vacWeeksOut int := 0;
        empID int := 201;
        fname employees.first_name%type := '';
        lname employees.last_name%type := '';
        hireDate date;
    BEGIN
        spCalcCurrentSalary(empID, fName, lName, hireDate, salaryOut,vacWeeksOut);
        
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || empID);
        DBMS_OUTPUT.PUT_LINE('First Name: ' || fName);
        DBMS_OUTPUT.PUT_LINE('Last Name: ' || lName);
        DBMS_OUTPUT.PUT_LINE('Hire Date: ' || to_char(hireDate, 'Mon. dd, yyyy'));
        DBMS_OUTPUT.PUT_LINE('Employee Current Salary: $' || salaryOut);
        DBMS_OUTPUT.PUT_LINE('Vacation Weeks: ' || vacWeeksOut);
    END;            
/

-- Question 3
CREATE OR REPLACE PROCEDURE spDepartmentsReport IS
    CURSOR depts IS 
        SELECT d.department_ID AS dID, department_name as dN, city, NVL(COUNT(employee_id), 0) AS numEmps
        FROM employees e 
            RIGHT JOIN departments d ON e.department_id = d.department_id
            LEFT JOIN locations l ON d.location_id = l.location_id
        GROUP BY d.department_id, department_name, city          
        ORDER BY department_name;
BEGIN    
    DBMS_OUTPUT.PUT_LINE('  DeptID  Department       City           NumEmp');
    FOR r IN depts LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(r.dID,6,' ') || '  ' 
            || RPAD(r.dN, 15, ' ') || '  ' 
            || RPAD(r.city, 12, ' ') || '  ' 
            || LPAD(r.numEmps, 7, ' '));
    END LOOP;
    IF depts%ISOPEN THEN 
        CLOSE depts;  
    END IF;
END;
/
-- execute Q3
BEGIN
    spDepartmentsReport();
END;
/

-- Q4a

CREATE OR REPLACE FUNCTION fncDetermineWinningTeam 
    ( gID INT ) RETURN INT IS
    hteamID INT;
    hScore INT;
    vteamID INT;
    vScore INT;
    isPlay INT;
BEGIN
    SELECT hometeam, homescore, visitteam, visitscore, isplayed 
        INTO hteamID, hScore, vteamID, vScore, isPlay
    FROM games
    WHERE gameID = gID;
    
    IF isPlay = 0 THEN
        RETURN -1;
    ELSIF hscore = vscore THEN 
        RETURN 0;
    ELSIF hscore > vscore THEN
        RETURN hteamID;
    ELSE 
        RETURN vteamID;
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS
        THEN 
            DBMS_OUTPUT.PUT_LINE('Too many rows were returned from your query!');
            RETURN -99;
    WHEN NO_DATA_FOUND
        THEN 
            DBMS_OUTPUT.PUT_LINE('No game was found using that gameID!');
            RETURN -98;
    WHEN OTHERS
        THEN 
            DBMS_OUTPUT.PUT_LINE('An unknown error occured!');
            RETURN -97;
END fncDetermineWinningTeam;

-- Execute 4a
BEGIN
    DBMS_OUTPUT.PUT_LINE( 'GameID 56: - Winner: ' || fncDetermineWinningTeam(56) );
    DBMS_OUTPUT.PUT_LINE( 'GameID 33: - Winner: ' || fncDetermineWinningTeam(33) );
    DBMS_OUTPUT.PUT_LINE( 'GameID 23: - Winner: ' || fncDetermineWinningTeam(23) );
END;
-- or
SELECT fncDetermineWinningTeam(3) AS WINNINGTEAM FROM dual;

-- Q4b
SELECT 
    wteamID, 
    CASE wteamID
        WHEN 0 THEN 
            'TIES'
        ELSE
            (SELECT teamname FROM teams WHERE teamID = wteamID)
        END AS teamName,
    COUNT(wteamID) AS numWins
FROM (
    SELECT fncDetermineWinningTeam(gameID) AS wteamID
    FROM games
    WHERE isPlayed = 1)
GROUP BY wteamID
ORDER BY numWins DESC;
