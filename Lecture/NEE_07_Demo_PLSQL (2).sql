-- *******************************
-- DBS311 Week 7 - Lecture Demo
-- Clint MacDonald
-- Oct 17, 2023
-- PL/SQL Introduction Continued
-- *******************************
SET SERVEROUTPUT ON;

-- more on SPs
-- parameters with the same names as fields
CREATE OR REPLACE PROCEDURE spInsertPeople2 (
    firstName VARCHAR2, 
    lastName VARCHAR2,
    dob DATE,
    isActive NUMERIC,
    favNum INT
) AS
newPID INT := 0;
BEGIN
    INSERT INTO xPeople p (p.firstName, p.lastName, p.dob, p.isActive, p.favNum)
        VALUES (firstName, lastName, dob, isActive, favNum);
    
    SELECT pID INTO newPID
    FROM xPeople
    WHERE rownum = 1
    ORDER BY pID DESC;
    
    DBMS_OUTPUT.PUT_LINE('Insert was successful: ' || newPID);
    
EXCEPTION
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('Insertion failed, an error occured');
END spInsertPeople2;

-- Execute it
BEGIN
    spInsertPeople2('Jim', 'Smith', sysdate, 1, 4);
END;

-- IN OUT parameters
CREATE OR REPLACE PROCEDURE spInsertPeople3 (
    firstName VARCHAR2,   -- IN parameters by default
    lastName VARCHAR2,
    dob DATE,
    isActive IN NUMERIC,
    favNum IN INT,
    newPeepID OUT INT    -- OUT - output parameter
) AS
BEGIN
    INSERT INTO xPeople p (p.firstName, p.lastName, p.dob, p.isActive, p.favNum)
        VALUES (firstName, lastName, dob, isActive, favNum);
    
    SELECT pID INTO newPeepID
    FROM xPeople
    WHERE rownum = 1
    ORDER BY pID DESC;
    
    DBMS_OUTPUT.PUT_LINE('Insert was successful: ' || newPeepID);
    
EXCEPTION
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('Insertion failed, an error occured');
END spInsertPeople3;

-- execute it
DECLARE 
    newPID INT := 0;
BEGIN
    spInsertPeople3( 'Ruth', 'Marks', sysdate, 1, 4, newPID );
    DBMS_OUTPUT.PUT_LINE('The new peopleID is: ' || newPID || '.');
END;

-- Multiple IN or OUT parameters
CREATE OR REPLACE PROCEDURE spInsertPeople4 (
    firstName varchar2,  -- IN by default if not specified
    lastName varchar2,
    dob date, isActive IN numeric, favNum IN int,
    peepID OUT int,
    numPeeps OUT int
    ) AS
BEGIN
    INSERT INTO xPeople p  (p.firstName, p.lastName, p.dob, p.isactive, p.favNum)
        VALUES (firstName, lastName, dob, isActive, favNum);
        
    SELECT pID INTO peepID FROM xPeople WHERE rownum = 1 ORDER BY pID DESC;
    
    SELECT COUNT(pID) INTO numPeeps FROM xPeople;
    
    DBMS_OUTPUT.PUT_LINE('Insert Successful');
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('An error occured');
END spInsertPeople4;

-- Execute it
DECLARE
    newPeepID INT := 0;
    numPeeps INT := 0;
BEGIN
    spInsertPeople4('Sarah', 'Jones', sysdate, 1, 4, newPeepID, numPeeps);
    DBMS_OUTPUT.PUT_LINE('The new people ID is: ' || newPeepID || '.');
    DBMS_OUTPUT.PUT_LINE('There are ' || numPeeps || ' people in the table!');
END;

-- IN OUT at the same time
CREATE OR REPLACE PROCEDURE spNewSalary ( salary IN OUT float ) AS
BEGIN
    salary := ROUND(salary * 1.2, 2);
END spNewSalary;

-- execute it
DECLARE 
    myMonthlySalary float := ROUND( 123849.45/12, 2 );
BEGIN
    DBMS_OUTPUT.PUT_LINE('The old salary was: $' || myMonthlySalary);
    spNewSalary(myMonthlySalary);
    DBMS_OUTPUT.PUT_LINE('The new salary was: $' || myMonthlySalary);
END;

-- --------------------------------
-- Conditional statements 
-- explicit cursor attributes
-- --------------------------------
SELECT * FROM xPeople;

-- procedure to delete people
CREATE OR REPLACE PROCEDURE spDelPeep(peepID xPeople.pid%TYPE) AS
BEGIN
    DELETE FROM xPeople WHERE pID = peepID;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Person with pID ' || peepID || ' did not exist!');
    ELSIF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Person with pID ' || peepID || ' was deleted successfully!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Uh Oh! MULTIPLE rows were deleted!!!!');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');
END spDelPeep;

-- execute it
BEGIN
    spDelPeep(26);
END;

-- CASE SELECT
CREATE OR REPLACE PROCEDURE spDelPeep2(peepID xPeople.pid%TYPE) AS
BEGIN
    DELETE FROM xPeople WHERE pID = peepID;
    
    CASE SQL%ROWCOUNT
        WHEN 0 THEN
            DBMS_OUTPUT.PUT_LINE('Person with pID ' || peepID || ' did not exist!');
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('Person with pID ' || peepID || ' was deleted successfully!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Uh Oh! MULTIPLE rows were deleted!!!!');
    END CASE;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');
END spDelPeep2;

BEGIN 
    spDelPeep2(22);
    spDelPeep2(23);
    spDelPeep2(24);
END;




