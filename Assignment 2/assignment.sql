-- ***********************
-- Name:
--      1. Ashwin Pandey (156027211)
--      2. Francesco Elizalde (117258210)
-- Group: 10
-- Date: 29thth November, 2023
-- Purpose: Assignment 1 - DBS301
-- ***********************

SET SERVEROUTPUT ON;


------------------------------------------------------------------
-- QUESTION 1
------------------------------------------------------------------


/*
  --------------------------------------------------------------
  -------------------------- PLAYERS ---------------------------
  --------------------------------------------------------------
  This section includes procedures and functions related to the 
  management of player information within the database.

  - spPlayersInsert: Inserts a new player into the 'players' table.
  - spPlayersUpdate: Updates the information of an existing player.
  - spPlayersDelete: Deletes a player from the 'players' table.
  - spPlayersSelect: Retrives data of a players from the players table
*/

--PLAYERS INSERT
CREATE OR REPLACE PROCEDURE spPlayersInsert(
    p_playerid IN players.playerid%TYPE,
    p_regnumber IN players.regnumber%TYPE,
    p_lastname IN players.lastname%TYPE,
    p_firstname IN players.firstname%TYPE,
    p_isactive IN players.isactive%TYPE,
    o_playerid OUT players.playerid%TYPE
) 
AS
BEGIN
    INSERT INTO players (playerid, regNumber, lastname, firstname, isActive)
    VALUES (p_playerid, p_regnumber, p_lastname, p_firstname, p_isactive);

    select playerid INTO o_playerid
    FROM players
    WHERE rownum = 1
    ORDER BY playerid DESC;

    -- If the player ID is NULL, set the error code
    IF o_playerid IS NULL THEN
        o_playerid := -1;
    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN
        o_playerid := -1;
    WHEN OTHERS THEN
        o_playerid := -2;
END spPlayersInsert;

--PLAYERS UPDATE
CREATE OR REPLACE PROCEDURE spPlayersUpdate(
    p_playerid IN players.playerid%TYPE,
    p_regnumber IN players.regnumber%TYPE,
    p_lastname IN players.lastname%TYPE,
    p_firstname IN players.firstname%TYPE,
    p_isactive IN players.isactive%TYPE,
    o_playerid OUT players.playerid%TYPE
) AS
BEGIN
    UPDATE players
    SET regNumber = p_regnumber,
        lastname = p_lastname,
        firstname = p_firstname,
        isActive = p_isactive
    WHERE playerid = p_playerid;

    select playerid INTO o_playerid
    FROM players
    WHERE playerid = p_playerid;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        o_playerid := -3;
    WHEN VALUE_ERROR THEN
        o_playerid:= -1;
    WHEN OTHERS THEN
        o_playerid := -2;
END spPlayersUpdate;

--PLAYERS DELETE
CREATE OR REPLACE PROCEDURE spPlayersDelete(
    p_playerid IN players.playerid%TYPE,
    o_playerid OUT players.playerid%TYPE
) AS
BEGIN
    select playerid INTO o_playerid
    FROM players
    WHERE playerid = p_playerid;

    DELETE FROM players WHERE playerid = p_playerid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Could not find playerid: ' || p_playerid);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Deletion failed, an error occured');
END spPlayersDelete;

--PLAYERS SELECT
CREATE OR REPLACE PROCEDURE spPlayersSelect(
    p_playerid IN INT,
    p_regnumber OUT VARCHAR2,
    p_lastname OUT VARCHAR2,
    p_firstname OUT VARCHAR2,
    p_isactive OUT INT,
    o_playerid OUT INT
) AS
BEGIN
    SELECT playerid, regNumber, lastname, firstname, isActive
    INTO o_playerid, p_regnumber, p_lastname, p_firstname, p_isactive
    FROM players
    WHERE playerid = p_playerid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Fetching data failed, an error occured');
END spPlayersSelect;

