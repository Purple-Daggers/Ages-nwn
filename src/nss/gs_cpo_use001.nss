#include "gs_inc_portal"

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "GS_PO_SOURCE")) return FALSE;

    object oSpeaker = GetPCSpeaker();

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    return GetIsPC(oSpeaker) &&
           oSpeaker != OBJECT_SELF &&
           ! gsPOGetIsPortalActive(OBJECT_SELF, oSpeaker);
}
