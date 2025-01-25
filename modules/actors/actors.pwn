#include <YSI_Coding\y_hooks>

/*
    STEPS,
    1 -> Posição
        X -> 1.1
        Y -> 1.2 
        Z -> 1.3
        A -> 1.4 
        Posição atual -> 1.5
    2 -> Int
    3 -> Vw
    4 -> Nome
    5 -> Skin
*/

/* HOOKS ----------------------------------------*/

hook OnPlayerDisconnect(playerid, reason) {
    finishCreateActor(playerid);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_ACT_CONF_SKIN) {
        if(response) {
            createAct(ActorCreate[playerid][actorName], ActorCreate[playerid][cActorSkin], ActorCreate[playerid][cActorPos][0], ActorCreate[playerid][cActorPos][1],
            ActorCreate[playerid][cActorPos][2], ActorCreate[playerid][cActorPos][3], ActorCreate[playerid][cActorVw], 
            ActorCreate[playerid][cActorInt], 0);
            finishCreateActor(playerid);
            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(playerid, X, Y, Z);
            SetPlayerPos(playerid, X+0.5, Y, Z);
            return 1;
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_C_INT) {
        if(response) {
            if(!strlen(inputtext) || checkText(inputtext) == 1) {
                sendWarning(playerid, "Digite um interior válido!");
                showDlgActInt(playerid);
                return 1;
            }
            ActorCreate[playerid][cActorInt] = strval(inputtext);
            showDlgActVw(playerid);
            return 1;
        } else {
            return 1;
        }
    }

    if(dialogid == DIALOG_ACT_C_VW) {
        if(response) {
            if(!strlen(inputtext) || checkText(inputtext) == 1) {
                sendWarning(playerid, "Digite um virtual world válido!");
                showDlgActVw(playerid);
                return 1;
            }
            ActorCreate[playerid][cActorVw] = strval(inputtext);
            showDlgNameAct(playerid);
            return 1;
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_CONF_NAME) {
        if(response) {
            generateActorSkin(playerid);
            return 1;
        } else {
            showDlgNameAct(playerid);     
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_C_GENDER) {
        if(response) {
            new i = listitem;
            ActorCreate[playerid][actorGender] = i;
            showDlgConfNameAct(playerid);
            return 1;    
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_C_NAME) {
        if(response) {
            if(!strlen(inputtext) || checkNumber(inputtext) == 1) {
                sendWarning(playerid, "Digite um nome válido!");
                showDlgCrtNameAct(playerid);
                return 1;
            }   
            format(ActorCreate[playerid][actorName], 18, "%s", inputtext);
            showDlgGenderAct(playerid);
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_Q_NAME) {
        if(response) {
            switch(listitem) {
                case 0 : {
                    showDlgCrtNameAct(playerid);
                }
                case 1 : {
                    new i = random(20);
                    format(ActorCreate[playerid][actorName], 18, "%s", namesActors[i][nForActors]);
                    ActorCreate[playerid][actorGender] = namesActors[i][sForActors];
                    showDlgConfNameAct(playerid);
                }
            }
            return 1;
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_C_POS) {
        if(response) {
            if(!strlen(inputtext) || checkText(inputtext) == 1) {
                new str[128];
                format(str, sizeof(str),"%s Digite uma coordenada válida", MSG_ACTOR);
                SendClientMessage(playerid, -1, str);
                showDlgActPos(playerid);
                return 1;
            }
            if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_X) {
                ActorCreate[playerid][cActorPos][0] = strfloat(inputtext);
                ActorCreate[playerid][cActorStep] = STEP_ACT_POS_Y;
                showDlgActPos(playerid);
            } else if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_Y) {
                ActorCreate[playerid][cActorPos][1] = strfloat(inputtext);
                ActorCreate[playerid][cActorStep] = STEP_ACT_POS_Z;
                showDlgActPos(playerid);
            } else if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_Z) {
                ActorCreate[playerid][cActorPos][2] = strfloat(inputtext);
                ActorCreate[playerid][cActorStep] = STEP_ACT_POS_A;
                showDlgActPos(playerid);
            } else if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_A) {
                ActorCreate[playerid][cActorPos][3] = strfloat(inputtext);
                showDlgActInt(playerid);
            }
            return 1;
        } else {
            return 1;
        }
    }

    if(dialogid == DIALOG_ACT_QUESTION) {       
        if(response) {
            switch(listitem) {
                case 0 : {
                    new Float:X, Float:Y, Float:Z, Float:A;
                    GetPlayerPos(playerid, X, Y, Z);
                    GetPlayerFacingAngle(playerid, A);
                    ActorCreate[playerid][cActorPos][0] = X;
                    ActorCreate[playerid][cActorPos][1] = Y;
                    ActorCreate[playerid][cActorPos][2] = Z;
                    ActorCreate[playerid][cActorPos][3] = A;
                    ActorCreate[playerid][cActorStep] = STEP_ACT_POS_ATUAL;
                    showDlgNameAct(playerid);
                    return 1;
                } 

                case 1 : {
                    ActorCreate[playerid][cActorStep] = STEP_ACT_POS_X;
                    showDlgActPos(playerid);
                }
            }            
        } else {

            return 1;
        }
    }
    return 1;
}

/* COMMANDS -------------------------------------*/

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

CMD:vactor(playerid, params[]) {
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_OWNER) {
        new i;
        if(sscanf(params, "d", i)) return SendClientMessage(playerid, -1, "Digite: /vactor [idActor]");
        new str[128];
        format(str, sizeof(str),"ID: %d Nome: %s", ActorInfo[i][actorId], ActorInfo[i][nameActor]);
        SendClientMessage(playerid, -1, str);
        return 1;
    } else {
        return 0;
    }
}

