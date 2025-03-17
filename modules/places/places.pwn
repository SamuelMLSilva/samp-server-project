#include <YSI_Coding\y_hooks>

new mSecMenuPcikup[MAX_PLAYERS];

enum pickupsMenu {
	idPickup
};

static const menuPickups[][pickupsMenu] = { // Pickups do menu mSelection
	{954}, {1210}, {1212}, {1213}, {1239}, {1240}, {1241}, {1242}, {1247}, {1248}, {1252}, 
	{1254}, {1272}, {1273}, {1274}, {1275}, {1276}, {1277}, {1279}, {1310}, {1313}, {1314},
	{1318}, {1550}, {1575}, {1576}, {1577}, {1578}, {1579}, {1580}, {1581}, {1582}, {1636}, 
	{1650}, {1654}, {2057}, {2060}, {2061}, {2690}, {2710}, {11736}, {11738}, {19130}, {19131}, 
	{19132}, {19133}, {19134}, {19135}, {19197}, {19198}, {19320}, {19522}, {19523}, {19524}, {19602},
	{19605}, {19606}, {19607}, {19832}
};

hook OnPlayerModelSelectionEx(playerid, response, extraid, modelid) { // Retornar ID da pickup selecionado no menu mSelection
	
	if(modelid > 0) {
		
		if(PlaceModify[playerid][alterPlacePickup] == true) {
			PlaceModify[playerid][modifyIdPickupPlace] = modelid;	
			placeAlterPckp(playerid);		
		}
		if(PlaceCreate[playerid][clPickup] < 1) {
			if(PlaceCreate[playerid][cPlace] == true) {
				PlaceCreate[playerid][clPickup] = modelid;
				PlaceCreate[playerid][chooseLocInt] = true;
				showDialogLocInts(playerid);
				return 1;
			}	
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	finishCreatePlace(playerid);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
	if(!IsPlayerInAnyVehicle(playerid)) {
		if(newkeys & KEY_SECONDARY_ATTACK) { // Entrar em locais apertando a letra "F"
			new enterPlace = getLocalPublic(playerid);
			if(enterPlace > 0) {
				new strLock[128];
				format(strLock, sizeof(strLock),"%s %sEsse local está trancado no momento!",MSG_PLACE, EMBED_WHITE);
				if(PlaceInfo[enterPlace][lLock] == 1) return SendClientMessage(playerid, -1, strLock);
				SetPlayerVirtualWorld(playerid, enterPlace);
				setInteriorPlace(playerid, PlaceInfo[enterPlace][lIntId]);
				return 1;
			}	
			new exitPlace = getInLocalPublic(playerid);
			if(exitPlace > 0) {
				new i = exitPlace;
				SetPlayerPos(playerid, PlaceInfo[i][eX], PlaceInfo[i][eY], PlaceInfo[i][eZ]);
				SetPlayerFacingAngle(playerid, PlaceInfo[i][eA]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid , 0);
				SetCameraBehindPlayer(playerid);	
				return 1;
			}
		}	
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_LOC_MOD_DELETE) {
		if(response) {
			stopPlace(PlaceModify[playerid][modifyIdPlace]);
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query),"DELETE FROM `places` WHERE `lID`=%d",PlaceModify[playerid][modifyIdPlace]);
			mysql_tquery(ConexaoSQL, query);
			new str[128];
			format(str, sizeof(str),"%s %sVocê excluiu o local ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			SendClientMessage(playerid, -1, str);
			finishModifyPlace(playerid);
			qPlaces--;
			return 1;
		} else {
			new str[128];
			format(str, sizeof(str),"%s %sVocê cancelou a exclusão do local ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			SendClientMessage(playerid, -1, str);
			finishModifyPlace(playerid);
			return 1;
		}
	}
	if(dialogid == DIALOG_LOC_MOD_TITLE) {
		if(response) {
			new string[128];
			format(string, sizeof(string),"%s %sDigite um título válido!", MSG_PLACE, EMBED_WHITE);
			if(!strlen(inputtext) || strlen(inputtext) < 1) return SendClientMessage(playerid, -1, string);
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `lTitulo`='%s' WHERE `lID`='%d'",
				inputtext, PlaceModify[playerid][modifyIdPlace]);
			mysql_tquery(ConexaoSQL, query);
			stopPlace(PlaceModify[playerid][modifyIdPlace]);
			new str[128];
			format(str, sizeof(str),"%s %sVocê alterou o título do local ID: %d para: %s",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace],
				inputtext);
			SendClientMessage(playerid, -1, str);
			loadDbPlaceId(PlaceModify[playerid][modifyIdPlace]);
			restartTextPlace(PlaceModify[playerid][modifyIdPlace]);
			finishModifyPlace(playerid);
			return 1;
		} else {
			new str[128];
			format(str, sizeof(str),"%s %sVocê cancelou a alteração de título do local ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			SendClientMessage(playerid, -1, str);
			finishModifyPlace(playerid);
			return 1;
		}
	}
	if(dialogid == DIALOG_LOC_MOD_PCIKUP) { // Dialog de confirmação de alteração da pickup
		if(response) {
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `pIdPlace`='%d' WHERE `lID`='%d'",
				PlaceModify[playerid][modifyIdPickupPlace], PlaceModify[playerid][modifyIdPlace]);
			mysql_tquery(ConexaoSQL, query);
			stopPlace(PlaceModify[playerid][modifyIdPlace]);
			new str[128];
			format(str, sizeof(str),"%s %sVocê alterou a pickup do local ID: %d para pickup ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace],
				PlaceModify[playerid][modifyIdPickupPlace]);
			SendClientMessage(playerid, -1, str);
			new strAction[128];
			createLogAlter(PlayerInfo[playerid][pCode], getPlayerAdmin(playerid), getNamePlayer(playerid), strAction);
			loadDbPlaceId(PlaceModify[playerid][modifyIdPlace]);
			finishModifyPlace(playerid);
			return 1;
		} else {
			new str[128];
			format(str, sizeof(str),"%s %sVocê cancelou a alteração de pickup do local ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			SendClientMessage(playerid, -1, str);
			finishModifyPlace(playerid);
			return 1;
		}
	}

	if(dialogid == DIALOG_LOC_INTS) {
		if(response) {
			new i = listitem;
			SetPlayerPos(playerid, intsInfosLoc[i][insideIntLoc][0], intsInfosLoc[i][insideIntLoc][1], intsInfosLoc[i][insideIntLoc][2]);
			SetPlayerFacingAngle(playerid, intsInfosLoc[i][insideIntLoc][3]);
			SetPlayerInterior(playerid, intsInfosLoc[i][intLocId]);	
			SetCameraBehindPlayer(playerid);
			new str[128];
			format(str, sizeof(str),"%s| LOCAIS PÚBLICOS | %sDigite: %s/intloc %spara setar o interior do local!",EMBED_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE);
			SendClientMessage(playerid, -1, str);
			if(PlaceCreate[playerid][chooseLocInt] == true) {
				tempIntLoc[playerid] = intsInfosLoc[i][idLocInt];	
			}
			if(PlaceModify[playerid][alterPlaceInt] == true) {
				PlaceModify[playerid][modifyIdIntPlace] = intsInfosLoc[i][idLocInt];
			}
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_LOC_MODIFY) { //  Menu modificar local
		if(response) {
			new string[128];
			format(string, sizeof(string),"%s %sID local inválido - Debug ID: %d",MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			if(PlaceModify[playerid][modifyIdPlace] == 0) return SendClientMessage(playerid, -1, string);
			switch(listitem) {
				case 0: { // alterar interior					
					showDialogLocInts(playerid);
					PlaceModify[playerid][alterPlaceInt] = true;
				}

				case 1: { // Alterar pickup
					PlaceModify[playerid][alterPlacePickup] = true;
					showMenuLocPickup(playerid);
				}

				case 2: { // Alterar saída
					new str[128];
					format(str, sizeof(str),"%s %sDigite: %s/saidaloc %spara setar a saída do local ID: %d!",
						MSG_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
					SendClientMessage(playerid, -1, str);
					PlaceModify[playerid][alterPlaceExit] = true;
				}

				case 3: { // Alterar Titulo
					PlaceModify[playerid][alterPlaceTitle] = true;
					placeAlterTitle(playerid);
				}

				case 4: { // Trancar/Destrancar
					new i = PlaceModify[playerid][modifyIdPlace];
					new str[128];
					new query[128];
					if(PlaceInfo[i][lLock] == 0) {
						mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `lLock`='%d' WHERE `lID`='%d'",
							1, PlaceModify[playerid][modifyIdPlace]);
						format(str, sizeof(str),"%s %sVocê trancou o local ID: %d",MSG_PLACE, EMBED_WHITE, i);
					} else {
						mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `lLock`='%d' WHERE `lID`='%d'",
							0, PlaceModify[playerid][modifyIdPlace]);
						format(str, sizeof(str),"%s %sVocê destrancou o local ID: %d",MSG_PLACE, EMBED_WHITE, i);			
					}		
					mysql_tquery(ConexaoSQL, query);	
					SendClientMessage(playerid, -1, str);	
					loadDbPlaceId(i);							
					finishModifyPlace(playerid);						
				}
				case 5: {
					PlaceModify[playerid][deletePlace] = true;
					confPlaceDelete(playerid);
				}
			}
			return 1;
		} else {
			return 1;
		}
	}
	if(dialogid == DIALOG_LOC_TITLE) {
		if(response) {
			format(PlaceCreate[playerid][clTitle], 64, "%s", inputtext);
			SendClientMessage(playerid, -1, PlaceCreate[playerid][clTitle]);
			showMenuLocPickup(playerid);	
			return 1;
		} else {
			finishCreatePlace(playerid);
			return 1;
		}
	}
	if(dialogid == DIALOG_CONF_LOCATION) {
		if(response) {
			PlaceCreate[playerid][cPlace] = false;
			createPlace(playerid);
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_LOC_EXIT) {
		if(response) {
			new Float:X, Float:Y, Float:Z, Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			if(PlaceModify[playerid][alterPlaceExit] == true) {
				new query[350];
				mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `eX`='%f',`eY`='%f',`eZ`='%f', `eA`='%f' WHERE `lID`='%d'",
					X, Y, Z, A, PlaceModify[playerid][modifyIdPlace]);
				mysql_tquery(ConexaoSQL, query);
				new str[128];
				format(str, sizeof(str),"%s %sVocê setou a saída do local ID: %d", MSG_PLACE, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
				SendClientMessage(playerid, -1, str);
				loadDbPlaceId(PlaceModify[playerid][modifyIdPlace]);
				finishModifyPlace(playerid);	
				return 1;
			} else {
				new query[350];
				mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `eX`='%f',`eY`='%f',`eZ`='%f', `eA`='%f' WHERE `lID`='%d'",
					X, Y, Z, A, PlaceCreate[playerid][clID]);
				mysql_tquery(ConexaoSQL, query);
				stopPlace(PlaceCreate[playerid][clID]);
				loadDbPlaceId(PlaceCreate[playerid][clID]);
				new str[128];
				format(str, sizeof(str),"%s| LOCAIS PÚBLICO | %sVocê setou a saída do local ID: %d", EMBED_SERVER, EMBED_WHITE, PlaceCreate[playerid][clID]);
				SendClientMessage(playerid, -1, str);
				finishCreateExPlace(playerid);
				return 1;
			}		
		} else {
			return 1;
		}
	}
	return 1;
}

/* CALLBACKS ----------------------------------------------------------------------------------*/

forward OnGetPlaces();
public OnGetPlaces(){ // Pegar quantidade de locais existentes no DB
	printf("----------------- LOCAIS PÚBLICOS -----------------");	
	if(cache_num_rows() > 0) {
		new i = cache_num_rows();
		rowPlaces = i;
		qPlaces = i;
		printf("%d locais públicos foram carregados", i);
		loadDbPlace();
	} else {
		printf("não existe nenhum lugar público para ser carregado");
		return 1;
	}
	return 1;
}

forward OnLoadPlace();//3
public OnLoadPlace() { // Amarmazenar informações do DB em variáveis
	for(new j = 0; j <= rowPlaces; j++) {
		cache_get_value_int(j, "lIntId", PlaceInfo[j+1][lIntId]);
		cache_get_value_int(j, "lLock", PlaceInfo[j+1][lLock]);
		cache_get_value_name(j, "lTitulo", PlaceInfo[j+1][lTtile],64);
		cache_get_value_float(j, "lX", PlaceInfo[j+1][lX]);
		cache_get_value_float(j, "lY", PlaceInfo[j+1][lY]);
		cache_get_value_float(j, "lZ", PlaceInfo[j+1][lZ]);
		cache_get_value_float(j, "eX", PlaceInfo[j+1][eX]);
		cache_get_value_float(j, "eY", PlaceInfo[j+1][eY]);
		cache_get_value_float(j, "eZ", PlaceInfo[j+1][eZ]);
		cache_get_value_float(j, "eA", PlaceInfo[j+1][eA]);
		cache_get_value_int(j, "pIdPlace", PlaceInfo[j+1][pIdPlace]);
		startPlace(j);
		if(qPlaces < PlaceInfo[j][lID]) {
			qPlaces = PlaceInfo[j][lID];
		}
	}
	return 1;
}

forward OnLoadPlaceId(i);
public OnLoadPlaceId(i) {
	cache_get_value_int(0, "lID", PlaceInfo[i][lID]);		
	cache_get_value_int(0, "lIntId", PlaceInfo[i][lIntId]);
	cache_get_value_int(0, "lLock", PlaceInfo[i][lLock]);
	cache_get_value_name(0, "lTitulo", PlaceInfo[i][lTtile],64);
	cache_get_value_float(0, "lX", PlaceInfo[i][lX]);
	cache_get_value_float(0, "lY", PlaceInfo[i][lY]);
	cache_get_value_float(0, "lZ", PlaceInfo[i][lZ]);
	cache_get_value_float(0, "eX", PlaceInfo[i][eX]);
	cache_get_value_float(0, "eY", PlaceInfo[i][eY]);
	cache_get_value_float(0, "eZ", PlaceInfo[i][eZ]);
	cache_get_value_float(0, "eA", PlaceInfo[i][eA]);
	cache_get_value_int(0, "pIdPlace", PlaceInfo[i][pIdPlace]);
	startPlace(i);
	return 1;
}





forward OnCreatePlace(playerid, name[], id, title[]);
public OnCreatePlace(playerid, name[], id, title[]){ // log no console de criação de local público
	PlaceCreate[playerid][clID] = id;
	printf(" ");
	printf("----------------- LOCAIS PÚBLICOS -----------------");
	printf("O(A) %s %s criou local público ID:%d - Titulo: %s", getPlayerAdmin(playerid), name, id, title);
	printf(" ");
	printf(" ");
	new str[128];
	format(str, sizeof(str),"%s| LOCAIS PÚBLICOS | %sDigite: %s/saidaloc %spara setar a saída do local!",EMBED_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE);
	SendClientMessage(playerid, -1, str);
	return 1;
}

/* COMMANDS -----------------------------------------------------------------------------------*/
CMD:cancelint(playerid, params[]) { // CMD para cancelar a alteração de interior
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) {
		if(PlaceModify[playerid][alterPlaceInt] == true) {
			new str[128];
			format(str, sizeof(str),"%s %sVocê cancelou a alteração do interior do local [%sID%s: %d]",
				MSG_PLACE, EMBED_WHITE,EMBED_GREEN, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
			SendClientMessage(playerid, -1, str);
			new i = PlaceModify[playerid][modifyIdPlace];
			SetPlayerPos(playerid, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);		
			SetCameraBehindPlayer(playerid);
			finishModifyPlace(playerid);
			return 1;
		} else {
			sendWarning(playerid, "Você não tem nenhuma alteração de interior pendente!");
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:intloc(playerid, const params[]) { // CMD de confirmar interior do local
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) 
	{
		if(PlaceCreate[playerid][chooseLocInt] == true) {
			PlaceCreate[playerid][chooseIdInt] = tempIntLoc[playerid];//idLocInt
			PlaceCreate[playerid][finishPlace] = true;
			createPlace(playerid);
			return 1;		
		} 
		if(PlaceModify[playerid][alterPlaceInt] == true) {
			//lIntId
			new query[128];
			mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `lIntID`='%d' WHERE `lID`='%d'",
				PlaceModify[playerid][modifyIdIntPlace], PlaceModify[playerid][modifyIdPlace]);
			mysql_tquery(ConexaoSQL, query);
			new str[128];
			format(str, sizeof(str),"%s %sVocê alterou o interior do local [%sID%s: %d] para o interior ID: %d",
				MSG_PLACE, EMBED_WHITE,EMBED_GREEN, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace], PlaceModify[playerid][modifyIdIntPlace]);
			SendClientMessage(playerid, -1, str);
			loadDbPlaceId(PlaceModify[playerid][modifyIdPlace]);
			new i = PlaceModify[playerid][modifyIdPlace];
			SetPlayerPos(playerid, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);		
			SetCameraBehindPlayer(playerid);
			finishModifyPlace(playerid);
			return 1;
		} 
		else {
			new string[128];
			format(string, sizeof(string),"%s| AVISO | %sVocê não está em processo de criação/modificação de local público!", EMBED_WARNING, EMBED_WHITE);
			SendClientMessage(playerid, -1, string);
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:saidaloc(playerid, params[]) // CMD de confirmar saída do local
{
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) 
	{
		if(!IsPlayerInAnyVehicle(playerid)) {
			if(PlaceModify[playerid][alterPlaceExit] == true) {
				showDialogLocExit(playerid);
				return 1;
			}
			if(PlaceCreate[playerid][createExPlace] == true) {
				showDialogLocExit(playerid);	
				return 1;
			}
			else {
				new str[128];
				format(str, sizeof(str),"%s| ERRO | %sVocê não tem nenhum local público com pendência!",EMBED_ERROR, EMBED_WHITE);
				SendClientMessage(playerid, -1, str);
				return 1;	
			}
		}
		else {
			new str[128];
			format(str, sizeof(str),"%s| ERRO | %sVocê não pode estar dentro de um veículo!",EMBED_ERROR, EMBED_WHITE);
			SendClientMessage(playerid, -1, str);
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:modificar(playerid, const params[]) { // CMD para modificar local -> Interior, Pickup, Titulo, Saída e Excluir
	if(IsPlayerAdmin(playerid)) {
		new i = getLocalPublic(playerid);
		if(i > 0) {
			finishModifyPlace(playerid);
			PlaceModify[playerid][modifyIdPlace] = i;
			new str[128];
			format(str, sizeof(str),"%s %sVocê está modificando o local [%sID%s: %d]",MSG_SERVER, EMBED_WHITE, EMBED_GREEN, EMBED_WHITE, i);
			SendClientMessage(playerid, -1, str);
			showDialogLocModify(playerid);
		} else if(i <= 0) {
			new string[128];
			format(string, sizeof(string),"%s| AVISO | %sVocê não está em um local público!",EMBED_WARNING, EMBED_WHITE);
			SendClientMessage(playerid, -1, string);
		}
		return 1;
	} else {
		return 0;
	}
}

/* FUNCTIONS ------------------------------------------------------------------------------------*/

stock loadDbPlace() { // Carregar local pelo ID
	new query[128];
	mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `places`");
	mysql_tquery(ConexaoSQL, query, "OnLoadPlace", "d", loadRowPlace);
	loadRowPlace++;
	return 1;
}

stock loadDbPlaceId(i) { // Carregar local pelo ID
	stopPlace(i);
	new query[128];
	mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `places` WHERE `lID`= '%d'",i);
	mysql_tquery(ConexaoSQL, query, "OnLoadPlaceId", "d", i);
	return 1;
}

stock getLocalPublic(playerid) { // verificar se o player está em um local e retornar o id
	for(new i = 1; i <= qPlaces; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ])) {
			return i;
		}
	}
	return -1;
}

stock getInLocalPublic(playerid) { // verificar se o player está dentro de um local e retornar id
	for(new i = 0; i <= MAX_INT_PLACES-1; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, intsInfosLoc[i][doorIntLoc][0], intsInfosLoc[i][doorIntLoc][1], intsInfosLoc[i][doorIntLoc][2])) {
			new k = GetPlayerVirtualWorld(playerid);
			return k;
		}
	}
	return 0;
}

stock showDialogLocInts(playerid) { // confirmação de setar interior para local
	new string[256];
	new strInfo[128];
	for(new i = 0; i < MAX_INT_PLACES-1; i++){
		format(strInfo, sizeof(strInfo),"%s\n",intsInfosLoc[i][intLocTitle]);
		strcat(string, strInfo);
	}
	ShowPlayerDialog(playerid, DIALOG_LOC_INTS, DIALOG_STYLE_LIST, "{FFFFFF}Interiores local público", string,"Confirmar","Cancelar");
	return 1;
}

stock showDialogLocExit(playerid) { // confirmação de setar de saída do local
	ShowPlayerDialog(playerid, DIALOG_LOC_EXIT, DIALOG_STYLE_MSGBOX, "{FFFFFF}Local público","{ffffff}Você realmente deseja setar a saída do local aqui?","Confirmar","Cancelar");
	return 1;
}

stock showDialogLocModify(playerid) { // mostrar menu de modificação do local
	new i = getLocalPublic(playerid);
	new strTitle[128];
	format(strTitle, sizeof(strTitle),"{ffffff}Local: [ %sID: %s%d ]", EMBED_GREEN, EMBED_WHITE, i);
	ShowPlayerDialog(playerid, DIALOG_LOC_MODIFY, DIALOG_STYLE_LIST, strTitle, 
	"Alterar Interior\n\
	Alterar Pickup\n\
	Alterar Saída\n\
	Alterar Titulo\n\
	{ff0000}Trancar{ffffff}/{00ff00}Destrancar\n\
	Excluir\n",
	"Confirmar","Fechar");
	return 1;
}

stock createPlace(playerid) { // função de criar local
	if(qPlaces < MAX_PLACES) {
		if(PlaceCreate[playerid][finishPlace] == true) {
			qPlaces++;
			new string[128];
			format(string, sizeof(string),"criou local publico %d",qPlaces);
			createLog(playerid, 0, string, na(), na());
			new strDebug[256];
			format(strDebug, sizeof(strDebug),"DEBUG - INSERT INTO `places` (`lID`,`lIntId`,`lTitulo`,`lX`,`lY`,`lZ`,\
				`lLock`,`pIdPlace`) VALUES ('%d','%d','%s','%f','%f','%f','%d','%d')", qPlaces, 
				PlaceCreate[playerid][chooseIdInt], PlaceCreate[playerid][clTitle],
				PlaceCreate[playerid][clX], PlaceCreate[playerid][clY], 
				PlaceCreate[playerid][clZ], 0, PlaceCreate[playerid][clPickup]);
			SendClientMessage(playerid, -1, strDebug);
			new query[350];
			mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `places` (`lID`,`lIntId`,`lTitulo`,`lX`,`lY`,`lZ`,\
				`lLock`,`pIdPlace`) VALUES ('%d','%d','%s','%f','%f','%f','%d','%d')", qPlaces, 
				PlaceCreate[playerid][chooseIdInt], PlaceCreate[playerid][clTitle],
				PlaceCreate[playerid][clX], PlaceCreate[playerid][clY], 
				PlaceCreate[playerid][clZ], 0, PlaceCreate[playerid][clPickup]);
			mysql_tquery(ConexaoSQL, query, "OnCreatePlace", "dsds", playerid, getNamePlayer(playerid), qPlaces, PlaceCreate[playerid][clTitle]);
			new i = qPlaces;
			PlaceInfo[i][lID] = i;
			format(PlaceInfo[i][lTtile], 64, "%s", PlaceCreate[playerid][clTitle]);
			PlaceInfo[i][lX] = PlaceCreate[playerid][clX];
			PlaceInfo[i][lY] = PlaceCreate[playerid][clY];
			PlaceInfo[i][lZ] = PlaceCreate[playerid][clZ];
			PlaceInfo[i][pIdPlace] = PlaceCreate[playerid][clPickup];
			PlaceInfo[i][lIntId] = PlaceCreate[playerid][chooseIdInt];	
			SetPlayerPos(playerid, PlaceCreate[playerid][clX], PlaceCreate[playerid][clY], PlaceCreate[playerid][clZ]);
			SetPlayerInterior(playerid, 0);
			startPlace(qPlaces);	
			PlaceCreate[playerid][createExPlace] = true;
			finishCreatePlace(playerid);
			finishCreateIntPlace(playerid);
			return 1;
		}
		if(PlaceCreate[playerid][cPlace] == true) {
			new str[128];
			format(str, sizeof(str),"%s| AVISO | %sVocê já possui um local em processo de criação!\n\n\
				Deseja prosseguir assim mesmo?",EMBED_WARNING, EMBED_WHITE);
			ShowPlayerDialog(playerid, DIALOG_CONF_LOCATION, DIALOG_STYLE_MSGBOX, "{FFFFFF}Criar local público", str, "Confirmar", "Cancelar");
			return 1;
		}
		if(PlaceCreate[playerid][cPlace] == false) {	
			new Float: X, Float: Y, Float: Z;
			GetPlayerPos(playerid, X, Y, Z);
			PlaceCreate[playerid][clX] = X;
			PlaceCreate[playerid][clY] = Y;
			PlaceCreate[playerid][clZ] = Z;			
			showDialogLocTitle(playerid);
			PlaceCreate[playerid][cPlace] = true;
			return 1;
		} 			                                                                                                                    
	} else {
		new str[128];
		format(str, sizeof(str),"%s| AVISO | %sO servidor atingiu o máximo de locais possíveis | %d/%d",
		EMBED_WARNING, EMBED_WHITE, qPlaces, MAX_PLACES);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 1;
}

stock startPlace(i){ // iniciar local
	PlaceInfo[i][lText] = CreateDynamic3DTextLabel(PlaceInfo[i][lTtile], COLOR_WHITE,
	PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0,-1, 0);
	
	PlaceInfo[i][lPickup] = CreateDynamicPickup(PlaceInfo[i][pIdPlace], 1, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ], -1, -1, -1, STREAMER_PICKUP_SD, -1, 0);
	return 1;
}

stock restartPckpPlace(i) { // finalizar pickup
	DestroyDynamicPickup(PlaceInfo[i][lPickup]);
	return 1;
}

stock restartTextPlace(i) { //reinicializar 3DTextLabel
	DestroyDynamic3DTextLabel(PlaceInfo[i][lText]);
	return 1;
}

stock stopPlace(i) { // finalizar local
	DestroyDynamicPickup(PlaceInfo[i][lPickup]);
	DestroyDynamic3DTextLabel(PlaceInfo[i][lText]);
	return 1;
}

stock showDialogLocTitle(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOC_TITLE, DIALOG_STYLE_INPUT, "{FFFFFF}criação local público", "{ffffff}\nCrie um titulo para esse local público!\n", "Confirmar","Cancelar");
	return 1;
}

