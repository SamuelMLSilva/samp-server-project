/*
    --> COMANDOS

	AJUDANTE --------------------------------------------------------------


	MODERADOR -------------------------------------------------------------
	/v 				->		criar veículos com pintura padrão
    /cv 			->		criar veículos com escolha de pintura

	ADMINISTRADOR ---------------------------------------------------------


	SUB-DONO --------------------------------------------------------------


	RCON, DONO ------------------------------------------------------------

    /clocal 		-> 		criar locais públicos: banco, conce, prefetiura
 */

hook OnPlayerDisconnect(playerid) {
	DestroyVehicle(CarADM[playerid]);
	return 1;
}

CMD:clocal(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 4) {
		createPlace(playerid);
		return 1;
	} else {
		return 0;
	}
}

CMD:cv(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1 || IsPlayerAdmin(playerid)) {
		new id = 0, c1 = 0, c2 = 0;
		if(sscanf(params, "iii", id, c1, c2)) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /cv [id] [cor1] [cor2]");
		new Float:a, Float:x, Float:y, Float:z;
		GetPlayerFacingAngle(playerid, a);
		GetPlayerPos(playerid, x, y, z);
		DestroyVehicle(CarADM[playerid]);
		CarADM[playerid] = CreateVehicle(id, x, y, z, a, c1, c2, -1, false);
		PutPlayerInVehicle(playerid, CarADM[playerid], 0);		
		return 1;
	} 
	return 0;
}

CMD:v(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1 || IsPlayerAdmin(playerid)) {
		new id = 0;
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /v [id]");
		new Float:a, Float:x, Float:y, Float:z;
		GetPlayerFacingAngle(playerid, a);
		GetPlayerPos(playerid, x, y, z);
		DestroyVehicle(CarADM[playerid]);
		CarADM[playerid] = CreateVehicle(id, x, y, z, a, 0, 1, -1, false);
		PutPlayerInVehicle(playerid, CarADM[playerid], 0);
		return 1;
	}
	return 0;
}

CMD:go(playerid, const params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3)
	{
		new int, Float:pos[3];
		if(sscanf(params, "dfff", int, pos[0], pos[1], pos[2])) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /go [interior] [X] [Y] [Z]");
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerInterior(playerid, int);
		return 1;
	} else {
		return 0;
	}
}

CMD:irlocal(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || IsPlayerAdmin(playerid)) {
		new str[128], i = 0;
		format(str, sizeof(str),"%s %sDigite: %s/irlocal [idLocal]", EMBED_WARNING, EMBED_WHITE, EMBED_SERVER);
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, -1, str);
		SetPlayerPos(playerid, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		new string[128];
		format(string, sizeof(string),"%s %sVocê chegou no local ID: %s%d", MSG_SERVER, EMBED_WHITE, EMBED_SERVER, i);
		SendClientMessage(playerid, -1, string);
		return 1;
	}	
	return 0;
}