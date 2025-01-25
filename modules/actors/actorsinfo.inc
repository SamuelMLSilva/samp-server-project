/* STEPS DE CRIAÇÃO ----------------------------*/
#define         STEP_ACT_POS            Float:1
#define         STEP_ACT_POS_X          Float:1.1
#define         STEP_ACT_POS_Y          Float:1.2
#define         STEP_ACT_POS_Z          Float:1.3
#define         STEP_ACT_POS_A          Float:1.4
#define         STEP_ACT_POS_ATUAL      Float:1.5
#define         STEP_ACT_INT            Float:2
#define         STEP_ACT_VW             Float:3
#define         STEP_ACT_NAME           Float:4
#define         STEP_ACT_SKIN           Float:5

new qtdActors = 0; // load de atores

/* VARIÁVEIS DE CRIAÇÃO ------------------------*/
enum createActor {
    bool:creatingActor,
    actorName[18],
    actorGender,
    Float:cActorPos[4],
    cActorSkin,
    cActorVw,
    cActorInt,
    Float:cActorStep
};

new ActorCreate[MAX_ACTORS][createActor];

/* VARIÁVEIS DE INFOS ------------------------*/

enum infoActor {
    actorId,
    actorSkin,
    nameActor[18],
    genderActor,
    Float:posActor[4],
    intActor,
    vwActor,
    freeActor,
    bool:actorOn
};

new ActorInfo[MAX_ACTORS][infoActor];

/* NOMES ALEATÓRIOS P/ ATORES ----------------*/

enum namesForActors {
    nForActors[18],
    sForActors
};

new const namesActors[][namesForActors] = {
    {"Samuel", 1},
    {"Gabriel", 1},
    {"Lucas", 1},
    {"João", 1},
    {"Mateus", 1},
    {"Rafael", 1},
    {"Caio", 1},
    {"Pedro", 1},
    {"Henrique", 1},
    {"Thiago", 1},
    {"Ana", 0},
    {"Maria", 0},
    {"Clara", 0},
    {"Beatriz", 0},
    {"Laura", 0},
    {"Sofia", 0},
    {"Julia", 0},
    {"Isabela", 0},
    {"Carolina", 0},
    {"Larissa", 0}
};

enum actorSkinMenu {
	skinMenuActor,
    genMenuActor
};

new const menuSkinActors[][actorSkinMenu] = { // Pickups do menu mSelection
    {227, 1}, {17, 1}, {147, 1}, {187, 1}, {141, 0}, {150, 0}, {148, 0}, {9, 0}
};

