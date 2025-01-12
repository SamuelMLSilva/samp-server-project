#define 	MAX_PLACES		250
#define 	AZUL_ESCURO 	0x0000FFff

#define		INT_AGENCIA		0
#define		INT_AUTOESCOLA	1
#define		INT_DP_LS		2
#define		INT_DP_LV		3
#define		INT_DP_SF		4
#define		INT_LOTERICA	5

new qPlaces;
new qInts = 5;
new tempIntLoc[MAX_PLAYERS];

enum modifyPlace {
	modifyIdPlace,
	bool:alterPlaceInt,
	modifyIdIntPlace,
	bool:alterPlacePickup,
	modifyIdPickupPlace,
	bool:alterPlaceExit,
	bool:alterPlaceTitle,
	modifyTitlePlace[64],
	bool:deletePlace
};

new PlaceModify[MAX_PLAYERS][modifyPlace];

enum makePlace {
	bool:cPlace,
	clID,
	clTitle[64],
	clPickup,
	Float:clX,
	Float:clY,
	Float:clZ,
	Float:elX,
	Float:elY,
	Float:elZ,
	Float:elA,
	bool:finishPlace,
	bool:createExPlace,
	bool:chooseLocInt,
	chooseIdInt
};

new PlaceCreate[MAX_PLAYERS][makePlace];

enum infoPlace {
	lID,
	lIntId,
	lTtile[32],
	lCity[32],
	Float: lX,
	Float: lY,
	Float: lZ,
	Float: eX,
	Float: eY,
	Float: eZ,
	Float: eA,
	lLock,
	pPlace,
	pIdPlace,
	Text3D:lText,
	lPickup,
};

new PlaceInfo[MAX_PLACES][infoPlace];

enum infosIntsLoc {
	idLocInt,
	intLocTitle[32],
	intLocId,
	Float:intLocPos[3],
	Float:doorIntLoc[3],
	Float:insideIntLoc[4]
};

new const intsInfosLoc[][infosIntsLoc] = {
	//{INT_(LOCAL),"Titulo do interior", idInterior, {coords interior}, {coords door intreior}, {coords inside interior}}
	{INT_AGENCIA, "Agência de Empregos", 3,
	{1494.85, 1306.47, 1093.29}, {1494.4056, 1303.5790, 1093.2891}, {1493.5084,	1304.7977,	1093.2891, 63.4601}},
	{INT_AUTOESCOLA, "Autoescola", 3,
	{-2031.11, -115.82, 1035.17}, {-2026.9260, -103.6026, 1035.1831}, {-2027.8103,-104.7037,1035.1719,133.1983}},
	{INT_DP_LS, "DP Los Santos", 6,
	{246.66, 65.80,	 1003.64}, {246.7354,62.3485,1003.6406}, {246.5727,63.6261,1003.6406,1.9128}},
	{INT_DP_LV, "DP Las Venturas", 3,
	{288.47, 170.06, 1007.17}, {288.7505,166.9930,1007.1719}, {288.5816,168.7016,1007.1719,359.5289}},
	{INT_DP_SF, "DP San Fierro", 10,
	{246.06, 108.97, 1003.21}, {246.3524,107.3023,1003.2188}, {246.3164,109.1408,1003.2188,359.6097}},
	{INT_LOTERICA, "Lotérica", 3,
	{830.60, 5.94, 1004.17}, {834.6495,7.4071,1004.1870}, {833.0562,7.5377,1004.1797,91.1583}}
};