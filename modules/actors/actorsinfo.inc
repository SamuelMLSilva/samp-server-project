new bool:creatingActor[MAX_PLAYERS];

enum infoActor {
    actorId,
    actorSkin,
    nameActor[18],
    Float:posActor[4],
    intActor,
    vwActor,
    freeActor
};

new ActorInfo[MAX_ACTORS][infoActor];
