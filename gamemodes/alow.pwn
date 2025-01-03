#include <open.mp>
#include <sscanf2>
#include <izcmd>
#include <a_mysql>
#include <streamer>
#include <zones>

#define         COR_SELECT              0x1E90FFFF

#define         NAME_SERVER             "Brasil Cidade Metropolitana"
#define         SIGLA_SERVER            "BCM"
#define         INFO_CASAS              "{1E90FF}CASAS | {FFFFFF}"
#define         MAX_HOUSES              100
#define         MAX_LOCAIS              100
#define         HOUSE_AVENDA            0
#define         HOUSE_COMPRADA          1
#define         MAX_NICK                14
#define         MAX_LOGIN               18
#define         MAX_PASS                16
#define         MAX_EMAIL               50
#define         MIN_NICK                4
#define         MIN_LOGIN               6
#define         MIN_PASS                6
#define         MIN_EMAIL               14

/* --------- DIALOGS --------- */
#define         DIALOG_REG_NICK         1
#define         DIALOG_REG_PASS         2
#define         DIALOG_REG_CONF_PASS    3
#define         DIALOG_REG_EMAIL        4
#define         DIALOG_REG_REGISTER     5
#define         DIALOG_REG_LOGIN        6
#define         DIALOG_REG_AVISO        7
#define         DIALOG_LOG_LOG          8
#define         DIALOG_LOG_PASS         9
#define         DIALOG_INT_PROPS        10
#define         DIALOG_SELL             11
#define         DIALOG_BUY              12    
/* --------- FIM DIALOGS --------- */

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
    
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
    (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


main()
{
    printf(" ");
    printf("  -------------------------------");
    printf("  |  										 |");
    printf("  -------------------------------");
    printf(" ");
}

/* ------------ FORWARDS ------------ */
forward OnCreateTable();
forward OnCreateTextRegister(playerid);
forward OnCreateTextLogin(playerid);
forward OnCreateTextStart(playerid);
forward OnQueryPlayer(playerid);
forward OnGetPlayers(playerid);
forward OnGetHouses();
forward OnLoadHouses();
forward OnStartLoadHouses();
forward OnStartedLoadHouses();
forward OnGetingOwner(hid);
forward getLoginPlayer(playerid, nick);
forward OnCreateCasa(playerid, hid, intid, value, X, Y, Z, A);
forward OnVerifyCode(playerid);
forward OnLoadPlayer(playerid);
forward OnCreatePlayerDB(playerid);
forward getEmailExists(playerid);
forward getLoginExists(playerid);
forward getNickExists(playerid);
forward OnSavePlayer(playerid);
forward OnCreateLocal(i, X, Y, Z);
forward OnGetLocais();
forward OnStartedLoadLocais();
forward OnStartLoadLocais();
/* ------------ FIM FORWARDS ------------ */

/* ------------ CONEXAO DB ------------ */
new MySQL:ConexaoSQL;

/*#define HOST "198.50.187.244"
#define USER "samuell_9652"
#define DTBS "samuell_9652"//samuell_9652
#define PASS "w6MDQ748o8"*/

#define HOST "localhost"
#define USER "root"
#define DTBS "samp"
#define PASS ""
/* ------------ FIM CONEXAO DB ------------ */

new CarADM[MAX_PLAYERS];

new bool:textDrawON[MAX_PLAYERS];

/* ------------ VARIÁVEIS CASAS ------------ */
new housesExists = 0;
new localExists = 0;
new valueBuy[MAX_PLAYERS];
new valueSell[MAX_PLAYERS];

/*enum iLocais {
    titleI[64],
    interior,
    Float:lCoords[4]
};*/

/*static const LocaisCoords[][iLocais] = {
    {"Pequena para média", 2, {226.4562,1239.8372,1082.1406,84.3742,   224.9915,1239.8558,1082.1406,89.3119}}, // porta casa pequena para média
    {"Grande 3 quartos", 3, {235.3427,1187.1564,1080.2578,20.8904,   235.4200,1188.1589,1080.2578,355.2197}}, // porta casa grande 3 quartos
    {"Pequena 1 quarto", 1, {222.9606,1287.0353,1082.1406,199.5815,   222.9182,1288.2798,1082.1406,352.8088}}, // porta casa pequena 1 quarto
    {"Grande 2 andar 3 quartos", 5, {226.6754,1114.3439,1080.9949,276.1393,   227.9247,1114.3527,1080.9922,270.3922}}, // porta casa grande 2 andar 3 quartos 1 switch
    {"Grande p/ média 2 quartos", 15, {295.1040,1472.5094,1080.2578,16.6413,   295.2047,1473.6947,1080.2578,359.3617}}, // porta casa grande para média 2 quartos
    {"Pequena 1 quarto", 4, {221.8839,1140.3673,1082.6094,4.4736,   221.7537,1141.5895,1082.6094,0.9929}}, // porta casa pequena 1 quarto
    {"Mediana 2 quartos", 5, {22.7529,1403.4939,1084.4297,   23.0549,1404.4661,1084.4297,357.9023}}, // porta casa mediana 2 quartos
    {"Mansão 3 quartos + sala jantar", 5, {140.2249,1366.1494,1083.8594,178.2259,   140.1133,1367.5449,1083.8617,358.0418}}, // porta mansao 3 quartos 1 sala de jantar
    {"Mansão 3 quartos 2 andar", 6, {234.1444,1063.7277,1084.2123,170.5397,   233.9610,1065.2522,1084.2101,359.4914}}, // porta mansao 3 quartos 2 andar
    {"Casa pequena sem quarto", 6, {-68.8250,1351.1959,1080.2109,181.9418,   -69.0454,1352.1377,1080.2109,2.1036}}, // porta casa pequena+ sem quarto
    {"Mansão 2 quartos + sala de jantar", 9, {82.9771,1322.4271,1083.8662,183.9431,   83.1285,1323.5549,1083.8594,2.2433}}, // porta mansao 2 quartos sala de jantar
    {"Média- sem quarto", 9, {260.7685,1237.3856,1084.2578,180.2927,   260.6051,1238.8737,1084.2578,355.7376}} // porta casa media- sem quarto
};*/

enum coordsInts {
    nHouse[64],
    hIntid,
    Float:hCoords[9]
};

static const IntsCoords[][coordsInts] = {
    {"Pequena para média", 2, {226.4562,1239.8372,1082.1406,84.3742,   224.9915,1239.8558,1082.1406,89.3119}}, // porta casa pequena para média
    {"Grande 3 quartos", 3, {235.3427,1187.1564,1080.2578,20.8904,   235.4200,1188.1589,1080.2578,355.2197}}, // porta casa grande 3 quartos
    {"Pequena 1 quarto", 1, {222.9606,1287.0353,1082.1406,199.5815,   222.9182,1288.2798,1082.1406,352.8088}}, // porta casa pequena 1 quarto
    {"Grande 2 andar 3 quartos", 5, {226.6754,1114.3439,1080.9949,276.1393,   227.9247,1114.3527,1080.9922,270.3922}}, // porta casa grande 2 andar 3 quartos 1 switch
    {"Grande p/ média 2 quartos", 15, {295.1040,1472.5094,1080.2578,16.6413,   295.2047,1473.6947,1080.2578,359.3617}}, // porta casa grande para média 2 quartos
    {"Pequena 1 quarto", 4, {221.8839,1140.3673,1082.6094,4.4736,   221.7537,1141.5895,1082.6094,0.9929}}, // porta casa pequena 1 quarto
    {"Mediana 2 quartos", 5, {22.7529,1403.4939,1084.4297,   23.0549,1404.4661,1084.4297,357.9023}}, // porta casa mediana 2 quartos
    {"Mansão 3 quartos + sala jantar", 5, {140.2249,1366.1494,1083.8594,178.2259,   140.1133,1367.5449,1083.8617,358.0418}}, // porta mansao 3 quartos 1 sala de jantar
    {"Mansão 3 quartos 2 andar", 6, {234.1444,1063.7277,1084.2123,170.5397,   233.9610,1065.2522,1084.2101,359.4914}}, // porta mansao 3 quartos 2 andar
    {"Casa pequena sem quarto", 6, {-68.8250,1351.1959,1080.2109,181.9418,   -69.0454,1352.1377,1080.2109,2.1036}}, // porta casa pequena+ sem quarto
    {"Mansão 2 quartos + sala de jantar", 9, {82.9771,1322.4271,1083.8662,183.9431,   83.1285,1323.5549,1083.8594,2.2433}}, // porta mansao 2 quartos sala de jantar
    {"Média- sem quarto", 9, {260.7685,1237.3856,1084.2578,180.2927,   260.6051,1238.8737,1084.2578,355.7376}} // porta casa media- sem quarto
};
/* ------------ FIM VARIÁVEIS CASAS ------------ */

/* ------------ ENUMS INFOS ------------ */
enum infoPlayer {
    pName[MAX_PLAYER_NAME],
    pMoney,
    pMoneyBank,
    pLevel,
    pSkin,
    pAdmin,
    pVip,
    pEmail[64],
    Float:pX,
    Float:pY,
    Float:pZ, 
    Float:pA,
    pInt,
    pVW,
    uCode
};

new PlayerInfo[MAX_PLAYERS][infoPlayer];

enum infoHouse {
    hID,
    hDono[25],
    hPickup,
    hMoney,
    hValue,
    Float:hX,
    Float:hY,
    Float:hZ,
    Float:hA,
    Float:hIX,
    Float:hIY,
    Float:hIZ,
    Float:hIA,
    hInt,
    Text3D:h3DText,
    hComprada,
    hLock
};

new HouseInfo[MAX_HOUSES][infoHouse];

enum infoLocal {
    lID,
    textLocal[64],
    lPickup,
    Float:lX,
    Float:lY,
    Float:lZ,
    lInt,
    Float:liX,
    Float:liY,
    Float:liZ,
    Float:liA,
    lcPickup,
    Text3D:lcText
};

new LocalInfo[MAX_LOCAIS][infoLocal];

/* ------------ FIM ENUMS INFOS ------------ */
/* ------------ VARIÁVEIS LOGIN/REGISTRO ------------ */
/* LOGANDO */
new PlayerText:startWindowTXD[MAX_PLAYERS][15];
new bool:startWindow[MAX_PLAYERS];

new timerTXD[MAX_PLAYERS];
/* REGISTRO */
new PlayerText:registroTXD[MAX_PLAYERS][25];
new PlayerText:Fundo[MAX_PLAYERS];
new PlayerText:BarraTitulo[MAX_PLAYERS];
new bool:windowRegister[MAX_PLAYERS];
new regLogin[MAX_PLAYERS] = 0;
new regNick[MAX_PLAYERS] = 0;
new regPass[MAX_PLAYERS] = 0;
new regConfPass[MAX_PLAYERS] = 0;
new regEmail[MAX_PLAYERS] = 0;
new regSexo[MAX_PLAYERS] = 1;
/* LOGIN */
new PlayerText:textLogin[MAX_PLAYERS][21];
new bool:windowLogin[MAX_PLAYERS];
new loginPass[MAX_PLAYERS] = 0;
new loginLogin[MAX_PLAYERS] = 0;

new bool:pLogado[MAX_PLAYERS];
/* ------------ FIM VARIÁVEIS LOGIN/REGISTRO ------------ */


public OnGameModeInit()
{
    ConexaoSQL = mysql_connect(HOST,USER,PASS,DTBS);
    if(mysql_errno(ConexaoSQL) != 0) 
    {
        print("[MySQL] Falha ao tentar estabelecer conexão com o banco de dados.");
    } else {
        print("[MySQL] Sucesso ao conectar com o banco de dados.");
    }
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players`");
    mysql_tquery(ConexaoSQL, query, "OnGetPlayers");
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `houses`");
    mysql_tquery(ConexaoSQL, query, "OnGetHouses");    
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `local`");
    mysql_tquery(ConexaoSQL, query, "OnGetLocais");   
    EnableStuntBonusForAll(false);
    DisableInteriorEnterExits();
    startTablePlayer();
    startTableHouses();
    SetGameModeText("Role Play Gaming");
    AddStaticVehicle(522, 2493.7583, -1683.6482, 12.9099, 270.8069, -1, -1);
    /* ------------------- CASAS ------------------- */   
    SetTimer("OnStartLoadHouses", 5000, false);
    SetTimer("OnStartLoadLocais", 5000, false);
    /* ------------------- FIM CASAS ------------------- */
    return 1;
}
 
public OnGameModeExit()
{
    for(new i = 0; i <= MAX_PLAYERS; i++) {
        savePlayer(i);
    }
    return 1;
}
 
public OnPlayerConnect(playerid)
{
    for(new i = 1; i <= 50; i++) {
        SendClientMessage(playerid, -1, "");
    }
    new versionP[24], string[64];
    GetPlayerVersion(playerid, versionP, sizeof(versionP));
    format(string, sizeof(string),"Versão SAMP: %s", versionP);
    SendClientMessageToAll(-1, string);
    createTextStart(playerid);
    showTextStart(playerid);
    new nick[MAX_PLAYER_NAME];
    format(nick, sizeof(nick),"PLAYER_%d",playerid);
    SetPlayerName(playerid, nick);
    SelectTextDraw(playerid, 0x1E90FFFF);
    return 1;
}
 
public OnPlayerDisconnect(playerid, reason)
{
    pLogado[playerid] = false;
    CarADM[playerid] = 0;
    valueBuy[playerid] = 0;
    valueSell[playerid] = 0;
    hideTextLogin(playerid);
    hideTextRegistro(playerid);
    hideTextStart(playerid);
    if(windowRegister[playerid]) {
        finishRegister(playerid);
        return 1;
    }
    return 1;
}
 
public OnPlayerRequestClass(playerid, classid)
{
    return 0;
}
 
public OnPlayerSpawn(playerid)
{
    return 1; 
}
 
public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    return 1;
}
 
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}
 
public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}
 
public OnVehicleSpawn(vehicleid)
{
    return 1;
}
 
public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}
 
public OnPlayerRequestSpawn(playerid)
{
    return 1;
}
 
public OnPlayerText(playerid, text[])
{
    return 1;
}
 
public OnPlayerUpdate(playerid)
{
    new Float:X, Float:Y, Float:Z, Float:A;
    GetPlayerPos(playerid, X, Y, Z);
    GetPlayerFacingAngle(playerid, A);
    PlayerInfo[playerid][pX] = X;
    PlayerInfo[playerid][pY] = Y;
    PlayerInfo[playerid][pZ] = Z;
    PlayerInfo[playerid][pA] = A;
    PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);
    savePlayer(playerid);
    if(GetPlayerMoney(playerid) > PlayerInfo[playerid][pMoney]) {
        SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Aviso você está com divergência de dinheiro!");
        return 1;
    }
    new Float:Speed;
    GetVehicleVelocity(GetPlayerVehicleID(playerid), X, Y, Z);
    Speed = floatmul(floatsqroot(floatadd(floatadd(floatpower(X, 2), floatpower(Y, 2)),  floatpower(Z, 2))), 200.0);
    new velocidade;
    velocidade = floatround(Speed, floatround_floor);
    new string[128];  
    format(string, sizeof(string),"Sua velocidade %i",velocidade);
    if(IsPlayerInAnyVehicle(playerid)) {
        //SendClientMessage(playerid, -1, string);
    }
    return 1;
}
 
public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if(RELEASED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    RepairVehicle(GetPlayerVehicleID(playerid));
		RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
	 	return 1;
	}
	if(HOLDING(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		RepairVehicle(GetPlayerVehicleID(playerid));
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
	 	return 1;
	}    
    return 1;
}
 
public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    return 1;
}
 
public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}
 
public OnActorStreamIn(actorid, forplayerid)
{
    return 1;
}
 
public OnActorStreamOut(actorid, forplayerid)
{
    return 1;
}
 
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_INT_PROPS) {
        new i = listitem;
        if(response) {
            SetPlayerPos(playerid, IntsCoords[i][hCoords][0], IntsCoords[i][hCoords][1], IntsCoords[i][hCoords][2]);
            SetPlayerInterior(playerid, IntsCoords[i][hIntid]);
            new str[128];
            format(str, sizeof(str),"{FFFF00}CASA | {FFFFFF}%s ID: %d", IntsCoords[i][nHouse], i);
            SendClientMessage(playerid, -1, str);
        }
        return 1;
    }
    if(dialogid == DIALOG_BUY) {
        if(response) {
            new i = getPosHouse(playerid);
            if(i == 0) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de uma casa!");
            if(HouseInfo[i][hComprada] != 0) return SendClientMessage(playerid, 0xff0000ff, "Essa casa não está à venda.");
            if(PlayerInfo[playerid][pMoney] < HouseInfo[i][hValue]) return SendClientMessage(playerid, 0xff0000ff, "Você não possui dinheiro suficiente para comprar essa casa.");
            PlayerInfo[playerid][pMoney] -= HouseInfo[i][hValue];
            GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
            GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
            PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
            format(HouseInfo[i][hDono], 50,"%s",PlayerInfo[playerid][uCode]);
            HouseInfo[i][hComprada] = HOUSE_COMPRADA;
            stopHouse(i);
            startHouse(i);
            new str[128];
            format(str, sizeof(str), "%s O(A) Jogador(a) %s comprou a casa ID: %d em: %s", INFO_CASAS, getNamePlayer(playerid), i, getLocPlayer(playerid));
            SendClientMessageToAll(-1, str);
            return 1;
        }       
    }
    if(dialogid == DIALOG_SELL) {
        if(response) {
            new i = getPosHouse(playerid);
            if(i == 0) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de uma casa!");
            if(HouseInfo[i][hDono] != PlayerInfo[playerid][uCode]) return SendClientMessage(playerid, 0xff0000ff, "Essa casa não te pertence.");
            PlayerInfo[playerid][pMoney] += (HouseInfo[i][hValue] / 4) * 3;
            GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
            GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
            PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
            format(HouseInfo[i][hDono], 50,"Ninguém");
            HouseInfo[i][hComprada] = HOUSE_AVENDA;
            stopHouse(i);
            startHouse(i);
            new str[128];
            format(str, sizeof(str), "%s O(A) Jogador(a) %s vendeu a casa ID: %d em: %s", INFO_CASAS, getNamePlayer(playerid), i, getLocPlayer(playerid));
            SendClientMessageToAll(-1, str);
            return 1;
        }
    }
    if(dialogid == DIALOG_LOG_LOG) { // login login
        if(response) {
            if(strlen(inputtext) > 0) {
                format(loginLogin[playerid], 50,"%s",inputtext);
                PlayerTextDrawSetString(playerid, textLogin[playerid][13], loginLogin[playerid]);
                refreshTextDraw(playerid, textLogin[playerid][13]);
                return 1;
            } else {
                return 1;
            }    
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_LOG_PASS) { // login pass
        if(response) {
            if(strlen(inputtext) > 0) {         
                new pass[50];
                format(pass, sizeof(pass),"%s", hidePass(inputtext));
                format(loginPass[playerid], 25,"%s", inputtext);
                PlayerTextDrawSetString(playerid, textLogin[playerid][14], pass);
                PlayerTextDrawFont(playerid, textLogin[playerid][14], TEXT_DRAW_FONT_0);
                refreshTextDraw(playerid, textLogin[playerid][14]);
                PlayerTextDrawShow(playerid, textLogin[playerid][20]);
                return 1;
            } else {
                return 1;
            }
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_REG_NICK) { // register nick
        new str[128];
        if(response) {
            if(!strlen(inputtext)) {
                SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Crie um nick.");
                showDialogRegNick(playerid);
                return 1;        
            } else if(strlen(inputtext) < MIN_NICK) {
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Seu nick deve conter no m?nimo %d", MIN_NICK);
                SendClientMessage(playerid, -1, str);
                showDialogRegNick(playerid);
                return 1;
            } else if(strlen(inputtext) > MAX_NICK) {
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Seu nick deve conter no máximo %d", MAX_NICK);
                SendClientMessage(playerid, -1, str);
                showDialogRegNick(playerid);
                return 1;
            } else {
                format(regNick[playerid], 50,"%s",inputtext);
                PlayerTextDrawSetString(playerid, registroTXD[playerid][18], regNick[playerid]);
                refreshTextDraw(playerid, registroTXD[playerid][18]);
                return 1;
            }  
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_REG_LOGIN) { // register login
        new str[128];
        if(response) {
            if(!strlen(inputtext)) {
                SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Crie um login.");
                showDialogRegLogin(playerid);
                return 1;        
            } else if(strlen(inputtext) < MIN_LOGIN) {
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Seu login deve conter no m?nimo %d", MIN_LOGIN);
                SendClientMessage(playerid, -1, str);
                showDialogRegLogin(playerid);
                return 1;
            } else if(strlen(inputtext) > MAX_LOGIN) {
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Seu login deve conter no máximo %d", MAX_LOGIN);
                SendClientMessage(playerid, -1, str);
                showDialogRegLogin(playerid);
                return 1;
            } else {
                format(regLogin[playerid], 50,"%s",inputtext);
                PlayerTextDrawSetString(playerid, registroTXD[playerid][15], regLogin[playerid]);
                refreshTextDraw(playerid, registroTXD[playerid][15]);
                return 1;
            }  
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_REG_PASS) { // registar pass
        if(response) {
            new str[128];
            if(!strlen(inputtext)) {
                SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Crie uma senha.");
                showDialogRegPass(playerid);
                return 1;        
            } else if(strlen(inputtext) > MAX_PASS) {
                showDialogRegPass(playerid);
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Sua senha deve conter no máximo %d", MAX_PASS);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else if(strlen(inputtext) < MIN_PASS) {
                showDialogRegPass(playerid);
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Sua senha deve conter no m?nimo %d", MIN_PASS);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else {
                if(regPass[playerid] == 0) {
                    PlayerTextDrawShow(playerid, registroTXD[playerid][20]); 
                }
                format(regPass[playerid], 25,"%s", inputtext);
                PlayerTextDrawSetString(playerid, registroTXD[playerid][16], regPass[playerid]);    
                hideTypePass(playerid, registroTXD[playerid][20], registroTXD[playerid][16], regPass[playerid]);           
                return 1;
            }  
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_REG_CONF_PASS) { // confirm pass
        if(response) {
            new str[128];
            if(!strlen(inputtext)) {
                SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Confirme sua senha.");
                showDialogRegConfPass(playerid);
                return 1;        
            } else if(strlen(inputtext) > MAX_PASS) {
                showDialogRegConfPass(playerid);
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Sua senha deve conter no m?ximo %d", MAX_PASS);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else if(strlen(inputtext) < MIN_PASS) {
                showDialogRegConfPass(playerid);
                format(str, sizeof(str), "{ffff00}AVISO | {ffffff}Sua senha deve conter no m?nimo %d", MIN_PASS);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else {
                if(regConfPass[playerid] == 0) {
                    PlayerTextDrawShow(playerid, registroTXD[playerid][21]); 
                }
                format(regConfPass[playerid], 25,"%s", inputtext);
                PlayerTextDrawSetString(playerid, registroTXD[playerid][17], regConfPass[playerid]);    
                hideTypePass(playerid, registroTXD[playerid][21], registroTXD[playerid][17], regPass[playerid]);            
                return 1;
            }
        } else {
            return 1;
        }
    }
    if(dialogid == DIALOG_REG_EMAIL) { // register email
        if(response) {
            new str[128];
            if(!strlen(inputtext)) {
                SendClientMessage(playerid, -1, "{ffff00}AVISO | {ffffff}Cadastre seu E-Mail.");
                showDialogRegEmail(playerid);
                return 1;        
            } else if(strlen(inputtext) > MAX_EMAIL) {
                showDialogRegEmail(playerid);
                format(str, sizeof(str),"{ffff00}AVISO | {ffffff}O E-Mail deve conter menos de %d caracteres.", MAX_EMAIL);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else if(strlen(inputtext) < MIN_EMAIL) {
                showDialogRegEmail(playerid);
                format(str, sizeof(str),"{ffff00}AVISO | {ffffff}O E-Mail deve conter mais de %d caracteres.", MIN_EMAIL);
                SendClientMessage(playerid, -1, str);
                return 1;
            } else {
                format(regEmail[playerid], 50,"%s",inputtext);
                PlayerTextDrawSetString(playerid, registroTXD[playerid][19], regEmail[playerid]);
                refreshTextDraw(playerid, registroTXD[playerid][19]);
                return 1;
            }
        } else {
            return 1;
        }
    }
    return 1;
}
 
public OnPlayerEnterGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerLeaveGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerEnterPlayerGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerLeavePlayerGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerClickGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerClickPlayerGangZone(playerid, zoneid)
{
    return 1;
}
 
public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}
 
public OnPlayerExitedMenu(playerid)
{
    return 1;
}
 
public OnClientCheckResponse(playerid, actionid, memaddr, retndata)
{
    return 1;
}
 
public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}
 
public OnPlayerFinishedDownloading(playerid, virtualworld)
{
    return 1;
}
 
public OnPlayerRequestDownload(playerid, DOWNLOAD_REQUEST:type, crc)
{
    return 1;
}
 
public OnRconCommand(cmd[])
{
    return 0;
}
 
public OnPlayerSelectObject(playerid, SELECT_OBJECT:type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}
 
public OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    return 1;
}
 
public OnObjectMoved(objectid)
{
    return 1;
}
 
public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}
 
public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}
 
public OnPlayerPickUpPlayerPickup(playerid, pickupid)
{
    return 1;
}
 
public OnPickupStreamIn(pickupid, playerid)
{
    return 1;
}
 
public OnPickupStreamOut(pickupid, playerid)
{
    return 1;
}
 
public OnPlayerPickupStreamIn(pickupid, playerid)
{
    return 1;
}
 
public OnPlayerPickupStreamOut(pickupid, playerid)
{
    return 1;
}
 
public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}
 
public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}
 
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}
 
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}
 
public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source)
{
    return 1;
}
 
public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}
 
public OnScriptCash(playerid, amount, source)
{
    return 1;
}
 
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}
 
public OnIncomingConnection(playerid, ip_address[], port)
{
    return 1;
}
 
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    return 1;
}
 
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    return 1;
}
 
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(startWindow[playerid]) { 
		if(playertextid == startWindowTXD[playerid][9]) { // registrar
			hideTextStart(playerid);
			KillTimer(timerTXD[playerid]);
			timerTXD[playerid] = 0;
			timerTXD[playerid] = SetTimerEx("OnCreateTextRegister", 2000, false, "i", playerid);
			createTextRegistro(playerid);
			windowRegister[playerid] = true;
			return 1;
      }
		if(playertextid == startWindowTXD[playerid][8]) { // logar
			hideTextStart(playerid);
			KillTimer(timerTXD[playerid]);
			timerTXD[playerid] = SetTimerEx("OnCreateTextLogin", 2000, false, "i", playerid);
			createTextLogin(playerid);
			return 1;
      }
	}
	if(windowRegister[playerid]) {
		if(playertextid == registroTXD[playerid][15]) { // REG LOGIN
	      showDialogRegLogin(playerid);
	      return 1;
      }
		if(playertextid == registroTXD[playerid][16]) { // REG PASS
         new strAtual[25] = "{ffff00}a senha", strAnt[25] = "{00ff00}o login";
         if(regLogin[playerid] == 0) return dialogAviso(playerid, strAtual, strAnt);
         showDialogRegPass(playerid);
         return 1;
		}
		if(playertextid == registroTXD[playerid][17]) { // REG CONF PASS
         new strAtual[50] = "{ffff00}a confirmação da senha", strAnt[25] = "{00ff00}senha";
         if(regPass[playerid] == 0) return dialogAviso(playerid, strAtual, strAnt);
         showDialogRegConfPass(playerid);
         return 1;
      }
		if(playertextid == registroTXD[playerid][18]) { // REG NICK
         new strAtual[50] = "{ffff00}o nickname/nome", strAnt[50] = "{00ff00}a confirmação da senha";
         if(regConfPass[playerid] == 0) return dialogAviso(playerid, strAtual, strAnt);
         showDialogRegNick(playerid);
         return 1;
      }
		if(playertextid == registroTXD[playerid][19]) { // REG EMAIL
         new strAtual[50] = "{ffff00}o e-mail", strAnt[50] = "{00ff00}o nickname/nome";
         if(regNick[playerid] == 0) return dialogAviso(playerid, strAtual, strAnt);
         showDialogRegEmail(playerid);
         return 1;
      }
		if(playertextid == registroTXD[playerid][20]) { // HIDE PASS
         new string[25];
         PlayerTextDrawGetString(playerid, registroTXD[playerid][20], string, sizeof(string));
         if(strcmp(string, "ld_pool:ball", false) == 0) {
         	hideTypePass(playerid, registroTXD[playerid][20], registroTXD[playerid][16], regPass[playerid]);
         } else if(strcmp(string, "ld_beat:circle", false) == 0){
	         showPass(playerid, registroTXD[playerid][20], registroTXD[playerid][16], regPass[playerid]);
         }
         return 1;
      }
		if(playertextid == registroTXD[playerid][21]) { // HIDE PASS
         new string[25];
         PlayerTextDrawGetString(playerid, registroTXD[playerid][21], string, sizeof(string));
         if(strcmp(string, "ld_pool:ball", false) == 0) {
         	hideTypePass(playerid, registroTXD[playerid][21], registroTXD[playerid][17], regPass[playerid]);
         } else if(strcmp(string, "ld_beat:circle", false) == 0){
	         showPass(playerid, registroTXD[playerid][21], registroTXD[playerid][17], regPass[playerid]);
         }
         return 1;
      }
		if(playertextid == registroTXD[playerid][14]) { // Registrar
			if(regLogin[playerid] == 0 || regNick[playerid] == 0 ||
			regPass[playerid] == 0 || regConfPass[playerid] == 0 || 
			regEmail[playerid] == 0) {
			SendClientMessage(playerid, -1, "{ffff00}AVISO | {FFFFFF}Você não preencheu todos os campos!"); 
			return 1;
		} 
			if(strcmp(regPass[playerid], regConfPass[playerid]) != 0) {
				SendClientMessage(playerid, -1, "{ffff00}AVISO | {FFFFFF}As senhas estão divergentes!");    
				return 1;
			} 
			getNickExistsDb(playerid); 
			SendClientMessage(playerid, -1, "Ta aqui");
			return 1;
		}
		if(playertextid == registroTXD[playerid][23]) { // esquerda          
         if(regSexo[playerid] == 1) {
         	regSexo[playerid] = 6;
         } else if(regSexo[playerid] <= 6) {
         	regSexo[playerid]--;
         } 
         updateRegSkin(playerid);
         return 1;
		}
		if(playertextid == registroTXD[playerid][22]) { // direita
			if(regSexo[playerid] == 6) {
				regSexo[playerid] = 1;
			} else if(regSexo[playerid] >= 1) {
				regSexo[playerid]++;
			}
			updateRegSkin(playerid);
			return 1;
		}
		if(playertextid == registroTXD[playerid][24]) { // X Registro
			windowRegister[playerid] = false;
			KillTimer(timerTXD[playerid]);
			timerTXD[playerid] = 0;
			timerTXD[playerid] = SetTimerEx("OnCreateTextStart", 2000, false, "i", playerid);
			hideTextRegistro(playerid);
			createTextStart(playerid);
			return 1;
		}
		
	}
	if(windowLogin[playerid]) {
		if(playertextid == textLogin[playerid][13]) { // type login
			showDialogLogLogin(playerid);
			return 1;
		}
		if(playertextid == textLogin[playerid][14]) { // type pass
			showDialogLogPass(playerid);
			return 1;
		}
		if(playertextid == textLogin[playerid][20]) { // hide pass
			new string[25];
			PlayerTextDrawGetString(playerid, textLogin[playerid][20], string, sizeof(string));
			if(strcmp(string, "ld_pool:ball", false) == 0) {
			hideTypePass(playerid, textLogin[playerid][20], textLogin[playerid][14], loginPass[playerid]);
			} else if(strcmp(string, "ld_beat:circle", false) == 0){
				showPass(playerid, textLogin[playerid][20], textLogin[playerid][14], loginPass[playerid]);
			}
			return 1;
		}
		if(playertextid == textLogin[playerid][9]) { // login
			new query[256];
			mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'", loginLogin[playerid]);
			mysql_tquery(ConexaoSQL, query, "OnQueryPlayer", "i", playerid);
			return 1;
		}
		if(playertextid == textLogin[playerid][3]) { // X Login
			windowLogin[playerid] = false;
			KillTimer(timerTXD[playerid]);
			timerTXD[playerid] = 0;
			timerTXD[playerid] = SetTimerEx("OnCreateTextStart", 2000, false, "i", playerid);
			hideTextLogin(playerid);
			createTextStart(playerid);
			return 1;
		}
		return 1;
	}
	return 1;
}
 
public OnTrailerUpdate(playerid, vehicleid)
{
    return 1;
}
 
public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
    return 1;
}
 
public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}
 
public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}
 
public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}
 
public OnEnterExitModShop(playerid, enterexit, interiorid)
{
    return 1;
}
 
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}
 
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}
 
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	return 1;
}
 
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    return 1;
}

CMD:cv(playerid, params[]) {
	if(IsPlayerAdmin(playerid)) {
	new deleteOn[2];
	new idCar = 0, color1 = 0, color2 = 0;
	if(sscanf(params, "iiis[2]", idCar, color1, color2, deleteOn)) {
		return SendClientMessage(playerid, 0xFF0000AA, "Use: /cv <id carro> <cor1> <cor2> <deletar antigo S/N>");
	}
	new Float:X, Float:Y, Float:Z, Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	if(!strcmp(deleteOn, "S")) {
		DestroyVehicle(CarADM[playerid]);
	}
	CarADM[playerid] = CreateVehicle(idCar, X, Y, Z, A, color1, color2, -1, false);
	PutPlayerInVehicle(playerid, CarADM[playerid], 0);
	SetPlayerCameraPos(playerid, X, Y, Z);
	return 1;
	}
	return 0;
}

CMD:v(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
		new idCar = 0, color1 = 0, color2 = 0;
		if(sscanf(params, "iii", idCar, color1, color2)) {
            return SendClientMessage(playerid, 0xFF0000AA, "Use: /v <id carro> <cor1> <cor2>");
        }
        new Float:X, Float:Y, Float:Z, Float:A;
        GetPlayerPos(playerid, X, Y, Z);
        GetPlayerFacingAngle(playerid, A);
        DestroyVehicle(CarADM[playerid]);
        CarADM[playerid] = CreateVehicle(idCar, X, Y, Z, A, color1, color2, -1, false);
        PutPlayerInVehicle(playerid, CarADM[playerid], 0);
        SetPlayerCameraPos(playerid, X, Y, Z);
        return 1;
	}
    return 0;
}

CMD:weapon(playerid, params[]) {
    new id = 0, idWeapon[20] = 0, ammount = 0;
    if(sscanf(params, "ds[20]d", id, idWeapon, ammount)) {
        return SendClientMessage(playerid, 0xff0000ff, "Use: /weapon [Id] [idArma] [Munição]");
    }
    if(strcmp(idWeapon, "jet") == 0) {
        GivePlayerWeapon(id, WEAPON_PARACHUTE, 1);   
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
        return 1;     
    } else {
        GivePlayerWeapon(id, WEAPON:strval(idWeapon), ammount);
        return 1;
    }
}
 

public OnGetPlayers() {
    new i = cache_num_rows();
    printf("------------------------------------------");
    printf("              BACO DE DADOS               ");
    printf("     Players no banco de dados %02d       ", i);
    return 1;
}

public OnGetHouses() {
    new i = cache_num_rows();
    printf("  Casa carregadas no banco de dados %02d   ", i);
    housesExists = i;
    return 1;
}

public OnGetLocais() {
    new i = cache_num_rows();
    printf("  Locais carregados no banco de dados %02d   ", i);
    localExists = i;
    return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(!pLogado[playerid]) {
        SendClientMessage(playerid, 0xff0000ff, "Você precisa estar logado para executar comandos!");
        return 0;
    }
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(success == CMD_FAILURE) {
        return SendClientMessage(playerid, 0xff0000ff, "Comando Inválido!");
    }
	return success;
}

/* --------------- FUNÇÕES IMPORTANTES --------------- */
public OnCreateTextRegister(playerid) {
    showTextRegistro(playerid);
    return 1;
}

stock showDialogRegNick(playerid) {
    ShowPlayerDialog(playerid, DIALOG_REG_NICK, DIALOG_STYLE_INPUT, "{FFFFFF}Cadastro","{ffffff}Crie um nickname/nome:", "Confirmar","Cancelar");
    return 1;
}

stock showDialogRegLogin(playerid) {
    ShowPlayerDialog(playerid, DIALOG_REG_LOGIN, DIALOG_STYLE_INPUT, "{FFFFFF}Cadastro","{ffffff}Crie um login:", "Confirmar","Cancelar");
    return 1;
}

stock showDialogRegPass(playerid) {
    ShowPlayerDialog(playerid, DIALOG_REG_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Cadastro","{ffffff}Crie uma senha:", "Confirmar","Cancelar");
    return 1;
}

stock showDialogRegConfPass(playerid) {
    ShowPlayerDialog(playerid, DIALOG_REG_CONF_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Cadastro","{ffffff}Confirme sua senha:", "Confirmar","Cancelar");
    return 1;
}

stock showDialogRegEmail(playerid) {
    ShowPlayerDialog(playerid, DIALOG_REG_EMAIL, DIALOG_STYLE_INPUT, "{FFFFFF}Cadastro","{ffffff}Confirme sua senha:", "Confirmar","Cancelar");
    return 1;
}

stock refreshTextDraw(playerid, PlayerText:textid) {
    PlayerTextDrawHide(playerid, textid);
    PlayerTextDrawShow(playerid, textid);
    return 1;
}

stock createTextRegistro(playerid) { // create text
    Fundo[playerid] = CreatePlayerTextDraw(playerid, 323.000000, 127.000000, "_");
    PlayerTextDrawFont(playerid, Fundo[playerid], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, Fundo[playerid], 0.600000, 25.299991);
    PlayerTextDrawTextSize(playerid, Fundo[playerid], 361.000000, 232.500000);
    PlayerTextDrawSetOutline(playerid, Fundo[playerid], 1);
    PlayerTextDrawSetShadow(playerid, Fundo[playerid], 0);
    PlayerTextDrawAlignment(playerid, Fundo[playerid], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, Fundo[playerid], -1);
    PlayerTextDrawBackgroundColour(playerid, Fundo[playerid], 255);
    PlayerTextDrawBoxColour(playerid, Fundo[playerid], 160);
    PlayerTextDrawUseBox(playerid, Fundo[playerid], true);
    PlayerTextDrawSetProportional(playerid, Fundo[playerid], true);
    PlayerTextDrawSetSelectable(playerid, Fundo[playerid], false);

    BarraTitulo[playerid] = CreatePlayerTextDraw(playerid, 323.000000, 129.500000, "_");
    PlayerTextDrawFont(playerid, BarraTitulo[playerid], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BarraTitulo[playerid], 0.600000, 1.550003);
    PlayerTextDrawTextSize(playerid, BarraTitulo[playerid], 298.500000, 229.000000);
    PlayerTextDrawSetOutline(playerid, BarraTitulo[playerid], 1);
    PlayerTextDrawSetShadow(playerid, BarraTitulo[playerid], 0);
    PlayerTextDrawAlignment(playerid, BarraTitulo[playerid], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BarraTitulo[playerid], -1);
    PlayerTextDrawBackgroundColour(playerid, BarraTitulo[playerid], 255);
    PlayerTextDrawBoxColour(playerid, BarraTitulo[playerid], 1097458175);
    PlayerTextDrawUseBox(playerid, BarraTitulo[playerid], true);
    PlayerTextDrawSetProportional(playerid, BarraTitulo[playerid], true);
    PlayerTextDrawSetSelectable(playerid, BarraTitulo[playerid], false);

    registroTXD[playerid][0] = CreatePlayerTextDraw(playerid, 323.000000, 130.699996, "cadastramento");
    PlayerTextDrawFont(playerid, registroTXD[playerid][0], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][0], 0.275000, 1.300000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][0], 472.500000, 142.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][0], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][0], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][0], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][0], false);

    registroTXD[playerid][1] = CreatePlayerTextDraw(playerid, 383.000000, 147.000000, "SEJA BEM-VINDO");
    PlayerTextDrawFont(playerid, registroTXD[playerid][1], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][1], 0.283333, 1.600000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][1], 400.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][1], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][1], 100);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][1], 35584);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][1], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][1], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][1], false);

    registroTXD[playerid][2] = CreatePlayerTextDraw(playerid, 383.000000, 286.000000, "NICKNAME");
    PlayerTextDrawFont(playerid, registroTXD[playerid][2], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][2], 0.204166, 1.300001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][2], 27.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][2], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][2], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][2], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][2], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][2], false);

    registroTXD[playerid][3] = CreatePlayerTextDraw(playerid, 207.300003, 147.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, registroTXD[playerid][3], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][3], 120.000000, 171.500000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][3], 160);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][3], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][3], false);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][3], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][3], false);
    PlayerTextDrawSetPreviewModel(playerid, registroTXD[playerid][3], 0);
    PlayerTextDrawSetPreviewRot(playerid, registroTXD[playerid][3], -10.000000, 0.000000, -20.000000, 1.000000);

    registroTXD[playerid][4] = CreatePlayerTextDraw(playerid, 383.000000, 169.000000, "LOGIN");
    PlayerTextDrawFont(playerid, registroTXD[playerid][4], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][4], 0.279166, 1.200001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][4], 12.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][4], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][4], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][4], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][4], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][4], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][4], false);

    registroTXD[playerid][5] = CreatePlayerTextDraw(playerid, 383.000000, 207.000000, "SENHA");
    PlayerTextDrawFont(playerid, registroTXD[playerid][5], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][5], 0.204166, 1.300001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][5], 12.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][5], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][5], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][5], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][5], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][5], false);

    registroTXD[playerid][6] = CreatePlayerTextDraw(playerid, 383.000000, 246.000000, "CONFIRMAR SENHA");
    PlayerTextDrawFont(playerid, registroTXD[playerid][6], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][6], 0.204166, 1.300001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][6], 12.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][6], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][6], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][6], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][6], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][6], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][6], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][6], false);

    registroTXD[playerid][7] = CreatePlayerTextDraw(playerid, 383.000000, 187.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][7], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][7], 0.600000, 1.200001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][7], 298.500000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][7], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][7], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][7], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][7], 160);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][7], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][7], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][7], false);

    registroTXD[playerid][8] = CreatePlayerTextDraw(playerid, 383.000000, 227.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][8], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][8], 0.600000, 1.200001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][8], 298.500000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][8], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][8], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][8], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][8], 160);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][8], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][8], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][8], false);

    registroTXD[playerid][9] = CreatePlayerTextDraw(playerid, 383.000000, 267.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][9], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][9], 0.600000, 1.200001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][9], 298.500000, 100.500000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][9], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][9], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][9], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][9], 160);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][9], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][9], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][9], false);

    registroTXD[playerid][10] = CreatePlayerTextDraw(playerid, 383.000000, 306.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][10], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][10], 0.600000, 1.200001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][10], 298.500000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][10], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][10], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][10], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][10], 160);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][10], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][10], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][10], false);

    registroTXD[playerid][11] = CreatePlayerTextDraw(playerid, 320.700012, 322.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][11], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][11], 0.600000, 1.300003);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][11], 298.500000, 224.500000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][11], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][11], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][11], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][11], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][11], 135);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][11], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][11], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][11], false);

    registroTXD[playerid][12] = CreatePlayerTextDraw(playerid, 233.000000, 322.299987, "E-MAIL:");
    PlayerTextDrawFont(playerid, registroTXD[playerid][12], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][12], 0.204166, 1.250001);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][12], 12.000000, 49.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][12], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][12], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][12], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][12], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][12], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][12], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][12], false);

    registroTXD[playerid][13] = CreatePlayerTextDraw(playerid, 321.000000, 339.000000, "_");
    PlayerTextDrawFont(playerid, registroTXD[playerid][13], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][13], 0.600000, 1.500000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][13], 298.500000, 97.500000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][13], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][13], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][13], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][13], 1097458175);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][13], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][13], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][13], false);

    registroTXD[playerid][14] = CreatePlayerTextDraw(playerid, 321.000000, 337.000000, "registrar");
    PlayerTextDrawFont(playerid, registroTXD[playerid][14], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][14], 0.275000, 1.750000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][14], 15.000000, 92.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][14], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][14], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][14], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][14], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][14], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][14], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][14], true);

    registroTXD[playerid][15] = CreatePlayerTextDraw(playerid, 382.000000, 185.000000, "Digite seu login");
    PlayerTextDrawFont(playerid, registroTXD[playerid][15], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][15], 0.254167, 1.400000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][15], 12.000000, 90.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][15], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][15], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][15], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][15], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][15], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][15], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][15], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][15], true);

    registroTXD[playerid][16] = CreatePlayerTextDraw(playerid, 382.000000, 227.500000, "Crie sua senha");
    PlayerTextDrawFont(playerid, registroTXD[playerid][16], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][16], 0.162500, 1.050000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][16], 12.000000, 90.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][16], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][16], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][16], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][16], 0);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][16], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][16], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][16], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][16], true);

    registroTXD[playerid][17] = CreatePlayerTextDraw(playerid, 382.000000, 267.500000, "Confirme sua senha");
    PlayerTextDrawFont(playerid, registroTXD[playerid][17], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][17], 0.162500, 1.050000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][17], 12.000000, 90.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][17], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][17], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][17], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][17], 0);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][17], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][17], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][17], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][17], true);

    registroTXD[playerid][18] = CreatePlayerTextDraw(playerid, 382.000000, 304.000000, "Crie seu nickname");
    PlayerTextDrawFont(playerid, registroTXD[playerid][18], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][18], 0.254167, 1.400000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][18], 12.000000, 90.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][18], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][18], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][18], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][18], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][18], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][18], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][18], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][18], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][18], true);

    registroTXD[playerid][19] = CreatePlayerTextDraw(playerid, 345.000000, 320.000000, "Cadastre seu e-mail");
    PlayerTextDrawFont(playerid, registroTXD[playerid][19], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][19], 0.254167, 1.400000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][19], 12.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][19], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][19], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][19], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, registroTXD[playerid][19], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][19], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][19], 0);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][19], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][19], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][19], true);

    registroTXD[playerid][20] = CreatePlayerTextDraw(playerid, 425.000000, 229.000000, "ld_pool:ball");
    PlayerTextDrawFont(playerid, registroTXD[playerid][20], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][20], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][20], 8.000000, 8.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][20], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][20], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][20], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][20], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][20], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][20], 50);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][20], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][20], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][20], true);

    registroTXD[playerid][21] = CreatePlayerTextDraw(playerid, 425.000000, 268.000000, "ld_pool:ball");
    PlayerTextDrawFont(playerid, registroTXD[playerid][21], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][21], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][21], 8.000000, 8.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][21], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][21], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][21], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][21], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][21], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][21], 50);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][21], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][21], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][21], true);

    registroTXD[playerid][22] = CreatePlayerTextDraw(playerid, 315.000000, 307.000000, "ld_beat:right");
    PlayerTextDrawFont(playerid, registroTXD[playerid][22], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][22], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][22], 10.000000, 10.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][22], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][22], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][22], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][22], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][22], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][22], 50);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][22], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][22], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][22], true);

    registroTXD[playerid][23] = CreatePlayerTextDraw(playerid, 302.000000, 307.000000, "ld_beat:left");
    PlayerTextDrawFont(playerid, registroTXD[playerid][23], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][23], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][23], 10.000000, 10.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][23], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][23], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][23], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][23], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][23], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][23], 50);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][23], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][23], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][23], true);

    registroTXD[playerid][24] = CreatePlayerTextDraw(playerid, 421.000000, 128.000000, "ld_beat:cross");
    PlayerTextDrawFont(playerid, registroTXD[playerid][24], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, registroTXD[playerid][24], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, registroTXD[playerid][24], 17.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, registroTXD[playerid][24], 1);
    PlayerTextDrawSetShadow(playerid, registroTXD[playerid][24], 0);
    PlayerTextDrawAlignment(playerid, registroTXD[playerid][24], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, registroTXD[playerid][24], -1);
    PlayerTextDrawBackgroundColour(playerid, registroTXD[playerid][24], 255);
    PlayerTextDrawBoxColour(playerid, registroTXD[playerid][24], 50);
    PlayerTextDrawUseBox(playerid, registroTXD[playerid][24], true);
    PlayerTextDrawSetProportional(playerid, registroTXD[playerid][24], true);
    PlayerTextDrawSetSelectable(playerid, registroTXD[playerid][24], true);
}

stock showTextRegistro(playerid) {
    PlayerTextDrawShow(playerid, Fundo[playerid]);
    PlayerTextDrawShow(playerid, BarraTitulo[playerid]);
    for(new i = 0; i <= 24; i++) {
        if(i == 20 || i == 21) {
        } else {
            PlayerTextDrawShow(playerid, registroTXD[playerid][i]);
        }
    }
    updateRegSkin(playerid);
    return 1;
}

stock hideTextRegistro(playerid) {
    PlayerTextDrawHide(playerid, Fundo[playerid]);
    PlayerTextDrawDestroy(playerid, Fundo[playerid]);
    PlayerTextDrawHide(playerid, BarraTitulo[playerid]);
    PlayerTextDrawDestroy(playerid, BarraTitulo[playerid]);
    for(new i = 0; i <= 24; i++) {
        PlayerTextDrawHide(playerid, registroTXD[playerid][i]);
        PlayerTextDrawDestroy(playerid, registroTXD[playerid][i]);
    }
    return 1;
}

stock createTextStart(playerid) { // create text start
    startWindowTXD[playerid][0] = CreatePlayerTextDraw(playerid, 321.000000, 155.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][0], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][0], 0.600000, 19.800003);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][0], 298.500000, 165.500000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][0], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][0], 135);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][0], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][0], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][0], false);

    startWindowTXD[playerid][1] = CreatePlayerTextDraw(playerid, 321.000000, 335.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][1], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][1], 0.600000, -0.149985);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][1], 298.500000, 165.500000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][1], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][1], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][1], 1097458175);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][1], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][1], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][1], false);

    startWindowTXD[playerid][2] = CreatePlayerTextDraw(playerid, 321.000000, 223.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][2], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][2], 0.600000, 1.800003);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][2], 298.500000, 130.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][2], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][2], 180);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][2], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][2], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][2], false);

    startWindowTXD[playerid][3] = CreatePlayerTextDraw(playerid, 321.000000, 251.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][3], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][3], 0.600000, 1.800003);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][3], 298.500000, 130.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][3], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][3], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][3], 180);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][3], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][3], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][3], false);

    startWindowTXD[playerid][4] = CreatePlayerTextDraw(playerid, 321.000000, 279.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][4], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][4], 0.600000, 1.800003);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][4], 298.500000, 45.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][4], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][4], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][4], -16776961);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][4], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][4], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][4], false);

    startWindowTXD[playerid][5] = CreatePlayerTextDraw(playerid, 321.000000, 242.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][5], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][5], 0.600000, -0.249996);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][5], 298.500000, 130.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][5], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][5], 1097458175);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][5], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][5], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][5], false);

    startWindowTXD[playerid][6] = CreatePlayerTextDraw(playerid, 321.000000, 270.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][6], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][6], 0.600000, -0.249996);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][6], 298.500000, 130.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][6], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][6], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][6], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][6], 1097458175);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][6], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][6], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][6], false);

    startWindowTXD[playerid][7] = CreatePlayerTextDraw(playerid, 321.000000, 298.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][7], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][7], 0.600000, -0.249996);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][7], 298.500000, 45.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][7], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][7], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][7], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][7], 1097458175);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][7], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][7], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][7], false);

    startWindowTXD[playerid][8] = CreatePlayerTextDraw(playerid, 321.000000, 223.000000, "LOGAR");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][8], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][8], 0.275000, 1.549999);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][8], 12.000000, 38.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][8], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][8], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][8], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][8], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][8], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][8], true);

    startWindowTXD[playerid][9] = CreatePlayerTextDraw(playerid, 321.000000, 251.000000, "registrar");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][9], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][9], 0.275000, 1.549999);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][9], 12.000000, 55.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][9], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][9], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][9], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][9], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][9], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][9], true);

    startWindowTXD[playerid][10] = CreatePlayerTextDraw(playerid, 321.000000, 279.000000, "sair");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][10], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][10], 0.275000, 1.549999);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][10], 12.000000, 23.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][10], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][10], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][10], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][10], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][10], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][10], true);

    startWindowTXD[playerid][11] = CreatePlayerTextDraw(playerid, 320.000000, 165.000000, "sera sempre um prazer te receber");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][11], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][11], 0.304165, 1.600000);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][11], 400.000000, 162.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][11], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][11], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][11], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][11], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][11], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][11], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][11], false);

    startWindowTXD[playerid][12] = CreatePlayerTextDraw(playerid, 320.000000, 199.000000, "BEM-VINDO(A)");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][12], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][12], 0.295832, 1.399999);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][12], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][12], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][12], 1097458175);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][12], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][12], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][12], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][12], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][12], false);

    startWindowTXD[playerid][13] = CreatePlayerTextDraw(playerid, 320.000000, 309.000000, "ACESSE: NOSSOSITE.COM.BR");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][13], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][13], 0.245832, 1.450000);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][13], 400.000000, 247.000000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][13], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][13], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][13], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][13], 50);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][13], false);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][13], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][13], false);

    startWindowTXD[playerid][14] = CreatePlayerTextDraw(playerid, 320.000000, 324.000000, "_");
    PlayerTextDrawFont(playerid, startWindowTXD[playerid][14], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, startWindowTXD[playerid][14], 0.600000, -0.299984);
    PlayerTextDrawTextSize(playerid, startWindowTXD[playerid][14], 298.500000, 136.500000);
    PlayerTextDrawSetOutline(playerid, startWindowTXD[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, startWindowTXD[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, startWindowTXD[playerid][14], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, startWindowTXD[playerid][14], -1);
    PlayerTextDrawBackgroundColour(playerid, startWindowTXD[playerid][14], 255);
    PlayerTextDrawBoxColour(playerid, startWindowTXD[playerid][14], -1);
    PlayerTextDrawUseBox(playerid, startWindowTXD[playerid][14], true);
    PlayerTextDrawSetProportional(playerid, startWindowTXD[playerid][14], true);
    PlayerTextDrawSetSelectable(playerid, startWindowTXD[playerid][14], bool:0);
    return 1;
}

stock showTextStart(playerid) {
    for(new i = 0; i <= 14; i++) {
        PlayerTextDrawShow(playerid, startWindowTXD[playerid][i]);
    }
    startWindow[playerid] = true;
    return 1;
}

stock hideTextStart(playerid) {
    for(new i = 0; i <= 14; i++) {
        PlayerTextDrawHide(playerid, startWindowTXD[playerid][i]);
        PlayerTextDrawDestroy(playerid, startWindowTXD[playerid][i]);
    }
    startWindow[playerid] = false;
    return 1;
}

stock dialogAviso(playerid, atual[], ant[]) {
    new string[128];
    format(string, sizeof(string),"{ffffff}Antes de cadastrar %s {ffffff}crie %s", atual, ant);
    return ShowPlayerDialog(playerid, DIALOG_REG_AVISO, DIALOG_STYLE_MSGBOX, "{ffff00}AVISO!", string, "Ok","");
}

stock hidePass(const passType[]) {
    new result[25];
    for(new i = 1; i <= strlen(passType); i++) {
        strcat(result, "]");        
    }
    return result;
}

stock hideTypePass(playerid, PlayerText:textButton, PlayerText:textPass, const pass[]) {
    PlayerTextDrawSetString(playerid, textButton, "ld_beat:circle");
    refreshTextDraw(playerid, textButton);
    PlayerTextDrawSetString(playerid, textPass, hidePass(pass));
    PlayerTextDrawFont(playerid, textPass, TEXT_DRAW_FONT_0);
    refreshTextDraw(playerid, textPass);
    return 1;
}

stock showPass(playerid, PlayerText:textButton, PlayerText:text, const pass[]) {
    PlayerTextDrawSetString(playerid, textButton, "ld_pool:ball");
    refreshTextDraw(playerid, textButton);
    PlayerTextDrawSetString(playerid, text, pass);
    PlayerTextDrawFont(playerid, text, TEXT_DRAW_FONT_1);
    refreshTextDraw(playerid, text);
    return 1;
}

stock getNickExistsDb(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pName` = '%s'",regNick[playerid]);
    mysql_tquery(ConexaoSQL, query, "getNickExists", "d", playerid);
    SendClientMessage(playerid, -1, "get nick");
    return 1;
}

public getNickExists(playerid) {
    if(cache_num_rows() > 0) {
        SendClientMessage(playerid, -1, "{FFFF00}AVISO | {FFFFFF}Esse nickname já está sendo utilizado!");    
        return 1;
    } else {
        getLoginExistsDb(playerid);
        SendClientMessage(playerid, -1, "nick válido");
        return 1;
    }
}

stock getLoginExistsDb(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'",regLogin[playerid]);
    mysql_tquery(ConexaoSQL, query, "getLoginExists", "d", playerid);
    SendClientMessage(playerid, -1, "get login");
    return 1;
}

public getLoginExists(playerid) {
    if(cache_num_rows() > 0) {
        SendClientMessage(playerid, -1, "{FFFF00}AVISO | {FFFFFF}Esse login já está sendo utilizado!");   
        return 1;
    } else {
        getEmailExistsDb(playerid);
        SendClientMessage(playerid, -1, "login válido");
        return 1;
    }
}

stock getEmailExistsDb(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pEmail` = '%s'",regEmail[playerid]);
    mysql_tquery(ConexaoSQL, query, "getEmailExists", "d", playerid);
    SendClientMessage(playerid, -1, "get email");
    return 1;
}

public getEmailExists(playerid) {
    if(cache_num_rows() > 0) {
        SendClientMessage(playerid, -1, "{FFFF00}AVISO | {FFFFFF}Esse e-mail já está sendo utilizado!"); 
        return 1;
    } else {
        SendClientMessage(playerid, -1, "email válido");
        registerPlayer(playerid);
        return 1;
    }
}

stock registerPlayer(playerid) {
    new query[256];
    mysql_format(ConexaoSQL, query, sizeof(query), "INSERT INTO `players` (`pLogin`, `pName`, `pPassword`, `uCode`)\
    VALUES ('%s', '%s', '%s', '%s')",regLogin[playerid], regNick[playerid], regPass[playerid], createCodePlayer(playerid));
    mysql_tquery(ConexaoSQL, query, "OnCreatePlayerDB", "d", playerid);
    SendClientMessage(playerid, -1, "registrando");
    return 1;
}

public OnCreatePlayerDB(playerid) { // create player
   /*new dtb[50], coluna[50], colunaChave[50];
   dtb = "players", coluna = "pEmail", colunaChave = "pLogin";
   insertInfo(playerid, dtb, coluna, regEmail[playerid], colunaChave, regLogin[playerid]);
   coluna = "pSkin", colunaChave = "pLogin";
   insertInfo(playerid, dtb, coluna, regSexo[playerid], colunaChave, regLogin[playerid]);		*/		
   finishRegister(playerid);
   SendClientMessage(playerid, -1, "criado");
   return 1;
}

stock finishRegister(playerid) {
    windowRegister[playerid] = false;
    regLogin[playerid] = 0;
    regNick[playerid] = 0;
    regPass[playerid] = 0;
    regConfPass[playerid] = 0;
    regEmail[playerid] = 0;
    hideTextRegistro(playerid);       
    timerTXD[playerid] = SetTimerEx("OnCreateTextLogin", 2000, false, "i", playerid);    
    createTextLogin(playerid);
    SendClientMessage(playerid, -1, "quebrando tela registro");
    return 1;
}

stock finishLogin(playerid) {
    windowLogin[playerid] = false;
    loginPass[playerid] = 0;
    loginLogin[playerid] = 0;
    return 1;
}

stock updateRegSkin(playerid) {
    new previewSkin = 26;
    if(regSexo[playerid] == 1) { previewSkin = 26; }
    if(regSexo[playerid] == 2) { previewSkin = 35; }
    if(regSexo[playerid] == 3) { previewSkin = 45; }
    if(regSexo[playerid] == 4) { previewSkin = 40; }
    if(regSexo[playerid] == 5) { previewSkin = 56; }
    if(regSexo[playerid] == 6) { previewSkin = 131; }
    PlayerTextDrawSetPreviewModel(playerid, registroTXD[playerid][3], previewSkin);
    refreshTextDraw(playerid, registroTXD[playerid][3]);
    return 1;
}

stock createTextLogin(playerid) {

    textLogin[playerid][0] = CreatePlayerTextDraw(playerid, 316.000000, 128.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][0], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][0], 0.600000, 21.200019);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][0], 298.500000, 109.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][0], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][0], 135);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][0], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][0], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][0], false);

    textLogin[playerid][1] = CreatePlayerTextDraw(playerid, 316.000000, 131.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][1], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][1], 0.666665, 1.299998);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][1], 298.500000, 105.500000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][1], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][1], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][1], 1097458175);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][1], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][1], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][1], false);

    textLogin[playerid][2] = CreatePlayerTextDraw(playerid, 264.000000, 128.000000, "entrar");
    PlayerTextDrawFont(playerid, textLogin[playerid][2], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][2], 0.370832, 1.699999);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][2], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][2], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, textLogin[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][2], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][2], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][2], false);

    textLogin[playerid][3] = CreatePlayerTextDraw(playerid, 355.000000, 130.000000, "ld_beat:cross");
    PlayerTextDrawFont(playerid, textLogin[playerid][3], TEXT_DRAW_FONT:4);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][3], 14.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][3], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, textLogin[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][3], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][3], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][3], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][3], true);

    textLogin[playerid][4] = CreatePlayerTextDraw(playerid, 275.000000, 189.000000, "LOGIN");
    PlayerTextDrawFont(playerid, textLogin[playerid][4], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][4], 0.270833, 1.300001);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][4], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][4], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][4], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][4], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][4], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][4], false);

    textLogin[playerid][5] = CreatePlayerTextDraw(playerid, 264.000000, 225.000000, "SENHA");
    PlayerTextDrawFont(playerid, textLogin[playerid][5], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][5], 0.233333, 1.300001);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][5], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][5], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, textLogin[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][5], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][5], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][5], false);

    textLogin[playerid][6] = CreatePlayerTextDraw(playerid, 316.000000, 205.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][6], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][6], 0.600000, 1.250001);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][6], 298.500000, 102.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][6], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][6], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][6], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][6], 135);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][6], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][6], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][6], false);

    textLogin[playerid][7] = CreatePlayerTextDraw(playerid, 316.000000, 240.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][7], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][7], 0.600000, 1.250001);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][7], 298.500000, 102.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][7], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][7], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][7], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][7], 135);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][7], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][7], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][7], false);

    textLogin[playerid][8] = CreatePlayerTextDraw(playerid, 316.000000, 262.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][8], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][8], 0.600000, 1.250001);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][8], 298.500000, 51.500000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][8], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][8], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][8], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][8], 2094792959);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][8], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][8], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][8], false);

    textLogin[playerid][9] = CreatePlayerTextDraw(playerid, 316.000000, 261.000000, "LOGAR");
    PlayerTextDrawFont(playerid, textLogin[playerid][9], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][9], 0.233333, 1.250000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][9], 400.000000, 36.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][9], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][9], 255);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][9], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][9], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][9], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][9], true);

    textLogin[playerid][10] = CreatePlayerTextDraw(playerid, 317.000000, 153.000000, "E SEMPRE UM PRAZER RECEBER VOCE AQUI");
    PlayerTextDrawFont(playerid, textLogin[playerid][10], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][10], 0.204166, 1.600000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][10], 400.000000, 94.500000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][10], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][10], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][10], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][10], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][10], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][10], false);

    textLogin[playerid][11] = CreatePlayerTextDraw(playerid, 316.000000, 289.000000, "ESQUECI MINHA SENHA");
    PlayerTextDrawFont(playerid, textLogin[playerid][11], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][11], 0.191667, 1.300000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][11], 400.000000, 92.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][11], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][11], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][11], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][11], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][11], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][11], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][11], true);

    textLogin[playerid][12] = CreatePlayerTextDraw(playerid, 316.000000, 303.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][12], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][12], 0.600000, -0.249996);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][12], 298.500000, 83.500000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][12], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][12], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][12], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][12], -1);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][12], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][12], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][12], true);

    textLogin[playerid][13] = CreatePlayerTextDraw(playerid, 316.000000, 205.000000, "Digite seu login");
    PlayerTextDrawFont(playerid, textLogin[playerid][13], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][13], 0.187500, 1.150000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][13], 10.000000, 70.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][13], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][13], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][13], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][13], 0);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][13], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][13], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][13], true);

    textLogin[playerid][14] = CreatePlayerTextDraw(playerid, 316.000000, 241.000000, "Digite sua senha");
    PlayerTextDrawFont(playerid, textLogin[playerid][14], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][14], 0.129166, 1.000000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][14], 9.000000, 70.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][14], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][14], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][14], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][14], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][14], 0);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][14], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][14], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][14], true);

    textLogin[playerid][15] = CreatePlayerTextDraw(playerid, 316.000000, 219.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][15], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][15], 0.600000, -0.249997);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][15], 298.500000, 102.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][15], 4);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][15], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][15], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][15], 1296911871);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][15], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][15], 1097458175);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][15], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][15], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][15], false);

    textLogin[playerid][16] = CreatePlayerTextDraw(playerid, 316.000000, 253.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][16], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][16], 0.600000, -0.249997);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][16], 298.500000, 102.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][16], 4);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][16], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][16], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][16], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][16], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][16], 1097458175);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][16], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][16], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][16], false);

    textLogin[playerid][17] = CreatePlayerTextDraw(playerid, 316.000000, 276.000000, "_");
    PlayerTextDrawFont(playerid, textLogin[playerid][17], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][17], 0.600000, -0.249997);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][17], 298.500000, 51.500000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][17], 4);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][17], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][17], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][17], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][17], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][17], 9109759);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][17], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][17], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][17], false);

    textLogin[playerid][18] = CreatePlayerTextDraw(playerid, 283.000000, 152.000000, "/");
    PlayerTextDrawFont(playerid, textLogin[playerid][18], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][18], 0.245833, 0.300000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][18], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][18], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][18], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][18], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][18], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][18], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][18], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][18], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][18], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][18], false);

    textLogin[playerid][19] = CreatePlayerTextDraw(playerid, 330.000000, 163.000000, "-");
    PlayerTextDrawFont(playerid, textLogin[playerid][19], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][19], 0.370833, 0.950000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][19], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][19], 0);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][19], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][19], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, textLogin[playerid][19], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][19], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][19], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][19], false);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][19], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][19], false);

    textLogin[playerid][20] = CreatePlayerTextDraw(playerid, 359.000000, 242.000000, "ld_beat:circle");
    PlayerTextDrawFont(playerid, textLogin[playerid][20], TEXT_DRAW_FONT:4);
    PlayerTextDrawLetterSize(playerid, textLogin[playerid][20], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, textLogin[playerid][20], 7.000000, 7.000000);
    PlayerTextDrawSetOutline(playerid, textLogin[playerid][20], 1);
    PlayerTextDrawSetShadow(playerid, textLogin[playerid][20], 0);
    PlayerTextDrawAlignment(playerid, textLogin[playerid][20], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, textLogin[playerid][20], -1);
    PlayerTextDrawBackgroundColour(playerid, textLogin[playerid][20], 255);
    PlayerTextDrawBoxColour(playerid, textLogin[playerid][20], 50);
    PlayerTextDrawUseBox(playerid, textLogin[playerid][20], true);
    PlayerTextDrawSetProportional(playerid, textLogin[playerid][20], true);
    PlayerTextDrawSetSelectable(playerid, textLogin[playerid][20], true);
    return 1;
}

public OnCreateTextLogin(playerid) {
    showTextLogin(playerid);
    return 1;
}

stock showTextLogin(playerid) {
    windowLogin[playerid] = true;
    for(new i = 0; i <= 19; i++) {
        PlayerTextDrawShow(playerid, textLogin[playerid][i]);
    }
    return 1;
}

stock hideTextLogin(playerid) {
    for(new i = 0; i <= 20; i++) {
        PlayerTextDrawHide(playerid, textLogin[playerid][i]);
        PlayerTextDrawDestroy(playerid, textLogin[playerid][i]);
    }
    windowLogin[playerid] = false;
    return 1;
}

stock showDialogLogLogin(playerid) {
    ShowPlayerDialog(playerid, DIALOG_LOG_LOG, DIALOG_STYLE_INPUT, "{FFFFFF}Entrar","{ffffff}Digite seu login:", "Confirmar","Cancelar");
    return 1;
}

stock showDialogLogPass(playerid) {
    ShowPlayerDialog(playerid, DIALOG_LOG_PASS, DIALOG_STYLE_PASSWORD, "{FFFFFF}Entrar","{ffffff}Digite sua senha:", "Confirmar","Cancelar");
    return 1;
}

public OnQueryPlayer(playerid) {
    if(cache_num_rows() > 0) {
        new passPlayer[25];
        new namePlayer[25];
        cache_get_value_name(0, "pPassword", passPlayer, sizeof(passPlayer));
        cache_get_value_name(0, "pName", namePlayer, sizeof(namePlayer));
        if(strcmp(loginPass, passPlayer) == 0) {
            SetPlayerName(playerid, namePlayer);
            startLoginPlayer(playerid);
            return 1;
        } else {
            SendClientMessage(playerid, -1, "{FFFF00}AVISO | {FFFFFF}Senha incorreta!");
            return 1;
        }
    } else {
        new string[128];
        format(string, sizeof(string), "{FFFF00}AVISO | {FFFFFF}Nenhuma conta com esse login: %s foi encontrada!",loginLogin[playerid]);
        SendClientMessage(playerid, -1, string);
        return 1;
    }
}

stock startLoginPlayer(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pLogin` = '%s'", loginLogin[playerid]);
    mysql_tquery(ConexaoSQL, query, "OnLoadPlayer", "i", playerid);
    return 1;
}

public OnLoadPlayer(playerid) {
    finishLogin(playerid);
    hideTextLogin(playerid);
    CancelSelectTextDraw(playerid);
    cache_get_value_int(0, "pMoney", PlayerInfo[playerid][pMoney]);
    cache_get_value_float(0, "pX", PlayerInfo[playerid][pX]);
    cache_get_value_float(0, "pY", PlayerInfo[playerid][pY]);
    cache_get_value_float(0, "pZ", PlayerInfo[playerid][pZ]);
    cache_get_value_float(0, "pA", PlayerInfo[playerid][pA]);
    cache_get_value_int(0, "pInt", PlayerInfo[playerid][pInt]);
    cache_get_value_int(0, "pVW", PlayerInfo[playerid][pVW]);
    cache_get_value_name(0, "uCode", PlayerInfo[playerid][uCode], 50);
    setSpawnPlayer(playerid);
    return 1;
}

stock setSpawnPlayer(playerid) {
    SpawnPlayer(playerid);
    SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
    SetPlayerCameraPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
    SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
    SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
    pLogado[playerid] = true;
    return 1;
}

stock createCodePlayer(playerid) {
    new number[128];
    new rand[9];
    for(new i = 0; i <= 8; i++){
        rand[i] = random(9);    
    }
    format(number, sizeof(number),"%d%d%d%d%d%d%d%d%d", rand[0],rand[1],rand[2],rand[3],rand[4],rand[5],rand[6],rand[7],rand[8]);
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `uCode` = '%s'", number);
    mysql_tquery(ConexaoSQL, query, "OnVerifyCode", "i", playerid);
    return number;
}

public OnVerifyCode(playerid) {
    if(cache_num_rows() > 0) {
        new query[128];
        mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
        SET `uCode`='%s' WHERE `pLogin`='%s'",createCodePlayer(playerid),regLogin[playerid]);
        mysql_tquery(ConexaoSQL, query);
        return 1;
    }
    return 1;
}

stock setTextDrawOFF(playerid) {
    textDrawON[playerid] = false;
    return 1;
}

stock setTextDrawON(playerid) {
    textDrawON[playerid] = true;
    return 1;
}

stock Separador(numbers)  
{
    new temp[24],counter = -1;
    valstr(temp,numbers);
    for(new i = strlen(temp);i > 0; i--)
    {
        counter++;
        if(counter == 3)
        {
            strins(temp,".",i);
            counter = 0;
        }
    }
    return temp;
}

public OnCreateCasa(playerid, hid, intid, value, X, Y, Z, A) {
    new str[128];
    format(str, sizeof(str), "Debug: casa %d interior: %d valor: %d será criada.", hid, intid, value);
    SendClientMessage(playerid, -1, str);
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `houses` SET `hX`='%f', `hY`='%f',\
    `hZ`='%f', `hA`='%f', `hInt`='%d' WHERE `hID`='%d'", X, Y, Z, A, intid, hid);
    mysql_tquery(ConexaoSQL, query);
    return 1;
}

public getLoginPlayer(playerid, nick) { // callback para puxar login
    if(cache_num_rows() > 0) {
        new strGet[50], strName[50], strNick[50];
        cache_get_value_name(0, "pLogin", strName, 24);
        cache_get_value_name(0, "pName", strNick, 24);
        format(strGet, sizeof(strGet),"{00ff00}RCON | {FFFFFF}O login do %s é %s", strNick, strName);
        SendClientMessage(playerid, -1, strGet);
        return 1;
    } else {
        new string[256];
        format(string, sizeof(string),"{FFFF00}AVISO | {FFFFFF}Nenhum nick como: %s foi encontrado!", nick);
        SendClientMessage(playerid, -1, string); 
        return 1;
    }
}

public OnCreateTextStart(playerid) {
    showTextStart(playerid);
    return 1;
}

stock getNamePlayer(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock getLocPlayer(playerid) {
    new local[64];
    GetPlayer2DZone(playerid, local, sizeof(local));  
    return local;
}

stock savePlayer(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `pName` = '%s'", getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query, "OnSavePlayer", "i", playerid);
    return 1;
}

public OnSavePlayer(playerid) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pMoney`='%d' WHERE `pName`='%s'",PlayerInfo[playerid][pMoney], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pX`='%f' WHERE `pName`='%s'",PlayerInfo[playerid][pX], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pY`='%f' WHERE `pName`='%s'",PlayerInfo[playerid][pY], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pZ`='%f' WHERE `pName`='%s'",PlayerInfo[playerid][pZ], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pA`='%f' WHERE `pName`='%s'",PlayerInfo[playerid][pA], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pInt`='%d' WHERE `pName`='%s'",PlayerInfo[playerid][pInt], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `pVW`='%d' WHERE `pName`='%s'",PlayerInfo[playerid][pVW], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `players`\
    SET `uCode`='%s' WHERE `pName`='%s'",PlayerInfo[playerid][uCode], getNamePlayer(playerid));
    mysql_tquery(ConexaoSQL, query);
    return 1;
}

