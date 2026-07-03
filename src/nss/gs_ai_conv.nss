#include "gs_inc_combat"
#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_CONVERSATION));

    object oSpeaker = GetLastSpeaker();
    object oTarget  = OBJECT_INVALID;

    SetListening(OBJECT_SELF, FALSE);

    switch (GetListenPatternNumber())
    {
    case -1:
        //DMFI
        if (GetIsPC(oSpeaker) &&(GetLocalInt(GetModule(), "dmfi_AllMute") || GetLocalInt(OBJECT_SELF, "dmfi_Mute")))
        {
            SendMessageToAllDMs(GetName(oSpeaker) + " is trying to speak to a muted NPC, " + GetName(OBJECT_SELF) + ", in area " + GetName(GetArea(OBJECT_SELF)));
            SendMessageToPC(oSpeaker, "This NPC is muted. A DM will be here shortly.");
            return;
        }
        //DMFI END

        if (! gsCBGetHasAttackTarget() &&
            gsCBGetIsPerceived(oSpeaker))
        {
            ClearAllActions(TRUE);
            BeginConversation();
        }
        break;

    case 10000: //GS_AI_ATTACK_TARGET
        if (! (GetLevelByClass(CLASS_TYPE_COMMONER) ||
               gsCBGetHasAttackTarget()))
        {
            gsCBDetermineAttackTarget(oSpeaker);
        }
        break;

    case 10001: //GS_AI_PVP
        oTarget = GetLocalObject(oSpeaker, "GS_PVP_TARGET");

        if (GetIsObjectValid(oTarget) &&
            ! GetIsEnemy(oTarget))
        {
            gsCBDetermineCombatRound(oSpeaker);
        }
        break;

    case 10002: //GS_AI_THEFT
        if (GetIsSkillSuccessful(OBJECT_SELF, SKILL_SPOT, GetSkillRank(SKILL_PICK_POCKET, oSpeaker) + d20()))
        {
            gsCBDetermineCombatRound(oSpeaker);
        }
        break;

    case 10003: //GS_AI_REQUEST_REINFORCEMENT
        if (! GetIsEnemy(oSpeaker)) gsCBSetReinforcementRequestedBy(oSpeaker);
        break;
    }

    SetListening(OBJECT_SELF, TRUE);
}
