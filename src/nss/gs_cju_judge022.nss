#include "gs_inc_common"
#include "gs_inc_justice"

int StartingConditional()
{
    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);

    gsJUCloseTrial(oJustice, GetLocalInt(OBJECT_SELF, "GS_JU_TRIAL"));

    return TRUE;
}
