#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
	finishPlayer(playerid);
	screenStartPlayer(playerid);
	new name[MAX_PLAYER_NAME];
	format(name, sizeof(name),"PLAYER_%d",playerid);
	SetPlayerName(playerid, name);
	//SetTimerEx("verificarStatus", 30000, true, "i", playerid);
	//CarADM[playerid] = -1;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	savePlayer(playerid);
	return 1;
}

hook OnPlayerSpawn(playerid) {
	for(new i = 0; i < 100; i++) {
		SendClientMessage(playerid, -1, "");
	}
	new string[128];
	format(string, sizeof(string),"O(A) Jogador(a) %s acabou de se conectar.", getNamePlayer(playerid));
	SendClientMessageToAll(-1, string);
	
	SetPlayerInterior(playerid, PlayerInfo[playerid][pI]);
	SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
	SetPlayerCameraPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
	
	KillTimer(timerSpawn[playerid]);
	PlayerInfo[playerid][pSpawn] = true;
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_LOG_LOGIN) { // dialog de login para logar
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite um login válido.");
				logPlayerLogin(playerid);
				return 1;
			}

			if(strlen(inputtext) < minLogin || strlen(inputtext) > maxLogin) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O login deve conter no mínimo %d e no máximo %d caracteres.", minLogin, maxLogin);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				logPlayerLogin(playerid);
				return 1;
			}

			logLogin[playerid] = 0;
			format(logLogin[playerid], maxLogin, "%s", inputtext);
			//logPlayerPass(playerid);
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'", logLogin[playerid]);
			mysql_tquery(ConexaoSQL, query, "getLoginPlayer", "ds", playerid, logLogin[playerid]);
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_LOG_PASS) { // dialog de senha para logar
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite uma senha válida.");
				logPlayerPass(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minSenha || strlen(inputtext) > maxSenha) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O senha deve conter no mínimo %d e no máximo %d caracteres.", minSenha, maxSenha);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				logPlayerPass(playerid);
				return 1;	
			} 

			logPass[playerid] = 0;
			format(logPass[playerid], maxSenha, "%s", inputtext);
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'", logLogin[playerid]);
			mysql_tquery(ConexaoSQL, query, "getPassPlayer", "ds", playerid, logLogin[playerid]);
			return 1;
		} else {
			return 1;
		}
	}


	if(dialogid == DIALOG_START) {
		if(response) {
			pScreenStart[playerid] = false;
			pScreenLogin[playerid] = true;
			logPlayerLogin(playerid); 
			return 1;
		} else {
			pScreenStart[playerid] = false;
			pScreenRegister[playerid] = true;
			regPlayerLogin(playerid);
			return 1;
		}
	}

	if(dialogid == DIALOG_REG_LOGIN) { // Dialog p/ cadastrar login
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite um login válido.");
				regPlayerLogin(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minLogin || strlen(inputtext) > maxLogin) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O login deve conter no mínimo %d e no máximo %d caracteres.", minLogin, maxLogin);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				regPlayerLogin(playerid);
				return 1;	
			} 
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'", inputtext);
			mysql_tquery(ConexaoSQL, query, "getLoginRegister", "ds", playerid, inputtext);
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_REG_NICK) { // Dialog p/ cadastrar nick
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite um nick válido.");
				regPlayerNick(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minNick || strlen(inputtext) > maxNick) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O nick deve conter no mínimo %d e no máximo %d caracteres.", minNick, maxNick);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				regPlayerNick(playerid);
				return 1;	
			} 
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pNick` = '%s'", inputtext);
			mysql_tquery(ConexaoSQL, query, "getNickRegister", "ds", playerid, inputtext);
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_REG_PASS) { // Dialog p/ cadastrar senha
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite uma senha válida.");
				regPlayerPass(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minSenha || strlen(inputtext) > maxSenha) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O senha deve conter no mínimo %d e no máximo %d caracteres.", minSenha, maxSenha);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				regPlayerPass(playerid);
				return 1;	
			} 
			regPass[playerid] = 0;
			format(regPass[playerid], 32, "%s", inputtext);
			regPlayerConfPass(playerid);
			return 1;
		} else {
			return 1;
		}
	}
	// FALTA FAZER COMPARAÇÃO DE SENHAS, PARA VERIFICAR SE AS SENHAS SÃO COMPÁTIVEIS
	if(dialogid == DIALOG_REG_CONF_PASS) { // Dialog p/ confirmar senha
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite uma senha válida.");
				regPlayerConfPass(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minSenha || strlen(inputtext) > maxSenha) {
				new str[128];
				format(str, sizeof(str),"| AVISO | {FFFFFF}O senha deve conter no mínimo %d e no máximo %d caracteres.", minSenha, maxSenha);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				regPlayerConfPass(playerid);
				return 1;	
			} 
			regConfPass[playerid] = 0;
			format(regConfPass[playerid], 32, "%s", inputtext);

			if(strcmp(regPass[playerid], regConfPass[playerid], true, 32) == 0) {
				regPlayerEmail(playerid);
				return 1;
			} else {
				SendClientMessage(playerid, COLOR_VERMELHO, "As senhas estão divergentes");		
				regPass[playerid] = 0;
				regConfPass[playerid] = 0;
				regPlayerPass(playerid);
				return 1;
			} 
			
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_REG_EMAIL) { // Dialog p/ cadastrar email
		if(response) {
			if(!strlen(inputtext)) {
				SendClientMessage(playerid, COLOR_VERMELHO, "Digite um email válido.");
				regPlayerEmail(playerid);
				return 1;
			}
			
			if(strlen(inputtext) < minEmail || strlen(inputtext) > maxEmail) {
				new str[128];
				format(str, sizeof(str),"O e-mail deve conter no mínimo %d e no máximo %d caracteres.", minEmail, maxEmail);
				SendClientMessage(playerid, COLOR_AMARELO, str);
				regPlayerEmail(playerid);
				return 1;	
			} 
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pEmail` = '%s'", inputtext);
			mysql_tquery(ConexaoSQL, query, "getEmailRegister", "ds", playerid, inputtext);
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_REG_GEN) {
		if(response) {
			regGen[playerid] = 0;
			switch(listitem) {
				case 0: {
					regGen[playerid] = 1; //homem
				}
				case 1: {
					regGen[playerid] = 2; //mulher
				}
				case 2: {
					regGen[playerid] = 3; //não identificar
				}
			}
			createCode(playerid);
			return 1;
		} else {
			return 1;
		}

	}

	return 1;
}