public OnCreateLocal(i, X, Y, Z) {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `local` SET `lX`='%f', `lY`='%f',\
    `lZ`='%f' WHERE `lID`='%d'", X, Y, Z, i);
    mysql_tquery(ConexaoSQL, query);
    return 1;
}

public OnStartLoadLocais() {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `local`");
    mysql_tquery(ConexaoSQL, query, "OnStartedLoadLocais");    
    return 1;
}

public OnStartedLoadLocais() {
    if(cache_num_rows() > 0) 
	{
        new i = 0;
        for(new k = 0; k <= localExists-1; k++) {
            i++;
            cache_get_value_int(k, "lID", LocalInfo[i][lID]);
            cache_get_value_float(k, "lX", LocalInfo[i][lX]);
            cache_get_value_float(k, "lY", LocalInfo[i][lY]);
            cache_get_value_float(k, "lZ", LocalInfo[i][lZ]);
            cache_get_value_float(k, "liX", LocalInfo[i][liX]);
            cache_get_value_float(k, "liY", LocalInfo[i][liY]);
            cache_get_value_float(k, "liZ", LocalInfo[i][liZ]);
            cache_get_value_float(k, "liA", LocalInfo[i][liA]);
            cache_get_value_int(k, "lPickup", LocalInfo[i][lPickup]);
            cache_get_value_name(k, "textLocal", LocalInfo[i][textLocal], 50);
            startLocal(i);      
        }  
        return 1;   
    }
    return 1;
}

