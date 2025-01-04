/* 
	criar 	sistema de locais
	criar 	db --------------------------------------done
	criar 	loaddb ----------------------------------done
	criar 	funcao de criar local -------------------done	
	criar	cmd /saidaloc para setar sa�da --------------done
	criar	cmd /modificar -> mudar int, mudar pickup, trancar/destrancar, excluir

*/
#include <YSI_Coding\y_hooks>

new mSecMenuPcikup[MAX_PLAYERS];

enum pickupsMenu {
	idPickup
};

static const menuPickups[][pickupsMenu] = {
	{954}, {1210}, {1212}, {1213}, {1239}, {1240}, {1241}, {1242}, {1247}, {1248}, {1252}, 
	{1254}, {1272}, {1273}, {1274}, {1275}, {1276}, {1277}, {1279}, {1310}, {1313}, {1314},
	{1318}, {1550}, {1575}, {1576}, {1577}, {1578}, {1579}, {1580}, {1581}, {1582}, {1636}, 
	{1650}, {1654}, {2057}, {2060}, {2061}, {2690}, {2710}, {11736}, {11738}, {19130}, {19131}, 
	{19132}, {19133}, {19134}, {19135}, {19197}, {19198}, {19320}, {19522}, {19523}, {19524}, {19602},
	{19605}, {19606}, {19607}, {19832}
};

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid) {
	
	if(modelid > 0) {
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
		if(newkeys & KEY_SECONDARY_ATTACK) {
			new enterPlace = getLocalPublic(playerid);
			if(enterPlace > 0) {
				SetPlayerVirtualWorld(playerid, enterPlace);
				setInteriorPlace(playerid, enterPlace);
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
	if(dialogid == DIALOG_LOC_INTS) {
		if(response) {
			new i = listitem;
			SetPlayerPos(playerid, intsInfosLoc[i][insideIntLoc][0], intsInfosLoc[i][insideIntLoc][1], intsInfosLoc[i][insideIntLoc][2]);
			SetPlayerFacingAngle(playerid, intsInfosLoc[i][insideIntLoc][3]);
			SetPlayerInterior(playerid, intsInfosLoc[i][intLocId]);	
			SetCameraBehindPlayer(playerid);
			tempIntLoc[playerid] = intsInfosLoc[i][idLocInt];	
			new str[128];
			format(str, sizeof(str),"%s| LOCAIS P�BLICOS | %sDigite: %s/intloc %spara setar o interior do local!",EMBED_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE);
			SendClientMessage(playerid, -1, str);	
			return 1;
		} else {
			return 1;
		}
	}

	if(dialogid == DIALOG_LOC_MODIFY) {
		if(response) {
			switch(listitem) {
				case 0: {
					showDialogLocInts(playerid);
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
			new query[350];
			mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `places` SET `eX`='%f',`eY`='%f',`eZ`='%f', `eA`='%f' WHERE `lID`='%d'",
				X, Y, Z, A, PlaceCreate[playerid][clID]);
			mysql_tquery(ConexaoSQL, query, "OnUpdatePlace","dd", playerid, PlaceCreate[playerid][clID]);
			finishCreateExPlace(playerid);
			return 1;
		} else {
			return 1;
		}
	}
	return 1;
}

forward OnUpdatePlace(playerid, i);
public OnUpdatePlace(playerid,i) {
	printf("Foi setado a sa�da do local %d",i);
	new str[128];
	format(str, sizeof(str),"%s| LOCAIS P�BLICO | %sVoc� setou a sa�da do local ID: %02d", EMBED_SERVER, EMBED_WHITE, i);
	SendClientMessage(playerid, -1, str);
	return 1;
}

forward OnGetPlaces();
public OnGetPlaces(){
	printf("                                              ");
	printf("----------------- LOCAIS P�BLICOS -----------------");	
	if(cache_num_rows() > 0) {
		new i = cache_num_rows();
		printf("%d locais p�blicos foram carregados\n\n", i);
		printf("                                              ");
		printf("											  ");
		qPlaces = i;
		new query[128];
		mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `places`");
    	mysql_tquery(ConexaoSQL, query, "OnLoadPlace", "d", qPlaces);
	} else {
		printf("n�o existe nenhum lugar p�blico para ser carregado");
		return 1;
	}
	return 1;
}

forward OnLoadPlace(qtd);
public OnLoadPlace(qtd) {
	for(new i = 1; i <= qtd; i++) {
		cache_get_value_int(i-1, "lID", PlaceInfo[i][lID]);
		cache_get_value_int(i-1, "lIntId", PlaceInfo[i][lIntId]);
		cache_get_value_name(i-1, "lTitulo", PlaceInfo[i][lTtile],64);
		cache_get_value_float(i-1, "lX", PlaceInfo[i][lX]);
		cache_get_value_float(i-1, "lY", PlaceInfo[i][lY]);
		cache_get_value_float(i-1, "lZ", PlaceInfo[i][lZ]);
		cache_get_value_float(i-1, "eX", PlaceInfo[i][eX]);
		cache_get_value_float(i-1, "eY", PlaceInfo[i][eY]);
		cache_get_value_float(i-1, "eZ", PlaceInfo[i][eZ]);
		cache_get_value_float(i-1, "eA", PlaceInfo[i][eA]);
		cache_get_value_int(i-1, "pIdPlace", PlaceInfo[i][pIdPlace]);
	}
	startServerPlace();
	return 1;
}

CMD:intloc(playerid, const params[]) {
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) 
	{
		if(PlaceCreate[playerid][chooseLocInt] == true) {
			PlaceCreate[playerid][chooseIdInt] = tempIntLoc[playerid];//idLocInt
			PlaceCreate[playerid][finishPlace] = true;
			createPlace(playerid);
			return 1;		
		} else {
			new string[128];
			format(string, sizeof(string),"%s| AVISO | %sVoc� n�o est� em processo de cria��o de local p�blico!", EMBED_WARNING, EMBED_WHITE);
			SendClientMessage(playerid, -1, string);
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:saidaloc(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) 
	{
		if(!IsPlayerInAnyVehicle(playerid)) {
			if(PlaceCreate[playerid][createExPlace] == true) {
				showDialogLocExit(playerid);	
				return 1;
			}
			else {
				new str[128];
				format(str, sizeof(str),"%s| ERRO | %sVoc� n�o tem nenhum local p�blico com pend�ncia!",EMBED_ERROR, EMBED_WHITE);
				SendClientMessage(playerid, -1, str);
				return 1;	
			}
		}
		else {
			new str[128];
			format(str, sizeof(str),"%s| ERRO | %sVoc� n�o pode estar dentro de um ve�culo!",EMBED_ERROR, EMBED_WHITE);
			SendClientMessage(playerid, -1, str);
			return 1;
		}
	} else {
		return 0;
	}
}

CMD:modificar(playerid, const params[]) {
	if(IsPlayerAdmin(playerid)) {
		new i = getLocalPublic(playerid);
		if(i != 0) {
			showDialogLocModify(playerid);
		} else if(i == 0) {
			new string[128];
			format(string, sizeof(string),"%s| AVISO | %sVoc� n�o est� em um local p�blico!",EMBED_WARNING, EMBED_WHITE);
			SendClientMessage(playerid, -1, string);
		}
		return 1;
	} else {
		return 0;
	}
}

CMD:testeints(playerid, const params[]) {
	showDialogLocInts(playerid);
	return 1;
}

stock getLocalPublic(playerid) {
	for(new i = 1; i <= qPlaces; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ])) {
			return i;
		}
	}
	return 0;
}

stock getInLocalPublic(playerid) {
	for(new i = 0; i <= qInts; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, intsInfosLoc[i][doorIntLoc][0], intsInfosLoc[i][doorIntLoc][1], intsInfosLoc[i][doorIntLoc][2])) {
			return GetPlayerVirtualWorld(playerid);
		}
	}
	return 0;
}

