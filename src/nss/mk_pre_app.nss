#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_2da_disp"
#include "mk_inc_ccoh_db"

const string MK_APPEARANCE_TYPE_SAVE = "MK_APPEARANCE_TYPE_SAVE";

void RestoreOriginalAppearance(object oTarget)
{
    string sIAStr = GetLocalString(oTarget, MK_APPEARANCE_TYPE_SAVE);
    MK_DEBUG_TRACE("Restoring original appearance type: '"+sIAStr+"'");
    if (sIAStr!="")
    {
        MK_CCOH_DB_IAStrToBodyAppearance(oTarget, sIAStr, MK_CCOH_DB_BODY_APPR_TYPE);
        DeleteLocalString(oTarget, MK_APPEARANCE_TYPE_SAVE);
    }
}

void SaveOriginalAppearance(object oTarget)
{
    string sIAStr = GetLocalString(oTarget, MK_APPEARANCE_TYPE_SAVE);
    if (sIAStr=="")
    {
        sIAStr = MK_CCOH_DB_BodyAppearanceToIAStr(oTarget, MK_CCOH_DB_BODY_APPR_TYPE);
        SetLocalString(oTarget, MK_APPEARANCE_TYPE_SAVE, sIAStr);
    }
}

int GetHasOriginalAppearance(object oTarget)
{
    string sIAStr1 = GetLocalString(oTarget, MK_APPEARANCE_TYPE_SAVE);
    string sIAStr2 = MK_CCOH_DB_BodyAppearanceToIAStr(oTarget, MK_CCOH_DB_BODY_APPR_TYPE);
    return (sIAStr1=="") || (sIAStr1==sIAStr2);
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    int nCurrentPage;

    switch (nState)
    {
    case MK_STATE_APPEARANCETYPE:
        nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
        switch (nAction)
        {
        case 250:
        case 251:
        case 252:
        case 253:
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 127:
            // Restore original appearance
            RestoreOriginalAppearance(oTarget);
            break;
        default:
            int nNewAppearanceType = MK_2DA_DISPLAY_GetValueAsInt(nAction);
            if (nNewAppearanceType!=-1)
            {
                SaveOriginalAppearance(oTarget);
                SetCreatureAppearanceType(oTarget, nNewAppearanceType);
            }
            break;
        }
        break;
    default:
        nState = MK_STATE_APPEARANCETYPE;
        MK_2DA_DISPLAY_Initialize("appearance", "", "NAME", "STRING_REF", "LABEL", 1500);
        nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
        MK_GenericDialog_SetState(nState);
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        break;
    }

    switch (nState)
    {
    case MK_STATE_APPEARANCETYPE:
        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, GetAppearanceType(oTarget));

        MK_GenericDialog_SetCondition(127, !GetHasOriginalAppearance(oTarget));
        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oTarget));
        break;
    }

    return TRUE;
}
