#define     VALUE_DIALOG_PLAYER     0
#define     VALUE_DIALOG_ADMIN      1000

/* DIALOGS PLAYERS -----------------------------------------*/
#define 	DIALOG_START			(1 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_LOGIN 		(2 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_NICK 		(3 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_PASS 		(4 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_CONF_PASS 	(5 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_EMAIL 		(6 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_REG_GEN	 		(7 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_LOG_LOGIN		(8 + VALUE_DIALOG_PLAYER)
#define 	DIALOG_LOG_PASS			(9 + VALUE_DIALOG_PLAYER)

/* DIALOGS ADMINS -----------------------------------------*/
// Dialogs sistema places -> modules/places/places.pwn
#define 	DIALOG_CONF_LOCATION	(1 + VALUE_DIALOG_ADMIN)
#define 	DIALOG_LOC_TITLE		(2 + VALUE_DIALOG_ADMIN)
#define 	DIALOG_LOC_INTS			(3 + VALUE_DIALOG_ADMIN)
#define 	DIALOG_LOC_EXIT			(4 + VALUE_DIALOG_ADMIN)
#define     DIALOG_LOC_MODIFY       (5 + VALUE_DIALOG_ADMIN)
#define     DIALOG_LOC_MOD_PCIKUP   (6 + VALUE_DIALOG_ADMIN)
#define     DIALOG_LOC_MOD_TITLE    (7 + VALUE_DIALOG_ADMIN)
#define     DIALOG_LOC_MOD_DELETE   (8 + VALUE_DIALOG_ADMIN)
// Dialogs sistema actors -> modules/actors/actors.pwn
#define     DIALOG_ACT_QUESTION     (9 + VALUE_DIALOG_ADMIN)


#define 	DIALOG_DEBUG			10000
#define 	T_DEBUG					"{FFFFFF}Debug"