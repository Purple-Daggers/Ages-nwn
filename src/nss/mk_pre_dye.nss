#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"
#include "mk_inc_iaac"
#include "mk_inc_color"
#include "mk_inc_2da_disp"
#include "mk_inc_states"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    int nState = MK_GenericDialog_GetState();

    int nAction = MK_GenericDialog_GetAction();

    int nNWNversion_GE_1_74 = MK_VERSION_GetIsVersionGreaterEqual_1_74();
//    int nDisableEEFeatures = MK_INIT_GetAreEEFeaturesDisabled();

    object oItem = CIGetCurrentModItem(oPC);
    int nMaterial = GetLocalInt(oPC, "MK_MaterialToDye");
    int nModMode = CIGetCurrentModMode(oPC);

    switch (nState)
    {
    case MK_STATE_MATERIAL:
    {
        if ((nAction>=0) && (nAction<MK_ITEM_APPR_ARMOR_NUM_COLORS))
        {
            SetLocalInt(oPC, "MK_MaterialToDye", nMaterial = nAction);
        }
        MK_GenericDialog_SetState(nState = MK_STATE_COLOR);

        string sColumn = MK_IAAC_GetColorColumn(nMaterial);
        MK_2DA_DISPLAY_Initialize(MK_COLOR_2DAFILE, sColumn, "", sColumn, sColumn, 10);
        MK_2DA_DISPLAY_SetPageLength(GetLocalInt(oPC, "MK_NUMBER_OF_COLORS_PER_GROUP"));
        MK_2DA_DISPLAY_EnsureVisible(MK_GetItemColor(oPC, oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial));
        break;
    }
    case MK_STATE_COLOR:
    {
//        int nMaterial = GetLocalInt(oPC, "MK_MaterialToDye");
        int bEnsureVisible=FALSE;
        switch (nAction)
        {
        case 31:
            MK_IM_NextColor(oTarget, oPC, oItem, -1);
            bEnsureVisible=TRUE;
            break;
        case 32:
            MK_IM_PrevColor(oTarget, oPC, oItem, -1);
            bEnsureVisible=TRUE;
            break;
        case 250:
        case 251:
        case 252:
        case 253:
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 36:
            if (nNWNversion_GE_1_74)
            {
                MK_ClearOverrideColor(oTarget, oPC, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial, -1, FALSE);
            }
            break;
        case 37:
            if (nNWNversion_GE_1_74)
            {
                MK_ClearOverrideColor(oTarget, oPC, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial, MK_GetCurrentModPart(oPC), FALSE);
            }
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nColor = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                MK_DyeItem(oTarget, oPC, nMaterial, nColor);
            }
            break;
        }
        oItem = CIGetCurrentModItem(oPC);

        if (bEnsureVisible)
        {
            MK_2DA_DISPLAY_EnsureVisible(MK_GetItemColor(oPC, oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial));
        }
        break;
    }
    }


    switch (nState)
    {
    case MK_STATE_COLOR:
    {
        MK_SetMaterialToken(nMaterial);

        MK_SetColorToken(oPC, oItem, nMaterial);

//        string sColumn = MK_IAAC_GetColorColumn(nMaterial);
        int nColor = MK_GetItemColor(oPC, oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial);
//        MK_COLOR_SetCustomToken(sColumn, nColor);
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), nColor);

//    MK_GenericDialog_SetState(MK_STATE_CGROUP);

        int nPerPartColoring = GetLocalInt(oPC, MK_PERPARTCOLORING);
        int nCurrentModPart = MK_GetCurrentModPart(oPC);
        if ((nNWNversion_GE_1_74) && (nPerPartColoring) && (nCurrentModPart>=0))
        {
            MK_GenericDialog_SetCondition(36, MK_GetIsPerPartColored(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, -1, nCurrentModPart));
//        if ((nMaterial>=0) && (nMaterial<ITEM_APPR_ARMOR_NUM_COLORS))
            if ((nMaterial>=0) && (nMaterial<MK_ITEM_APPR_ARMOR_NUM_COLORS))
            {
                MK_GenericDialog_SetCondition(37, MK_GetIsPerPartColored(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nMaterial, nCurrentModPart));
            }
            else
            {
                MK_GenericDialog_SetCondition(37, FALSE);
            }
        }
        else
        {
            MK_GenericDialog_SetCondition(36, FALSE);
            MK_GenericDialog_SetCondition(37, FALSE);
        }
        break;
    }
    }

    return TRUE;
}

