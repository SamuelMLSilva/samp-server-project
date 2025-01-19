#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid) {
    createTxdBank(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    finishBank(playerid);
    return 1;
}

hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
    if(bankMenu[playerid] == true) {
        for(new i = 1; i <= MAX_BANK_TXD-1; i++) {
            if(playertextid == txdBank[playerid][i]) {
                new str[128];
                format(str, sizeof(str),"%d", i);
                SendClientMessage(playerid, -1, str);
            }
        }
    }
    return 1;
}

/* COMMANDS ---------------------------------- */
CMD:banco(playerid, params[]) {
    if(bankMenu[playerid] == true) {
        hideTextBank(playerid);
        return 1;
    } else if(bankMenu[playerid] == false) {
        showTextBank(playerid);
        return 1;
    }   
    return 1;
}

/* FUNCTIONS --------------------------------- */
stock showTextBank(playerid) {
    for(new i = 1; i <= MAX_BANK_TXD-1; i++) {
        PlayerTextDrawShow(playerid, txdBank[playerid][i]);
    }
    bankMenu[playerid] = true;
    SelectTextDraw(playerid, COLOR_SERVER);
    return 1;
}

stock hideTextBank(playerid) {
    for(new i = 1; i <= MAX_BANK_TXD-1; i++) {
        PlayerTextDrawHide(playerid, txdBank[playerid][i]);
    }
    bankMenu[playerid] = false;
    CancelSelectTextDraw(playerid);
    return 1;
}

stock finishBank(playerid) {
    destroyTxdBank(playerid);
    CancelSelectTextDraw(playerid);
    bankMenu[playerid] = false;
    return 1;
}

