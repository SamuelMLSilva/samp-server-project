/*
    --> COMANDOS

	AJUDANTE --------------------------------------------------------------


	MODERADOR -------------------------------------------------------------
	/v 				->		criar veículos com pintura padrão
    /cv 			->		criar veículos com escolha de pintura

	ADMINISTRADOR ---------------------------------------------------------
	/irlocal		->		ir até um local pelo ID

	SUB-DONO --------------------------------------------------------------
	/go				->		ir para posição diretamente pelas coords
	/mypos			->		retorna uma mensagem de qual posição o player está
	/myvw			-> 		retorna uma mensagem do virtual world que o player está
	/myint			->		retorna uma mensagem de qual interior o player está
	 
	RCON, DONO ------------------------------------------------------------
    /clocal 		-> 		criar locais públicos: banco, conce, prefetiura

 */

hook OnPlayerDisconnect(playerid) {
	DestroyVehicle(CarADM[playerid]);
	return 1;
}

/* COMMANDS HELPER ---------------------------------------------------------------------------- */

/* COMMANDS MODERATOR ------------------------------------------------------------------------- */

CMD:cv(playerid, params[]) // CMD para criar veículos com cores personalizadas.
{
	if(PlayerInfo[playerid][pAdmin] >= L_MODERATOR || IsPlayerAdmin(playerid)) {
		new id, c1 = 0, c2 = 0;
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

CMD:v(playerid, params[]) // CMD para criar veículo com cores padrão.
{
	if(PlayerInfo[playerid][pAdmin] >= L_MODERATOR || IsPlayerAdmin(playerid)) {
		new id;
		if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /v [id]");
		new Float:a, Float:x, Float:y, Float:z;
		GetPlayerFacingAngle(playerid, a);
		GetPlayerPos(playerid, x, y, z);
		//DestroyVehicle(CarADM[playerid]);
		CarADM[playerid] = CreateVehicle(id, x, y, z, a, 0, 1, -1, false);
		PutPlayerInVehicle(playerid, CarADM[playerid], 0);
		return 1;
	}
	return 0;
}


/* COMMANDS ADMINISTRATOR --------------------------------------------------------------------- */

CMD:irlocal(playerid, params[]) { // CMD para ir até algum local público pelo ID.
	if(PlayerInfo[playerid][pAdmin] >= L_ADMINISTRATOR || IsPlayerAdmin(playerid)) {
		new str[128], i = 0;
		format(str, sizeof(str),"%s %sDigite: %s/irlocal [idLocal]", EMBED_WARNING, EMBED_WHITE, EMBED_SERVER);
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, -1, str);
		if(qPlaces == 0) return sendWarning(playerid, "Não existe locais criados ainda.");
		if(i > qPlaces || i == 0) {
			new string[128];
			format(string, sizeof(string),"%s %sID dos locais vão de 1 até %d",MSG_PLACE, EMBED_WHITE, qPlaces);
			SendClientMessage(playerid, -1, string);
			return 1;
		} else {
			SetPlayerPos(playerid, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			new string[128];
			format(string, sizeof(string),"%s %sVocê chegou no local ID: %s%d", MSG_SERVER, EMBED_WHITE, EMBED_SERVER, i);
			SendClientMessage(playerid, -1, string);
			return 1;
		}
	}	
	return 0;
}

/* COMMANDS SUB-OWNER ------------------------------------------------------------------------- */

CMD:go(playerid, const params[]) { // CMD para ir para alguma coord específica.
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER)
	{
		new int, Float:pos[3];
		if(sscanf(params, "dfff", int, pos[0], pos[1], pos[2])) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /go [interior] [X] [Y] [Z]");
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerInterior(playerid, int);
		return 1;
	}
	return 0;
}

CMD:mypos(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		new str[128];
		format(str, sizeof(str),"%s Sua posição é: X: %f Y: %f Z: %f A: %f", MSG_SERVER, X, Y, Z, A);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 0;
}

CMD:myvw(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new vwPlayer = GetPlayerVirtualWorld(playerid);
		new str[128];
		format(str, sizeof(str),"%s Seu virtual world é: %d", MSG_SERVER, vwPlayer);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 0;
}

CMD:myint(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new intPlayer = GetPlayerInterior(playerid);
		new str[128];
		format(str, sizeof(str),"%s Seu interior é: %d", MSG_SERVER, intPlayer);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 0;
}


/* COMMANDS OWNER ----------------------------------------------------------------------------- */

CMD:clocal(playerid, params[]) // CMD para criar locais públicos, agência, autoescola, banco, etc.
{
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
		createPlace(playerid);
		return 1;
	} else {
		return 0;
	}
}