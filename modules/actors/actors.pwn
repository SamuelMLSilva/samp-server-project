#include <YSI_Coding\y_hooks>

/* HOOKS ----------------------------------------*/

hook OnGameModeInit() {
    loadActors();
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    finishCreateActor(playerid);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    return 1;
}

/* COMMANDS -------------------------------------*/

CMD:cactor(playerid, params[]) { // Criar um ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        if(IsPlayerInAnyVehicle(playerid)) return sendWarning(playerid, "Você não pode estar em um veículo para criar um ator!");
        creatingActor[playerid] = true;
        showDlgCreateAct(playerid);
        return 1;
    } else {
        return 0;
    }
}

CMD:cancelactor(playerid, params[]) { // Cancelar criação de ator
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_SUB_OWNER) {
        if(creatingActor[playerid] == true) {
            creatingActor[playerid] = false;
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

/* CALLBACKS ------------------------------------*/

forward OnLoadActors();
public OnLoadActors() {
    new lines = cache_num_rows();
    printf("Linhas %d",lines);
    for(new j = 0; j <= lines; j++){
        cache_get_value_int(j, "actorID", ActorInfo[j][actorId]);
        cache_get_value_int(j, "actorSkin", ActorInfo[j][actorSkin]);
        cache_get_value_name(j, "actorName", ActorInfo[j][nameActor], 18);
        cache_get_value_float(j, "actorX", ActorInfo[j][posActor][0]);
        cache_get_value_float(j, "actorY", ActorInfo[j][posActor][1]);
        cache_get_value_float(j, "actorZ", ActorInfo[j][posActor][2]);
        cache_get_value_float(j, "actorA", ActorInfo[j][posActor][3]);
        cache_get_value_int(j, "actorVw", ActorInfo[j][vwActor]);
        cache_get_value_int(j, "actorInt", ActorInfo[j][intActor]);
        cache_get_value_int(j, "actorFree", ActorInfo[j][freeActor]);
        /*printf("ID: %d | Skin: %d | Nome: %s | X: %f Y: %f Z: %f A: %f | Vw: %d | Int: %d | actorFree: %d",
        ActorInfo[j][actorId], ActorInfo[j][actorSkin], ActorInfo[j][nameActor], ActorInfo[j][posActor][0],
        ActorInfo[j][posActor][1], ActorInfo[j][posActor][2], ActorInfo[j][posActor][3], ActorInfo[j][vwActor],
        ActorInfo[j][intActor], ActorInfo[j][freeActor]);*/
        printf("Teste");
    }
    printf("Teste aqui");
    return 1;
}

/* FUNCTIONS ------------------------------------*/

stock loadActors() {
    new query[128];
    mysql_format(ConexaoSQL, query, sizeof(query),"SELECT * FROM `actors`");
    mysql_tquery(ConexaoSQL, query, "OnLoadActors");
    return 1;
}

stock showDlgCreateAct(playerid) { // Criar dialog inicial de criação do ator.
    ShowPlayerDialog(playerid, DIALOG_ACT_QUESTION, DIALOG_STYLE_MSGBOX, "{FFFFFF}Criação de ator",
        "Você deseja criar o ator na sua atual posição?\n\
        Ou deseja informar as coordenadas manualmente?", "Atual","Manual");
    return 1;
}

stock finishCreateActor(playerid) { // Finalizar variáveis criação de ator
    SendClientMessage(playerid, -1, "OK");
    return 1;
}