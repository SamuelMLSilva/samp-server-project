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

stock sendWarning(playerid, const text[]) { // enviar msg para o player com prefixo aviso
	if(strlen(text) > 85) {
		printf("Erro ao enviar mensagem! Limite de caracteres foi excedido!");
		printf("%s",text);
	} else {
		new string[85];
		format(string, sizeof(string),"%s %s%s",MSG_WARNING, EMBED_WHITE, text);
		SendClientMessage(playerid, -1, string);
	}		
	return 1;
}

stock sendMsgServer(playerid, const text[]) { // enviar msg para o player com prefixo server
	if(strlen(text) > 85) {
		printf("Erro ao enviar mensagem! Limite de caracteres foi excedido!");
		printf("%s",text);
	} else {
		new string[85];
		format(string, sizeof(string),"%s %s",MSG_SERVER, text);
		SendClientMessage(playerid, -1, string);
	}		
	return 1;
}