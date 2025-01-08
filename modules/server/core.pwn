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