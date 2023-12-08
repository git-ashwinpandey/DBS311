DECLARE
    v_playerid INT := 1;
    v_regnumber VARCHAR2(50) := '3';
    v_lastname VARCHAR2(50) := 'Dat';
    v_firstname VARCHAR2(50) := 'Test';
    v_isactive INT := 1;
    o_playerid INT;

BEGIN
    spPlayersInsert(v_playerid, v_regnumber, v_lastname, v_firstname, v_isactive, o_playerid);

    DBMS_OUTPUT.PUT_LINE('New Player ID: ' || v_playerid);
END;

--spPlayerUpdate
DECLARE
   v_player_id INT := -1; -- Replace with the desired player ID
   o_player_id INT;
BEGIN
   spPlayersUpdate(v_player_id, 'NEW_REG_NUMBER', 'NEW_LAST_NAME', 'NEW_FIRST_NAME', 1, o_player_id);

   DBMS_OUTPUT.PUT_LINE('Update details for Player ID: ' || o_player_id);
END;

--spPlayerDelete
DECLARE
   v_player_id INT := 2; -- Replace with the desired player ID
   o_player_id INT;
BEGIN
   spPlayersDelete(v_player_id,  o_player_id);

   DBMS_OUTPUT.PUT_LINE('Deleted Player ID: ' || o_player_id);
END;



--question 8
DECLARE
    in_teamid INT := 210;
    result INT;
BEGIN
    result := fncNumPlayersByTeamID(in_teamid);
    DBMS_OUTPUT.PUT_LINE('no of players: ' || result);
END;