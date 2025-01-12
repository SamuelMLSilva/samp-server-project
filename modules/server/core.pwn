#include <YSI_Coding\y_hooks>

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 1) {
        if(IsPlayerInAnyVehicle(playerid)) {
            if(RELEASED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                RepairVehicle(GetPlayerVehicleID(playerid));
                RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                return 1;
            }
            if(HOLDING(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                RepairVehicle(GetPlayerVehicleID(playerid));
                AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                return 1;
            }  
        }
    }
    return 1;
}

stock getDateServer() {
    new result[64], day, month, year;
    getdate(year, month, day);
    format(result, sizeof(result),"%02d/%02d/%02d", day, month, year);
    return result;
}

stock getTimeServer() {
    new result[64], hour, minute, second;
    gettime(hour, minute, second);
    format(result, sizeof(result),"%02d:%02d:%02d", hour, minute, second);
    return result;
}