/*
  --------------------------------------------------------------
  -------------------------- TEAMS ---------------------------
  --------------------------------------------------------------
  This section includes procedures and functions related to the 
  management of team information within the database.

  - spTeamsInsert: Inserts a new player into the 'players' table.
  - spTeamsUpdate: Updates the information of an existing player.
  - spTeamsDelete: Deletes a player from the 'players' table.
  - spTeamsSelect: Retrives data of a players from the players table
*/

-- TEAMS INSERT
CREATE OR REPLACE PROCEDURE spTeamsInsert(
    p_teamid IN INT,
    p_teamname IN VARCHAR2,
    p_isactive IN INT,
    p_jerseycolour IN VARCHAR2,
    o_teamid OUT INT
) AS
BEGIN
    INSERT INTO teams(teamid, teamname, isActive, jerseyColour)
    VALUES (p_teamid, p_teamname, p_isactive, p_jerseycolour);

    select teamid INTO o_teamid
    FROM teams
    WHERE rownum = 1
    ORDER BY teamid DESC;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Insertion failed, an error occured');
END spTeamsInsert;

-- TEAMS UPDATE
CREATE OR REPLACE PROCEDURE spTeamsUpdate(
    p_teamid IN INT,
    p_teamname IN VARCHAR2,
    p_isactive IN INT,
    p_jerseycolour IN VARCHAR2,
    o_teamid OUT INT
) AS
BEGIN
    UPDATE teams
    SET teamname = p_teamname,
        isActive = p_isactive,
        jerseyColour = p_jerseycolour
    WHERE teamid = p_teamid;

    select teamid INTO o_teamid
    FROM teams
    WHERE teamid = p_teamid;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Update failed, an error occured');
END spTeamsUpdate;

-- TEAMS DELETE
CREATE OR REPLACE PROCEDURE spTeamsDelete(
    p_teamid IN INT,
    o_teamid OUT INT
) AS
BEGIN

    select teamid INTO o_teamid
    FROM teams
    WHERE teamid = p_teamid;

    DELETE FROM teams WHERE teamid = p_teamid;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Deletion failed, an error occured');
END spTeamsDelete;

-- TEAMS SELECT
CREATE OR REPLACE PROCEDURE spTeamsSelect(
    p_teamid IN INT,
    p_teamname OUT VARCHAR2,
    p_isactive OUT INT,
    p_jerseycolour OUT VARCHAR2,
    o_teamid OUT INT
) AS
BEGIN
    SELECT teamid, teamname, isActive, jerseyColour
    INTO o_teamid, p_teamname, p_isactive, p_jerseycolour
    FROM teams
    WHERE teamid = p_teamid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Fetching data failed, an error occured');
END spTeamsSelect;

/*
  --------------------------------------------------------------
  ---------------------------ROSTER ----------------------------
  --------------------------------------------------------------
  This section includes procedures and functions related to the 
  management of rosters, which represent the association between 
  players and teams.

  - spRosterAssign: Assigns a player to a team in the 'roster' table.
  - spRosterRemove: Removes a player from a team in the 'roster' table.
  - spRosterView: Displays the roster information for a specific team.
*/

-- ROSTER INSERT
CREATE OR REPLACE PROCEDURE spRostersInsert(
    p_rosterid IN INT,
    p_playerid IN INT,
    p_teamid IN INT,
    p_isactive IN INT,
    p_jerseynumber IN INT,
    o_rosterid OUT INT
) AS
BEGIN
    INSERT INTO rosters(rosterid, playerid, teamid, isactive, jerseynumber)
    VALUES (p_rosterid, p_playerid, p_teamid, p_isactive, p_jerseynumber);

    SELECT rosterid INTO o_rosterid
    FROM rosters
    WHERE ROWNUM = 1
    ORDER BY rosterid DESC;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Insertion failed, an error occured');
END spRostersInsert;

