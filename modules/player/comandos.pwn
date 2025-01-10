CMD:entrar(playerid, params[]) {
    new enterPlace = getLocalPublic(playerid);
    if(enterPlace == 0) {
        sendWarning(playerid, "Você não está em nenhum local de entrada.");
    } else {
        new i = enterPlace;
        if(PlaceInfo[playerid][lLock] == 0) {
            SetPlayerVirtualWorld(playerid, i);
            setInteriorPlace(playerid, i);
        } else {
            new str[128];
            format(str, sizeof(str), "%s %sEsse local está trancado!", MSG_PLACE, EMBED_WHITE);
            SendClientMessage(playerid, -1, str);
        }
    }
    return 1;
}

CMD:sair(playerid, params[]) {
    new exitPlace = getInLocalPublic(playerid);
    if(exitPlace == 0) {
        sendWarning(playerid, "Você não está em nenhum local de saída.");
    } else {
        new i = exitPlace;
        SetPlayerPos(playerid, PlaceInfo[i][eX], PlaceInfo[i][eY], PlaceInfo[i][eZ]);
        SetPlayerFacingAngle(playerid, PlaceInfo[i][eA]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid , 0);
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}