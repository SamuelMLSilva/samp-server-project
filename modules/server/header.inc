/* BIBLIOTECAS ----------------------------------*/
#include <open.mp>
#include <a_mysql>
#include <izcmd>
#include <sscanf2>
#include <streamer>
#include <crashdetect>
#include <mSelection>
#include <zones>
#include <YSI_Coding\y_hooks>

/* CABEÇALHOS ----------------------------------*/
#include "../modules/player/playerinfo.inc"
#include "../modules/server/db.inc"
#include "../modules/server/serverinfo.inc"
#include "../modules/server/dialogs.inc"
#include "../modules/server/logs.inc"
#include "../modules/server/cores.inc"
#include "../modules/server/core.inc"
#include "../modules/admin/admininfo.inc"
#include "../modules/login/logininfo.inc"
#include "../modules/places/placesinfo.inc"
#include "../modules/server/messages.inc"
#include "../modules/bank/bankinfo.inc"
#include "../modules/actors/actorsinfo.inc"
#include "../modules/houses/houses.inc"

/* modules ----------------------------------*/
#include "../modules/admin/comandos.pwn"
#include "../modules/player/player.pwn"
#include "../modules/player/comandos.pwn"
#include "../modules/server/logs.pwn"
#include "../modules/server/core.pwn"
#include "../modules/places/places.pwn"
#include "../modules/login/login.pwn"
#include "../modules/bank/bank.pwn"
#include "../modules/actors/actors.pwn"
#include "../modules/houses/houses.pwn"

/* AUTOCOMPLETE -----------------------------*/
//#snippet cmd CMD:cmd_name(playerid, params[]) {\n\treturn 1;\n}
//#snippet cdialog if(dialogid == DIALOG_NAME) {\n\tif(response) {\n\t\treturn 1;\n\t} else {\n\t\treturn 1;\n\t}\n}
//#snippet scm SendClientMessage(playerid, -1, );
//#snippet verifyadmin if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= L_...) {\n\treturn 1;\n} else {\n\treturn 0;\n}
//#snippet fstr new str[128]\nformat(str, sizeof(str),"",);\nSendClientMessage(playerid, -1, str);
//#snippet fstring new string[128];\nformat(string, sizeof(string),"",);\nSendClientMessage(playerid, -1, string);
//#snippet fdebug new debug[128]\nformat(debug, sizeof(debug),"",);\nSendClientMessage(playerid, -1, debug);
//#snippet ploading printf("-----------------------------------------");\nprintf("-- EXEMPLO ------------------------------");
