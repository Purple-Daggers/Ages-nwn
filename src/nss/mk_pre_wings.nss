#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_2da_disp"
#include "mk_inc_ccoh_db"


const string MK_WINGS_TYPE_SAVE = "MK_WINGS_TYPE_SAVE";

void RestoreOriginalWings(object oPC)
{
    string sIAStr = GetLocalString(oPC, MK_WINGS_TYPE_SAVE);
    MK_DEBUG_TRACE("Restoring original wings type: '"+sIAStr+"'");
    if (sIAStr!="")
    {
        MK_CCOH_DB_IAStrToBodyAppearance(oPC, sIAStr, MK_CCOH_DB_BODY_APPR_WINGS);
        DeleteLocalString(oPC, MK_WINGS_TYPE_SAVE);
    }
}

void SaveOriginalWings(object oPC)
{
    string sIAStr = GetLocalString(oPC, MK_WINGS_TYPE_SAVE);
    if (sIAStr=="")
    {
        sIAStr = MK_CCOH_DB_BodyAppearanceToIAStr(oPC, MK_CCOH_DB_BODY_APPR_WINGS);
        SetLocalString(oPC, MK_WINGS_TYPE_SAVE, sIAStr);
    }
}

int GetHasOriginalWings(object oPC)
{
    string sIAStr1 = GetLocalString(oPC, MK_WINGS_TYPE_SAVE);
    string sIAStr2 = MK_CCOH_DB_BodyAppearanceToIAStr(oPC, MK_CCOH_DB_BODY_APPR_WINGS);
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
    case MK_STATE_WINGS:
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
            RestoreOriginalWings(oTarget);
            break;
        default:
            int nNewWingType = MK_2DA_DISPLAY_GetValueAsInt(nAction);
            if (nNewWingType!=-1)
            {
                SaveOriginalWings(oTarget);
                SetCreatureWingType(nNewWingType, oTarget);
            }
            break;
        }
        break;
    default:
        nState = MK_STATE_WINGS;
        MK_2DA_DISPLAY_Initialize("wingmodel", "", "LABEL", "", "", 300);
        MK_2DA_DISPLAY_EnsureVisible(GetCreatureWingType(oTarget));
        nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
        MK_GenericDialog_SetState(nState);
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, FALSE, oTarget);
        break;
    }

    switch (nState)
    {
    case MK_STATE_WINGS:
        MK_DELIMITER_Initialize();

        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, GetCreatureWingType(oTarget));

        MK_GenericDialog_SetCondition(127, !GetHasOriginalWings(oTarget));
        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oTarget));
        break;
    }

    return TRUE;
}