-- ROSTER UPDATE
CREATE OR REPLACE PROCEDURE spRostersUpdate(
    p_rosterid IN INT,
    p_playerid IN INT,
    p_teamid IN INT,
    p_isactive IN INT,
    p_jerseynumber IN INT,
    o_rosterid OUT INT
) AS
BEGIN
    UPDATE rosters
    SET playerID = p_playerid,
        teamID = p_teamid,
        isActive = p_isactive,
        jerseynumber = p_jerseynumber
    WHERE rosterID = p_rosterid;

    SELECT rosterid INTO o_rosterid
    FROM rosters
    WHERE rosterID = p_rosterid;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Update failed, an error occured');
END spRostersUpdate;

-- ROSTER DELETE
CREATE OR REPLACE PROCEDURE spRostersDelete(
    p_rosterid IN INT,
    o_rosterid OUT INT
) AS
BEGIN
    SELECT rosterid INTO o_rosterid
    FROM rosters
    WHERE rosterID = p_rosterid;

    DELETE FROM rosters WHERE rosterID = p_rosterid;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Deletion failed, an error occured');
END spRostersDelete;

-- ROSTER SELECT
CREATE OR REPLACE PROCEDURE spRostersSelect(
    p_rosterid IN INT,
    p_playerid OUT INT,
    p_teamid OUT INT,
    p_isactive OUT INT,
    p_jerseynumber OUT INT,
    o_rosterid OUT INT
) AS
BEGIN
    SELECT rosterid, playerid, teamid, isactive, jerseynumber
    INTO o_rosterid, p_playerid, p_teamid, p_isactive, p_jerseynumber
    FROM rosters
    WHERE rosterid = p_rosterid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Fetching data failed, an error occured');
END spRostersSelect;


------------------------------------------------------------------
-- QUESTION 2
------------------------------------------------------------------

-- PLAYERS SELECT ALL
CREATE OR REPLACE PROCEDURE spPlayersSelectAll AS
    p_playerid players.playerID%TYPE;
    p_regnumber players.regNumber%TYPE;
    p_lastname players.lastname%TYPE;
    p_firstname players.lastname%TYPE;
    p_isactive players.isActive%TYPE;
    
    CURSOR players_cursor IS
        SELECT playerid, regnumber, lastname, firstname, isactive FROM players;
        
BEGIN
    OPEN players_cursor;
    LOOP
        FETCH players_cursor INTO p_playerid, p_regnumber, p_lastname, p_firstname, p_isactive;
        EXIT WHEN players_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Player ID: ' || p_playerid || ' || RegNumber: ' || p_regnumber ||
                             ' || Lastname: ' || p_lastname || ' || Firstname: ' || p_firstname ||
                             ' || IsActive: ' || p_isactive);
    END LOOP;
    CLOSE players_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spPlayersSelectAll;



-- TEAMS SELECT ALL
CREATE OR REPLACE PROCEDURE spTeamsSelectAll AS
    p_teamid teams.teamid%TYPE;
    p_teamname teams.teamname%TYPE;
    p_isactive teams.isactive%TYPE;
    p_jerseycolour teams.jerseycolour%TYPE;
    
    CURSOR teams_cursor IS
        SELECT teamid, teamname, isactive, jerseycolour FROM teams;
        
BEGIN
    OPEN teams_cursor;
    LOOP
        FETCH teams_cursor INTO p_teamid, p_teamname, p_isactive, p_jerseycolour;
        EXIT WHEN teams_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Team ID: ' || p_teamid || ' || Teamname: ' || p_teamname ||
                             ' || isActive: ' || p_isactive || ' || Jersey Colour: ' || p_jerseycolour);
    END LOOP;
    CLOSE teams_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spTeamsSelectAll;

-- ROSTER SELECT ALL
CREATE OR REPLACE PROCEDURE spRostersSelectAll AS
    p_rosterid rosters.rosterID%TYPE;
    p_playerid rosters.playerID%TYPE;
    p_teamid rosters.teamid%TYPE;
    p_isactive rosters.isActive%TYPE;
    p_jerseynumber rosters.jerseynumber%TYPE;
    
    CURSOR rosters_cursor IS
        SELECT rosterid, playerid, teamid, isactive, jerseynumber FROM rosters;
        
