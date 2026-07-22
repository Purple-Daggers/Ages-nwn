#include "mk_inc_generic"
#include "mk_inc_version"
#include "x2_inc_craft"
#include "mk_inc_craft"
#include "mk_inc_debug"
#include "mk_inc_states"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem = CIGetCurrentModItem(oPC);
    int nPart =  MK_GetCurrentModPart(oPC);

    int nState = MK_GenericDialog_GetState(TRUE);

//    MK_DEBUG_TRACE("mk_pre_critem: nState="+IntToString(nState)+", modMode="+IntToString(CIGetCurrentModMode(oPC)));

    switch (nState)
    {
    case MK_STATE_SELECTPART:
        switch (CIGetCurrentModMode(oPC))
        {
        case X2_CI_MODMODE_ARMOR:
        {
            int nPartQ = MK_GenericDialog_GetAction();
            if ((nPartQ>=0) && (nPartQ<MK_ITEM_APPR_ARMOR_NUM_MODELS))
            {
//                MK_DEBUG_TRACE("MK_SetCurrentModPart("+IntToString(nPartQ)+")");
                MK_SetCurrentModPart(oPC, nPartQ);
                nPart=nPartQ;
            }
            break;
        }
        case X2_CI_MODMODE_WEAPON:
        {
            int nPartQ = MK_GenericDialog_GetAction();
//            MK_DEBUG_TRACE("mk_pre_critem: nState="+IntToString(nState)
//                +", modMode="+IntToString(CIGetCurrentModMode(oPC))+", nPartQ="+IntToString(nPartQ));
            if ((nPartQ>=0) && (nPartQ<3))
            {
//                MK_DEBUG_TRACE("MK_SetCurrentModPart("+IntToString(nPartQ)+")");
                MK_SetCurrentModPart(oPC, nPartQ);
                nPart=nPartQ;
            }
            break;
        }
        }
        break;
    case MK_STATE_MODIFY:
        int nAction = MK_GenericDialog_GetAction();
        switch (nAction)
        {
        case 0:
            MK_IM_NextPart(oTarget, oPC, oItem, nPart);
            break;
        case 1:
            MK_IM_PrevPart(oTarget, oPC, oItem, nPart);
            break;
        case 2:
//        case 3:
            MK_IM_ClearPart(oTarget, oPC, oItem, nPart);
            break;
        case 4:
            MK_IM_OppositePart(oTarget, oPC, oItem, nPart);
            break;
        case 5:
        case 6:
            MK_IM_ToggleVisibility(oTarget, oPC, oItem);
            break;
        case 7:
            MK_IM_NextColor(oTarget, oPC, oItem, nPart);
            break;
        case 8:
            MK_IM_PrevColor(oTarget, oPC, oItem, nPart);
            break;
        }
        oItem = CIGetCurrentModItem(oPC);
        break;
    }

    MK_GenericDialog_SetState(MK_STATE_MODIFY);

    int nAppearance = 0;
    string sAppearance = "";

    int bDisableHideItems = FALSE;
    string sDisableHideVarNamePart = "";

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
    {
        sDisableHideVarNamePart="ARMOR";
        nAppearance = MK_GetItemAppearance2(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
        int nCondition=0;
        if (MK_HasOppositePart(nPart))
        {
            int nPart2 = MK_GetOppositePart(nPart);
            if (MK_GetItemAppearance2(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)!=
                MK_GetItemAppearance2(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart2))
            {
                nCondition=1;
            }
        }
        MK_GenericDialog_SetCondition(4,nCondition);

        nCondition = (!MK_IAAM_GetContainsPart(nPart, ITEM_APPR_ARMOR_MODEL_TORSO) &&
            (!MK_GetIsArmorPartEmptyAppearance(oPC, oItem, nPart)));
        MK_GenericDialog_SetCondition(2, nCondition);
//        (nAppearance!=0));
//        int nIsBasePart = MK_IAAM_GetIsBase(nPart);
//        MK_GenericDialog_SetCondition(2, nCondition && nIsBasePart);
//        MK_GenericDialog_SetCondition(3, nCondition && !nIsBasePart);
        break;
    }
    case X2_CI_MODMODE_WEAPON:
        sDisableHideVarNamePart="WEAPON";
        nAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_WEAPON_MODEL,nPart) * 10+
                      GetItemAppearance(oItem,ITEM_APPR_TYPE_WEAPON_COLOR,nPart);
//        MK_DEBUG_TRACE("mk_pre_critem: nPart="+IntToString(nPart)+", nAppearance="+IntToString(nAppearance));
        break;
    case MK_CI_MODMODE_CLOAK:
        sDisableHideVarNamePart="CLOAK";
        nAppearance = GetItemAppearance(oItem, 0, 0);
        sAppearance = Get2DAString("CloakModel", "LABEL", nAppearance);
        break;
    case MK_CI_MODMODE_HELMET:
        sDisableHideVarNamePart="HELMET";
        nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
        break;
    case MK_CI_MODMODE_SHIELD:
        sDisableHideVarNamePart="SHIELD";
        nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
        break;
    }

//    int bDisableExtendedEditionFeatures = MK_INIT_GetAreEEFeaturesDisabled();

    if (MK_VERSION_GetIsVersionLower_1_74(oPC))
    {
//        SendMessageToPC(OBJECT_SELF, "Features of NWN Extended Edition are disabled!");
        bDisableHideItems = TRUE;
    }
    else if (sDisableHideVarNamePart!="")
    {
        bDisableHideItems = GetLocalInt(oPC, "MK_DISABLE_HIDE_"+sDisableHideVarNamePart);
    }

    int nHidden=FALSE;
    if (bDisableHideItems)
    {
        MK_GenericDialog_SetCondition(5, FALSE);
        MK_GenericDialog_SetCondition(6, FALSE);
    }
    else
    {
        nHidden = MK_GetHiddenWhenEquipped(oItem);
        MK_GenericDialog_SetCondition(5, nHidden);
        MK_GenericDialog_SetCondition(6, !nHidden);
    }
    MK_GenericDialog_SetConditionRange(0, 1, !nHidden);
//    MK_GenericDialog_SetCondition(252, !nHidden);

    switch (CIGetCurrentModMode(oPC))
    {
//    case X2_CI_MODMODE_WEAPON:
//        MK_GenericDialog_SetCondition(251, !nHidden);
//        break;
    case MK_CI_MODMODE_SHIELD:
    case X2_CI_MODMODE_WEAPON:
        MK_GenericDialog_SetConditionRange(7, 8, !nHidden && (MK_GetModifyShieldMode(oPC)!=1));
//        MK_GenericDialog_SetCondition(251, !nHidden && (MK_GetModifyShieldMode(oPC)!=1));
        break;
    }

    SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nAppearance));
    SetCustomToken(MK_TOKEN_PARTSTRING, sAppearance);

    return TRUE;
}
