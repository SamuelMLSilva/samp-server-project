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
	{"Teste de titulo!", 2, {-25.72,-187.82,1003.54}}
};