stock showDialogLocInts(playerid) {
	new string[256];
	new strInfo[128];
	for(new i = 0; i < 6; i++){
		format(strInfo, sizeof(strInfo),"%s\n",intsInfosLoc[i][intLocTitle]);
		strcat(string, strInfo);
	}
	ShowPlayerDialog(playerid, DIALOG_LOC_INTS, DIALOG_STYLE_LIST, "{FFFFFF}Interiores local p�blico", string,"Confirmar","Cancelar");
	return 1;
}

stock showDialogLocExit(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOC_EXIT, DIALOG_STYLE_MSGBOX, "{FFFFFF}Local p�blico","{ffffff}Voc� realmente deseja setar a sa�da do local aqui?","Confirmar","Cancelar");
	return 1;
}

stock showDialogLocModify(playerid) {
	new i = getLocalPublic(playerid);
	new strTitle[128];
	format(strTitle, sizeof(strTitle),"{ffffff}Local: [ %sID:%s%d ]", EMBED_GREEN, EMBED_WHITE, i);
	ShowPlayerDialog(playerid, DIALOG_LOC_MODIFY, DIALOG_STYLE_LIST, strTitle, 
	"Alterar Interior\n\
	Alterar Pickup\n\
	Alterar Sa�da\n\
	Alterar Titulo\n\
	Excluir\n\
	{ff0000}Trancar{ffffff}/{00ff00}Destrancar\n",
	"Confirmar","Fechar");
	return 1;
}