stock startLocal(i) {
    //lcPickup,
    //Text3D:lcText
    /*new string[128];
    format(string, sizeof(string),"%s",LocalInfo[i][textLocal]);*/
    LocalInfo[i][lcText] = CreateDynamic3DTextLabel(LocalInfo[i][textLocal], -1, LocalInfo[i][lX], LocalInfo[i][lY], LocalInfo[i][lZ]+0.25, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0, -1, 0);
    LocalInfo[i][lcPickup] = CreateDynamicPickup(LocalInfo[i][lPickup], 1, LocalInfo[i][lX], LocalInfo[i][lY], LocalInfo[i][lZ], -1, -1, -1, 80.0, -1, 0);
    return 1;
}
/* --------------- FIM FUNÇÕES IMPORTANTES --------------- */

/* --------------- COMANDOS RCON --------------- */
CMD:insert(playerid, params[]) { // atualizar banco de dados
    if(IsPlayerAdmin(playerid)) {
        new dtb[30], valor[30], coluna[30], colunaChave[30], chave[30];
        if(sscanf(params, "s[30]s[30]s[30]s[30]s[30]", dtb, coluna, valor, colunaChave, chave)) {
            SendClientMessage(playerid, -1, "Use: dtb, valor, coluna, colunaChave, chave"); 
            SendClientMessage(playerid, -1, "EX: /t players pEmail seuemail pLogin seulogin"); 
            return 1;
        } 
        insertInfo(playerid, dtb, coluna, valor, colunaChave, chave);
        return 1;
    }
    return 0;
}

