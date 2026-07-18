#include "gs_inc_common"
#include "gs_inc_flag"
#include "gs_inc_pc"
#include "gs_inc_strack"
#include "gs_inc_text"
#include "gs_inc_theft"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "gs_inc_xp"

const string GS_TEMPLATE_CORPSE = "gs_placeable017";
const int GS_PENALTY_PER_LEVEL  = 25;

void gsDeath()
{
    //state
    gsSTSetInitialState();

    object oObject1 = GetLastKiller();

    if (GetObjectType(oObject1) == OBJECT_TYPE_CREATURE)
    {
        object oObject2 = OBJECT_INVALID;
        int nSuicide    = FALSE;
        int nPVP        = FALSE;

        //get master
        do
        {
            oObject2 = oObject1;
            oObject1 = GetMaster(oObject2);
        }
        while (GetIsObjectValid(oObject1));

        nSuicide        = oObject2 == OBJECT_SELF;
        nPVP            = GetIsPC(oObject2);

        if (! nSuicide)
        {
            if (! nPVP)
            {
                //deity resurrection
                if (gsWOGrantResurrection()) return;
            }

            //reward
            gsXPRewardKill();

            //stolen items
            gsTHReturnStolenItems(OBJECT_SELF, oObject2);

            //dm notification
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777437,
                    GetName(OBJECT_SELF),
                    GetName(oObject2)));
        }

        if (nSuicide || ! nPVP)
        {
            //apply penalty
            gsXPApplyDeathPenalty(OBJECT_SELF, GetHitDice(OBJECT_SELF) * GS_PENALTY_PER_LEVEL, TRUE);
        }
    }

    //teleport
    SetPlotFlag(OBJECT_SELF, TRUE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() + 10), OBJECT_SELF);
    ClearAllActions(TRUE);
    ActionJumpToObject(GetObjectByTag("GS_TARGET_DEATH"));
    ActionDoCommand(DelayCommand(6.0, SetPlotFlag(OBJECT_SELF, FALSE)));
    ActionDoCommand(SetCommandable(TRUE));
    SetCommandable(FALSE);

    //timeout
    SetCampaignInt("GS_DEATH_TIMESTAMP",
                   gsPCGetPlayerID(OBJECT_SELF),
                   gsTIGetActualTimestamp());

    //create corpse
    oObject1 = CreateObject(OBJECT_TYPE_PLACEABLE,
                            GS_TEMPLATE_CORPSE,
                            GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject1))
    {
        int nGold = GetGold();

        SetName(oObject1, GetName(OBJECT_SELF));
        SetLocalObject(oObject1, "GS_TARGET", OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, "GS_CORPSE", oObject1);

        if (nGold)
        {
            TakeGoldFromCreature(nGold, OBJECT_SELF, TRUE);
            SetLocalInt(oObject1, "GS_GOLD", nGold);
        }
    }
}
//----------------------------------------------------------------
void main()
{
    object oDied = GetLastPlayerDied();

    //spelltracker
    gsSPTReset(oDied);

    if (gsFLGetAreaFlag("PVP", oDied))
    {
        DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDied));
    }
    else
    {
        AssignCommand(oDied, gsDeath());
    }
}
