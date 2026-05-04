#include "gs_inc_subrace"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        AssignCommand(oTarget, ActionStartConversation(oTarget, "gs_su_select", TRUE, FALSE));
    }
}
