#include "gs_inc_boss"
#include "gs_inc_chain"
#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_flag"
#include "gs_inc_forum"
#include "gs_inc_iprop"
#include "gs_inc_placeable"
#include "gs_inc_state"
#include "gs_inc_text"
#include "gs_inc_time"

void main()
{
    object oItem       = GetItemActivated();
    string sTag        = GetStringUpperCase(GetTag(oItem));

    //custom: item tag must have prefix 'I_' and script named like item tag must be provided
    if (GetStringLeft(sTag, 2) == "I_")
    {
        ExecuteScript(sTag, OBJECT_SELF);
    }

    object oActivator  = GetItemActivator();
    object oTarget     = GetItemActivatedTarget();
    location lLocation = GetItemActivatedTargetLocation();

    //chain
    if (sTag == "GS_CHAIN")
    {
        gsCHRemoveChain(oItem);
        gsCHApplyChain(oItem, oTarget);
        return;
    }

    //portal lens
    if (sTag == "GS_PO_LENS")
    {
        if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oActivator))
        {
            FloatingTextStringOnCreature(GS_T_16777430, oActivator, FALSE);
        }
        else if (! GetIsInCombat(oActivator))
        {
            AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_po_use", TRUE, FALSE));
            DestroyObject(oItem);
        }
        return;
    }

    //firewood
    if (sTag == "GS_FIREWOOD")
    {
        CreateObject(OBJECT_TYPE_PLACEABLE, "gs_placeable177", lLocation);
        return;
    }

    //craft
    if (sTag == "GS_CR_RECIPE")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_cr_recipe", TRUE, FALSE));
        return;
    }

    //worship
    if (sTag == "GS_WO_SELECT")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_wo_select", TRUE, FALSE));
        return;
    }

    //write message
    if (sTag == "GS_ME_WRITE")
    {
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oTarget, SpeakString(GS_T_16777234));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_write2", TRUE, FALSE));
        return;
    }

    //food
    if (GetStringLeft(sTag, 10) == "GS_ST_FOOD")
    {
        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 11));
        AssignCommand(oTarget, SpeakString(GS_T_16777235));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_FOOD, fValue));
        return;
    }

    //water
    if (GetStringLeft(sTag, 11) == "GS_ST_WATER")
    {
        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 12));
        AssignCommand(oTarget, SpeakString(GS_T_16777236));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_WATER, fValue));
        return;
    }

    //message
    if (GetStringLeft(sTag, 6) == "GS_ME_")
    {
        if (GetIsObjectValid(oTarget))
        {
            //post message
            if (GetStringLeft(GetTag(oTarget), 8) == "GS_FORUM")
            {
                if (gsFOPostMessage(GetStringRight(sTag, 16), oActivator, oTarget))
                {
                    DestroyObject(oItem);
                }
                return;
            }

            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_CREATURE:

                //read message public
                if (oTarget == oActivator)
                {
                    SetLocalObject(oActivator, "GS_TARGET", oItem);
                    AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
                    AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", FALSE, FALSE));
                }
                break;

            case OBJECT_TYPE_ITEM:

                //copy message
                if (GetTag(oTarget) == "GS_ME_WRITE" &&
                    GetIsObjectValid(CopyItem(oItem, oActivator)))
                {
                    DestroyObject(oTarget);
                }
                break;
            }
            return;
        }

        //read message private
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", TRUE, FALSE));
        return;
    }

    //item property
    if (GetStringLeft(sTag, 6) == "GS_IP_")
    {
        if (GetIsObjectValid(oTarget) &&
            GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {
            //GS_IP_{type}_{subtype}_{cost}_{param}_{duration}
            int nType = StringToInt(GetSubString(sTag, 6, 3));

            if (gsIPGetIsValid(oTarget, nType))
            {
                int nSubType            = StringToInt(GetSubString(sTag, 10, 3));
                int nCost               = StringToInt(GetSubString(sTag, 14, 3));
                int nParam              = StringToInt(GetSubString(sTag, 18, 3));
                float fDuration         = HoursToSeconds(StringToInt(GetSubString(sTag, 22, 3)));
                itemproperty ipProperty = gsIPGetItemProperty(nType, nSubType, nCost, nParam);

                switch (nType)
                {
                case ITEM_PROPERTY_DAMAGE_BONUS:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    gsIPAddDamageBonus(oTarget, ipProperty, fDuration);
                    break;

                default:
                    gsIPAddItemProperty(oTarget, ipProperty, fDuration, fDuration == 0.0);
                    break;
                }

                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectVisualEffect(VFX_IMP_HOLY_AID),
                                    oActivator);
            }
            else
            {
                SendMessageToPC(oActivator, GS_T_16777237);
            }
        }

        return;
    }

    if (! (GetIsDM(oActivator) ||
           GetIsDMPossessed(oActivator)))
        return;

    //soulcatcher
    if (GetResRef(oItem) == "gs_item018" &&
        GetStringLeft(sTag, 6) == "GS_BA_")
    {
        if (GetIsObjectValid(oTarget) &&
            oTarget != oActivator)
        {
            if (GetIsPC(oTarget))
            {
                object oObject = CopyObject(oItem,
                                            GetLocation(oActivator),
                                            oActivator,
                                            "GS_BA_" + GetPCPublicCDKey(oTarget, TRUE));
                if (GetIsObjectValid(oObject))
                {
                    SetName(oObject, GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + ")");
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DEMON_HAND), oTarget);
                    DestroyObject(oItem);
                }
            }
        }
        else
        {
            if (sTag == "GS_BA_VOID")
            {
                SendMessageToPC(oActivator, GS_T_16777424);
            }
            else
            {
                SendMessageToPC(
                    oActivator,
                    gsCMReplaceString(
                        GS_T_16777423,
                        GetSubString(sTag, 6, GetStringLength(sTag) - 6)));
            }
        }
        return;
    }

    if (oActivator == oTarget) return;

    //bonus/punishment
    if (sTag == "GS_XP_APPLY")
    {
        if (GetIsObjectValid(oTarget) && GetIsPC(oTarget))
        {
            SetLocalObject(oActivator, "GS_TARGET", oTarget);
            AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_xp_apply", TRUE, FALSE));
        }
        return;
    }

    //value
    if (sTag == "GS_DM_VALUE")
    {
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
            SendMessageToPC(
                oActivator,
                gsCMReplaceString(
                    GS_T_16777476,
                    GetName(oTarget),
                    IntToString(gsCMGetItemValue(oTarget))));
        return;
    }

    //spawn encounter
    if (sTag == "GS_EN_CREATE")
    {
        SetLocalLocation(oActivator, "GS_TARGET", lLocation);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_create", TRUE, FALSE));
        return;
    }

    //edit dynamic encounter
    if (sTag == "GS_EN_EDIT")
    {
        if (GetIsObjectValid(oTarget)) gsENSetCreature(oTarget, 5, GetArea(oTarget));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_edit", TRUE, FALSE));
        return;
    }

    //edit boss encounter
    if (sTag == "GS_BO_EDIT")
    {
        if (GetIsObjectValid(oTarget)) gsBOSetCreature(oTarget, GetArea(oTarget));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_bo_edit", TRUE, FALSE));
        return;
    }

    //edit permanent placeables
    if (sTag == "GS_PL_EDIT")
    {
        if (! GetIsObjectValid(oTarget))
        {
            oTarget = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);

            if (GetIsObjectValid(oTarget) &&
                GetDistanceBetweenLocations(lLocation, GetLocation(oTarget)) > 1.0)
            {
                oTarget = OBJECT_INVALID;
            }
        }

        if (GetIsObjectValid(oTarget)) gsPLAddPlaceable(oTarget);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_pl_edit", TRUE, FALSE));
        return;
    }
}
