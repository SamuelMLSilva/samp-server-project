/* 
	criar 	sistema de locais
	criar 	db --------------------------------------done
	criar 	loaddb ----------------------------------done
	criar 	funcao de criar local -------------------done	
	criar	cmd /aqui para setar saída --------------done
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
		if(LocationCreate[playerid][clPickup] < 1) {
			if(LocationCreate[playerid][cLocation] == true) {
				LocationCreate[playerid][clPickup] = modelid;
				LocationCreate[playerid][finishLocation] = true;
				createLocation(playerid);
				return 1;
			}	
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	finishCreateLocation(playerid);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(dialogid == DIALOG_LOC_TITLE) {
		if(response) {
			format(LocationCreate[playerid][clTitle], 64, "%s", inputtext);
			SendClientMessage(playerid, -1, LocationCreate[playerid][clTitle]);
			showMenuLocPickup(playerid);	
			return 1;
		} else {
			finishCreateLocation(playerid);
			return 1;
		}
	}
	if(dialogid == DIALOG_CONF_LOCATION) {
		if(response) {
			createLocation(playerid);
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
			mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE `locations` SET `eX`='%f',`eY`='%f',`eZ`='%f', `eA`='%f' WHERE `lID`='%d'",
				X, Y, Z, A, LocationCreate[playerid][clID]);
			mysql_tquery(ConexaoSQL, query, "OnUpdateLocation","dd", playerid, LocationCreate[playerid][clID]);
			finishCreateExLocation(playerid);
			return 1;
		} else {
			return 1;
		}
	}
	return 1;
}

forward OnUpdateLocation(playerid, i);
public OnUpdateLocation(playerid,i) {
	printf("Foi setado a saída do local %d",i);
	new str[128];
	format(str, sizeof(str),"%s| LOCAL PÚBLICO | %sVocê setou a saída do local ID: %02d", EMBED_SERVER, EMBED_WHITE, i);
	SendClientMessage(playerid, -1, str);
	return 1;
}

forward OnGetLocations();
public OnGetLocations(){
	printf("                                              ");
	printf("----------------- LOCAIS PÚBLICOS -----------------");	
	if(cache_num_rows() > 0) {
		new i = cache_num_rows();
		printf("%d locais públicos foram carregados\n\n", i);
		printf("                                              ");
		printf("											  ");
		qLocations = i;
		new query[128];
		mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `locations`");
    	mysql_tquery(ConexaoSQL, query, "OnLoadLocation", "d", qLocations);
	} else {
		printf("não existe nenhum lugar público para ser carregado");
		return 1;
	}
	return 1;
}

forward OnLoadLocation(qtd);
public OnLoadLocation(qtd) {
	for(new i = 1; i <= qtd; i++) {
		cache_get_value_int(i-1, "lID", LocationInfo[i][lID]);
		cache_get_value_name(i-1, "lTitulo", LocationInfo[i][lTtile],64);
		cache_get_value_float(i-1, "lX", LocationInfo[i][lX]);
		cache_get_value_float(i-1, "lY", LocationInfo[i][lY]);
		cache_get_value_float(i-1, "lZ", LocationInfo[i][lZ]);
		cache_get_value_float(i-1, "eX", LocationInfo[i][eX]);
		cache_get_value_float(i-1, "eY", LocationInfo[i][eY]);
		cache_get_value_float(i-1, "eZ", LocationInfo[i][eZ]);
		cache_get_value_float(i-1, "eA", LocationInfo[i][eA]);
		cache_get_value_float(i-1, "liX", LocationInfo[i][liX]);
		cache_get_value_float(i-1, "liY", LocationInfo[i][liY]);
		cache_get_value_float(i-1, "liZ", LocationInfo[i][liZ]);
		cache_get_value_float(i-1, "liA", LocationInfo[i][liA]);
		cache_get_value_int(i-1, "lI", LocationInfo[i][lI]);
		cache_get_value_int(i-1, "lVW", LocationInfo[i][lVW]);
		cache_get_value_int(i-1, "pIdLocation", LocationInfo[i][pIdLocation]);
	}
	startServerLocation();
	return 1;
}

CMD:aqui(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] > 3) 
	{
		if(!IsPlayerInAnyVehicle(playerid)) {
			if(LocationCreate[playerid][createExLocation] == true) {
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

CMD:modificar(playerid, const params[]) {
	if(IsPlayerAdmin(playerid)) {
		new i = getLocalPublico(playerid);
		if(i != 0) {
			showDialogLocModify(playerid);
		} else if(i == 0) {
			new string[128];
			format(string, sizeof(string),"%s| AVISO | %sVocê não está em um local público!",EMBED_WARNING, EMBED_WHITE);
			SendClientMessage(playerid, -1, string);
		}
		return 1;
	} else {
		return 0;
	}
}

CMD:testeints(playerid, const params[]) {
	showDialogLocInts(playerid);
	/*intLocTitle[32],
	intLocId,
	intLocPos[3]*/
	new str[256];
	format(str, sizeof(str),"Titulo: %s Interior: %d Coords: X - %f Y - %f Z - %f",
	 intsInfosLoc[0][intLocTitle],  intsInfosLoc[0][intLocId], intsInfosLoc[0][intLocPos][0], intsInfosLoc[0][intLocPos][1],
	 intsInfosLoc[0][intLocPos][2]);
	SendClientMessage(playerid, -1, str);
	return 1;
}


