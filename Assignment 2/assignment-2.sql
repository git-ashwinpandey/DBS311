-- ***************************************
-- DBS311 - Fall 2023
-- Assignment 2
--
-- <Francesco Elizalde>
-- <117258210>
-- <oct 13 2023>
-- ***************************************

SET SERVEROUTPUT ON;

/*
Error Codes:
 0 : success
-1 : no record found
-2 : more than 1 record found
-3 : general error
*/

-- Task 1
---------- PLAYER INSERT ----------
CREATE OR REPLACE PROCEDURE spPlayerInsert (
    pID OUT players.playerid%TYPE,
    regionNum players.regnumber%TYPE,
    lName players.lastname%TYPE,
    fName players.firstname%TYPE,
    active players.isactive%TYPE,
    errorCode OUT INT
) AS
BEGIN
    SELECT MAX(playerid) + 1
    INTO pID
    FROM players;

    INSERT INTO players (playerid, regnumber, lastname, firstname,isactive)
        VALUES(pID, regionNum, lName, fName, active);
    errorCode:=0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode:= -1; --players table empty
        WHEN OTHERS THEN
            errorCode:= -3; -- general error

END spPlayerInsert;

DECLARE
    player_id players.playerid%TYPE;
    region_num players.regnumber%TYPE := '123';
    last_name players.lastname%TYPE := 'bezos';
    first_name players.firstname%TYPE := 'jeff';
    active players.isactive%TYPE := 1;
    errorCode INT;
