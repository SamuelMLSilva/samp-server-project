forward OnGetPlayers();
public OnGetPlayers() {
	printf("-- PLAYERS CADASTRADOS ------------------");
	if(cache_num_rows() > 0) {
		new i = cache_num_rows();
		printf("%d players cadastrados no banco de dados\n", i);
	} else {
		printf("Não existe nenhum player para ser localizado\n");
		return 1;
	}
	return 1;
}

stock loadPlayersDb() {
	new queryPlayers[128];
    mysql_format(ConexaoSQL, queryPlayers, sizeof(queryPlayers),"SELECT * FROM `players`");
    mysql_tquery(ConexaoSQL, queryPlayers, "OnGetPlayers");
	return 1;
}

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

stock getNamePlayer(playerid) { // função para pegar nome do player
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