
enum InfoPlayer {
	bool:pLogado,
	bool:pSpawn,
	pLogin[64],
	pNick[MAX_PLAYER_NAME],
	pPassword[64],
	pEmail[64],
	pGen,
	pCode[12],
	pMoney,
	pBankAccount,
	pNumberBankAccount,
	pMoneyBank,
	Float:pX,
	Float:pY,
	Float:pZ,
	Float:pA,
	pI,
	pVW,
	pLevel,
	pSkin,
	pAdmin
};

new PlayerInfo[MAX_PLAYERS][InfoPlayer];