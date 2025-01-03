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
		createLocation(playerid);
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