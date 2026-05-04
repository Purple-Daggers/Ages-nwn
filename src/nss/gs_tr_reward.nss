#include "gs_inc_xp"

void main()
{
    object oClicking = GetClickingObject();
    object oTarget   = GetTransitionTarget(OBJECT_SELF);

    if (GetIsPC(oClicking))
    {
        string sTag = GetTag(OBJECT_SELF);

        if (! GetLocalInt(oClicking, "GS_TR_" + sTag))
        {
            gsXPGiveExperience(oClicking, GetLocalInt(OBJECT_SELF, "GS_EXPERIENCE"));
            SetLocalInt(oClicking, "GS_TR_" + sTag, TRUE);
        }
    }

    if (GetIsObjectValid(oTarget))
    {
        int nObjectType = GetObjectType(oTarget);

        if (nObjectType == OBJECT_TYPE_DOOR ||
            nObjectType == OBJECT_TYPE_WAYPOINT)
        {
            AssignCommand(oClicking, ActionJumpToObject(oTarget, FALSE));
        }
    }
}
