#include "gs_inc_common"
#include "gs_inc_justice"

int StartingConditional()
{
    if (! GetIsDM(GetPCSpeaker()))       return FALSE;

    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);

    if (gsJUGetFirstJudgement(oJustice)) return TRUE;

    return FALSE;
}