BEGIN
    OPEN rosters_cursor;
    LOOP
        FETCH rosters_cursor INTO p_rosterid, p_playerid, p_teamid, p_isactive, p_jerseynumber;
        EXIT WHEN rosters_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Roster ID: ' || p_rosterid || ' || Player ID: ' || p_playerid ||
                             ' || Team ID: ' || p_teamid || ' || IsActive: ' || p_isactive ||
                             ' || JerseyNumber: ' || p_jerseynumber);
    END LOOP;
    CLOSE rosters_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spRostersSelectAll;


------------------------------------------------------------------
-- QUESTION 3
------------------------------------------------------------------

--PLAYERS TABLE
CREATE OR REPLACE PROCEDURE spPlayersSelectAllv3(
    p_result_table OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_result_table FOR
        SELECT playerid, regnumber, lastname, firstname, isactive
        FROM players;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

END spPlayersSelectAllv3;

-- Non-saved Procedure to Call the Stored Procedure and Output Result
DECLARE
    v_playerid players.playerID%TYPE;
    v_regnumber players.regNumber%TYPE;
    v_lastname players.lastname%TYPE;
    v_firstname players.lastname%TYPE;
    v_isactive players.isActive%TYPE;
    v_result_cursor SYS_REFCURSOR;
BEGIN
    -- Call the stored procedure and pass the cursor as an output parameter
    spPlayersSelectAllv3(v_result_cursor);
    
    -- Loop through the result set and output the data to the script window
    LOOP
        FETCH v_result_cursor INTO v_playerid, v_regnumber, v_lastname, v_firstname, v_isactive;
        EXIT WHEN v_result_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Player ID: ' || v_playerid || ' || RegNumber: ' || v_regnumber ||
                             ' || Lastname: ' || v_lastname || ' || Firstname: ' || v_firstname ||
                             ' || IsActive: ' || v_isactive);
    END LOOP;
    
    CLOSE v_result_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;


-- TEAMS TABLE
CREATE OR REPLACE PROCEDURE spTeamsSelectAllv3(
    p_result_table OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_result_table FOR
        SELECT teamid, teamname, isActive, jerseycolour
        FROM teams;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

END spTeamsSelectAllv3;

-- Non-saved Procedure to Call the Stored Procedure and Output Result
DECLARE
    v_teamid teams.teamID%TYPE;
    v_teamname teams.teamname%TYPE;
    v_isactive teams.isActive%TYPE;
    v_jerseycolour teams.jerseycolour%TYPE;
    v_result_cursor SYS_REFCURSOR;
BEGIN
    -- Call the stored procedure and pass the cursor as an output parameter
    spTeamsSelectAllv3(p_result_table => v_result_cursor);
    
    -- Loop through the result set and output the data to the script window
    LOOP
        FETCH v_result_cursor INTO v_teamid, v_teamname, v_isactive, v_jerseycolour;
        EXIT WHEN v_result_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Team ID: ' || v_teamid || ' || Teamname: ' || v_teamname ||
                             ' || isActive: ' || v_isactive || ' || Jersey Colour: ' || v_jerseycolour);
    END LOOP;
    
    CLOSE v_result_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

