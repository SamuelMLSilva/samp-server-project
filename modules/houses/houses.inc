#define         MAX_HOUSES          100
#define         CASA_AVENDA         0
#define         CASA_COMPRADA       1

/*
    Infos da casa:
    ID, hPosX, hPosY, hPosZ, hPosA, hInt, hDono, hStatus, hMorador

    hInt        -> ID do interior de acordo com tabela configurada no banco de dados
    hStatus     -> Status da casa, comprada, à venda, interditada, etc.
    hMorador    -> Limite de moradores que a casa terá
*/

enum infoHouse {
    hId,
    hPos[3],
    hPosDoor[4],
    hInt,
    hDono[MAX_PLAYER_NAME],
    hStatus,
    hMoradores, // Moradores, se for -1 será o padrão definido na tabela ints_houses
    hBauKg      // Kilos do baú da casa, se for -1 será o padrão definido na tabela ints_houses
};

new HouseInfo[MAX_HOUSES][infoHouse];