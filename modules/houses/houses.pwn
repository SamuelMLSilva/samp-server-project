/* --------------- SISTEMA DE CADASTRO DE INTERIORES --------------- */
/* ----------- FUNCTIONS -----------*/
stock loadIntsHousesId(i) { // função para carregar interior pelo ID
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM h_ints_houses WHERE iIntId = '%d'",i);
    mysql_tquery(ConexaoSQL, query, "OnLoadIntsHousesId", "i", i);
    return 1;
}

forward OnLoadIntsHousesId(i); // !testar
public OnLoadIntsHousesId(i) { // public que retorna informações do interior pelo ID 
    cache_get_value_name_int(0, "iInt", InfoInt[i][iInt]);
    cache_get_value_name_float(0, "iPosX", InfoInt[i][iPos][0]);
    cache_get_value_name_float(0, "iPosY", InfoInt[i][iPos][1]);
    cache_get_value_name_float(0, "iPosZ", InfoInt[i][iPos][2]);
    cache_get_value_name_float(0, "iPosA", InfoInt[i][iPos][3]);
    return 1;
}

stock loadIntsHouses() { // função para carregar todos interiores
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM h_ints_houses");
    mysql_tquery(ConexaoSQL, query, "OnLoadIntsHouses");
    return 1;
}

forward OnLoadIntsHouses();
public OnLoadIntsHouses() { // public que retorna informações do interior
    new i = cache_num_rows();
    printf("-- INTERIORES CASAS ---------------------");
    printf("%02d interiores registrados\n", i);
    for(new j = 1; j <= i; j++) {
        new id = 0;
        cache_get_value_name_int(j-1, "iIntId", id);
        InfoInt[id][iIntId] = id;
        cache_get_value_name_int(j-1, "iInt", InfoInt[id][iInt]);
        cache_get_value_name_float(j-1, "iPosX", InfoInt[id][iPos][0]);
        cache_get_value_name_float(j-1, "iPosY", InfoInt[id][iPos][1]);
        cache_get_value_name_float(j-1, "iPosZ", InfoInt[id][iPos][2]);
        cache_get_value_name_float(j-1, "iPosA", InfoInt[id][iPos][3]);
        qIntsHouses++;
    }
    return 1;
}
/* ----------- FUNCTIONS FIM -----------*/

CMD:cint(playerid, params[]) { // CMD para cadastrar interior no db
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
        if(IntCreate[playerid][creatingInt] == false) {
            IntCreate[playerid][creatingInt] = true;
            showDlgCadastroInt(playerid);
            return 1;
        } else {
            showDlgContinuaCadastro(playerid);
        }
        return 1;
    } else {
        return 0;
    }
}

CMD:ccint(playerid, params[]) { // cancelar cadastro do interior
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
        cancelCreateInt(playerid);
        return 1;
    } else {
        return 0;
    }
}

CMD:vint(playerid, params[]) { // comando para ver informações do interior
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
        new i = 0;
        if(sscanf(params, "d", i)) return sendWarning(playerid, "Digite: /vint [idInt]");
        if(InfoInt[i][iIntId] == 0) return sendMsgServer(playerid, "Esse interior não existe!");
        new str[512];
        format(str, sizeof(str),"{ffffff}Info\t{ffffff}Valor\nID Interior\t%d\nInterior\t%d\nPos X\t%f\nPos Y\t%f\nPos Z\t%f\nPos A\t%f",
        InfoInt[i][iIntId], InfoInt[i][iInt], InfoInt[i][iPos][0], InfoInt[i][iPos][1], InfoInt[i][iPos][2],
        InfoInt[i][iPos][3]);
        new strTitlle[64];
        format(strTitlle, sizeof(strTitlle),"{ffffff}Interior ID: %d", i);
        ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, strTitlle, str, "Ok","");
        return 1;
    } else {
        return 0;
    }
}

CMD:lint(playerid, params[]) { // comando para ver informações do interior
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
        new i = 0;
        if(sscanf(params, "d", i)) return sendWarning(playerid, "Digite: /vint [idInt]");
        if(InfoInt[i][iIntId] == 0) return sendMsgServer(playerid, "Esse interior não existe!");
        loadIntsHousesId(i);
        new str[128];
        format(str, sizeof(str),"Interior %d carregado",i);
        SendClientMessage(playerid, -1, str);
        return 1;
    } else {
        return 0;
    }
}

stock cancelCreateInt(playerid) { // função para cancelar a criação do interior
    if(IntCreate[playerid][creatingInt] == true) {
        new str[128];
        format(str, sizeof(str),"%s Você cancelou o cadastro do interior atual!",MSG_CASAS);
        SendClientMessage(playerid, -1, str);
        IntCreate[playerid][creatingInt] = false;
        return 1;
    }
    return 1;
}

stock showDlgCadastroInt(playerid) { // mostrar dialog de status da criação do interior
    new str[256];
    new sDoor[30], sBau[30], sMoradores[30], sKgBau[30];
    if(IntCreate[playerid][bDoorPos] == true) sDoor = "{00ff00}Feito";
    if(IntCreate[playerid][bDoorPos] == false) sDoor = "{ffff00}Pendênte";
    if(IntCreate[playerid][bBauPos] == true) sBau = "{00ff00}Feito";
    if(IntCreate[playerid][bBauPos] == false) sBau = "{ffff00}Pendênte";
    if(IntCreate[playerid][bQtdMoradores] == true) sMoradores = "{00ff00}Feito";
    if(IntCreate[playerid][bQtdMoradores] == false) sMoradores = "{ffff00}Pendênte";
    if(IntCreate[playerid][bKgBau] == true) sKgBau = "{00ff00}Feito";
    if(IntCreate[playerid][bKgBau] == false) sKgBau = "{ffff00}Pendênte";
    format(str, sizeof(str),"{ffffff}Etapa\t{ffffff}Status\n\
    Pos Porta\t%s\n\
    Pos Bau\t%s\n\
    Moradores\t%s\n\
    Kg baú\t%s", sDoor, sBau, sMoradores, sKgBau);
    ShowPlayerDialog(playerid, DIALOG_INTS_CADASTRO, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Cadastrp interiores para casas", str, "Selecionar","Cancelar");
    return 1;
}

stock showDlgContinuaCadastro(playerid) { // dialog para confirmar a continuidade da criação do interior
    ShowPlayerDialog(playerid, DIALOG_INTS_CONF_CONT, DIALOG_STYLE_MSGBOX, "{FFFFFF}Cadastro de interiores",
    "{ffffff}Você já possui um cadastro de interior pendênte\nVocê deseja prosseguir com a criação do interior ID: __", "Confirmar","Cancelar");
    return 1;
}

/* --------------- SISTEMA DE CADASTRO DE INTERIORES FIM --------------- */