-- ROSTER TABLE
CREATE OR REPLACE PROCEDURE spRosterSelectAllv3(
    p_result_table OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_result_table FOR
        SELECT rosterid, playerid, teamid, isActive, jerseynumber
        FROM rosters;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

END spRosterSelectAllv3;

-- Non-saved Procedure to Call the Stored Procedure and Output Result
DECLARE
    v_rosterid rosters.rosterID%TYPE;
    v_playerid rosters.playerID%TYPE;
    v_teamid rosters.teamID%TYPE;
    v_isactive rosters.isActive%TYPE;
    v_jerseynumber rosters.jerseynumber%TYPE;
    v_result_cursor SYS_REFCURSOR;
BEGIN
    -- Call the stored procedure and pass the cursor as an output parameter
    spRosterSelectAllv3(p_result_table => v_result_cursor);
    
    -- Loop through the result set and output the data to the script window
    LOOP
        FETCH v_result_cursor INTO v_rosterid, v_playerid, v_teamid, v_isactive, v_jerseynumber;
        EXIT WHEN v_result_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Roster ID: ' || v_rosterid || ' || Player ID: ' || v_playerid ||
                             ' || Team ID: ' || v_teamid || ' || IsActive: ' || v_isactive ||
                             ' || JerseyNumber: ' || v_jerseynumber);
    END LOOP;
    
    CLOSE v_result_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;


------------------------------------------------------------------
-- QUESTION 4
------------------------------------------------------------------

CREATE VIEW vwPlayerRosters AS
    SELECT 
        p.playerid,
        p.regnumber,
        p.lastname,
        p.firstname,
        p.isactive AS player_isactive,
        r.rosterid,
        r.teamid AS roster_teamid,
        r.isactive AS roster_isactive,
        r.jerseynumber,
        t.teamid AS team_teamid,
        t.teamname,
        t.isactive AS team_isactive,
        t.jerseycolour
    FROM players p
        JOIN rosters r ON p.playerid = r.playerid   
        JOIN teams t ON r.teamid = t.teamid;


--select * from vwPlayerRosters;
--SELECT firstname, lastname, teamname, jerseynumber from vwPlayerRosters;

------------------------------------------------------------------
-- QUESTION 5
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spTeamRosterByID(
    p_teamID IN INT,
    p_firstname OUT VARCHAR2,
    p_lastname OUT VARCHAR2,
    p_teamname OUT, VARCHAR2,
    p_jerseynumber OUT INT
) AS
BEGIN
    SELECT firstname, lastname, teamname, jerseynumber
        INTO p_firstname, p_lastname, p_teamname, p_jerseynumber
    FROM vwPlayerRosters
    WHERE teamID = p_teamID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the specified teamID: ' || p_teamID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spTeamRosterByID;


------------------------------------------------------------------
-- QUESTION 6
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spTeamRosterByName(
    p_searchName IN VARCHAR2,
    p_teamname OUT VARCHAR2,
    p_teamID OUT VARCHAR2,
    p_firstname OUT VARCHAR2,
    p_lastname OUT VARCHAR2,
    p_jerseynumber OUT INT
) AS
BEGIN
    SELECT firstname, lastname, teamname, teamid, jerseynumber
        INTO p_firstname, p_lastname, p_teamname, p_teamID, p_jerseynumber
    FROM vwPlayerRosters
    WHERE LOWER(teamname) LIKE '%' || LOWER(p_searchName) || '%';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the specified teamID: ' || p_teamID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spTeamRosterByName;

------------------------------------------------------------------
-- QUESTION 7
------------------------------------------------------------------

CREATE VIEW vwTeamsNumPlayers AS
    SELECT teamname, r.teamid AS teamID, COUNT(r.teamid) AS playerCount
    FROM rosters r
        JOIN teams t ON r.teamid = t.teamid
    GROUP BY teamname, r.teamid;

--SELECT * from vwTeamsNumPlayers;
--DROP view vwTeamsNumPlayers;

------------------------------------------------------------------
-- QUESTION 8
------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID(p_teamID INT)
    RETURN INT IS
    numPlayers INT;
BEGIN
    SELECT playerCount INTO numPlayers
    FROM vwTeamsNumPlayers
    WHERE teamid = p_teamID;

    RETURN numPlayers;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the specified teamID: ' || p_teamID);
        RETURN -1;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid value entered.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

------------------------------------------------------------------
-- QUESTION 9
------------------------------------------------------------------

