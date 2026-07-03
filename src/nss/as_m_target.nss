#include "as_inc_target"
#include "as_inc_rep"
#include "as_inc_fxnui"

void main()
{
    object oPlayer = GetLastPlayerToSelectTarget();
    object oTarget = GetTargetingModeSelectedObject();
    vector vTarget = GetTargetingModeSelectedPosition();
    int nTargetingMode = GetLocalInt(oPlayer, "AS_TARGET_MODE_ID");
    DeleteLocalInt(oPlayer, "AS_TARGET_MODE_ID");

    if (!GetIsObjectValid(oTarget) && vTarget == Vector())
    {
        //Player exit targeting mode
        return;
    }

    switch(nTargetingMode){
        case TARGETING_MODE_MOVE_FIXTURE:
            if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE){
                asFXSetObjectSelection(oPlayer, oTarget);
            }
        break;
        case TARGETING_MODE_REPUTATION_VIEW:
            if((GetIsDM(oPlayer) || GetIsDMPossessed(oPlayer)) && GetIsObjectValid(oTarget) && GetIsPC(oTarget)){
                SetLocalObject(oPlayer, "AS_REP_TARGET", oTarget);
                AssignCommand(oPlayer, ActionStartConversation(oPlayer, "as_crep_view", TRUE, FALSE));
            }
        break;
        case TARGETING_MODE_REPUTATION_GIVE:
            //Testing mode:
            /*if(GetIsDM(oPlayer) && GetIsObjectValid(oTarget)){
                int nChange = GetLocalInt(oPlayer, "AS_REPUTATION_CHANGE");
                string sFaction = GetName(oTarget);
                asRPAdjustReputation(oPlayer, sFaction, nChange);
                DeleteLocalInt(oPlayer, "AS_REPUTATION_CHANGE");
            }*/
            if(GetIsDMPossessed(oPlayer) && GetIsObjectValid(oTarget) && GetIsPC(oTarget)){
                int nChange = GetLocalInt(oPlayer, "AS_REPUTATION_CHANGE");
                string sFaction = GetName(oPlayer);
                object oTargetPlayer = oTarget;
                while(GetIsObjectValid(GetMaster(oTarget)))
                {
                    oTargetPlayer = GetMaster(oTarget);
                }
                asRPAdjustReputation(oTargetPlayer, sFaction, nChange);
                DeleteLocalInt(oPlayer, "AS_REPUTATION_CHANGE");
            }
        break;
        default:
            SendMessageToPC(oPlayer, "Invalid targeting mode bug.");
        break;
    }
}
