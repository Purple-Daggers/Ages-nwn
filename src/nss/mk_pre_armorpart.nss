#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"
#include "mk_inc_states"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    int nNWNversion_GE_1_74 = MK_VERSION_GetIsVersionGreaterEqual_1_74();
//    int nDisableEEFeatures = MK_INIT_GetAreEEFeaturesDisabled();

    object oItem = CIGetCurrentModItem(oPC);

    int nState = MK_GenericDialog_GetState(TRUE);

    switch (nState)
    {
    case MK_STATE_COPY:
    {
        int nItem = MK_GenericDialog_GetAction();
        MK_DEBUG_TRACE("mk_pre_armorpart(MK_STATE_COPY): nItem="+IntToString(nItem));
        if (nItem>=0)
        {
            object oSourceItem = MK_GenericDialog_GetObject(nItem);
            MK_DEBUG_TRACE("mk_pre_armorpart(MK_STATE_COPY): oSourceItem="+GetName(oSourceItem));

            if (GetIsObjectValid(oSourceItem))
            {
                oItem = MK_CopyAppearance(oItem, oSourceItem);
                MK_DEBUG_TRACE("mk_pre_armorpart(MK_STATE_COPY): oItem="+GetName(oItem));

                CISetCurrentModItem(oPC,oItem);

                MK_EquipModifiedItem(oTarget, oPC);
            }
        }
        break;
    }
    case MK_STATE_MODIFY:
        CISetDefaultModItemCamera(oPC);
        break;
    case MK_STATE_SELECTPART:
    {
        int nAction = MK_GenericDialog_GetAction();
        switch (nAction)
        {
//        case 249:
//            MK_ResetAllPreReadArmorPartCache();
//            break;
        case 250:
        case 251:
            MK_IM_ToggleVisibility(oTarget, oPC, oItem);
            oItem = CIGetCurrentModItem(oPC);
            break;
        }
        break;
    }
    case MK_STATE_INIT:
        CISetDefaultModItemCamera(oPC);
        MK_ResetAllPreReadArmorPartCache(oPC);
        break;
    }

    MK_GenericDialog_SetState(MK_STATE_SELECTPART);

    int nVisible = !MK_GetHiddenWhenEquipped(oItem);;

    int nRobe = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE);

    int iItemAppr;
    int nValid;
    for (iItemAppr=0; iItemAppr<MK_ITEM_APPR_ARMOR_NUM_MODELS; iItemAppr++)
    {
        nValid = nVisible && MK_IAAM_GetIsValid(iItemAppr) && MK_IAAM_GetIsValidForModelModify(iItemAppr)
            &&  ((nRobe == 0) || (MK_IAAM_GetIsHiddenByRobe(iItemAppr, nRobe, TRUE)<100));
//            && MK_IAAM_GetAllPartsHaveIdenticalAppearance(iItemAppr, oItem);
        MK_GenericDialog_SetCondition(iItemAppr, nValid);
    }
    MK_GenericDialog_SetCondition(252, nVisible);

//    MK_GenericDialog_SetCondition(249, GetLocalInt(oPC, "MK_ALLOW_RESET_BUFFER"));

    MK_GenericDialog_SetCondition(250, (nNWNversion_GE_1_74) && (!nVisible));
    MK_GenericDialog_SetCondition(251, (nNWNversion_GE_1_74) && (nVisible));

    MK_SetCurrentModPart(oPC, -1);

//    MK_VerifyCurrentModItem(oPC, "mk_pre_armorpart(end)");
    return TRUE;
}
