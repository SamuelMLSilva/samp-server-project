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
#include "../modulos/player/playerinfo.inc"
#include "../modulos/server/db.inc"
#include "../modulos/server/serverinfo.inc"
#include "../modulos/server/dialogs.inc"
#include "../modulos/server/logs.inc"
#include "../modulos/server/cores.inc"
#include "../modulos/admin/admininfo.inc"
#include "../modulos/login/logininfo.inc"
#include "../modulos/locations/locationsinfo.inc"

/* MODULOS ----------------------------------*/
#include "../modulos/admin/comandos.pwn"
#include "../modulos/player/player.pwn"
#include "../modulos/server/logs.pwn"

#include "../modulos/locations/locations.pwn"
#include "../modulos/login/login.pwn"

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
    
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
    (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

/* AUTOCOMPLETE -----------------------------*/
//#snippet cmd CMD:cmd_name(playerid, const params[]) {\n\treturn 1;\n}
//#snippet cdialog if(dialogid == DIALOG_NAME) {\n\treturn 1;\n}
//#snippet scm SendClientMessage(playerid, colour, const format[])