stock showMenuLocPickup(playerid) {
	mSecMenuPcikup[playerid] = ShowModelSelectionMenuEx(playerid, menuPickups[idPickup], 59, "Pickups", 0, 0.0, 0.0, 35.0, 1.0, 0x4A5A6BBB, 0x88888899 , 0xFFFF00AA);
	return 1;
}

stock finishCreatePlace(playerid) {
	PlaceCreate[playerid][clTitle] = 0;
	PlaceCreate[playerid][clPickup] = 0;
	PlaceCreate[playerid][clX] = 0;
	PlaceCreate[playerid][clY] = 0;
	PlaceCreate[playerid][clZ] = 0;
	PlaceCreate[playerid][finishPlace] = false;
	return 1;
}

stock finishCreateExPlace(playerid) {
	PlaceCreate[playerid][cPlace] = false;
	PlaceCreate[playerid][elX] = 0;
	PlaceCreate[playerid][elY] = 0;
	PlaceCreate[playerid][elZ] = 0;
	PlaceCreate[playerid][elA] = 0;
	PlaceCreate[playerid][createExPlace] = false;
	return 1;
}

stock finishCreateIntPlace(playerid) {
	PlaceCreate[playerid][clID] = 0;
	PlaceCreate[playerid][chooseLocInt] = false;
	PlaceCreate[playerid][chooseIdInt] = 0;
	return 1;
}