stock createTxdBank(playerid) { // função criar textdraw banco
    txdBank[playerid][0] = CreatePlayerTextDraw(playerid, 0.000000, -2.000000, "loadsc0:loadsc0");
    PlayerTextDrawFont(playerid, txdBank[playerid][0], TEXT_DRAW_FONT:4);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][0], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][0], 648.500000, 457.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][0], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, txdBank[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][0], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][0], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][0], false);

    txdBank[playerid][1] = CreatePlayerTextDraw(playerid, 324.000000, 85.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][1], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][1], 0.600000, 31.500007);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][1], 298.500000, 353.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][1], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][1], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][1], 193); //1296911686
    PlayerTextDrawUseBox(playerid, txdBank[playerid][1], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][1], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][1], false);

    txdBank[playerid][2] = CreatePlayerTextDraw(playerid, 368.000000, 90.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][2], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][2], 0.600000, 30.350009);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][2], 298.500000, 254.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][2], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][2], 1296911686); //193
    PlayerTextDrawUseBox(playerid, txdBank[playerid][2], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][2], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][2], false);

    txdBank[playerid][3] = CreatePlayerTextDraw(playerid, 193.000000, 261.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][3], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][3], 0.600000, 2.000001);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][3], 298.500000, 80.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][3], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][3], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][3], 1296911686); // 135
    PlayerTextDrawUseBox(playerid, txdBank[playerid][3], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][3], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][3], false);

    txdBank[playerid][4] = CreatePlayerTextDraw(playerid, 193.000000, 289.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][4], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][4], 0.600000, 2.000001);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][4], 298.500000, 80.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][4], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][4], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][4], 1296911686); // 135
    PlayerTextDrawUseBox(playerid, txdBank[playerid][4], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][4], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][4], false);

    txdBank[playerid][5] = CreatePlayerTextDraw(playerid, 193.000000, 317.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][5], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][5], 0.600000, 2.000001);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][5], 298.500000, 80.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][5], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][5], 1296911686); // 135
    PlayerTextDrawUseBox(playerid, txdBank[playerid][5], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][5], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][5], false);

    txdBank[playerid][6] = CreatePlayerTextDraw(playerid, 193.000000, 345.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][6], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][6], 0.600000, 2.000001);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][6], 298.500000, 80.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][6], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][6], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][6], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][6], 1296911686); // 135
    PlayerTextDrawUseBox(playerid, txdBank[playerid][6], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][6], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][6], false);

    txdBank[playerid][7] = CreatePlayerTextDraw(playerid, 193.000000, 90.000000, "_");
    PlayerTextDrawFont(playerid, txdBank[playerid][7], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][7], 0.600000, 17.899988);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][7], 298.500000, 80.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][7], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][7], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][7], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][7], 1296911686); // 135
    PlayerTextDrawUseBox(playerid, txdBank[playerid][7], true);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][7], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][7], false);

    txdBank[playerid][8] = CreatePlayerTextDraw(playerid, 193.000000, 261.000000, "Sacar");
    PlayerTextDrawFont(playerid, txdBank[playerid][8], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][8], 0.283333, 1.750000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][8], 12.000000, 45.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][8], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][8], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][8], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][8], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][8], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][8], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][8], true);

    txdBank[playerid][9] = CreatePlayerTextDraw(playerid, 193.000000, 289.000000, "depositar");
    PlayerTextDrawFont(playerid, txdBank[playerid][9], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][9], 0.283333, 1.750000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][9], 12.000000, 70.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][9], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][9], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][9], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][9], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][9], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][9], true);

    txdBank[playerid][10] = CreatePlayerTextDraw(playerid, 193.000000, 317.000000, "transferir");
    PlayerTextDrawFont(playerid, txdBank[playerid][10], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][10], 0.283333, 1.750000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][10], 12.000000, 72.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][10], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][10], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][10], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][10], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][10], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][10], true);

    txdBank[playerid][11] = CreatePlayerTextDraw(playerid, 193.000000, 345.000000, "pixi");
    PlayerTextDrawFont(playerid, txdBank[playerid][11], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][11], 0.283333, 1.750000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][11], 12.000000, 25.500000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][11], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][11], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][11], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][11], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][11], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][11], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][11], true);

    txdBank[playerid][12] = CreatePlayerTextDraw(playerid, 168.000000, 146.000000, "ola,");
    PlayerTextDrawFont(playerid, txdBank[playerid][12], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][12], 0.325000, 1.200000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][12], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][12], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][12], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][12], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][12], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][12], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][12], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][12], false);

    txdBank[playerid][13] = CreatePlayerTextDraw(playerid, 155.000000, 156.000000, "samuelsamuelsamuel");
    PlayerTextDrawFont(playerid, txdBank[playerid][13], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][13], 0.204167, 1.900000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][13], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][13], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, txdBank[playerid][13], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][13], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][13], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][13], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][13], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][13], false);

    txdBank[playerid][14] = CreatePlayerTextDraw(playerid, 157.000000, 179.000000, "saldo");
    PlayerTextDrawFont(playerid, txdBank[playerid][14], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][14], 0.320833, 1.550000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][14], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][14], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, txdBank[playerid][14], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][14], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][14], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][14], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][14], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][14], false);

    txdBank[playerid][15] = CreatePlayerTextDraw(playerid, 154.000000, 193.000000, "$999.999.999");
    PlayerTextDrawFont(playerid, txdBank[playerid][15], TEXT_DRAW_FONT:3);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][15], 0.345833, 2.000000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][15], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][15], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][15], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, txdBank[playerid][15], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][15], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][15], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][15], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][15], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][15], false);

    txdBank[playerid][16] = CreatePlayerTextDraw(playerid, 192.000000, 224.000000, "ag - 1234");
    PlayerTextDrawFont(playerid, txdBank[playerid][16], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][16], 0.204167, 1.600000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][16], 585.500000, 96.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][16], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][16], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][16], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, txdBank[playerid][16], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][16], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][16], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][16], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][16], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][16], false);

    txdBank[playerid][17] = CreatePlayerTextDraw(playerid, 158.000000, 238.000000, "cc - 12345678-9");
    PlayerTextDrawFont(playerid, txdBank[playerid][17], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, txdBank[playerid][17], 0.199999, 1.400000);
    PlayerTextDrawTextSize(playerid, txdBank[playerid][17], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdBank[playerid][17], 0);
    PlayerTextDrawSetShadow(playerid, txdBank[playerid][17], 0);
    PlayerTextDrawAlignment(playerid, txdBank[playerid][17], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, txdBank[playerid][17], -1);
    PlayerTextDrawBackgroundColour(playerid, txdBank[playerid][17], 255);
    PlayerTextDrawBoxColour(playerid, txdBank[playerid][17], 50);
    PlayerTextDrawUseBox(playerid, txdBank[playerid][17], false);
    PlayerTextDrawSetProportional(playerid, txdBank[playerid][17], true);
    PlayerTextDrawSetSelectable(playerid, txdBank[playerid][17], false);
    return 1;
}

stock destroyTxdBank(playerid) { // função destruir textdraw banco
    for(new i = 0; i <= MAX_BANK_TXD; i++) {
        PlayerTextDrawDestroy(playerid, txdBank[playerid][i]);
    }
    return 1;
}