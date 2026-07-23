#include "gs_inc_subrace"
int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    return GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || gsSUGetHasCatTail(gsSUGetSubRace(oSpeaker));
}
