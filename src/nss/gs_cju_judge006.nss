#include "gs_inc_common"

int StartingConditional()
{
    if (! GetIsPC(GetPCSpeaker())) return FALSE;

    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);

    return GetIsObjectValid(oJustice);
}