CREATE VIEW vwSchedule AS
    SELECT 
        gameid, 
        gamedatetime,
        hometeam.teamname AS HomeTeam, 
        visitteam.teamname AS VisitTeam,
        sl.locationname AS location,
        isplayed,
        homescore,
        visitscore
    FROM games g
        JOIN teams homeTeam ON g.hometeam = hometeam.teamid
        JOIN teams visitTeam ON g.visitteam = visitteam.teamid
        JOIN sllocations sl ON g.locationid = sl.locationid
    ORDER BY gamedatetime;

DROP view vwSchedule;
SELECT * from vwSchedule;
------------------------------------------------------------------
-- QUESTION 10
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spSchedUpcomingGames(
    p_nextDays IN INT
) AS
    CURSOR spSchedule_cursor IS
        SELECT gameid, gamedatetime, HomeTeam, VisitTeam, location, isplayed, homescore, visitscore
        FROM vwSchedule
        WHERE gamedatetime BETWEEN sysdate AND sysdate+p_nextDays;

    p_gameid vwSchedule.gameid%TYPE;
    p_gamedatetime vwSchedule.gamedatetime%TYPE;
    p_hometeam vwSchedule.hometeam%TYPE;
    p_visitteam vwSchedule.visitteam%TYPE;
    p_location vwSchedule.location%TYPE;
    p_isplayed vwSchedule.isplayed%TYPE;
    p_homescore vwSchedule.homescore%TYPE;
    p_visitscore vwSchedule.visitscore%TYPE;

BEGIN
    open spSchedule_cursor;
    LOOP
        FETCH spSchedule_cursor INTO p_gameid, p_gamedatetime, p_hometeam, p_visitteam,
            p_location, p_isplayed, p_homescore, p_visitscore;
        EXIT WHEN spSchedule_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Game ID: ' || p_gameid ||
                             ', Game DateTime: ' || TO_CHAR(p_gamedatetime, 'YYYY-MM-DD HH24:MI:SS') ||
                             ', Home Team ID: ' || p_hometeam ||
                             ', Visit Team ID: ' || p_visitteam ||
                             ', Location: ' || p_location ||
                             ', Is Played: ' || p_isplayed ||
                             ', Home Score: ' || p_homescore ||
                             ', Visit Score: ' || p_visitscore);

    END LOOP;
    close spSchedule_cursor;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid value entered.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');
END spSchedUpcomingGames;


--USE
DECLARE
    --v_nextDays INT := 7; -- You can adjust the number of days as needed
BEGIN
    -- Call the stored procedure
    spSchedUpcomingGames(30);
END;

------------------------------------------------------------------
-- QUESTION 11
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spSchedPastGames(
    p_previousDays IN INT
) AS
    CURSOR spSchedule_cursor IS
        SELECT gameid, gamedatetime, HomeTeam, VisitTeam, location, isplayed, homescore, visitscore
        FROM vwSchedule
        WHERE gamedatetime BETWEEN sysdate-p_previousDays AND sysdate;

    p_gameid vwSchedule.gameid%TYPE;
    p_gamedatetime vwSchedule.gamedatetime%TYPE;
    p_hometeam vwSchedule.hometeam%TYPE;
    p_visitteam vwSchedule.visitteam%TYPE;
    p_location vwSchedule.location%TYPE;
    p_isplayed vwSchedule.isplayed%TYPE;
    p_homescore vwSchedule.homescore%TYPE;
    p_visitscore vwSchedule.visitscore%TYPE;

BEGIN
    open spSchedule_cursor;
    LOOP
        FETCH spSchedule_cursor INTO p_gameid, p_gamedatetime, p_hometeam, p_visitteam,
            p_location, p_isplayed, p_homescore, p_visitscore;
        EXIT WHEN spSchedule_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Game ID: ' || p_gameid ||
                             ', Game DateTime: ' || TO_CHAR(p_gamedatetime, 'YYYY-MM-DD HH24:MI:SS') ||
                             ', Home Team ID: ' || p_hometeam ||
                             ', Visit Team ID: ' || p_visitteam ||
                             ', Location: ' || p_location ||
                             ', Is Played: ' || p_isplayed ||
                             ', Home Score: ' || p_homescore ||
                             ', Visit Score: ' || p_visitscore);

    END LOOP;
    close spSchedule_cursor;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid value entered.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured');
