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

hook OnPlayerModelSelectionEx(playerid, response, extraid, modelid) { // Retornar ID da pickup selecionado no menu mSelection
	
	if(modelid > 0) {
		
		if(ActorModify[playerid][changeActSkin] == true) {
            new i = ActorModify[playerid][modActorID];
			ActorInfo[i][actorSkin] = modelid;	
			setSkinActor(i, modelid);	
            SetActorSkin(ActorInfo[i][actorId], modelid);    
            new str[128];
            format(str, sizeof(str),"%s A skin do actor ID: %d foi trocado para a skin ID: %d",MSG_ACTOR, i, modelid);
            SendClientMessage(playerid, -1, str);        
            finishModifyActor(playerid);
            return 1;
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_ACT_MODIFY_VW) { // Dialog de modificar vw do actor
        if(response) {
            if(!strlen(inputtext) || checkText(inputtext) == 1) {
                showDlgModActVw(playerid);
                sendWarning(playerid, "Digite um valor válido!");
                return 1;
            }
            new i = ActorModify[playerid][modActorID];
			ActorInfo[i][vwActor] = strval(inputtext);	
            new str[128];
            format(str, sizeof(str),"%s O Virtual World do actor ID: %d foi trocado para a Virtual World ID: %d",MSG_ACTOR, i, ActorInfo[i][vwActor]);
            SendClientMessage(playerid, -1, str);   
            SetActorVirtualWorld(ActorInfo[i][actorId], ActorInfo[i][vwActor]);
            setModVwActor(i, ActorInfo[i][vwActor]);
            finishModifyActor(playerid);
            return 1;
        } else {
            return 1;
        }
    }
    
    if(dialogid == DIALOG_ACT_MODIFY_NAME) { // Dialog de modificação de name
        if(response) {
            if(!strlen(inputtext)) {
                sendWarning(playerid, "Digite um nome válido!");
                changeActorName(playerid);
                return 1;
            }
            new i = ActorModify[playerid][modActorID];
            format(ActorInfo[i][nameActor], 50, "%s", inputtext);
            new str[128];
            format(str, sizeof(str),"%s Nome: %s setado com sucesso!", MSG_ACTOR, ActorInfo[i][nameActor]);
            SendClientMessage(playerid, -1, str);
            setActName(i, ActorInfo[i][nameActor]);
            finishModifyActor(playerid);
            return 1;
        } else {
            finishModifyActor(playerid);
            return 1;
        }
    }

    if(dialogid == DIALOG_ACT_MODIFY) { // Dialog de modificação de atores
        if(response) {
            switch(listitem) {
                case 0: { // modificar nome do actor
                    changeActorName(playerid);
                    return 1;
                }
                case 1: { // modificar skin do actor
                    changeActorSkin(playerid);
                    return 1;
                }
                case 2: { // modificar vw do actor
                    showDlgModActVw(playerid);                   
                    return 1;
                }
            }
            return 1;
        } else {
            finishModifyActor(playerid);
            return 1;
        }
    }

    if(dialogid == DIALOG_ACT_MODIFY_ID) { // dialog para digitar id do ator que o player irá editar
        if(response) {
            if(!strlen(inputtext) || checkText(inputtext) == 1) { // válida ID e caracteres digitado
                sendWarning(playerid, "Digite um ID válido!");
                showDlgModifyActId(playerid);
                return 1;
            }
            if(qtdActors == 0) { // se não existir atores no db
                sendWarning(playerid, "Não existe atores no banco de dados ainda!");                   
                showDlgModifyActId(playerid);
                return 1;
            }
            if(strval(inputtext) > qtdActors) { // gera aviso se o valor digitado for maior que a quantidade existente de atores no db
                new str[128];
                format(str, sizeof(str),"Os ID's de atores vão de 1 até %d",qtdActors);
                sendWarning(playerid, str);
                showDlgModifyActId(playerid);
                return 1;
            }
            ActorModify[playerid][modActorID] = strval(inputtext); 
            new string[128];
            format(string, sizeof(string),"Você está modificando o ator ID: %d", ActorModify[playerid][modActorID]);
            sendWarning(playerid, string);
            showDialogModifyAct(playerid);
            return 1;
        } else {
            finishModifyActor(playerid);
            return 1;
        }
    }
    
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
    //startActor(ActorInfo[i][actorId]);
    return 1;
}

/* FUNCTIONS ------------------------------------*/

stock showDlgModActInt(playerid) { // mostrar dialog para alterar interior do ator
    ActorModify[playerid][changeActInt] = true;
    new strTitle[64];
    format(strTitle, sizeof(strTitle),"{ffffff}Actor [ID: {00ff00}%02d{ffffff}]",ActorModify[playerid][modActorID]);
    ShowPlayerDialog(playerid, DIALOG_ACT_MODIFY_INT, DIALOG_STYLE_INPUT, strTitle, "{ffffff}Digite o interior desejado para o ator:", "Confirmar","Cancelar");
    return 1;
}

stock setModIntActor(id, idInt){ // setar interior do actor no db
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE actors SET actorInt = '%d' WHERE actorID = %d", idInt, id);
    mysql_tquery(ConexaoSQL, query);  
    return 1;
}

stock showDlgModActVw(playerid) { // mostrar dialog para alterar virtual world
    ActorModify[playerid][changeActVw] = true;
    new strTitle[64];
    format(strTitle, sizeof(strTitle),"{ffffff}Actor [ID: {00ff00}%02d{ffffff}]",ActorModify[playerid][modActorID]);
    ShowPlayerDialog(playerid, DIALOG_ACT_MODIFY_VW, DIALOG_STYLE_INPUT, strTitle, "{ffffff}Digite o virtual world desejado para o ator:", "Confirmar","Cancelar");
    return 1;
}

stock setModVwActor(id, idVw){ // setar virtual world do actor no db
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE actors SET actorVw = '%d' WHERE actorID = %d", idVw, id);
    mysql_tquery(ConexaoSQL, query);  
    return 1;
}

stock changeActorSkin(playerid) {
    ActorModify[playerid][changeActSkin] = true;
    mSecMenuCSkinAct[playerid] = ShowModelSelectionMenuEx(playerid, menuChangeActSkin[skinForActor], 312, "Skins", 0, 0.0, 0.0, 35.0, 1.0, 0x4A5A6BBB, 0x88888899 , 0xFFFF00AA);
    return 1;
}

stock setSkinActor(id, skin) { // função para alterar nome do ator no db
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE actors SET actorSkin = '%d' WHERE actorID = %d", skin, id);
    mysql_tquery(ConexaoSQL, query);  
    return 1;
}

stock changeActorName(playerid) { // função trocar nome do ator
    ActorModify[playerid][changeActName] = true;
    new strTitle[64];
    format(strTitle, sizeof(strTitle),"{ffffff}Actor [ID: {00ff00}%02d{ffffff}]",ActorModify[playerid][modActorID]);
    ShowPlayerDialog(playerid, DIALOG_ACT_MODIFY_NAME, DIALOG_STYLE_INPUT, strTitle, "{ffffff}Digite o nome desejado para o ator:", "Confirmar","Cancelar");
    return 1;
}

stock setActName(id, nameAct[]) { // função para alterar nome do ator no db
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query),"UPDATE actors SET actorName = '%s' WHERE actorID = %d", nameAct, id);
    mysql_tquery(ConexaoSQL, query);
    return 1;
}

