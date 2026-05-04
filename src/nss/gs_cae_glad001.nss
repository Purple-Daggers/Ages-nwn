#include "gs_inc_arena"
#include "gs_inc_common"

int StartingConditional()
{
    string sTag   = GetLocalString(OBJECT_SELF, "GS_ARENA");
    object oArena = gsCMGetNearestObject(sTag);

    if (! GetIsObjectValid(oArena)) return FALSE;

    return ! gsAEGetIsParticipant(oArena, OBJECT_SELF);
}
