#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_execute"
#include "gs_inc_flag"
#include "gs_inc_istate"
#include "gs_inc_sequencer"
#include "gs_inc_spell"
#include "gs_inc_theft"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "gs_inc_xp"

void gsCombat()
{
    //get offense target
    object oTarget = GetAttemptedAttackTarget();

    if (! GetIsObjectValid(oTarget) &&
        gsSPGetSpellCallback() &&
        gsSPGetLastSpellHarmful())
    {
        oTarget = gsSPGetLastSpellTarget();
    }

    if (GetIsObjectValid(oTarget))
    {
        if (GetIsPC(oTarget) &&
            oTarget != OBJECT_SELF &&
            ! (GetIsDM(oTarget) || GetIsDMPossessed(oTarget)))
        {
            SetPCDislike(oTarget, OBJECT_SELF);

            if (! GetIsObjectValid(GetLocalObject(oTarget, "GS_PVP_TARGET")))
            {
                if (gsTHGetHasItemStolenFrom(oTarget, OBJECT_SELF) ||
                    GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "GS_PEACEKEEPER_BADGE")))
                {
                    SetLocalObject(oTarget, "GS_PVP_TARGET", OBJECT_SELF);
                    AssignCommand(oTarget, SpeakString("GS_AI_PVP", TALKVOLUME_SILENT_TALK));
                }
                else
                {
                    SetLocalObject(OBJECT_SELF, "GS_PVP_TARGET", oTarget);
                    SpeakString("GS_AI_PVP", TALKVOLUME_SILENT_TALK);
                }
            }
        }

        //corrupt equipment
        gsISCorruptEquipment();
    }
    else if (! GetIsInCombat() &&
             GetIsObjectValid(GetLocalObject(OBJECT_SELF, "GS_PVP_TARGET")))
    {
        DelayCommand(4.0, DeleteLocalObject(OBJECT_SELF, "GS_PVP_TARGET"));
    }
}
//----------------------------------------------------------------
void main()
{
    //force time update
    SetCalendar(GetCalendarYear(),
                GetCalendarMonth(),
                GetCalendarDay());
    SetTime(GetTimeHour(),
            GetTimeMinute(),
            GetTimeSecond(),
            GetTimeMillisecond());

    object oPC          = OBJECT_INVALID;
    object oArea        = OBJECT_INVALID;
    object oTarget      = OBJECT_INVALID;
    location lLocation1;
    location lLocation2;
    vector vPosition1;
    vector vPosition2;
    int nPreviousDay    = GetLocalInt(OBJECT_SELF, "GS_DAY");
    int nCurrentDay     = GetCalendarDay();
    int nPreviousHour   = GetLocalInt(OBJECT_SELF, "GS_HOUR");
    int nCurrentHour    = GetTimeHour();
    int nTimestamp      = gsTIGetActualTimestamp();
    int nRestartTimeout = GetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");
    int nTickTimeout = GetLocalInt(OBJECT_SELF, "GS_TICK_TIMEOUT");
    int nNth            = 0;

    //reboot
    if (nRestartTimeout &&
        nTimestamp >= nRestartTimeout)
    {
        DeleteLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");
        gsCMRebootServer();
    }

    //per day
    if (nPreviousDay != nCurrentDay)
    {
        //process deity presence
        gsWOProcessPresence();

        SetLocalInt(OBJECT_SELF, "GS_DAY", nCurrentDay);
    }

    //per hour
    //if (nPreviousHour != nCurrentHour)

    //TIME UPDATE: 20 minutes (every 6.6 minutes real time)
    if (nTimestamp >= nTickTimeout)
    {
        SetLocalInt(OBJECT_SELF, "GS_TICK_TIMEOUT", nTimestamp + 1200); //TIME UPDATE: 20 minutes (every 6.6 minutes real time)
        string sDeity = "";

        //process deity power
        gsWOProcessPower();

        oPC           = GetFirstPC();

        while (GetIsObjectValid(oPC))
        {
            if (! GetIsDM(oPC) &&
                GetLocalInt(oPC, "GS_ENABLED") &&
                ! gsFLGetAreaFlag("OVERRIDE_STATE", oPC))
            {
                if (GetLocalInt(oPC, "GS_ACTIVE"))
                {
                    //experience bonus
                    if (! gsFLGetAreaFlag("OVERRIDE_DEATH", oPC))
                        gsXPApply(oPC, gsPCGetRolePlay(oPC));

                    DeleteLocalInt(oPC, "GS_ACTIVE");
                }
                else
                {
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
                }

                //state
                AssignCommand(oPC, gsSTProcessState());

                //deity information
                sDeity = GetDeity(oPC);

                if (gsWOGetDeityByName(sDeity) != GS_WO_NONE)
                {
                    SendMessageToPC(
                        oPC,
                        gsCMReplaceString(
                            GS_T_16777453,
                            sDeity,
                            IntToString(gsWOGetPresence(sDeity)),
                            IntToString(gsWOGetPower(sDeity))));
                }
            }

            oPC = GetNextPC();
        }

        //clean area
        int nCount = gsARGetRegisteredAreaCount();
        int nNth   = 1;

        for (; nNth <= nCount; nNth++)
        {
            oArea = gsARGetRegisteredArea(nNth);
            gsSEAdd("gs_run_cleanarea", oArea);
        }

        //TIME UPDATE: gsEXExecuteHour is going to be per tick instead of per hour.
        SetCampaignInt("GS_SYSTEM", "TIMESTAMP", nTimestamp);
        SetLocalInt(OBJECT_SELF, "GS_HOUR", nCurrentHour);

        gsEXExecuteHour();
    }

    //set timestamp
    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", nTimestamp);

    //per round
    oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        oArea = GetArea(oPC);

        if (GetIsObjectValid(oArea) &&
            GetLocalInt(oArea, "GS_ENABLED"))
        {
            oArea = GetArea(oPC);

            if (GetLocalInt(oArea, "GS_TIMESTAMP") != nTimestamp)
            {
                //ambience
                gsSEAdd("gs_run_ambience", oArea);

                //timestamp
                SetLocalInt(oArea, "GS_TIMESTAMP", nTimestamp);
            }

            if (! (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
            {
                //activity
                lLocation1 = GetLocation(oPC);
                lLocation2 = GetLocalLocation(oPC, "GS_LOCATION");
                vPosition1 = GetPositionFromLocation(lLocation1);
                vPosition2 = GetPositionFromLocation(lLocation2);;

                if (vPosition1.x != vPosition2.x ||
                    vPosition1.y != vPosition2.y)
                {
                    SetLocalLocation(oPC, "GS_LOCATION", lLocation1);
                    SetLocalInt(oPC, "GS_ACTIVE", TRUE);
                }

                //state animation
                AssignCommand(oPC, gsSTPlayAnimation());

                //combat
                if (! gsFLGetAreaFlag("PVP", oPC)) AssignCommand(oPC, gsCombat());

                gsSPResetSpellCallback(oPC);
            }
        }

        oPC = GetNextPC();
    }

    gsEXExecuteRound();
}