regPlayerLogin(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_LOGIN, DIALOG_STYLE:1, "{FFFFFF}Registrar - Login", \
	"{ffffff}Crie um login:", "Confirmar", "Sair");
	return 1;
}

regPlayerNick(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_NICK, DIALOG_STYLE:1, "{FFFFFF}Registrar - Nick", \
	"{ffffff}Crie um nick:", "Confirmar", "Sair");
	return 1;
}

regPlayerPass(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Registrar - Senha", \
	"{ffffff}Crie uma senha:", "Confirmar", "Sair");
	return 1;
}

regPlayerConfPass(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_CONF_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Confirmar - Senha", \
	"{ffffff}Confirme sua senha:", "Confirmar", "Sair");
	return 1;
}

regPlayerEmail(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_EMAIL, DIALOG_STYLE:1, "{FFFFFF}Registrar - E-mail", \
	"{ffffff}Registre um e-mail:", "Confirmar", "Sair");
	return 1;
}

regPlayerGen(playerid) {
	ShowPlayerDialog(playerid, DIALOG_REG_GEN, DIALOG_STYLE_LIST, "{FFFFFF}Registrar - Gênero", \
	"{ffffff}Masculino\nFeminino\nNão identificar", "Confirmar", "Sair");
	return 1;
}

screenStartPlayer(playerid) { // tela inicial
	ShowPlayerDialog(playerid, DIALOG_START, DIALOG_STYLE_MSGBOX, "{FFFFFF}Seja Bem-Vindo", "{ffffff}Escolha uma das opções:",\
	"Logar", "Registrar");
	pScreenStart[playerid] = true;
	pScreenRegister[playerid] = false;
	return 1;
}

