#include "mk_inc_generic"
#include "mk_inc_version"
#include "mk_inc_iaam"
#include "mk_inc_craft"
#include "mk_inc_states"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

//    int nDisableEEFeatures = MK_INIT_GetAreEEFeaturesDisabled();
    int nVersion_GE_1_74 = MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC);

    int nPerPartColoring = GetLocalInt(oPC, MK_PERPARTCOLORING);

    object oItem;

    switch (MK_GenericDialog_GetState(TRUE))
    {
    case MK_STATE_COLOR:
        {
            int nColor = MK_GenericDialog_GetAction();
            int nNumberOfColorsPerGroup = GetLocalInt(oPC, "MK_NUMBER_OF_COLORS_PER_GROUP");
            if ((nColor>=0) && (nColor<nNumberOfColorsPerGroup))
            {
//                SetLocalInt(oPC, "MK_ColorToDye", nColor);
//                ExecuteScript("mk_dyeitem", oPC);

                int iMaterialToDye = GetLocalInt(oPC, "MK_MaterialToDye");
                int iColorGroup = GetLocalInt(oPC, "MK_ColorGroup");
                int iColor = (iColorGroup * nNumberOfColorsPerGroup) + nColor;
                MK_DyeItem(oTarget, oPC, iMaterialToDye, iColor);
            }
        }
        break;
    case MK_STATE_COPY:
        {
            int nItem = MK_GenericDialog_GetAction();
            if (nItem>=0)
            {
                object oSourceItem = MK_GenericDialog_GetObject(nItem);

                if (GetIsObjectValid(oSourceItem))
                {
                    oItem = CIGetCurrentModItem(oPC);

                    int bMirrorUpdateDeactivated = FALSE;
                    if (MK_GetUpdateMirror(oPC))
                    {
                        bMirrorUpdateDeactivated=TRUE;
                        MK_DeactivateMirrorUpdate(oTarget, oPC, TRUE);
                    }

                    oItem = MK_CopyColor(oItem, oSourceItem, nVersion_GE_1_74);
                    CISetCurrentModItem(oPC,oItem);

                    if (bMirrorUpdateDeactivated)
                    {
                        MK_DeactivateMirrorUpdate(oTarget, oPC, FALSE);
                    }
                    else
                    {
                        MK_EquipModifiedItem(oTarget, oPC);
                    }
                }
            }
        }
        break;
    case MK_STATE_SELECTPART:
        {
            int nPart = MK_GenericDialog_GetAction();
            if ((nPart>=0) && (nPart<MK_ITEM_APPR_ARMOR_NUM_MODELS))
            {
                MK_SetCurrentModPart(oPC, nPart);
                nPerPartColoring = TRUE;
                SetLocalInt(oPC, MK_PERPARTCOLORING, nPerPartColoring);
            }
        }
        break;
    default:
        {
            switch (CIGetCurrentModMode(oPC))
            {
            case X2_CI_MODMODE_ARMOR:
                if (nVersion_GE_1_74)
                {
                    switch (MK_GenericDialog_GetAction())
                    {
                    case 251:
                        MK_ClearOverrideColor(oTarget, oPC, ITEM_APPR_TYPE_ARMOR_COLOR, -1, -1, FALSE);
                        break;
                    case 252:
                        {
                            int nPart = MK_GetCurrentModPart(oPC);
                            if (nPart!=-1)
                            {
                                MK_ClearOverrideColor(oTarget, oPC, ITEM_APPR_TYPE_ARMOR_COLOR, -1, nPart, FALSE);
                            }
                        }
                        break;
                    case 255:
                        nPerPartColoring = FALSE;
                        MK_SetCurrentModPart(oPC, -1);
                        SetLocalInt(oPC, MK_PERPARTCOLORING, nPerPartColoring);
                        break;
                    }
                }
                break;
            }
        }
        break;
    }

    oItem = CIGetCurrentModItem(oPC);

    MK_SetColorToken(oPC, oItem,-1);

    MK_GenericDialog_SetState(MK_STATE_MATERIAL);

    int iCond;
    for (iCond=250; iCond<=255; iCond++)
    {
        MK_GenericDialog_SetCondition(iCond, FALSE);
    }

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
    {
        int nCurrentModPart = MK_GetCurrentModPart(oPC);
        if ((nCurrentModPart == X2_CI_MODMODE_INVALID) || (!nPerPartColoring))
        {
            nPerPartColoring = FALSE;
            SetCustomToken(14421,"");
        }
        else
        {
            SetCustomToken(14421,MK_COLOR_HIGHLIGHT + "Dyeing armor part: "
                + MK_IAAM_GetDescription(nCurrentModPart) + MK_COLOR_CLOSE + "\n");
        }
        if (nVersion_GE_1_74)
        {
            MK_GenericDialog_SetCondition(251, MK_GetIsPerPartColored(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, -1, -1));
            if (nCurrentModPart>=0)
            {
                int nValue = MK_GetIsPerPartColored(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, -1, nCurrentModPart);
                MK_GenericDialog_SetCondition(252, nValue);
            }
            else
            {
                MK_GenericDialog_SetCondition(252, FALSE);
            }
            MK_GenericDialog_SetCondition(250, TRUE);
            MK_GenericDialog_SetCondition(255, nPerPartColoring);
        }
        break;
    }
    default:
        SetCustomToken(14421,"");
        break;
    }

    return TRUE;
}