CMD:getlogin(playerid, params[]) { // puxar login pelo nick
    if(IsPlayerAdmin(playerid)) {
        new nick[MAX_PLAYER_NAME];
        if(sscanf(params, "s[25]",nick)) {
            return SendClientMessage(playerid, 0xFF0000FF, "Use: /getlogin [NICK]");  
        }
        new query[256];
        mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `players` WHERE `pName` = '%s'", nick);
        mysql_tquery(ConexaoSQL, query, "getLoginPlayer", "ir", playerid, nick);
        return 1;
    }
    return 0;
}

CMD:go(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new Float:X, Float:Y, Float:Z, int = 0;
        if(sscanf(params, "dfff",int, X, Y, Z)) {
            return SendClientMessage(playerid, 0xff0000ff, "Use: /go [INT] [X] [Y] [Z]");
        }    
        SetPlayerInterior(playerid, int);
        SetPlayerPos(playerid, X, Y, Z);
        return 1;
    }
    return 0;
}

CMD:ccasa(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new value, intid;
        if(sscanf(params, "dd",value, intid)) {
            SendClientMessage(playerid, 0xffff00ff, "Use: /ccasa [valor] [id interior]");
            return 1;
        }    
        housesExists++;
        new Float:X, Float:Y, Float:Z, Float:A;
        GetPlayerFacingAngle(playerid, A);
        GetPlayerPos(playerid, X, Y, Z);
        new query[128];
        mysql_format(ConexaoSQL, query, sizeof(query), "INSERT INTO `houses` (`hID`, `hValue`, `hInt`)\
        VALUES ('%d', '%d', '%d')",housesExists, value, intid);
        mysql_tquery(ConexaoSQL, query, "OnCreateCasa", "ddddffff", playerid, housesExists, intid, value, X, Y, Z, A);
        return 1;
    }
    return 0;
}

