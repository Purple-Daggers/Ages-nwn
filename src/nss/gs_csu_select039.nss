#include "gs_inc_subrace"

int StartingConditional()
{
    SetCustomToken(100, gsSUGetNameBySubRace(GetLocalInt(GetPCSpeaker(), "GS_SU_SELECTION")));

    return TRUE;
}