stock getLocalPublico(playerid) {
	for(new i = 1; i <= qLocations; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, LocationInfo[i][lX], LocationInfo[i][lY], LocationInfo[i][lZ])) {
			return i;
		}
	}
	return 0;
}

stock showDialogLocInts(playerid) {
	//DIALOG_LOC_INTS
	new string[128];
	ShowPlayerDialog(playerid, DIALOG_LOC_INTS, DIALOG_STYLE_LIST, "{FFFFFF}Interiores local público", string,"Confirmar","Cancelar");
	return 1;
}

stock showDialogLocExit(playerid) {
	ShowPlayerDialog(playerid, DIALOG_LOC_EXIT, DIALOG_STYLE_MSGBOX, "{FFFFFF}Local público","{ffffff}Você realmente deseja setar a saída do local aqui?","Confirmar","Cancelar");
	return 1;
}

stock showDialogLocModify(playerid) {
	new i = getLocalPublico(playerid);
	new strTitle[128];
	format(strTitle, sizeof(strTitle),"{ffffff}Local: [ %sID:%s%d ]", EMBED_GREEN, EMBED_WHITE, i);
	ShowPlayerDialog(playerid, DIALOG_LOC_MODIFY, DIALOG_STYLE_LIST, strTitle, 
	"Alterar Interior\n\
	Alterar Pickup\n\
	Alterar Saída\n\
	Alterar Titulo\n\
	Excluir\n\
	{ff0000}Trancar{ffffff}/{00ff00}Destrancar\n",
	"Confirmar","Fechar");
	return 1;
}

