#include "gs_inc_arena"

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "GS_AE_READONLY")) return FALSE;

    string sTag   = GetTag(OBJECT_SELF);
    sTag          = GetStringLeft(sTag, GetStringLength(sTag) - 5);
    object oArena = GetObjectByTag(sTag);

    return gsAEGetIsParticipant(oArena, GetPCSpeaker());
}