CMD:vw(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new str[128];
        format(str, sizeof(str),"{ffff00}AVISO | {ffffff}Virtual World %d", GetPlayerVirtualWorld(playerid));
        SendClientMessage(playerid, -1, str);
        return 1;
    }
    return 0;
}

CMD:int(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new str[128];
        format(str, sizeof(str),"{ffff00}AVISO | {ffffff}Interior %d", GetPlayerInterior(playerid));
        SendClientMessage(playerid, -1, str);
        return 1;
    }
    return 0;
}

CMD:setgrana(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new id, value;
        if(sscanf(params, "dd", id, value)) {
            SendClientMessage(playerid, 0xffff00ff, "Use: /setgrana [id] [valor]");
            return 1;
        } else {
            GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
            GivePlayerMoney(playerid, value);
            PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
            return 1;
        }
    }
    return 0;
}

CMD:dargrana(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new id, value;
        if(sscanf(params, "dd", id, value)) {
            SendClientMessage(playerid, 0xffff00ff, "Use: /dargrana [id] [valor]");
            return 1;
        } else {
            GivePlayerMoney(playerid, value);
            new str[128];
            format(str, sizeof(str),"{ffff00}AVISO | {ffffff}O(A) Administrador(a) %s te deu {00FF7F}${ffffff}%s",getNamePlayer(playerid),Separador(value));
            SendClientMessage(id, -1, str);
            new string[128];
            format(string, sizeof(string),"{ffff00}AVISO | {ffffff}Você deu {00FF7F}${ffffff}%s para o jogador(a) %s.", Separador(value), getNamePlayer(playerid));
            SendClientMessage(playerid, -1, string);
            PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
            return 1;
        }
    }  
    return 0;
}

