#include "gs_inc_arena"
#include "gs_inc_common"

void main()
{
    string sTag   = GetLocalString(OBJECT_SELF, "GS_ARENA");
    object oArena = gsCMGetNearestObject(sTag);

    gsAERetireParticipant(oArena, OBJECT_SELF);
}