stock createPlace(playerid) {
	if(qPlaces < MAX_PLACES) {
		if(PlaceCreate[playerid][finishPlace] == true) {
			qPlaces++;

			new string[128];
			format(string, sizeof(string),"criou local publico %d",qPlaces);
			createLog(playerid, 0, string, na(), na());
			new strDebug[256];
			format(strDebug, sizeof(strDebug),"INSERT INTO `places` (`lID`,`lIntId`,`lTitulo`,`lX`,`lY`,`lZ`,\
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
			return 1;
		}
		if(PlaceCreate[playerid][cPlace] == true) {
			new str[128];
			format(str, sizeof(str),"%s| AVISO | %sVoc� j� possui um local em processo de cria��o!\n\n\
				Deseja prosseguir assim mesmo?",EMBED_WARNING, EMBED_WHITE);
			ShowPlayerDialog(playerid, DIALOG_CONF_LOCATION, DIALOG_STYLE_MSGBOX, "{FFFFFF}Criar local p�blico", str, "Confirmar", "Cancelar");
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
		format(str, sizeof(str),"%s| AVISO | %sO servidor atingiu o m�ximo de locais poss�veis | %d/%d",
		EMBED_WARNING, EMBED_WHITE, qPlaces, MAX_PLACES);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 1;
}


forward OnCreatePlace(playerid, name[], id, title[]);
public OnCreatePlace(playerid, name[], id, title[]){
	PlaceCreate[playerid][clID] = id;
	printf(" ");
	printf("----------------- LOCAIS P�BLICOS -----------------");
	printf("O(A) %s %s criou local p�blico ID:%d - Titulo: %s", getPlayerAdmin(playerid), name, id, title);
	printf(" ");
	printf(" ");
	new str[128];
	format(str, sizeof(str),"%s| LOCAIS P�BLICOS | %sDigite: %s/saidaloc %spara setar a sa�da do local!",EMBED_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE);
	SendClientMessage(playerid, -1, str);
	return 1;
}

stock startPlace(i){
	PlaceInfo[i][lText] = CreateDynamic3DTextLabel(PlaceInfo[i][lTtile], COLOR_WHITE,
	PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0,-1, 0);
	PlaceInfo[i][lPickup] = CreateDynamicPickup(PlaceInfo[i][pIdPlace], 1, PlaceInfo[i][lX], PlaceInfo[i][lY], PlaceInfo[i][lZ], -1, -1, -1, STREAMER_PICKUP_SD, -1, 0);
	return 1;
}

stock startServerPlace() {
	for(new i = 1; i <= qPlaces; i++) {
		startPlace(i);
	}
	return 1;
}

stock showDialogLocTitle(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOC_TITLE, DIALOG_STYLE_INPUT, "{FFFFFF}cria��o local p�blico", "{ffffff}\nCrie um titulo para esse local p�blico!\n", "Confirmar","Cancelar");
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
	new j = PlaceInfo[i][lIntId];
	SetPlayerPos(playerid, intsInfosLoc[j][insideIntLoc][0], intsInfosLoc[j][insideIntLoc][1], intsInfosLoc[j][insideIntLoc][2]);
	SetPlayerInterior(playerid, intsInfosLoc[j][intLocId]);
	SetPlayerFacingAngle(playerid, intsInfosLoc[j][insideIntLoc][3]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

stock createPickupInts() {
	for(new i = 0; i <= 5; i++){
		CreateDynamicPickup(1318, 1, intsInfosLoc[i][doorIntLoc][0], intsInfosLoc[i][doorIntLoc][1], intsInfosLoc[i][doorIntLoc][2],
		-1, intsInfosLoc[i][intLocId], -1, 20.0, -1, 0);
	}
	return 1;
}