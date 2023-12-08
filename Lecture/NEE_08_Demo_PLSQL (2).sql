-- ************************************
-- DBS311 NEE - Week 8
-- Clint MacDonald
-- October 31, 2023
-- PL/SQL Continued - Loops and Cursors
-- ************************************
SET SERVEROUTPUT ON;
/*
LOOPS
    4 types of LOOPS
    - BASIC Loop
    - WHILE Loop
    - FOR Loop
    - Cursor For Loop

-- plan or strategy
    - entry condition
    - iterations
    - increment
    - exit strategy - MOST IMPORTANT!

    FOR (INT i=0; i < 10; i++) {}
*/

-- 1) BASIC LOOPS

-- example: OUTPUT the powers of 2 (binary numbers (bits and bytes))
DECLARE 
    currentNum  INT := 0;
    maxNum      INT := 32;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    
    LOOP  -- WARNING: this is an infinite loop BY DEFAULT
        DBMS_OUTPUT.PUT_LINE('Power: ' || currentNum || ' - ' || POWER(2, currentNum));
        currentNum := currentNum + 1;
        
        -- exit strategy - method 1
        /*
        IF currentNum >= maxNum THEN
            EXIT;
        END IF; */
        
        -- exit strategy - method 1
        EXIT WHEN currentNum >= maxNum;
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;

-- NESTED LOOPING

-- example:  multiplication table
DECLARE
    r NUMBER := 0;
    c NUMBER := 0;
    max# NUMBER := &num;
    rowString VARCHAR2(255) := '';
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    LOOP -- rows
        rowString := LPAD(r, 3, ' ') || ' - ';
    
        LOOP -- columns
            rowString := rowString || LPAD(r*c, 4, ' ');
            c := c + 1;
            EXIT WHEN c > max#;
        END LOOP; -- columns
        DBMS_OUTPUT.PUT_LINE(rowString);
        c := 0;         -- reset column to 0
        r := r + 1;     -- move to the next row
        
        EXIT WHEN r > max#;
    END LOOP; -- rows 
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;
    
-- CONTINUE and CONTINUE WHEN
-- same as skip

DECLARE
    Counter INT := 0;
    exitNum INT := 10;
BEGIN
    LOOP
        Counter := Counter + 1;
        CONTINUE WHEN Counter = 3;
        DBMS_OUTPUT.PUT_LINE(Counter);
        EXIT WHEN Counter >= exitNum;
    END LOOP;
END;

-- 2) WHILE LOOP
DECLARE
    i INT := 0;
    maxNum INT := 10;
BEGIN
    WHILE i <= maxNum LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
    
-- 3) FOR LOOP
BEGIN
    FOR i IN 0..10 LOOP  -- note: inclusive
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
-- reverse FOR LOOP
BEGIN
    FOR i IN REVERSE 0..10 LOOP  -- note: inclusive
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
    
    
-- ********************************************
-- CURSORS
-- ********************************************

/*
    Implicit and Explicit Cursors
  
    Implicit
    - already show - typically pre-built
        - SQL%ROWCOUNT - number of rows effected in the previously run SQL statement
        - %TYPE - obtain the type of the object in front of the %
        - SQL%FOUND - BOOLEAN, if last statement effected at least one row
        - SQL%NOTFOUND - opposite of %FOUND
        - %ROWTYPE - the type of a row
        
    Exclusive
    - almost always custom built
    - analogy would be an array of JavaScript Objects or Array of Class Objects
         - OUTPUT of a SELECT statement can be put in a cursor...
*/  

-- example
-- Output all employees with the letter M in their job title!
DECLARE 
    lName employees.last_name%TYPE;
    fName employees.first_name%TYPE;
    jTitle employees.job_id%TYPE;
    CURSOR c IS
        SELECT last_name, first_name, job_id FROM employees
        WHERE UPPER(job_id) LIKE '%M%' ORDER BY last_name, first_name;
BEGIN
    -- DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 40, '-'));
    -- using the cursor
    OPEN c;  -- execute the SQL statement and store it in c.
        -- columns headers
        DBMS_OUTPUT.PUT_LINE( RPAD('First Name',15,' ') || RPAD('Last Name',15,' ') || 'Title');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 45, '-'));
        LOOP
            FETCH c INTO lName, fName, jTitle;  -- grabs the NEXT row and fills INTO the variables
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE( RPAD(fName,15,' ') || RPAD(lName,15,' ') || jTitle);
        END LOOP;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 40, '-'));
END;
    