stock showDialogModifyAct(playerid) { // funçao de mostrar dialog de modificação de atores
    new strTitle[64];
    format(strTitle, sizeof(strTitle),"{ffffff}Actor [ID: {00ff00}%02d{ffffff}]",ActorModify[playerid][modActorID]);
    ShowPlayerDialog(playerid, DIALOG_ACT_MODIFY, DIALOG_STYLE_LIST, strTitle, 
    "Nome\n\
    Skin\n\
    Virtual World", 
    "Selecionar","Fechar");
    return 1;
}

stock showDlgModifyActId(playerid) {
    ShowPlayerDialog(playerid, DIALOG_ACT_MODIFY_ID, DIALOG_STYLE_INPUT, "{FFFFFF}Moficiar ator", "{ffffff}Digite o ID do ator que você deseja modificar:","Confirmar","Cancelar");
    return 1;
}


stock getPosActorID(playerid) {
    for(new i = 0; i <= 10-1; i++) {
        printf("Passando pelo índice %d %f %f %f", i, ActorInfo[i][posActor][0], ActorInfo[i][posActor][1], ActorInfo[i][posActor][2]);
		if(IsPlayerInRangeOfPoint(playerid, 4.0, ActorInfo[i][posActor][0], ActorInfo[i][posActor][1], ActorInfo[i][posActor][2])) {
            printf("Parou no índice %d", i);
			return i;
		}
	}
    return -1;
}

stock startActor(i) { // Função para criar ator
    ActorInfo[i][actorId] = CreateActor(ActorInfo[i][actorSkin], ActorInfo[i][posActor][0], ActorInfo[i][posActor][1],
    ActorInfo[i][posActor][2], ActorInfo[i][posActor][3]);
    SetActorVirtualWorld(ActorInfo[i][actorId], ActorInfo[i][vwActor]);
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
    SetTimerEx("cStartActor", 1500, false, "i", qtdActors);
    return 1;
}

forward cStartActor(i);
public cStartActor(i) { // public para startar o actor que foi criado
    startActor(qtdActors);
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
    ActorCreate[playerid][creatingActor] = false;
    ActorCreate[playerid][actorName] = 0;
    ActorCreate[playerid][cActorPos][0] = 0; 
    ActorCreate[playerid][cActorPos][1] = 0; 
    ActorCreate[playerid][cActorPos][2] = 0; 
    ActorCreate[playerid][cActorPos][3] = 0; 
    ActorCreate[playerid][cActorSkin] = 0;
    ActorCreate[playerid][cActorVw] = 0;
    ActorCreate[playerid][cActorInt] = 0;
    ActorCreate[playerid][cActorStep] = 0;
    return 1;
}

stock finishModifyActor(playerid) { // finalizar todas variáveis de modificação
    ActorModify[playerid][isModActor] = false;
    ActorModify[playerid][modActorID] = 0;
    ActorModify[playerid][changeActName] = false;
    ActorModify[playerid][changeActSkin] = false;
    /*
    bool:changeActName,
    bool:changeActSkin,
    bool:changeActVw,
    bool:changeActInt
    */
    return 1;
}

stock loadActors() { // Carregar todos atores do DB
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query), "SELECT * FROM actors");
    mysql_tquery(ConexaoSQL, query, "OnLoadActors");
    return 1;
}

stock loadActorId(i) { // Carregar ator pelo ID
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