stock setInteriorPlace(playerid, i) {
	for(new k = 0; k <= MAX_INT_PLACES; k++) {
		if(intsInfosLoc[k][idLocInt] == i) { 
			SetPlayerPos(playerid, intsInfosLoc[k][insideIntLoc][0], intsInfosLoc[k][insideIntLoc][1], intsInfosLoc[k][insideIntLoc][2]);
			SetPlayerInterior(playerid, intsInfosLoc[k][intLocId]);
			SetPlayerFacingAngle(playerid, intsInfosLoc[k][insideIntLoc][3]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
	}
	return 1;
}

stock createPickupInts() {
	for(new i = 0; i <= MAX_INT_PLACES-1; i++){
		CreateDynamicPickup(1318, 1, intsInfosLoc[i][doorIntLoc][0], intsInfosLoc[i][doorIntLoc][1], intsInfosLoc[i][doorIntLoc][2],
		-1, intsInfosLoc[i][intLocId], -1, 20.0, -1, 0);
	}
	return 1;
}

stock finishModifyPlace(playerid) {
	PlaceModify[playerid][modifyIdPlace] = 0;
	PlaceModify[playerid][alterPlaceInt] = false;
	PlaceModify[playerid][alterPlacePickup] = false;
	PlaceModify[playerid][alterPlaceExit] = false;
	PlaceModify[playerid][alterPlaceTitle] = false;
	PlaceModify[playerid][deletePlace] = false;
	return 1;
}

stock placeAlterPckp(playerid) {
	new strTitle[128], strText[128];
	format(strTitle, sizeof(strTitle),"%sAlterar pickup local [%sID%s: %d]",EMBED_WHITE, EMBED_GREEN, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace]);
	format(strText, sizeof(strText),"%sVocê realmente deseja alterar a pickup do local [%sID%s: %d]\n\n\
		Para pickup [%sID%s: %d]",EMBED_WHITE, EMBED_GREEN, EMBED_WHITE, PlaceModify[playerid][modifyIdPlace],EMBED_GREEN, EMBED_WHITE, PlaceModify[playerid][modifyIdPickupPlace]);
	ShowPlayerDialog(playerid, DIALOG_LOC_MOD_PCIKUP, DIALOG_STYLE_MSGBOX, strTitle, strText, "Confirmar","Cancelar");
	return 1;
}

stock placeAlterTitle(playerid) {
	new strTitle[64], strText[128], i = PlaceModify[playerid][modifyIdPlace];
	format(strTitle, sizeof(strTitle),"%sAlterar título local [%sID%s: %d]",EMBED_WHITE, EMBED_GREEN, EMBED_WHITE, i);
	format(strText, sizeof(strText),"%sDigite o título que você deseja setar para esse local:",EMBED_WHITE);
	ShowPlayerDialog(playerid, DIALOG_LOC_MOD_TITLE, DIALOG_STYLE_INPUT, strTitle, strText, "Confirmar","Cancelar");
	return 1;
}

stock confPlaceDelete(playerid) {
	new strTitle[64], strText[128], i = PlaceModify[playerid][modifyIdPlace];
	format(strTitle, sizeof(strTitle),"%sLocal [%sID%s: %d]",EMBED_WHITE, EMBED_GREEN, EMBED_WHITE, i);
	format(strText, sizeof(strText),"%sVocê realmente deseja excluir esse local?",EMBED_WHITE);
	ShowPlayerDialog(playerid, DIALOG_LOC_MOD_DELETE, DIALOG_STYLE_MSGBOX, strTitle, strText, "Confirmar","Cancelar");
	return 1;
}