CMD:ints(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new str[650];
        new string[128];
        strcat(str, "{FFFFFF}ID\t{ffffff}Info\n");  
        for(new i = 0; i <= 11; i++) {
            format(string, sizeof(string),"{98FB98}ID: {ffffff}%d\t%s\n", i, IntsCoords[i][nHouse]);
            strcat(str, string);  
            SendClientMessage(playerid, -1, string);       
        }
        ShowPlayerDialog(playerid, DIALOG_INT_PROPS, DIALOG_STYLE_TABLIST_HEADERS, "{ffffff}Interiores", str, "Selecionar", "Cancelar");
        return 1;
    }
    return 0;
}

CMD:ircasa(playerid, params[]) {
    new i;
    if(sscanf(params, "d", i)) {
        SendClientMessage(playerid, 0xffff00ff, "Use: /ircasa [ID CASA]");
        return 1;
    } else {
        SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
        SetPlayerFacingAngle(playerid, HouseInfo[i][hA]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        return 1;
    }
}

CMD:reparar(playerid, params[]) {
    if(IsPlayerInAnyVehicle(playerid)) {
        SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
        RepairVehicle(GetPlayerVehicleID(playerid));
        return 1;
    } else {
        SendClientMessage(playerid, 0xff0000ff, "Você não está em um ve?culo!");
        return 1;
    }
}

CMD:virar(playerid, params[]) {
    if(IsPlayerInAnyVehicle(playerid)) {
        new Float:A;
        GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
  		SetVehicleZAngle(GetPlayerVehicleID(playerid), A);
        return 1;
    } else {
        SendClientMessage(playerid, 0xff0000ff, "Você não está em um veículo!");
        return 1;
    }
}

CMD:clocal(playerid, params[]) {
    if(IsPlayerAdmin(playerid)) {
        new pickup, text[128];
        if(sscanf(params, "ds[128]",pickup, text)) {
            SendClientMessage(playerid, 0xffff00ff, "Use: /clocal [pickup] [texto]");
            return 1;
        }    
        localExists++;
        new Float:X, Float:Y, Float:Z, Float:A;
        GetPlayerFacingAngle(playerid, A);
        GetPlayerPos(playerid, X, Y, Z);
        new query[128];
        mysql_format(ConexaoSQL, query, sizeof(query), "INSERT INTO `local` (`lID`, `textLocal`, `lPickup`)\
        VALUES ('%d', '%s', '%d')",localExists, text, pickup);
        mysql_tquery(ConexaoSQL, query, "OnCreateLocal", "dfff", localExists, X, Y, Z);
        startLocal(localExists);
        return 1;
    }
    return 0;
}
/* --------------- FIM COMANDOS RCON --------------- */
public OnStartLoadHouses() {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `houses`");
    mysql_tquery(ConexaoSQL, query, "OnStartedLoadHouses");    
    return 1;
}

stock saveHouse(hid) {
    new query[128]; //dono, money, hlock, hComprada
    mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `houses`\
    SET `hDono`='%s', `hMoney`='%d', `hLock`='%d', `hComprada`='%d' \
    WHERE `hID`='%d'",HouseInfo[hid][hDono], HouseInfo[hid][hMoney], 
    HouseInfo[hid][hLock], HouseInfo[hid][hComprada], hid);
    mysql_tquery(ConexaoSQL, query);
}

