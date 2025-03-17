/*
    --> COMANDOS

	AJUDANTE --------------------------------------------------------------


	MODERADOR -------------------------------------------------------------
	/v 				->		criar veículos com pintura padrão
    /cv 			->		criar veículos com escolha de pintura
	/cchat			->		limpar chat
	/setskin		->		setar skin para jogador

	ADMINISTRADOR ---------------------------------------------------------
	/irlocal		->		ir até um local pelo ID

	SUB-DONO --------------------------------------------------------------
	/go				->		ir para posição diretamente pelas coords
	/mypos			->		retorna uma mensagem de qual posição o player está
	/myvw			-> 		retorna uma mensagem do virtual world que o player está
	/myint			->		retorna uma mensagem de qual interior o player está
	/startactor		->		iniciar/spawnar um actor
	/stopactor		->		parar/despawnar um actor
	/iractor		->      ir até um actor pelo id
	/mactor			->		modificar um ator próximo ou por ID	
	/cmactor		->		cancelar modificação do ator

	RCON, DONO ------------------------------------------------------------
    /clocal 		-> 		criar locais públicos: banco, conce, prefetiura

 */

hook OnPlayerDisconnect(playerid) {
	DestroyVehicle(CarADM[playerid]);
	return 1;
}

/* COMMANDS HELPER ---------------------------------------------------------------------------- */

CMD:skin(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_HELPER) {
		new skin = 0;
		if(sscanf(params, "d", skin)) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: /skin [idSkin]");
		if(skin < 0 || skin > 311) return sendWarning(playerid, "Skins vão do ID 0 até o 311");
		SetPlayerSkin(playerid, skin);
		new str[128];
		format(str, sizeof(str),"%s Você setou a skin ID: %02d para você mesmo.", MSG_SERVER, skin);
		SendClientMessage(playerid, -1, str);
		return 1;
	} else {
		return 0;
	}
}

/* COMMANDS MODERATOR ------------------------------------------------------------------------- */

CMD:cchat(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
	{
		for(new i = 0; i <= 80; i++) {
			SendClientMessageToAll(-1, "");
		}
		return 1;
	}
	return 0;
}

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

CMD:setskin(playerid, params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_MODERATOR) {
		new id, skin;
		if(sscanf(params, "ii",id, skin)) return SendClientMessage(playerid, COLOR_VERMELHO, "Use: setskin: /id [skin]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_VERMELHO, "Este jogador(a) não está online!");
		if(skin < 0 || skin > 311) return SendClientMessage(playerid, COLOR_VERMELHO, "Os Id's das skins vão de 0 até 311");
		PlayerInfo[id][pSkin] = skin;
		SetPlayerSkin(id, PlayerInfo[id][pSkin]);
		new string[128];
		format(string, sizeof(string),"%s O(A) %s %s te setou a skin ID: %d",MSG_ADMIN, getPlayerAdmin(playerid), getNamePlayer(playerid), skin);
		SendClientMessage(id, -1, string);
		new str[128];
		format(str, sizeof(str),"%s Você setou a skin ID: %d para o(a) jogador(a) %s",MSG_ADMIN, skin, getNamePlayer(id));
		SendClientMessage(playerid, -1, str);
		return 1;
	} else {
		return 0;
	}
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

CMD:startactor(playerid, params[]) { // CMD para iniciar ator com base no ID
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new i = 0;
		if(sscanf(params, "d", i)) return sendWarning(playerid, "Digite: /startactor [idActor]");
		startActor(i);
		new str[128];
		format(str, sizeof(str),"%s Ator ID: %d foi iniciado com sucesso!", MSG_SERVER, i);
		SendClientMessage(playerid, -1, str);
		return 1;
	} else {
		return 0;
	}
}

CMD:stopactor(playerid, params[]) { // CMD para remover ator com base no ID
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new i = 0;
		if(sscanf(params, "d", i)) return sendWarning(playerid, "Digite: /stopactor [idActor]");
		stopActor(i);
		loadActorId(i);
		new str[128];
		format(str, sizeof(str),"%s Ator ID: %d foi removido com sucesso!", MSG_SERVER, i);
		SendClientMessage(playerid, -1, str);
		return 1;
	} else {
		return 0;
	}
}

