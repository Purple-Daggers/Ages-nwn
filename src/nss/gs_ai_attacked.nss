#include "gs_inc_combat"
#include "gs_inc_event"


//DMFI
void SafeFaction(object oCurrent, object oAttacker)
{
        AssignCommand(oAttacker, ClearAllActions());
        AssignCommand(oCurrent, ClearAllActions());
        // * Note: waiting for Sophia to make SetStandardFactionReptuation to clear all personal reputation
        if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oAttacker) <= 10)
        {   SetLocalInt(oAttacker, "NW_G_Playerhasbeenbad", 10); // * Player bad
            SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oAttacker);
        }
        if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oAttacker) <= 10)
        {   SetLocalInt(oAttacker, "NW_G_Playerhasbeenbad", 10); // * Player bad
            SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oAttacker);
        }
        if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oAttacker) <= 10)
        {   SetLocalInt(oAttacker, "NW_G_Playerhasbeenbad", 10); // * Player bad
            SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oAttacker);
        }


}
//END DMFI

void main()
{
//DMFI
    if ((GetIsPC(GetLastAttacker()) && (GetLocalInt(GetModule(), "dmfi_safe_factions")==1)))
        {
        SafeFaction(OBJECT_SELF, GetLastAttacker());
        SpeakString("DM ALERT:  Default non-hostile faction member attacked.  Player: "+GetName(GetLastAttacker()), TALKVOLUME_SILENT_SHOUT);
        SendMessageToAllDMs("DMFI Safe Faction setting is currently set to ignore.");
        SendMessageToPC(GetLastAttacker(), "Script Fired.");
        return;
        }
//END DMFI

    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_PHYSICAL_ATTACKED));

    object oAttacker = GetLastAttacker();

    if (gsCBGetHasAttackTarget())
    {
        object oTarget = gsCBGetLastAttackTarget();

        if (oAttacker != oTarget &&
            (gsCBGetIsFollowing() ||
             GetDistanceToObject(oAttacker) <=
             GetDistanceToObject(oTarget) + 5.0))
        {
            gsCBDetermineCombatRound(oAttacker);
        }
    }
    else
    {
        gsCBDetermineCombatRound(oAttacker);
    }
}