BEGIN
    spPlayerInsert(player_id, region_num, last_name, first_name,active, errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    END IF;
END;

SELECT *
FROM players
WHERE lastname LIKE 'bezos' AND firstname LIKE 'jeff';

---------- TEAM INSERT ----------
CREATE OR REPLACE PROCEDURE spTeamInsert (
    team_id OUT teams.teamid%TYPE,
    team_name teams.teamname%TYPE,
    active teams.isactive%TYPE,
    jersey_colour teams.jerseycolour%TYPE,
    errorCode OUT INT
) AS
BEGIN
    SELECT MAX(teamid) + 1
    INTO team_id
    FROM teams;

    INSERT INTO teams (teamid, teamname, isactive, jerseycolour)
        VALUES(team_id, team_name,active,jersey_colour);

    errorCode:=0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode:= -1; -- table empty
        WHEN OTHERS THEN
            errorCode:= -3; -- general error
END spTeamInsert;

DECLARE
    team_id teams.teamid%TYPE;
    team_name teams.teamname%TYPE := 'amazon';
    active teams.isactive%TYPE := 1;
    jersey_colour teams.jerseycolour%TYPE := 'orange';
    errorCode INT;
BEGIN
    spTeamInsert(team_id, team_name, active, jersey_colour,errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('SUCCESS');
    END IF; 
END;

SELECT *
FROM teams
WHERE teamname LIKE 'amazon';

SELECT MAX(teamid)
FROM teams;

---------- ROSTER INSERT ----------
CREATE OR REPLACE PROCEDURE spInsertRoster (
    roster_id OUT rosters.rosterid%TYPE,
    player_id rosters.playerid%TYPE,
    team_id rosters.teamid%TYPE,
    active rosters.isactive%TYPE,
    jersey_num rosters.jerseynumber%TYPE,
    errorCode OUT INT
) AS
BEGIN
    SELECT MAX(rosterid) + 1
    INTO roster_id
    FROM rosters;

    INSERT INTO rosters (rosterid,playerid,teamid,isactive,jerseynumber)
        VALUES(roster_id,player_id,team_id,active,jersey_num);

    errorCode:=0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode:= -1; -- table empty
        WHEN OTHERS THEN
            errorCode:= -3; -- general error
END spInsertRoster;

SELECT MAX(rosterid)
FROM rosters;

DECLARE
    roster_id OUT rosters.rosterid%TYPE;
    player_id rosters.playerid%TYPE;
    team_id rosters.teamid%TYPE;
    active rosters.isactive%TYPE;
    jersey_num rosters.jerseynumber%TYPE;
    errorCode OUT INT;
BEGIN
    spRosterInsert(p_rsoterid, p_playerid, p_teamid, p_isactive, p_jerseynumber, errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('SUCCESS');
    END IF; 
END;



---------- UPDATE PLAYER ----------
CREATE OR REPLACE PROCEDURE spPlayerUpdate (
    pID players.playerid%TYPE,
    regionNum players.regnumber%TYPE,
    lName players.lastname%TYPE,
    fName players.firstname%TYPE,
    active players.isactive%TYPE,
    errorCode OUT INT
) AS
BEGIN
    UPDATE players
        SET regnumber = regionNum,
            lastname = lName,
            firstname = fName,
            isactive = active
    WHERE playerid = pID;

    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;
END spPlayerUpdate;

SELECT *
FROM players
WHERE playerid = (SELECT MAX(playerid) FROM players);

DECLARE
    p_playerid players.playerid%TYPE := 2323745;
    p_regnumber players.regnumber%TYPE := 420;
    p_lastname players.lastname%TYPE := 'notbezos';
    p_firstname players.firstname%TYPE := 'notjeff';
    p_isactive players.isactive%TYPE := 1;
    errorCode INT;
BEGIN
    spPlayerUpdate(p_playerid, p_regnumber, p_lastname, p_firstname, p_isactive,errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    END IF; 
END;

---------- UPDATE TEAM ----------
CREATE OR REPLACE PROCEDURE spTeamUpdate (
    team_id teams.teamid%TYPE,
    team_name teams.teamname%TYPE,
    active teams.isactive%TYPE,
    jersey_colour teams.jerseycolour%TYPE,
    errorCode OUT INT
) AS
BEGIN
    UPDATE teams
        SET teamname = team_name,
            isactive = active,
            jerseycolour = jersey_colour
    WHERE teamid = team_id;

    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;
END spTeamUpdate;

SELECT *
FROM teams
WHERE teamid = (SELECT MAX(teamid) FROM teams);

DECLARE
    p_teamid teams.teamid%TYPE := 401;
    p_teamname teams.teamname%TYPE := 'notamazon';
    p_isactive teams.isactive%TYPE := 1; 
    p_jerseycolour teams.jerseycolour%TYPE := 'notorange';
    errorCode INT;
BEGIN
    spTeamUpdate(p_teamid, p_teamname, p_isactive, p_jerseycolour, errorCode);
    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('SUCCESS');
    END IF; 
END;

---------- UPDATE ROSTER ----------
CREATE OR REPLACE PROCEDURE spRosterUpdate (
    roster_id rosters.rosterid%TYPE,
    player_id rosters.playerid%TYPE,
    team_id rosters.teamid%TYPE,
    active rosters.isactive%TYPE,
    jersey_num rosters.jerseynumber%TYPE,
    errorCode OUT INT
) AS
BEGIN
    UPDATE rosters
        SET rosterid = roster_id,
            playerid = player_id,
            teamid = team_id,
            isactive = active,
            jerseynumber = jersey_num
    WHERE rosterid = roster_id;

    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;    
END spRosterUpdate;

DECLARE
    p_rosterid rosters.rosterid%TYPE := 230;
    p_playerid rosters.playerid%TYPE :=2323742;
    p_teamid rosters.teamid%TYPE := 223;
    p_isactive rosters.isactive%TYPE := 1;
    p_jerseynumber rosters.jerseynumber%TYPE := 52; --52
    errorCode INT;
BEGIN
    spRosterUpdate(p_rosterid, p_playerid, p_teamid, p_isactive, p_jerseynumber, errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('Success');
    END IF; 
END;

-- 230
SELECT * 
FROM rosters
WHERE rosterid = (SELECT MAX(rosterid) FROM rosters);

---------- PLAYER DELETE ----------
CREATE OR REPLACE PROCEDURE spPlayerDelete (
    pID players.playerid%TYPE,
    errorCode OUT INT
) AS
BEGIN
    DELETE players
    WHERE playerid = pID;
    
    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;
END spPlayerDelete;

DECLARE
    p_playerid players.playerid%TYPE := 2323745;
    errorCode INT;
BEGIN
    spPlayerDelete(p_playerid, errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('Success');
    END IF; 
END;

---------- TEAM DELETE ----------
CREATE OR REPLACE PROCEDURE spTeamDelete (
    team_id teams.teamid%TYPE,
    errorCode OUT INT
) AS
BEGIN
    DELETE teams
    WHERE teamid = team_id;
    
    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;
END spTeamDelete;

-- 401

DECLARE
    p_teamid teams.teamid%TYPE := 401;
    errorCode INT;
BEGIN
    spTeamDelete(p_teamid, errorCode);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('Success');
    END IF; 
END;

---------- ROSTER DELETE ----------
CREATE OR REPLACE PROCEDURE spRosterDelete (
    roster_id rosters.rosterid%TYPE,
    errorCode OUT INT
) AS
BEGIN
    DELETE rosters
    WHERE rosterid = roster_id;
    
    errorCode := 0;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            errorCode := -1;
        WHEN OTHERS THEN
            errorCode := -3;
END spRosterDelete;

-- 230

DECLARE
    p_rosterid rosters.rosterid%TYPE := 230;
    errorCode INT;
BEGIN
    spRosterDelete(p_rosterirosters.rosterid);

    IF errorCode != 0
        THEN
            DBMS_OUTPUT.PUT_LINE('error code: ' || errorCode);
    ELSE
        THEN
            DBMS_OUTPUT.PUT_LINE('Success');
    END IF; 
END;

-- Task 2

---------- PLAYERS SELECTALL ----------
CREATE OR REPLACE PROCEDURE spPlayerSelectAll AS
    player_id players.playerid%TYPE;
    regionNum players.regnumber%TYPE;
    lName players.lastname%TYPE;
    fName players.firstname%TYPE;
    active players.isactive%TYPE;
    errCode INT;

    CURSOR players_cursor IS
        SELECT playerid, regnumber, lastname, firstname, isactive
        FROM players;

BEGIN
    OPEN players_cursor;
    
    LOOP
        FETCH players_cursor INTO player_id, regionNum, lName, fName, active;
        EXIT WHEN players_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(LPAD(player_id,15) ||LPAD(regionNum,15) || LPAD(lName,15)|| LPAD(fName,15)|| LPAD(active,15));
    END LOOP;
    
    CLOSE players_cursor;

EXCEPTION
    WHEN OTHERS THEN
        errCode := -3;
END spPlayerSelectAll;

BEGIN
    spPlayerSelectAll;
END;

---------- TEAMS SELECTALL ----------
CREATE OR REPLACE PROCEDURE spTeamsSelectAll AS
    team_id teams.teamid%TYPE;
    team_name teams.teamname%TYPE;
    active teams.isactive%TYPE;
    jersey_colour teams.jerseycolour%TYPE;
    errCode INT:=0;

    CURSOR teams_cursor IS
        SELECT teamid, teamname, isactive, jerseycolour
        FROM teams;

BEGIN
    OPEN teams_cursor;
    
    LOOP
        FETCH teams_cursor INTO team_id, team_name, active, jersey_colour;
        EXIT WHEN teams_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(LPAD(team_id,10) || LPAD(team_name,20) || LPAD(active,10) || LPAD(jersey_colour,20));
    END LOOP;
    
    CLOSE teams_cursor;

EXCEPTION
    WHEN OTHERS THEN
        errCode := -3;
END spTeamsSelectAll;

BEGIN
    spTeamsSelectAll;
END;

---------- ROSTERS SELECTALL ----------
CREATE OR REPLACE PROCEDURE spRostersSelectAll AS
    roster_id rosters.rosterid%TYPE;
    player_id rosters.playerid%TYPE;
    team_id rosters.teamid%TYPE;
    active rosters.isactive%TYPE;
    jersey_num rosters.jerseynumber%TYPE;
    errCode INT:=0;

    CURSOR rosters_cursor IS
        SELECT rosterid, playerid, teamid, isactive, jerseynumber
        FROM rosters;

BEGIN
    OPEN rosters_cursor;
    
    LOOP
        FETCH rosters_cursor INTO roster_id, player_id, team_id, active, jersey_num;
        EXIT WHEN rosters_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(LPAD(roster_id,10) || LPAD(player_id,10) || LPAD(team_id,10) || LPAD(active,10) || LPAD(jersey_num, 10));
    END LOOP;
    
    CLOSE rosters_cursor;

EXCEPTION
    WHEN OTHERS THEN
        errCode := -3;
END spRostersSelectAll;

BEGIN
    spRostersSelectAll;
END;

-- Task 3

-- Task 4
CREATE VIEW vwPlayerRosters AS
SELECT 
    p.playerid AS playerID,
    p.isactive AS playerActive,
    firstname,
    lastname,
    rosterid,
    r.isactive AS rosterIsActive,
    t.teamid AS teamid,
    teamname,
    t.isactive As teamIsActive,
    jerseycolour
FROM players p
JOIN rosters r ON p.playerid = r.playerid
JOIN teams t ON r.teamid = t.teamid;

SELECT * FROM vwPlayerRosters;

-- Task 5

CREATE OR REPLACE PROCEDURE spTeamRosterByID(
    team_ID IN teams.teamid%TYPE
) AS
BEGIN 
    DECLARE
        fName players.firstname%TYPE; 
        lName players.lastname%TYPE;
        CURSOR playerRoster_cursor IS
            SELECT 
                firstname, 
                lastname
            FROM vwPlayerRosters
            WHERE teamid = team_ID;
    BEGIN
        OPEN playerRoster_cursor;
        LOOP
        FETCH playerRoster_cursor INTO fName, lName;
            IF playerRoster_cursor%FOUND THEN
                DBMS_OUTPUT.PUT_LINE(LPAD(fName, 25) || LPAD(lName, 25));    
            ELSE
                EXIT;
            END IF;
        END LOOP;   
        CLOSE playerRoster_cursor;
    END;
END spTeamRosterByID;

DECLARE
    teamID INT := 211;
BEGIN
    spTeamRosterByID(teamID);
END;

-- Task 6

CREATE OR REPLACE PROCEDURE spTeamRostersByName(
    team_name IN teams.teamname%TYPE
) AS
BEGIN 
    DECLARE
        fName players.firstname%TYPE;
        lName players.lastname%TYPE;
        tName teams.teamname%TYPE;
        CURSOR teamRoster_cursor IS
            SELECT firstname, lastname, teamname
            FROM vwPlayerRosters
            WHERE UPPER(teamname) LIKE '%' || UPPER(team_name) || '%';
    BEGIN
        OPEN teamRoster_cursor; 
        LOOP
        FETCH teamRoster_cursor INTO fName, lName, tName;
            IF teamRoster_cursor%FOUND THEN
                DBMS_OUTPUT.PUT_LINE(LPAD(tName, 15)|| LPAD(fName, 25) || LPAD(lName, 25));    
            ELSE
                EXIT;
            END IF;
        END LOOP;   
        CLOSE teamRoster_cursor;
    END;
END spTeamRostersByName;

DECLARE
tName teams.teamname%TYPE := 'kers';
BEGIN
    spTeamRostersByName(tName);
END;

-- Task 7

CREATE VIEW vwTeamsNumPlayers AS
SELECT teamid, COUNT(*) AS numPlayers
FROM rosters
GROUP BY teamid;

DROP VIEW vwTeamsNumPlayers;

SELECT * FROM vwTeamsNumPlayers;

-- Task 8

CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID (
    team_id INT
) RETURN INT IS
    result INT:= 0;
BEGIN
    SELECT numPlayers
    INTO result
    FROM vwTeamsNumPlayers
    where teamid = team_id;
    return result;
END;

DECLARE
    numPlayers INT := 0;
BEGIN
    numPlayers := fncNumPlayersByTeamID(210);
    DBMS_OUTPUT.PUT_LINE('210 Players: ' || numPlayers);
END;

-- Task 9

CREATE VIEW vwSchedule AS
SELECT
    gameid,
    divid,
    gameNum,
    gameDateTime,
    ht.teamName AS homeTeam,
    homeScore,
    vt.teamName AS visitTeam,
    visitScore,
    locationName,
    isPlayed,
    notes
FROM games g 
    JOIN teams ht ON g.homeTeam = ht.teamID
    JOIN teams vt ON g.visitTeam = vt.teamID
    JOIN slLocations l ON g.locationID = l.locationID;

DROP VIEW vwSchedule;

SELECT * FROM vwSchedule;

-- Task 10
CREATE OR REPLACE PROCEDURE spSchedUpcomingGames (
    nextDays NUMBER
) AS
    num_rows INT := 0;
    CURSOR games IS
    SELECT *
    FROM vwSchedule
    WHERE TRUNC(gamedatetime, 'DDD') - TRUNC(sysdate, 'DDD') - 
        BETWEEN 0 AND nextDays
        AND isPlayed = 1;
BEGIN
    FOR temp IN games
    LOOP
        DBMS_OUTPUT.PUT_LINE(
           LPAD(temp.GAMEID, 6) || LPAD(temp.DIVID, 5) 
        || LPAD(temp.GAMENUM, 7) || LPAD(temp.GAMEDATETIME, 12)
        || LPAD(temp.HOMETEAM, 8)|| LPAD(temp.HOMESCORE, 9)
        || LPAD(temp.VISITTEAM, 9)|| LPAD(temp.VISITSCORE, 10)
        || LPAD(temp.LOCATIONNAME, 22)|| LPAD(temp.ISPLAYED, 8)
        || LPAD(temp.NOTES, 4));
    num_rows := num_rows + 1;
    END LOOP;
    IF num_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No games found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred.');
END spSchedUpcomingGames;

BEGIN
    spSchedUpcomingGames(300);
END;

-- Task 11

CREATE OR REPLACE PROCEDURE spSchedPastGames (
    nextDays NUMBER
) AS
    num_rows INT := 0;
    CURSOR games IS
    SELECT *
    FROM vwSchedule
    WHERE TRUNC(sysdate, 'DDD') - TRUNC(gamedatetime, 'DDD')
        BETWEEN 0 AND nextDays
        AND isPlayed = 1;
BEGIN
    FOR temp IN games
    LOOP
        DBMS_OUTPUT.PUT_LINE(
           LPAD(temp.GAMEID, 6) || LPAD(temp.DIVID, 5) 
        || LPAD(temp.GAMENUM, 7) || LPAD(temp.GAMEDATETIME, 12)
        || LPAD(temp.HOMETEAM, 8)|| LPAD(temp.HOMESCORE, 9)
        || LPAD(temp.VISITTEAM, 9)|| LPAD(temp.VISITSCORE, 10)
        || LPAD(temp.LOCATIONNAME, 22)|| LPAD(temp.ISPLAYED, 8)
        || LPAD(temp.NOTES, 4));
    num_rows := num_rows + 1;
    END LOOP;
    IF num_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No games found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred.');
END spSchedPastGames;

BEGIN
    spSchedPastGames(300);
END;

-- Task 12

