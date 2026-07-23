#include "gs_inc_subrace"
int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nSubRace = gsSUGetSubRace(oSpeaker);
    return gsSUGetIsVeydran(nSubRace) || gsSUGetHasCatModel(nSubRace) || gsSUGetHasTigerFace(nSubRace);
}
