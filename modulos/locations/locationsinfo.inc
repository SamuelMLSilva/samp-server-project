#define 	MAX_LOCATIONS		250
#define 	AZUL_ESCURO 		0x0000FFff

new qLocations;

enum makeLocation {
	bool:cLocation,
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
	bool:finishLocation,
	bool:createExLocation
};

new LocationCreate[MAX_PLAYERS][makeLocation];

enum infoLocation {
	lID,
	lTtile[32],
	lCity[32],
	Float: lX,
	Float: lY,
	Float: lZ,
	lI,
	Float: liX,
	Float: liY,
	Float: liZ,
	Float: liA,
	Float: eX,
	Float: eY,
	Float: eZ,
	Float: eA,
	lVW,
	lLock,
	pLocation,
	pIdLocation,
	Text3D:lText,
	lPickup
};

new LocationInfo[MAX_LOCATIONS][infoLocation];

enum infosIntsLoc {
	intLocTitle[32],
	intLocId,
	Float:intLocPos[3]
};

new const intsInfosLoc[][infosIntsLoc] = {
	{"DP Los Santos", 		6, 	{246.66,	65.80,		1003.64}},
	{"DP Las Venturas", 	3, 	{288.47,	170.06,		1007.17}},
	{"DP San Fierro",		10, {246.06,	108.97,		1003.21}},
	{"Autoescola", 			3, 	{1494.85,	1306.47,	1093.29}},
	{"Agência de Empregos", 3, 	{-2031.11,	-115.82,	1035.17}},
	{"Lotérica", 			3, 	{830.60,	5.94,		1004.17}}
};