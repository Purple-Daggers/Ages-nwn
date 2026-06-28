#include "gs_inc_common"
#include "gs_inc_istate"
#include "gs_inc_shop"
#include "gs_inc_text"
#include "gs_inc_theft"
#include "gs_inc_time"

const int GS_TIMEOUT = 300; //TIME UPDATE: 5 minutes

void main()
{
    object oAcquiredBy   = GetModuleItemAcquiredBy();
    object oAcquiredFrom = GetModuleItemAcquiredFrom();
    object oAcquired     = GetModuleItemAcquired();
    string sTag          = GetTag(oAcquired);

    DeleteLocalInt(oAcquired, "GS_STORE");

    gsISInitializeItemState(oAcquired);

    //shop
    if (GetStringLeft(sTag, 6) == "GS_SH_")
    {
        oAcquiredFrom = GetLocalObject(oAcquired, "GS_SH_CONTAINER");

        if (GetIsDM(oAcquiredBy) ||
            gsSHGetIsVacant(oAcquiredFrom) ||
            gsSHGetIsOwner(oAcquiredFrom, oAcquiredBy))
        {
            gsSHExportItem(oAcquired, oAcquiredBy);
        }
        else
        {
            object oCopy = CopyItem(oAcquired, oAcquiredFrom, TRUE);

            if (GetIsObjectValid(oCopy))
            {
                DestroyObject(oAcquired);
                SetLocalObject(oAcquiredBy, "GS_SH_ITEM", oCopy);
                AssignCommand(oAcquiredFrom, ActionStartConversation(oAcquiredBy, "", TRUE, FALSE));
            }
        }
    }

    //stolen items
    if (GetStolenFlag(oAcquired))
    {
        object oStolenFrom = gsTHGetStolenFrom(oAcquired);

        if (! GetIsObjectValid(oStolenFrom))
        {
            if (GetObjectType(oAcquiredFrom) == OBJECT_TYPE_CREATURE)
            {
                SendMessageToAllDMs(
                    gsCMReplaceString(
                        GS_T_16777436,
                        GetName(oAcquiredBy),
                        GetName(oAcquired),
                        GetName(oAcquiredFrom)));

                if (sTag == "GS_BLADEORB")
                {
                    SetActionMode(oAcquiredBy, ACTION_MODE_STEALTH, FALSE);
                    AssignCommand(oAcquiredBy, ClearAllActions(TRUE));

                    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                        EffectVisualEffect(VFX_IMP_DISEASE_S),
                                        oAcquiredBy);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                        EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1)),
                                        oAcquiredBy);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                        EffectAbilityDecrease(ABILITY_DEXTERITY, d6(1)),
                                        oAcquiredBy);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                        EffectAbilityDecrease(ABILITY_STRENGTH, d6(1)),
                                        oAcquiredBy);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        EffectLinkEffects(EffectLinkEffects(EffectCutsceneParalyze(),
                                                                            EffectVisualEffect(VFX_DUR_PARALYZED)),
                                                          EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)),
                                        oAcquiredBy,
                                        RoundsToSeconds(10));

                    DestroyObject(oAcquired);
                }
                else if (GetIsPC(oAcquiredFrom))
                {
                    int nTimestamp = gsTIGetActualTimestamp();
                    int nTimeout   = GetLocalInt(oAcquiredBy, "GS_TH_TIMEOUT");

                    if (nTimeout < nTimestamp)
                    {
                        nTimeout     = nTimestamp + gsTIGetGameTimestamp(GS_TIMEOUT);

                        gsTHSetStolenFrom(oAcquired, oAcquiredFrom);
                        SetLocalInt(oAcquiredBy, "GS_TH_TIMEOUT", nTimeout);
                    }
                    else
                    {
                        nTimeout     = gsTIGetRealTimestamp(nTimeout - nTimestamp);

                        FloatingTextStringOnCreature(
                            gsCMReplaceString(
                                GS_T_16777448,
                                IntToString(nTimeout / 60),
                                IntToString(nTimeout % 60)),
                            oAcquiredBy,
                            FALSE);

                        object oCopy = CopyItem(oAcquired, oAcquiredFrom, TRUE);

                        if (GetIsObjectValid(oCopy))
                        {
                            gsTHResetStolenItem(oCopy);
                            DestroyObject(oAcquired);
                        }
                    }
                }

                AssignCommand(oAcquiredBy, SpeakString("GS_AI_THEFT", TALKVOLUME_SILENT_TALK));
            }
        }
        else if (oAcquiredBy == oStolenFrom)
        {
            gsTHResetStolenItem(oAcquired);
        }
    }

    if (sTag == "GS_FX_gs_placeable181") //voidstone
    {
        if (! FortitudeSave(oAcquiredBy, 25))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH),
                                                  EffectDeath()),
                                oAcquiredBy);
            SendMessageToPC(oAcquiredBy, GS_T_16777418);
        }
        return;
    }
}
