enum infoPlayer {
    pName[MAX_PLAYER_NAME],
    pMoney,
    pMoneyBank,
    pLevel,
    pSkin,
    pAdmin,
    pVip,
    pEmail[64],
    Float:pX,
    Float:pY,
    Float:pZ, 
    Float:pA,
    pInt,
    pVW,
    uCode
};

new PlayerInfo[MAX_PLAYERS][infoPlayer];


enum infoHouse {
    hID,
    hDono[25],
    hPickup,
    hMoney,
    hValue,
    Float:hX,
    Float:hY,
    Float:hZ,
    Float:hA,
    Float:hIX,
    Float:hIY,
    Float:hIZ,
    Float:hIA,
    hInt,
    Text3D:h3DText,
    hComprada,
    hLock
};

new HouseInfo[MAX_HOUSES][infoHouse];

