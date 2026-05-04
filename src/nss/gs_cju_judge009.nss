#include "gs_inc_common"
#include "gs_inc_justice"

int StartingConditional()
{
    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);

    if (gsJUGetFirstTrial(oJustice)) return TRUE;

    return FALSE;
}
