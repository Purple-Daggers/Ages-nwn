#include "gs_inc_arena"
#include "gs_inc_text"
#include "gs_inc_time"

void main()
{
    object oParticipant                 = GetClickingObject();
    if (! GetIsPC(oParticipant))    return;
    string sTag                         = GetTag(OBJECT_SELF);
    sTag                                = GetStringLeft(sTag, GetStringLength(sTag) - 6);
    object oArena                       = GetObjectByTag(sTag);
    if (! GetIsObjectValid(oArena)) return;
    int nPlacement                      = gsAEGetContest(oArena);
    struct gsAEParticipant stDefender   = gsAEGetParticipant(oArena, nPlacement);
    struct gsAEParticipant stChallenger = gsAEGetParticipant(oArena, nPlacement + 1);

    if (oParticipant == stDefender.oCreature ||
        oParticipant == stChallenger.oCreature)
    {
        switch (gsAEGetContestState(oArena))
        {
        case GS_AE_CONTEST_STATE_IDLE:
            break;

        case GS_AE_CONTEST_STATE_ACTIVATING:
        case GS_AE_CONTEST_STATE_ACTIVE:
            FloatingTextStringOnCreature(GS_T_16777504, oParticipant, FALSE);
            return;

        case GS_AE_CONTEST_STATE_DEACTIVATING:
            FloatingTextStringOnCreature(GS_T_16777505, oParticipant, FALSE);
            return;
        }

        object oTarget = OBJECT_INVALID;

        if (oParticipant == stDefender.oCreature)
        {
            oTarget = GetWaypointByTag(sTag + "_DEFENDER_IN");
        }
        else
        {
            oTarget = GetWaypointByTag(sTag + "_CHALLENGER_IN");
            nPlacement++;
        }

        gsAESetParticipantPresence(oArena, nPlacement);
        AssignCommand(oParticipant, ClearAllActions(TRUE));
        AssignCommand(oParticipant, JumpToObject(oTarget));
    }
    else
    {
        FloatingTextStringOnCreature(GS_T_16777506, oParticipant, FALSE);
    }
}
