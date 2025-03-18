/*
    Infos da casa:
    ID, hPosX, hPosY, hPosZ, hPosA, hInt, hDono, hStatus, hMorador

    hInt        -> ID do interior de acordo com tabela configurada no banco de dados
    hStatus     -> Status da casa, comprada, à venda, interditada, etc.
    hMorador    -> Limite de moradores que a casa terá
*/

/*
    Tabelas sistema de casas
    houses            -> Onde ficará todas as casas cadastradas
    h_ints_houses     -> Para controlar os interiores disponíveis para casa
    h_doors_houses    -> Para controlar as portas das casas (para casa ter a disponibilidade de ter mais de uma porta)
    h_garages_houses  -> Para controlar as garagens das casas
*/


#define         MAX_HOUSES          100
#define         CASA_AVENDA         0
#define         CASA_COMPRADA       1

new qIntsHouses = 0;

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

enum intInfo {
    iIntId,
    iInt, 
    Float:iPos[4]
};

new InfoInt[MAX_HOUSES][intInfo];

enum createInt {
    bool:creatingInt,
    cIdInt,
    bool:bDoorPos,
    cDoorPos[4],
    bool:bBauPos,
    cBauPos[3],
    bool:bQtdMoradores,
    cQtdMoradores,
    bool:bKgBau,
    cKgBau
};

new IntCreate[MAX_HOUSES][createInt];