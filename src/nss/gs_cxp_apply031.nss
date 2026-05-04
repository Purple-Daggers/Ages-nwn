#include "gs_inc_craft"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        gsCRResetSkillRank(oTarget);
        AssignCommand(oTarget, ActionStartConversation(oTarget, "gs_cr_recipe", TRUE, FALSE));
    }
}
