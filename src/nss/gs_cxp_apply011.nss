#include "gs_inc_common"
#include "gs_inc_text"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    SendMessageToPC(oTarget, GS_T_16777333);
    SendMessageToAllDMs(gsCMReplaceString(GS_T_16777337, GetName(oTarget), GetName(OBJECT_SELF)));

    AdjustAlignment(oTarget, ALIGNMENT_CHAOTIC, 10);
}
