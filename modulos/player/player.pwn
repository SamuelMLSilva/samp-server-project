stock getPlayerAdmin(playerid) {
	new result[64];
	if(!IsPlayerAdmin(playerid)) {
		switch(PlayerInfo[playerid][pAdmin]) {
			case 1: {
				format(result, sizeof(result),"Ajudante");
			}
			case 2: {
				format(result, sizeof(result),"Moderador(a)");
			}
			case 3: {
				format(result, sizeof(result),"Administrador(a)");
			}
			case 4: {
				format(result, sizeof(result),"Sub-dono(a)");
			}
			case 5: {
				format(result, sizeof(result),"Dono(a)");
			}
			default: {
				format(result, sizeof(result),"Jogador(a)");
			}
		}	
	} else {
		format(result, sizeof(result),"Dono(a)");
	}
	return result;
}

stock getNamePlayer(playerid) {
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}
