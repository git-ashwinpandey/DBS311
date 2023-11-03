-- *********************
-- DBS311 Week 5 Lab Demo
-- Clint MacDonald
-- Oct 6, 2023
-- Sportleagues standings demo
-- ****************************
CREATE TABLE standings AS
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
    -- from the home team perspective
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
        
        -- from the perspective of the visiting team
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
    
)
;

SELECT * FROM standings

ORDER BY pts DESC, W DESC, GD DESC;




CREATE OR REPLACE TRIGGER trgUpdateStandings
AFTER INSERT OR UPDATE OF homescore,isPlayed,visitScore ON games 
BEGIN
    DELETE FROM standings;

    INSERT INTO standings (
    
    SELECT 
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
    -- from the home team perspective
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
        
        -- from the perspective of the visiting team
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
END;

SELECT * FROM standings;
UPDATE games SET homescore = 6, visitscore = 1 WHERE gameid = 1;

SELECT * from games;