logPlayerLogin(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOG_LOGIN, DIALOG_STYLE_INPUT, "{FFFFFF}Login", "{ffffff}Digite seu login:", "Logar", "Sair");
	pScreenStart[playerid] = false;
	pScreenLogin[playerid] = true;
	return 1;
}

logPlayerPass(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOG_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Login", "{ffffff}Digite sua senha:", "Logar", "Sair");
	return 1;
}

debugStatus(playerid) {
	new str[128];
	format(str, sizeof(str),"Screen Start: %d", pScreenStart[playerid]);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str),"Screen Login: %d", pScreenLogin[playerid]);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str),"Screen Register: %d", pScreenRegister[playerid]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

forward	verificarStatus(playerid);
public verificarStatus(playerid) {
	debugStatus(playerid);
	return 1;
}

forward getLoginRegister(playerid, text[]);
public getLoginRegister(playerid, text[]) {
	if(cache_num_rows() > 0) {
		SendClientMessage(playerid, COLOR_VERMELHO, "Login já existente.");
		regPlayerLogin(playerid);
		return 1;
	} else {
		regLogin[playerid] = 0;
		format(regLogin[playerid], 32, "%s", text);
		regPlayerNick(playerid);
		return 1;
	}
}

forward getNickRegister(playerid, text[]);
public getNickRegister(playerid, text[]) {
	if(cache_num_rows() > 0) {
		SendClientMessage(playerid, COLOR_VERMELHO, "Nick já existente.");
		regPlayerNick(playerid);
		return 1;
	} else {
		regNick[playerid] = 0;
		format(regNick[playerid], 32, "%s", text);
		regPlayerPass(playerid);
		return 1;
	}
}

forward getEmailRegister(playerid, text[]);
public getEmailRegister(playerid, text[]) {
	if(cache_num_rows() > 0) {
		SendClientMessage(playerid, COLOR_VERMELHO, "Email utilizado em outra conta.");
		regPlayerEmail(playerid);
		return 1;
	} else {
		regEmail[playerid] = 0;
		format(regEmail[playerid], 32, "%s", text);
		regPlayerGen(playerid);
		return 1;
	}
}