stock createLocation(playerid) {
	if(qLocations < MAX_LOCATIONS) {
		if(LocationCreate[playerid][finishLocation] == true) {
			qLocations++;

			new string[128];
			format(string, sizeof(string),"criou local publico %d",qLocations);
			createLog(playerid, 0, string, na(), na());
			
			new query[350];
			mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `locations` (`lID`,`lTitulo`,`lX`,`lY`,`lZ`,`lVW`,
				`lLock`,`pIdLocation`) VALUES ('%d','%s','%f','%f','%f','%d','%d','%d')", qLocations, 
				LocationCreate[playerid][clTitle],
				LocationCreate[playerid][clX], LocationCreate[playerid][clY], 
				LocationCreate[playerid][clZ], qLocations, 0, LocationCreate[playerid][clPickup]);
			mysql_tquery(ConexaoSQL, query, "OnCreateLocation", "dsds", playerid, getNamePlayer(playerid), qLocations, LocationCreate[playerid][clTitle]);
			new i = qLocations;
			LocationInfo[i][lID] = i;
			format(LocationInfo[i][lTtile], 64, "%s", LocationCreate[playerid][clTitle]);
			LocationInfo[i][lX] = LocationCreate[playerid][clX];
			LocationInfo[i][lY] = LocationCreate[playerid][clY];
			LocationInfo[i][lZ] = LocationCreate[playerid][clZ];
			LocationInfo[i][lVW] = qLocations;
			LocationInfo[i][pIdLocation] = LocationCreate[playerid][clPickup];	
			startLocation(qLocations);	
			LocationCreate[playerid][createExLocation] = true;
			finishCreateLocation(playerid);
			return 1;
		}
		if(LocationCreate[playerid][cLocation] == true) {
			new str[128];
			format(str, sizeof(str),"%s| AVISO | %sVocê já possui um local em processo de criação!\n\n\
				Deseja prosseguir assim mesmo?",EMBED_WARNING, EMBED_WHITE);
			ShowPlayerDialog(playerid, DIALOG_CONF_LOCATION, DIALOG_STYLE_MSGBOX, "{FFFFFF}Criar local público", str, "Confirmar", "Cancelar");
			return 1;
		}
		if(LocationCreate[playerid][cLocation] == false) {	
			new Float: X, Float: Y, Float: Z;
			GetPlayerPos(playerid, X, Y, Z);
			LocationCreate[playerid][clX] = X;
			LocationCreate[playerid][clY] = Y;
			LocationCreate[playerid][clZ] = Z;			
			showDialogLocTitle(playerid);
			LocationCreate[playerid][cLocation] = true;
			return 1;
		} 			                                                                                                                    
	} else {
		new str[128];
		format(str, sizeof(str),"%s| AVISO | %sO servidor atingiu o máximo de locais possíveis | %d/%d",
		EMBED_WARNING, EMBED_WHITE, qLocations, MAX_LOCATIONS);
		SendClientMessage(playerid, -1, str);
		return 1;
	}
	return 1;
}


forward OnCreateLocation(playerid, name[], id, title[]);
public OnCreateLocation(playerid, name[], id, title[]){
	LocationCreate[playerid][clID] = id;
	printf(" ");
	printf("----------------- LOCAIS PÚBLICOS -----------------");
	printf("O(A) %s %s criou local público ID:%d - Titulo: %s", getPlayerAdmin(playerid), name, id, title);
	printf(" ");
	printf(" ");
	new str[128];
	format(str, sizeof(str),"%s| LOCAIS PÚBLICOS | %sDigite: %s/aqui %spara setar a saída do local!",EMBED_SERVER, EMBED_WHITE, EMBED_SERVER, EMBED_WHITE);
	SendClientMessage(playerid, -1, str);
	return 1;
}

stock startLocation(i){
	LocationInfo[i][lText] = CreateDynamic3DTextLabel(LocationInfo[i][lTtile], COLOR_WHITE,
	LocationInfo[i][lX], LocationInfo[i][lY], LocationInfo[i][lZ], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0,-1, 0);
	LocationInfo[i][lPickup] = CreateDynamicPickup(LocationInfo[i][pIdLocation], 1, LocationInfo[i][lX], LocationInfo[i][lY], LocationInfo[i][lZ], -1, -1, -1, STREAMER_PICKUP_SD, -1, 0);
	return 1;
}

stock startServerLocation() {
	for(new i = 1; i <= qLocations; i++) {
		startLocation(i);
	}
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

stock finishCreateLocation(playerid) {
	LocationCreate[playerid][clTitle] = 0;
	LocationCreate[playerid][clPickup] = 0;
	LocationCreate[playerid][clX] = 0;
	LocationCreate[playerid][clY] = 0;
	LocationCreate[playerid][clZ] = 0;
	LocationCreate[playerid][finishLocation] = false;
	return 1;
}

stock finishCreateExLocation(playerid) {
	LocationCreate[playerid][cLocation] = false;
	LocationCreate[playerid][clID] = 0;
	LocationCreate[playerid][elX] = 0;
	LocationCreate[playerid][elY] = 0;
	LocationCreate[playerid][elZ] = 0;
	LocationCreate[playerid][elA] = 0;
	LocationCreate[playerid][createExLocation] = false;
	return 1;
}