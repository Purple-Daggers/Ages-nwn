#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_2da_disp"
#include "mk_inc_ccoh_db"
#include "mk_inc_editor"

int MK_DEITY_SearchDeityName(string s2DA, string sDeity, int nMaxRangeOfEmptyRows)
{
    string sColumnLabel = "LABEL";
    string sColumnName = "Name";
    string sColumnStrRef = "StrRef";

    int nLength = MK_Get2DALength(s2DA, sColumnLabel, nMaxRangeOfEmptyRows);
    int iRow;
    int nStrRef;
    string sName;
    for (iRow=0; iRow<nLength; iRow++)
    {
        int nStrRef = MK_Get2DAInt(s2DA, sColumnStrRef, iRow, 0);
        if (nStrRef!=0)
        {
            sName = MK_TLK_GetStringByStrRef(nStrRef);
        }
        else
        {
            sName = Get2DAString(s2DA, sColumnName, iRow);
        }

        if (sName == sDeity)
        {
            return iRow;
        }
    }
    return -1;
}

void MK_DEITY_SetColumnNames(object oPC)
{
    int nRacialType = GetRacialType(oPC);
    string sRacialTypeColumn = Get2DAString("racialtypes", "Label", nRacialType);
    SetLocalString(oPC, "MK_BODY_DEITY_RACIAL_COLUMN", sRacialTypeColumn);
    MK_DEBUG_TRACE("MK_DEITY_SetColumnNames():");
    MK_DEBUG_TRACE(" > racialtype: "+ sRacialTypeColumn);

    int nAlignmentGoodEvil = GetAlignmentGoodEvil(oPC);
    int nAlignmentLawChaos = GetAlignmentLawChaos(oPC);
    string sAlignmentColumn = "";
    switch (nAlignmentLawChaos)
    {
    case ALIGNMENT_CHAOTIC:
        sAlignmentColumn = "C";
        break;
    case ALIGNMENT_NEUTRAL:
        sAlignmentColumn = "N";
        break;
    case ALIGNMENT_LAWFUL:
        sAlignmentColumn = "L";
        break;
    }
    switch (nAlignmentGoodEvil)
    {
    case ALIGNMENT_GOOD:
        sAlignmentColumn += "G";
        break;
    case ALIGNMENT_NEUTRAL:
        if (sAlignmentColumn=="N")
        {
            sAlignmentColumn = "TN";
        }
        else
        {
            sAlignmentColumn += "N";
        }
        break;
    case ALIGNMENT_EVIL:
        sAlignmentColumn += "E";
        break;
    }
    SetLocalString(oPC, "MK_BODY_DEITY_ALIGNMENT_COLUMN", sAlignmentColumn);
    MK_DEBUG_TRACE(" > alignment: "+ sAlignmentColumn);

    int iClass;
    int nNoAlignmentGenderAdjustment=TRUE;
    for (iClass=1; iClass<=3; iClass++)
    {
        int nClassType = GetClassByPosition(iClass, oPC);
        switch (nClassType)
        {
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
            SetLocalString(oPC, "MK_BODY_DEITY_CLASS"+IntToString(iClass)+"_COLUMN", Get2DAString("classes", "Label", nClassType));
            MK_DEBUG_TRACE(" > class"+IntToString(iClass)+": "+ Get2DAString("classes", "Label", nClassType));
            nNoAlignmentGenderAdjustment=FALSE;
            break;
        }
    }
    SetLocalInt(oPC, "MK_BODY_DEITY_ALIGNMENTGENDER_ADJUST", (nNoAlignmentGenderAdjustment ? 0 : 1));
    MK_DEBUG_TRACE(" > adjust: "+IntToString(GetLocalInt(oPC, "MK_BODY_DEITY_ALIGNMENTGENDER_ADJUST")));

    string sGenderColumn="";
    switch (GetGender(oPC))
    {
    case GENDER_FEMALE:
        sGenderColumn = "Female";
        break;
    case GENDER_MALE:
        sGenderColumn = "Male";
        break;
    }
    SetLocalString(oPC, "MK_BODY_DEITY_GENDER_COLUMN", sGenderColumn);
    MK_DEBUG_TRACE(" > alignment: "+ sGenderColumn);
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    int nCurrentPage;

    string s2DA = GetLocalString(oPC, "MK_DEITY_2DAFILE");
    if (s2DA == "") s2DA = "mk_deities";

    switch (nState)
    {
    case MK_STATE_DEITY:
        nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
        switch (nAction)
        {
        case 250:
        case 251:
        case 252:
        case 253:
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 100:
        // pressed OK in the 'edit box' -> get the description
        {
            string sText = MK_TrimString(GetLocalString(oPC, g_varEditorBuffer));
            int bDisableColors = GetLocalInt(oPC, g_varEditorDisableColors);
            if (bDisableColors)
            {
            // We don't want colors, so lets remove them.
            // Just in case the user has used the chat line
            // to enter color tokens.
                sText = MK_RemoveColorTagsFromString(sText);
            }
            else
            {
            // We close all color tags in case the user has forgotten
            // to do so.
                sText = MK_CloseColorTags(sText);
            }
            SetDeity(oPC, sText);
//            SetLocalString(oPC, "MK_NEWNAME", sText);
            MK_Editor_CleanUp(oPC);
            break;
        }
        case 101:
        // pressed Cancel in the 'edit box'
            MK_Editor_CleanUp(oPC);
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetItemCount()))
            {
                int nDeity = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                string sDeity = MK_2DA_DISPLAY_GetItemLabel(nDeity, FALSE);
                SetDeity(oPC, sDeity);
            }
            break;
        }
        break;
    default:
    {
        MK_GenericDialog_SetState(nState = MK_STATE_DEITY);

        MK_DEITY_SetColumnNames(oPC);

        MK_2DA_DISPLAY_Initialize(s2DA, "", "Name", "StrRef", "LABEL", 300, "mk_cb_deity_chk");
        int nCurrentDeity = MK_DEITY_SearchDeityName(s2DA, GetDeity(oPC) , 100);
        MK_2DA_DISPLAY_EnsureVisible(nCurrentDeity);
        nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();


        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        break;
    }
    }

    switch (nState)
    {
    case MK_STATE_DEITY:
    {
        string sDeity = GetDeity(oPC);
        SetCustomToken(14422, sDeity);
        int nCurrentDeity = MK_DEITY_SearchDeityName(s2DA, sDeity , 100);
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), nCurrentDeity, "", FALSE);
//        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "", FALSE);

        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oPC));

        int bAllowEditName = !GetLocalInt(oPC, "MK_DEITY_DISABLE_EDIT_NAME");
        MK_GenericDialog_SetCondition(30, bAllowEditName);

        if (bAllowEditName)
        {
            // In case the editor gets started
            int bUseChatEvent = GetLocalInt(oPC, "MK_EDITOR_USE_CHAT_EVENT");
            MK_PrepareEditor(oPC, 4, 26, 27,
                "Edit deity name:", -1, FALSE, FALSE, bUseChatEvent);
            SetLocalString(oPC, g_varEditorText, sDeity);

//            MK_GenericDialog_SetCondition(100, FALSE);
//            MK_GenericDialog_SetCondition(101, FALSE);
//            MK_GenericDialog_SetCondition(102, FALSE);
//            MK_GenericDialog_SetCondition(103, TRUE);
        }

        break;
    }
    }

    MK_DELIMITER_Initialize();

    MK_DEBUG_TRACE("GetCondition(20)="+IntToString(MK_GenericDialog_GetCondition(20, FALSE)));

    return TRUE;
}
