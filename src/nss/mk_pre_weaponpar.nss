#include "mk_inc_generic"
#include "x2_inc_craft"
#include "mk_inc_craft"
#include "mk_inc_states"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

//    int nDisableEEFeatures = MK_INIT_GetAreEEFeaturesDisabled();

    object oItem = CIGetCurrentModItem(oPC);

    int nState = MK_GenericDialog_GetState(TRUE);

    switch (nState)
    {
/*    case MK_STATE_COPY:
    {
        int nItem = MK_GenericDialog_GetAction();
        if (nItem>=0)
        {
            object oSourceItem = MK_GenericDialog_GetObject(nItem);

            if (GetIsObjectValid(oSourceItem))
            {
                oItem = MK_CopyAppearance(oItem, oSourceItem);

                CISetCurrentModItem(oPC,oItem);

                MK_EquipModifiedItem(oPC);
            }
        }
        break;
    }*/
    case MK_STATE_MODIFY:
        CISetDefaultModItemCamera(oPC);
        break;
    case MK_STATE_SELECTPART:
    {
        int nAction = MK_GenericDialog_GetAction();
        switch (nAction)
        {
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
        break;
    }

    MK_GenericDialog_SetState(MK_STATE_SELECTPART);

    int nVisible = !MK_GetHiddenWhenEquipped(oItem);

    MK_GenericDialog_SetConditionRange(1, 3, nVisible);

    int nNWNversion_GE_1_74 = MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC);
    MK_GenericDialog_SetCondition(250, (nNWNversion_GE_1_74) && (!nVisible));
    MK_GenericDialog_SetCondition(251, (nNWNversion_GE_1_74) && (nVisible));

    MK_SetCurrentModPart(oPC, -1);

    return TRUE;
}