createCode(playerid) {
	new randNumber[6];
	new randLyrics[2];
	new randLyricsLow[4];
	new codePlayer[64];

	randLyricsLow[0] = (random(26) + 'a');
	strcat(codePlayer, randLyricsLow[0]);

	for(new i = 0; i <= 1; i++) {
		new linha[64];
		randNumber[i] = random(9);
		format(linha, sizeof(linha), "%d", randNumber[i]);
		strins(codePlayer, linha, i+1);
	}

	format(randLyrics[0], 2, "%s", (random(26) + 'A'));
	strcat(codePlayer, randLyrics[0]);

	format(randLyricsLow[1], 2, "%s", (random(26) + 'a'));
	strcat(codePlayer, randLyricsLow[1]);

	format(randNumber[2], 2, "%d", random(9));
	strins(codePlayer, randNumber[2], 5);

	format(randLyricsLow[2], 2, "%s", (random(26) + 'a'));
	strcat(codePlayer, randLyricsLow[2]);

	format(randLyrics[1], 2, "%s", (random(26) + 'A'));
	strcat(codePlayer, randLyrics[1]);

	for(new i = 3; i <= 4; i++) {
		new linha[64];
		randNumber[i] = random(9);
		format(linha, sizeof(linha), "%d", randNumber[i]);
		strins(codePlayer, linha, i+5);
	}

	format(randLyricsLow[3], 2, "%s", (random(26) + 'a'));
	strcat(codePlayer, randLyricsLow[3]);

	new query[128];
	mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pCode` = '%s'", codePlayer);
	mysql_tquery(ConexaoSQL, query, "OnGiveCodePlayer", "ds", playerid, codePlayer);

	SendClientMessage(playerid, -1, "Criação Code:");
	SendClientMessage(playerid, -1, codePlayer);
	return 1;
}

forward OnGiveCodePlayer(playerid, code[]);
public OnGiveCodePlayer(playerid, code[]) {
	if(cache_num_rows() > 0) {
		createCode(playerid);
		return 1;
	} else {
		createPlayer(playerid);
		return 1;
	}
}

stock createPlayer(playerid) {
	new query[256];
	mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `players` (`pCode`, `pLogin`, `pNick`, `pPassword`, `pEmail`, `pGen`) VALUES ('%s', '%s', '%s', '%s', '%s', '%i')", 
	regCodePlayer[playerid], regLogin[playerid], regNick[playerid], regPass[playerid], regEmail[playerid], regGen[playerid]);
	mysql_tquery(ConexaoSQL, query, "createPlayerDB", "ds", playerid, regCodePlayer[playerid]); 
	return 1;
}

forward createPlayerDB(playerid, code[]);
public createPlayerDB(playerid, code[]) {
	SendClientMessage(playerid, 0x00BFFFff, "| REGISTRO | {ffffff}Conta cadastrada com sucesso!");
	screenStartPlayer(playerid);
	pScreenRegister[playerid] = false;
	pScreenStart[playerid] = true;

	new year = 0, month = 0, day = 0;
	getdate(year, month, day);
	new hour = 0, minute = 0, second = 0;
	gettime(hour, minute, second);
	new regDate[32], regTime[32];
	format(regDate, sizeof(regDate),"%02d/%02d/%02d",day, month, year);
	format(regTime, sizeof(regTime),"%02d:%02d:%02d",hour, minute, second);
	SendClientMessage(playerid, -1, regTime);
	SendClientMessage(playerid, -1, regDate);
	new query[128];
	mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `register` (`pCode`, `rDate`, `rTime`) VALUES ('%s', '%s', '%s')",code, regDate, regTime);
	mysql_tquery(ConexaoSQL, query, "OnCreateRegister", "d", playerid);
	return 1;
}

forward getLoginPlayer(playerid, text[]);
public getLoginPlayer(playerid, text[]) {
	if(cache_num_rows() == 1) {
		logPlayerPass(playerid);
		return 1;
	} else {
		logLogin[playerid] = 0;
		logPass[playerid] = 0;
		logPlayerLogin(playerid);
		SendClientMessage(playerid, COLOR_VERMELHO, "| ERRO | Login não encontrado!");
		return 1;
	}
}

forward getPassPlayer(playerid, text[]);
public getPassPlayer(playerid, text[]) {
	if(cache_num_rows() > 0) {
		new logPassPlayerDB[64];
		cache_get_value_name(0, "pPassword", logPassPlayerDB, sizeof(logPassPlayerDB));
		if(strcmp(logPass[playerid], logPassPlayerDB, false) == 0 ) {
			PlayerInfo[playerid][pLogado] = true;
			GameTextForPlayer(playerid, "~g~AGUARDE!!", 3000, 4);
			pScreenLogin[playerid] = false;
			new queryLoad[128];
			mysql_format(ConexaoSQL, queryLoad, sizeof(queryLoad), "SELECT * FROM `players` WHERE `pLogin` = '%s'", logLogin[playerid]);
			mysql_tquery(ConexaoSQL, queryLoad, "OnLoadPlayer", "d", playerid);
			return 1;
		} else {
			SendClientMessage(playerid, COLOR_VERMELHO, "| ERRO | Senha incorreta!");
			logPlayerPass(playerid);
			return 1;
		}
	}
	return 1;
}

forward OnLoadPlayer(playerid);
public OnLoadPlayer(playerid) {
	new namePlayer[MAX_PLAYER_NAME];
	cache_get_value_name(0, "pNick", namePlayer, MAX_PLAYER_NAME);
	SetPlayerName(playerid, namePlayer);
	cache_get_value_name(0, "pEmail", PlayerInfo[playerid][pEmail], maxEmail);
	cache_get_value_int(0, "pGen", PlayerInfo[playerid][pGen]);
	cache_get_value_name(0, "pCode", PlayerInfo[playerid][pCode], 50);
	cache_get_value_float(0, "pX", PlayerInfo[playerid][pX]);
	cache_get_value_float(0, "pY", PlayerInfo[playerid][pY]);
	cache_get_value_float(0, "pZ", PlayerInfo[playerid][pZ]);
	cache_get_value_float(0, "pA", PlayerInfo[playerid][pA]);
	cache_get_value_int(0, "pI", PlayerInfo[playerid][pI]);
	cache_get_value_int(0, "pVW", PlayerInfo[playerid][pVW]);
	cache_get_value_int(0, "pLevel", PlayerInfo[playerid][pLevel]);
	cache_get_value_int(0, "pSkin", PlayerInfo[playerid][pSkin]);
	cache_get_value_int(0, "pAdmin", PlayerInfo[playerid][pAdmin]);
	timerSpawn[playerid] = SetTimerEx("OnSpawnPlayer", 1000, true, "d", playerid);
	return 1;
}

forward	OnSpawnPlayer(playerid);
public OnSpawnPlayer(playerid) {
	if(PlayerInfo[playerid][pSpawn] == false) {
		SpawnPlayer(playerid);
		TogglePlayerSpectating(playerid, false);
		TogglePlayerControllable(playerid, true);
		SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
		KillTimer(timerSpawn[playerid]);
		PlayerInfo[playerid][pSpawn] = true;
		return 1;
	}
	return 1;
}

stock finishPlayer(playerid) { // função para zerar todas variáveis
	pScreenRegister[playerid] = false;
	pScreenLogin[playerid] = false;
	pScreenStart[playerid] = false;
	regLogin[playerid] = 0;
	regNick[playerid] = 0;
	regPass[playerid] = 0;
	regConfPass[playerid] = 0;
	regEmail[playerid] = 0;
	regGen[playerid] = 0;
	logLogin[playerid] = 0;
	logPass[playerid] = 0;
	PlayerInfo[playerid][pLogado] = false;
	PlayerInfo[playerid][pSpawn] = false;
	return 1;
}

stock savePlayer(playerid) {
	new Float:X, Float:Y, Float:Z, Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	new sVW, sI, sLevel, sSkin;
	sI = GetPlayerInterior(playerid);
	sVW = GetPlayerVirtualWorld(playerid);
	sLevel = GetPlayerScore(playerid);
	sSkin = GetPlayerSkin(playerid);
	new query[400];
	mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players` SET \
		`pX` = '%f',\
		`pY` = '%f',\
		`pZ` = '%f',\
		`pA` = '%f',\
		`pI` = '%d',\
		`pVW` = '%d',\
		`pLevel` = '%d',\
		`pSkin` = '%d'\
		WHERE `pCode`='%s'",
		X, Y, Z, A, 
		sI, sVW, sLevel, sSkin,
		PlayerInfo[playerid][pCode]);
	mysql_tquery(ConexaoSQL, query, "OnSavePlayer", "ss", getNamePlayer(playerid),PlayerInfo[playerid][pCode]);
	new string[128];
	format(string, sizeof(string),"X: %f Y: %f Z: %f A: %f", X, Y, Z, A);
	SendClientMessage(playerid, -1, string);
	return 1;
}

forward OnSavePlayer(nameP[], codeP[]);
public OnSavePlayer(nameP[], codeP[]) {
	printf("                                              ");
	printf("----------------------- SALVAMENTO DE PLAYERS ------------------------");
	printf("Jogador(a): %s Código: %s | Salvo com sucesso!", nameP, codeP);
	printf("                                              ");
	return 1;
}

forward OnGetPlayers();
public OnGetPlayers() {
	printf("                                              ");
	printf("----------------- PLAYERS CADASTRADOS -----------------");	
	if(cache_num_rows() > 0) {
		new i = cache_num_rows();
		printf("%d players cadastrados no banco de dados", i);
		printf("                                          ");
		printf("                                          ");
	} else {
		printf("Não existe nenhum player para ser localizado");
		return 1;
	}
	return 1;
}