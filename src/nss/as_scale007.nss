#include "gs_inc_subrace"
int StartingConditional()
{
    object oSpeaker = OBJECT_SELF;
    int nSubRace = gsSUGetSubRace(oSpeaker);
    return nSubRace == GS_SU_HUMAN_ORI || nSubRace == GS_SU_HUMAN_ORI_CIPHER;
}
