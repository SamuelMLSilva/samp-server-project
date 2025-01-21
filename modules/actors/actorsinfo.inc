/*
    * Criar CMD de criar actor
        1. cmd /cactor
        2. dialog criar actor na posição atual do player ou informar as coords manualmente
        3. criar log de criação    
    * Criar função de load, start, stop e actor
    * Criar CMD /mactor -> modificar actor 
*/


enum infoActorBank {
    actorBankId,
    actorBankSkin,
    nameActorBank[18],
    Float:posActorBank[4],
    intActorBank,
    vwActorBank,
    bool:freeActorBank
};