public OnStartedLoadHouses() {
    if(cache_num_rows() > 0) 
	{
        new i = 0;
        for(new k = 0; k <= housesExists-1; k++) {
            i++;
            cache_get_value_int(k, "hID", HouseInfo[i][hID]);
            cache_get_value_float(k, "hX", HouseInfo[i][hX]);
            cache_get_value_float(k, "hY", HouseInfo[i][hY]);
            cache_get_value_float(k, "hZ", HouseInfo[i][hZ]);
            cache_get_value_int(k, "hValue", HouseInfo[i][hValue]);
            cache_get_value_int(k, "hInt", HouseInfo[i][hInt]);
            cache_get_value_name(k, "hDono", HouseInfo[i][hDono], 50);
            cache_get_value_int(k, "hLock", HouseInfo[i][hLock]);
            cache_get_value_int(k, "hComprada", HouseInfo[i][hComprada]);
            new g = HouseInfo[i][hInt];
            HouseInfo[i][hIX] = IntsCoords[g][hCoords][4];
            HouseInfo[i][hIY] = IntsCoords[g][hCoords][5];
            HouseInfo[i][hIZ] = IntsCoords[g][hCoords][6];
            HouseInfo[i][hIA] = IntsCoords[g][hCoords][7];
            startHouse(i);      
        }  
        return 1;   
    }
    return 1;
}

