#include "as_inc_target"
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
            if(GetIsObjectValid(oTarget) && GetIsPC(oTarget)){
                SetLocalObject(oPlayer, "AS_REP_TARGET", oTarget);
                ActionStartConversation(oPlayer, "as_crep_view", TRUE, FALSE);
            }
        default:
            SendMessageToPC(oPlayer, "Invalid targeting mode bug.");
        break;
    }
}