CMD:iractor(playerid, params[]) { // CMD para ir até um ator
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		new i = 0;
		if(sscanf(params, "d", i)) return sendWarning(playerid, "Digite: /iractor [idActor]");	
		if(IsPlayerInAnyVehicle(playerid)) return sendWarning(playerid, "Você não pode estar dentro de um veículo, para ir até uma ator.");	
		new string[128];
		format(string, sizeof(string),"%s Os ID's de atores vão de 1 até %d", MSG_SERVER, qtdActors);
		if(i < 1 || i > qtdActors) return sendWarning(playerid, string);	
		SetPlayerPos(playerid, ActorInfo[i][posActor][0]+0.3, ActorInfo[i][posActor][1]+0.3, ActorInfo[i][posActor][2]);
		SetPlayerFacingAngle(playerid, ActorInfo[i][posActor][3]);
		SetPlayerInterior(playerid, ActorInfo[i][intActor]);
		SetPlayerVirtualWorld(playerid, ActorInfo[i][vwActor]);
		new str[128];
		format(str, sizeof(str),"%s Você foi até o ator ID: %d", MSG_SERVER, i);
		SendClientMessage(playerid, -1, str);
		return 1;
	} else {
		return 0;
	}
}

CMD:mactor(playerid, params[]) { // CMD para modificar ator
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		if(ActorModify[playerid][isModActor] == false || ActorModify[playerid][modActorID] > 0) {
			new k = getPosActorID(playerid);
			if(k > 0) {
				ActorModify[playerid][modActorID] = k; 
				ActorModify[playerid][isModActor] = true; 
				printf("%d | %d", ActorModify[playerid][modActorID], ActorModify[playerid][isModActor]);
				showDialogModifyAct(playerid);
				return 1;
			} else if(k <= 0) {
                showDlgModifyActId(playerid);
                ActorModify[playerid][isModActor] = true; 
				return 1;
            }
		} else {
			sendWarning(playerid, "Você já está modificicando um ator!");
			showDialogModifyAct(playerid);
			return 1;
		}
        return 1;
	} else {
		return 0;
	}
}

CMD:cmactor(playerid, params[]) { // CMD para cancelar modificação ator
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
		if(ActorModify[playerid][isModActor] != true) {
			sendWarning(playerid, "Você não está modificando nenhum ator!");
			return 1;
		} else {
			ActorModify[playerid][modActorID] = 0; 
			ActorModify[playerid][isModActor] = false; 
			sendWarning(playerid, "Modificação cancelada com sucesso!");
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:cactor(playerid, params[]) { // Criar um ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        if(IsPlayerInAnyVehicle(playerid)) return sendWarning(playerid, "Você não pode estar em um veículo para criar um ator!");
        if(ActorCreate[playerid][creatingActor] == false) {
            ActorCreate[playerid][creatingActor] = true;
            showDlgCreateAct(playerid);
        } else {
            new str[128];
            format(str, sizeof(str),"%s Você já possui um ator em processo de criação, digite %s/ccactor", MSG_ACTOR, EMBED_SERVER);
            SendClientMessage(playerid, -1, str);
        }
        return 1;
    } else {
        return 0;
    }
}

CMD:cancelactor(playerid, params[]) { // Cancelar criação de ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        if(ActorCreate[playerid][creatingActor] == true) {
            ActorCreate[playerid][creatingActor] = false;
            sendMsgServer(playerid, "Criação de ator cancelada com sucesso!");
            return 1;
        } else {
            sendWarning(playerid, "Você não possui nenhuma criação de ator pendente!");
            return 1;
        }
    } else {
        return 0;
    }
}

CMD:rnameactor(playerid, params[]) { // Recriar nome do ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        showDlgNameAct(playerid);    
        return 1;
    } else {
        return 0;
    }
}

CMD:vactor(playerid, params[]) { // ver informações do ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        new i;
        if(sscanf(params, "d", i)) return SendClientMessage(playerid, -1, "Digite: /vactor [idActor]");
        new str[128];
        format(str, sizeof(str),"ID: %d Nome: %s | VW: %d | Int: %d", i, ActorInfo[i][nameActor], 
		ActorInfo[i][vwActor], ActorInfo[i][intActor]);
        SendClientMessage(playerid, -1, str);
        return 1;
    } else {
        return 0;
    }
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
