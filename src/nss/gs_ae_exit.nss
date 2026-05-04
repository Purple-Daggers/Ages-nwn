#include "gs_inc_arena"

void gsClose()
{
    PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
    DeleteLocalInt(OBJECT_SELF, "GS_STATE");
}
//----------------------------------------------------------------
void gsOpen()
{
    PlayAnimation(ANIMATION_PLACEABLE_OPEN);
    SetLocalInt(OBJECT_SELF, "GS_STATE", TRUE);
    DelayCommand(60.0, gsClose());
}
//----------------------------------------------------------------
void main()
{
    object oUser                        = GetLastUsedBy();

    if (! GetIsPC(oUser)) return;

    if (! GetLocalInt(OBJECT_SELF, "GS_STATE"))
    {
        AssignCommand(oUser, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
        DelayCommand(1.0, gsOpen());
        return;
    }

    object oTarget                      = OBJECT_INVALID;
    string sTag                         = GetTag(OBJECT_SELF);
    sTag                                = GetStringLeft(sTag, GetStringLength(sTag) - 5);
    object oArena                       = GetObjectByTag(sTag);
    int nPlacement                      = gsAEGetContest(oArena);
    struct gsAEParticipant stDefender   = gsAEGetParticipant(oArena, nPlacement);
    struct gsAEParticipant stChallenger = gsAEGetParticipant(oArena, nPlacement + 1);

    if (oUser == stDefender.oCreature)
    {
        oTarget = GetWaypointByTag(sTag + "_DEFENDER_OUT");
        gsAESetParticipantPresence(oArena, nPlacement, FALSE);
    }
    else if (oUser == stChallenger.oCreature)
    {
        oTarget = GetWaypointByTag(sTag + "_CHALLENGER_OUT");
        gsAESetParticipantPresence(oArena, nPlacement + 1, FALSE);
    }
    else
    {
        oTarget = GetWaypointByTag(sTag + "_CHALLENGER_OUT");
    }

    SetPlotFlag(oUser, FALSE);
    AssignCommand(oUser, ClearAllActions(TRUE));
    AssignCommand(oUser, JumpToObject(oTarget));
}
