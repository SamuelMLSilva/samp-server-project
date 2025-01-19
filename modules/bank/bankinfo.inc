#define         MAX_BANK_TXD            18
#define         BTN_BANK_SACAR          8
#define         BTN_BANK_DEPOSITAR      9
#define         BTN_BANK_TRANSFERIR     10
#define         BTN_BANK_PIXI           11

new bool:bankMenu[MAX_PLAYERS];
new PlayerText:txdBank[MAX_PLAYERS][MAX_BANK_TXD];