-- ********************************
-- DBS311 NEE - Week 9 Lecture Demo
-- Clint MacDonald
-- Nov 7, 2023
-- Last Week of PL/SQL
-- ********************************
SET SERVEROUTPUT ON;

-- parameters and cursors

-- example: return all the players with the given initials (parameters) 
DECLARE
    player players%ROWTYPE;
    CURSOR pc ( fLetter CHAR, lLetter CHAR ) IS
        SELECT * FROM players
        WHERE UPPER(firstName) LIKE UPPER(fLetter) || '%'
            AND UPPER(lastName) LIKE UPPER(lLetter) || '%'
        ORDER BY lastname, firstname;
BEGIN
    OPEN pc('C','M');
        LOOP
            FETCH pc INTO player;
            EXIT WHEN pc%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(
                RPAD(player.firstname, 15, ' ') ||
                RPAD(player.lastname, 15, ' ') ||
                player.regNumber
            );
        END LOOP;
    CLOSE pc;
END;

-- CURSOR with FOR LOOP
DECLARE
    CURSOR pc ( fLetter CHAR, lLetter CHAR ) IS
        SELECT * FROM players
        WHERE UPPER(firstName) LIKE UPPER(fLetter) || '%'
            AND UPPER(lastName) LIKE UPPER(lLetter) || '%'
        ORDER BY lastname, firstname;
BEGIN
    
    FOR someVarName IN pc('C','M') LOOP -- auto OPEN the cursor, define someVarName as type ROW
            DBMS_OUTPUT.PUT_LINE(
                RPAD(someVarName.firstname, 15, ' ') ||
                RPAD(someVarName.lastname, 15, ' ') ||
                someVarName.regNumber
            ); 
    END LOOP;

END;

-- Hungarian Notation
-- all datatypes are defined with a 2 or 3 letter prefix
-- vw   - VIEW
-- sp   - Stored PROCEDURE
-- fnc  - Function
-- trg  - Trigger
-- seq  - Sequence

-- ***************************************
-- UDFs - User Defined Function

-- functions act the same as all functions you have learned before...
/*
MATH  - f(x) = y = 5x + 2
EXCEL - SUM(A1:C5)
JAVA  - INT FUNCTION fncName()
JAVA  - VOID FUNCTION fncName() -- Nothing return

-- STUFF IN, ONE thing out!
*/

CREATE OR REPLACE FUNCTION fncFindHigherNumber ( num1 INT, num2 INT ) 
    RETURN INT IS
BEGIN
    IF num2 > num1 THEN
        RETURN num2;
    ELSE 
        RETURN num1;
    END IF;
END fncFindHigherNumber;
-- ALL PATHS throught the function MUST result in a RETURN statement!

-- use the function
BEGIN
    DBMS_OUTPUT.PUT_LINE( fncFindHigherNumber(12, 24) ); -- 24
    DBMS_OUTPUT.PUT_LINE( fncFindHigherNumber(36, 15) ); -- 36
    DBMS_OUTPUT.PUT_LINE( fncFindHigherNumber(12, 12) ); -- 12
    DBMS_OUTPUT.PUT_LINE( fncFindHigherNumber(09, 10) ); -- 10
    DBMS_OUTPUT.PUT_LINE( fncFindHigherNumber(2, 10) );  -- 10
END;

-- test with SQL
SELECT 
    gameID,
    homescore,
    visitscore,
    fncFindHigherNumber(homescore, visitscore) AS higherScore
FROM games
ORDER BY gameID;

-- new example
-- UDFs with SQL and Declared local variables
CREATE OR REPLACE FUNCTION fncMostGoalsInAGame RETURN NUMBER IS 
    maxG NUMBER := 0;
BEGIN
    SELECT NVL(MAX(numGoals),0) INTO maxG
    FROM goalScorers;
    
    RETURN maxG;
END fncMostGoalsInAGame;

BEGIN
    DBMS_OUTPUT.PUT_LINE('The most goals in a game was: ' || fncMostGoalsInAGame() );
END;

-- back in week 4
SELECT
    firstname,
    lastname,
    fncMostGoalsInAGame() AS MaxGoals
FROM players
WHERE playerID IN (
    SELECT playerID FROM goalscorers WHERE numGoals = fncMostGoalsInAGame()
    );

-- repetitive tasks
CREATE OR REPLACE FUNCTION fncConcatNames (name1 VARCHAR, name2 VARCHAR) 
    RETURN VARCHAR IS
BEGIN
    RETURN INITCAP(name1) || ' ' || INITCAP(name2);
END;

-- use it
SELECT
    firstname,
    lastname,
    fncConcatNames(firstname, lastname) AS fullName
FROM players
ORDER BY lastname, firstname;

-- Functions with SQL Data
CREATE OR REPLACE FUNCTION fncGetPlayerData ( pID INT ) 
    RETURN players%ROWTYPE IS
    
    playerData players%ROWTYPE;
BEGIN

    SELECT * INTO playerData
    FROM players
    WHERE playerID = pID;

    RETURN playerData;
END fncGetPlayerData;

-- use it
DECLARE 
    playerData players%ROWTYPE;
BEGIN
    playerData := fncGetPlayerData(1348882);
    
    DBMS_OUTPUT.PUT_LINE(
        'Player: ' ||
        fncConcatNames(playerData.firstname, playerData.lastname) ||
        ' - ' || playerData.regNumber
    );

END;







