#include "gs_inc_arena"

void main()
{
    string sTag   = GetTag(OBJECT_SELF);
    sTag          = GetStringLeft(sTag, GetStringLength(sTag) - 5);
    object oArena = GetObjectByTag(sTag);

    gsAEAssignParticipant(oArena, GetPCSpeaker());
}