/* CALLBACKS ------------------------------------*/

forward OnLoadActors();
public OnLoadActors() { // loading de actors
    qtdActors = cache_num_rows();
    printf("----------------- ATORES -----------------");	
    printf("%02d atores foram carregados",qtdActors);
    for(new j = 0; j < qtdActors; j++) {
        cache_get_value_int(j, "actorID", ActorInfo[j+1][actorId]);
        cache_get_value_int(j, "actorSkin", ActorInfo[j+1][actorSkin]);
        cache_get_value_name(j, "actorName", ActorInfo[j+1][nameActor], 18);
        cache_get_value_float(j, "actorX", ActorInfo[j+1][posActor][0]);
        cache_get_value_float(j, "actorY", ActorInfo[j+1][posActor][1]);
        cache_get_value_float(j, "actorZ", ActorInfo[j+1][posActor][2]);
        cache_get_value_float(j, "actorA", ActorInfo[j+1][posActor][3]);
        cache_get_value_int(j, "actorVw", ActorInfo[j+1][vwActor]);
        cache_get_value_int(j, "actorInt", ActorInfo[j+1][intActor]);
        cache_get_value_int(j, "actorFree", ActorInfo[j+1][freeActor]);
        startActor(ActorInfo[j+1][actorId]);
        /*printf("ID: %d | Skin: %d | Nome: %s | X: %f Y: %f Z: %f A: %f | Vw: %d | Int: %d | actorFree: %d",
        ActorInfo[j][actorId], ActorInfo[j][actorSkin], ActorInfo[j][nameActor], ActorInfo[j][posActor][0],
        ActorInfo[j][posActor][1], ActorInfo[j][posActor][2], ActorInfo[j][posActor][3], ActorInfo[j][vwActor],
        ActorInfo[j][intActor], ActorInfo[j][freeActor]);*/
    }
    return 1;
}