stock startHouse(houses) {
    //house green 1273
    //house blue 1272
    //house red 19522
    //house orange 19523
    //house orange 19524
    if(HouseInfo[houses][hComprada] == HOUSE_AVENDA) {
        new string[256];
        format(string, sizeof(string),"{00FF7F}ID: {ffffff}%d\n{00FF7F}Dono: {ffffff}Ninguém\n{00FF7F}Preço: ${ffffff}%s\n\n/entrarcasa", houses, Separador(HouseInfo[houses][hValue]));
        HouseInfo[houses][h3DText] = CreateDynamic3DTextLabel(string, -1, HouseInfo[houses][hX], HouseInfo[houses][hY], HouseInfo[houses][hZ]+0.25, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0, -1, 0);
        HouseInfo[houses][hPickup] = CreateDynamicPickup(1273, 1, HouseInfo[houses][hX], HouseInfo[houses][hY], HouseInfo[houses][hZ], -1, -1, -1, 80.0, -1, 0);
    } else if(HouseInfo[houses][hComprada] == HOUSE_COMPRADA){
        new query[256];
        mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `uCode` = '%s'", HouseInfo[houses][hDono]);
        mysql_tquery(ConexaoSQL, query, "OnQueryDonoHouse", "i", houses);
        HouseInfo[houses][hPickup] = CreateDynamicPickup(19522, 1, HouseInfo[houses][hX], HouseInfo[houses][hY], HouseInfo[houses][hZ], -1, -1, -1, 80.0, -1, 0);  
    }
    return 1;
}

forward OnQueryDonoHouse(hid);
public OnQueryDonoHouse(hid) {
    if(cache_num_rows() > 0) {
        new name[50];
        cache_get_value_name(0, "pName", name, 50);
        new string[256];
        format(string, sizeof(string),"{00FF7F}ID: {ffffff}%d\n{00FF7F}Dono: {ffffff}%s\n\n/entrarcasa", hid, name);
        HouseInfo[hid][h3DText] = CreateDynamic3DTextLabel(string, -1, HouseInfo[hid][hX], HouseInfo[hid][hY], HouseInfo[hid][hZ]+0.25, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0, -1, 0);
        return 1;
    }
    return 1;
}

stock stopHouse(hid) {
    DestroyDynamic3DTextLabel(HouseInfo[hid][h3DText]);
    DestroyDynamicPickup(HouseInfo[hid][hPickup]);
    saveHouse(hid);
    return 1;
}

stock getPosHouse(playerid) {
    for(new i = 1; i <= housesExists; i++) {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))
        {
            return HouseInfo[i][hID];
        }
    }
    return 0;
}

stock getPosIntHouse(playerid) {
    for(new i = 1; i <= 12; i++) {
        if(IsPlayerInRangeOfPoint(playerid, 2.0,  HouseInfo[i][hIX], HouseInfo[i][hIY], HouseInfo[i][hIZ]))
        {
            return GetPlayerVirtualWorld(playerid);
        }
    }
    return -255;
}

CMD:entrarcasa(playerid, params[]) {
    new i = getPosHouse(playerid);
    if(i == 0) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de uma casa!");
    new j = HouseInfo[i][hInt];
    SetPlayerPos(playerid, IntsCoords[j][hCoords][4], IntsCoords[j][hCoords][5], IntsCoords[j][hCoords][6]);
    SetPlayerCameraPos(playerid, IntsCoords[j][hCoords][4], IntsCoords[j][hCoords][5], IntsCoords[j][hCoords][6]);
    SetPlayerFacingAngle(playerid, IntsCoords[j][hCoords][7]);
    SetPlayerInterior(playerid, IntsCoords[j][hIntid]);
    SetPlayerVirtualWorld(playerid, i);
    return 1;
}

CMD:saircasa(playerid, params[]) {
    new i = getPosIntHouse(playerid);
    if(i == -255) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de nenhuma porta!");
    SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
    SetPlayerCameraPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[i][hA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

CMD:comprarcasa(playerid, params[]) {
    new i = getPosHouse(playerid);
    if(i == 0) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de uma casa!");
    if(HouseInfo[i][hComprada] != 0) return SendClientMessage(playerid, 0xff0000ff, "Essa casa não está à venda.");
    if(PlayerInfo[playerid][pMoney] < HouseInfo[i][hValue]) return SendClientMessage(playerid, 0xff0000ff, "Você não possui dinheiro suficiente para comprar essa casa.");
    new title[128];
    format(title, sizeof(title), "{ffffff}Casas %s",SIGLA_SERVER);
    new string[256];
    format(string, sizeof(string), "\n\n{ffffff}Olá {1E90FF}%s\n\n\
    {ffffff}Deseja realmente comprar essa casa por {00FF7F}${00ff00}%s\n\n", getNamePlayer(playerid), Separador(HouseInfo[i][hValue]));
    ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_MSGBOX, title, string, "Comprar","Cancelar");
    return 1;
}

CMD:vendercasa(playerid, params[]){
    new i = getPosHouse(playerid);
    if(i == 0) return SendClientMessage(playerid, 0xff0000ff, "Você não está perto de uma casa!");
    if(HouseInfo[i][hDono] != PlayerInfo[playerid][uCode]) return SendClientMessage(playerid, 0xff0000ff, "Essa casa não te pertence.");
    new title[128];
    format(title, sizeof(title), "{ffffff}Casas %s",SIGLA_SERVER);
    new string[256];
    format(string, sizeof(string), "\n\n{ffffff}Olá {1E90FF}%s\n\n\
    {ffffff}Deseja realmente vender essa casa por {00FF7F}${00ff00}%s\n\n", getNamePlayer(playerid), Separador((HouseInfo[i][hValue] / 4) * 3));
    ShowPlayerDialog(playerid, DIALOG_SELL, DIALOG_STYLE_MSGBOX, title, string, "Vender","Cancelar");
    return 1;
}

/* ------------ FUNÇÕES IMPORTANTES DB ------------ */
stock insertInfo(playerid, const dtb[], const coluna[], const valor[], const colunaChave[], const chave[]) {
   new query[256];
   mysql_format(ConexaoSQL, query, sizeof(query), "UPDATE `%s` SET `%s`='%s' WHERE `%s`='%s'", dtb, coluna, valor, colunaChave, chave);
   mysql_tquery(ConexaoSQL, query, "executeInsert", "i", playerid); 
   SendClientMessage(playerid, -1, "geted");
   return 1;
}

forward executeInsert(playerid);
public executeInsert(playerid) {
    return 1;
}

stock startTablePlayer() { //iniciar player
    mysql_query(ConexaoSQL, "CREATE TABLE IF NOT EXISTS players (\
    id INT AUTO_INCREMENT PRIMARY KEY,\
    pLogin varchar(25) default 0,\
	 pName varchar(25) default 0,\
    pPassword varchar(25) default 0,\
	 pMoney int default 50000);", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pX float DEFAULT 1142.0504;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pY float DEFAULT -1704.6710;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pZ float DEFAULT 13.9531;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pA float DEFAULT 49.1388;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pI int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pVW int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pMoneyBank int DEFAULT 5000;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pLevel int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pSkin int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pAdmin int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pVip int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pEmail varchar(50) DEFAULT 0;", false);
    return 1;
}

stock startTableHouses() { //iniciar casa
    mysql_query(ConexaoSQL, "CREATE TABLE IF NOT EXISTS houses (\
    hID int DEFAULT 0,\
    hDono varchar(25) DEFAULT 0,\
    hPickup int DEFAULT 0,\
    hMoney int DEFAULT 0,\
    hValue int DEFAULT 0,\
    hX float DEFAULT 0,\
    hY float DEFAULT 0,\
    hZ float DEFAULT 0);", false);
    /*mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pX float DEFAULT 1142.0504;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pY float DEFAULT -1704.6710;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pZ float DEFAULT 13.9531;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pA float DEFAULT 49.1388;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pI int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pVW int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pMoneyBank int DEFAULT 5000;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pLevel int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pSkin int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pAdmin int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pVip int DEFAULT 0;", false);
    mysql_query(ConexaoSQL, "ALTER TABLE players ADD IF NOT EXISTS pEmail varchar(50) DEFAULT 0;", false);*/
    return 1;
}
/* ------------ FIM FUNÇÕES IMPORTANTES DB ------------ */