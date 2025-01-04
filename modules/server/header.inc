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
#include "../modules/admin/admininfo.inc"
#include "../modules/login/logininfo.inc"
#include "../modules/places/placesinfo.inc"
#include "../modules/server/messages.inc"

/* modules ----------------------------------*/
#include "../modules/admin/comandos.pwn"
#include "../modules/player/player.pwn"
#include "../modules/player/comandos.pwn"
#include "../modules/server/logs.pwn"
#include "../modules/places/places.pwn"
#include "../modules/login/login.pwn"

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
    
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
    (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

/* AUTOCOMPLETE -----------------------------*/
//#snippet cmd CMD:cmd_name(playerid, params[]) {\n\treturn 1;\n}
//#snippet cdialog if(dialogid == DIALOG_NAME) {\n\treturn 1;\n}
//#snippet scm SendClientMessage(playerid, colour, const format[])