forward OnLoadActorId(i);
public OnLoadActorId(i) {
    cache_get_value_int(0, "actorID", ActorInfo[i][actorId]);
    cache_get_value_int(0, "actorSkin", ActorInfo[i][actorSkin]);
    cache_get_value_name(0, "actorName", ActorInfo[i][nameActor], 18);
    cache_get_value_float(0, "actorX", ActorInfo[i][posActor][0]);
    cache_get_value_float(0, "actorY", ActorInfo[i][posActor][1]);
    cache_get_value_float(0, "actorZ", ActorInfo[i][posActor][2]);
    cache_get_value_float(0, "actorA", ActorInfo[i][posActor][3]);
    cache_get_value_int(0, "actorVw", ActorInfo[i][vwActor]);
    cache_get_value_int(0, "actorInt", ActorInfo[i][intActor]);
    cache_get_value_int(0, "actorFree", ActorInfo[i][freeActor]);
    startActor(ActorInfo[i][actorId]);
    return 1;
}

/* FUNCTIONS ------------------------------------*/

stock startActor(i) { // Função para criar ator
    ActorInfo[i][actorId] = CreateActor(ActorInfo[i][actorSkin], ActorInfo[i][posActor][0], ActorInfo[i][posActor][1],
    ActorInfo[i][posActor][2], ActorInfo[i][posActor][3]);
    ActorInfo[i][actorOn] = true;
    return 1;
}

stock stopActor(i) { // Função para remover ator
    DestroyActor(ActorInfo[i][actorId]);
    ActorInfo[i][actorOn] = false;
    return 1;
}

stock createAct(nameAct[], skin, Float:x, Float:y, Float:z, Float:a, vwAct, intAct, freeAct) { // Função criar ator
    new query[256];
    qtdActors++;
    mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `actors` (`actorID`,`actorName`,`actorSkin`,\
    `actorX`, `actorY`, `actorZ`, `actorA`, `actorVw`, `actorInt`, `actorFree`) VALUES \
    ('%d','%s','%d','%f','%f','%f','%f','%d','%d','%d')",qtdActors, nameAct, skin,
    x, y, z, a, vwAct, intAct, freeAct);
    mysql_tquery(ConexaoSQL, query);
    loadActorId(qtdActors);
    return 1;
}

stock showDlgCreateAct(playerid) { // Criar dialog inicial de criação do ator.
    ShowPlayerDialog(playerid, DIALOG_ACT_QUESTION, DIALOG_STYLE_LIST, "{FFFFFF}Criação de ator",
        "Criar na minha posição\n\
        Informar coordenadas manualmente", "Confirmar","Cancelar");  
    ActorCreate[playerid][cActorStep] = 1; 
    return 1;
}

stock showDlgNameAct(playerid) { // Criar dialog para definir nome do ator
    ShowPlayerDialog(playerid, DIALOG_ACT_Q_NAME, DIALOG_STYLE_LIST, "{FFFFFF}Nome do ator","{ffffff}Escolher nome\nGerar nome aleatório", "Confirmar","Cancelar");
    ActorCreate[playerid][cActorStep] = STEP_ACT_NAME;
    return 1;
}

stock showDlgCrtNameAct(playerid) { // Criar dialog de criação de nome para ator
    ShowPlayerDialog(playerid, DIALOG_ACT_C_NAME, DIALOG_STYLE_INPUT, "{FFFFFF}Nome do ator","{ffffff}Digite o nome do ator:", "Confirmar","Cancelar");
    ActorCreate[playerid][cActorStep] = STEP_ACT_NAME;
    return 1;
}

stock showDlgGenderAct(playerid) { // Criar dialog para setar gênero do ator
    ShowPlayerDialog(playerid, DIALOG_ACT_C_GENDER, DIALOG_STYLE_LIST, "{FFFFFF}Gênero do ator","Feminino\nMasculino", "Confirmar","Cancelar");
    return 1;
}