END spSchedPastGames;

------------------------------------------------------------------
-- QUESTION 12
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spRunStandings IS
BEGIN
    DELETE FROM tempStandings;

    INSERT INTO tempStandings
    (SELECT 
        TheTeamID,
        (SELECT teamname FROM teams WHERE teamid = t.TheTeamID) AS teamname,
        SUM(GamesPlayed) AS GP,
        SUM(Wins) AS W,
        SUM(Losses) AS L,
        SUM(Ties) AS T,
        SUM(Wins)*3 + SUM(Ties) AS Pts,
        SUM(GoalsFor) AS GF,
        SUM(GoalsAgainst) AS GA,
        SUM(GoalsFor) - SUM(GoalsAgainst) AS GD
    FROM (
    
        SELECT
            hometeam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(homescore) AS GoalsFor,
            SUM(visitscore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END
                ) As Wins, 
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END
                ) As Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END
                ) As Ties    
        FROM games
        WHERE isPlayed = 1
        GROUP BY hometeam
        
        UNION ALL
        
        
        SELECT
            visitteam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(visitscore) AS GoalsFor,
            SUM(homescore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END
                ) As Wins, 
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END
                ) As Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END
                ) As Ties    
        FROM games
        WHERE isPlayed = 1
        GROUP BY visitteam ) t
    GROUP BY TheTeamID
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END spRunStandings;


-----------------
--BEGIN
--spRunStandings;
--END;


--DROP table standings;
---------------------------


------------------------------------------------------------------
-- QUESTION 13
------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_games_update
AFTER INSERT OR UPDATE ON games
BEGIN
    spRunStandings;
END tr_games_update;



------------------------------------------------------------------
-- QUESTION 14
------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE spTopGoalScorers(
    p_noOfScorers IN INT,
    o_top_scorer_table OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN o_top_scorer_table FOR
        SELECT *  
        FROM 
            (SELECT 
                lastname, 
                firstname, 
                teamname, 
                COUNT(DISTINCT(g.gameid)) AS "Games Played", 
                SUM(numgoals) AS Goals, 
                sum(numassists) "Assists"
            FROM goalscorers g
                JOIN players p ON g.playerid = p.playerid
                JOIN teams t ON g.teamid = t.teamid
            GROUP BY lastname, firstname, teamname
            ORDER BY SUM(numgoals) DESC
            )
        WHERE ROWNUM <= p_noOfScorers;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

END spTopGoalScorers;


-----------
-- Q14b. Sample Implementation of spTopGoalScorers
----------

DECLARE
    v_noOfScorers INT := 3; -- Specify the number of top scorers to retrieve
    v_result_table SYS_REFCURSOR;
    
    v_lastname VARCHAR2(50);
    v_firstname VARCHAR2(50);
    v_teamname VARCHAR2(50);
    v_games_played INT;
    v_goals INT;
    v_assists INT;
BEGIN
    spTopGoalScorers(v_noOfScorers, v_result_table);
    
    DBMS_OUTPUT.PUT_LINE('Last Name | First Name | Team Name | Games Played | Goals | Assists');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    
    LOOP
        FETCH v_result_table INTO v_lastname, v_firstname, v_teamname, v_games_played, v_goals, v_assists;
        EXIT WHEN v_result_table%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_lastname, 12) || ' | ' ||
            RPAD(v_firstname, 11) || ' | ' ||
            RPAD(v_teamname, 10) || ' | ' ||
            RPAD(TO_CHAR(v_games_played), 13) || ' | ' ||
            RPAD(TO_CHAR(v_goals), 6) || ' | ' ||
            RPAD(TO_CHAR(v_assists), 8)
        );
    END LOOP;
    
    CLOSE v_result_table;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