stock showDlgConfNameAct(playerid) { // Dialog para informar nome do ator
    new str[64], result[16], string[96];
    if(ActorCreate[playerid][actorGender] == 1) result = "Masculino";
    if(ActorCreate[playerid][actorGender] == 0) result = "Feminino";
    format(str, sizeof(str),"{ffffff}Nome do ator: %s\nSexo: %s", ActorCreate[playerid][actorName], result);
    ShowPlayerDialog(playerid, DIALOG_ACT_CONF_NAME, DIALOG_STYLE_MSGBOX, "{FFFFFF}Nome do ator",str, "Confirmar","Cancelar");
    format(string, sizeof(string),"%s Se você deseja setar/gerar outro nome, digite: %s/rnameactor", MSG_ACTOR, EMBED_SERVER);
    SendClientMessage(playerid, -1, string);
    ActorCreate[playerid][cActorStep] = STEP_ACT_NAME;
    return 1;
}

stock showDlgActPos(playerid) { // Dialog para setar posições do ator
    new str[128], step[2];
    if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_X) step = "X";
    if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_Y) step = "Y";
    if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_Z) step = "Z";
    if(ActorCreate[playerid][cActorStep] == STEP_ACT_POS_A) step = "A";
    format(str, sizeof(str),"{FFFFFF}Digite a posição %s:", step);
    ShowPlayerDialog(playerid, DIALOG_ACT_C_POS, DIALOG_STYLE_INPUT, "{FFFFFF}Nome do ator", str, "Confirmar","Cancelar");
    return 1;
}

stock showDlgActInt(playerid) { // Criar dialog para setar interior do ator
    ShowPlayerDialog(playerid, DIALOG_ACT_C_INT, DIALOG_STYLE_INPUT, "{FFFFFF}Interior do ator", "{ffffff}Digite o interior do ator:", "Confirmar","Cancelar");
    ActorCreate[playerid][cActorStep] = STEP_ACT_INT;
    return 1;
}

stock showDlgActVw(playerid) { // Criar dialog para setar virtual world do ator
    ShowPlayerDialog(playerid, DIALOG_ACT_C_VW, DIALOG_STYLE_INPUT, "{FFFFFF}Interior do ator", "{ffffff}Digite o virtual world do ator:", "Confirmar","Cancelar");
    ActorCreate[playerid][cActorStep] = STEP_ACT_VW;
    return 1;
}

stock generateActorSkin(playerid) { // Gerar skin do ator de acordo com o gênero desejado
    new i = random(8);
    while(menuSkinActors[i][genMenuActor] != ActorCreate[playerid][actorGender]) {
        i = random(8);           
    }
    ActorCreate[playerid][cActorSkin] = menuSkinActors[i][skinMenuActor];
    showDlgConfSkin(playerid);
    return 1;
}

stock showDlgConfSkin(playerid) { // Criar dialog de confirmação da skin do ator
    new str[128];
    format(str, sizeof(str),"{ffffff}Skin ID: %d", ActorCreate[playerid][cActorSkin]);
    ShowPlayerDialog(playerid, DIALOG_ACT_CONF_SKIN, DIALOG_STYLE_MSGBOX, "{FFFFFF}Skin Ator", str, "Confirmar","Cancelar");
    return 1;
}

stock finishCreateActor(playerid) { // Finalizar variáveis criação de ator
    SendClientMessage(playerid, -1, "OK");
    return 1;
}

stock loadActors() { // Carregar todos atores do DB
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM actors");
    mysql_tquery(ConexaoSQL, query, "OnLoadActors");
    return 1;
}

loadActorId(i) { // Carregar ator pelo ID
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM actors WHERE `actorID`='%d'", i);
    mysql_tquery(ConexaoSQL, query, "OnLoadActorId", "d", i);
    return 1;
}

stock checkText(const string[]) {
    for (new i = 0; i < strlen(string); i++) {
        if ((string[i] >= 'A' && string[i] <= 'Z') || (string[i] >= 'a' && string[i] <= 'z')) {
            return true;
        }
    }
    return false;
}

stock checkNumber(const string[]) {
    for (new i = 0; i < strlen(string); i++) {
        if (string[i] >= 0 && string[i] <= 9) {
            return true;
        }
    }
    return false;
}
