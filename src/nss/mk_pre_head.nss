#include "mk_inc_debug"
#include "mk_inc_generic"
#include "mk_inc_body"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_states"
#include "mk_inc_head"
#include "mk_inc_delimiter"
#include "mk_inc_2da_disp"

int GetIsCraftingDisabled(object oPC, int i)
{
    string sVarName = "MK_DISABLE_CRAFT_" + MK_IntToString(i, 2, "0");
    return (GetLocalInt(oPC, sVarName)==1);
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();

    int nAction = MK_GenericDialog_GetAction();

    int nCurrentPage=-1;

    object oTarget = MK_GetCurrentTarget(oPC);

//    MK_DEBUG_TRACE("mk_pre_head: nState="+IntToString(nState)+
//        ", nAction="+IntToString(nAction));

    switch (nState)
    {
    case MK_STATE_BODY_SELECT:
        // So the finish/cancel scripts work properly
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);

        MK_SetBodyPartToBeModified(oPC, MK_CRAFTBODY_HEAD, TRUE);

        MK_HEAD_Initialize(oPC, oTarget);

        MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, FALSE, oTarget);
        MK_HEAD_CreateValidHeadsString(oTarget, oPC);

        MK_GenericDialog_SetState(nState = MK_STATE_HEAD_INIT);
        break;
    case MK_STATE_HEAD_MODIFY:
        switch (nAction)
        {
        case 31: // show next head
        case 32: // show previous head
            nCurrentPage = MK_2DA_DISPLAY_EnsureVisible(MK_HEAD_SetCreatureHead(oTarget, nAction-30));
            break;
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case -1:
            break;
        case 39: // swap tattoo colors
            MK_SwapTattooColors(oTarget);
            break;
        case 40: // change filter
            MK_GenericDialog_SetState(nState = MK_STATE_HEAD_FILTER);
            MK_2DA_DISPLAY_Initialize(MK_HEAD_Get2DAFile(oPC), "", "LABEL", "STRREF", "NAME", 10, "mk_cb_hd_f_flt");
            MK_2DA_DISPLAY_SetPageLength(10);
            break;
        default:  // select head
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nHead = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                MK_HEAD_SetCreatureHead(oTarget, MK_HEAD_MODEL, nHead);
            }
            break;
        }
        break;
    case MK_STATE_HEAD_FILTER:
        switch (nAction)
        {
        case 250:
        case 251:
        case 252:
        case 253:
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case -1:
            break;
        case 40:
            MK_GenericDialog_SetState(nState = MK_STATE_HEAD_INIT);
            MK_HEAD_CreateValidHeadsString(oTarget, oPC);
            MK_2DA_DISPLAY_Cleanup();
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nFilterID = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                MK_HEAD_ToggleFilter(OBJECT_SELF, nFilterID);
            }
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_HEAD_INIT:
    {
        MK_GenericDialog_SetState(nState = MK_STATE_HEAD_MODIFY);
        MK_2DA_DISPLAY_InitializeVirtual(MK_HEAD_GetValidHeadsString(oTarget));
        MK_2DA_DISPLAY_SetPageLength(10);
        nCurrentPage = MK_2DA_DISPLAY_EnsureVisible(GetCreatureBodyPart(CREATURE_PART_HEAD, oTarget));
        break;
    }
    }

//    MK_DEBUG_TRACE("1");
    nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
//    MK_DEBUG_TRACE("2");

    switch (nState)
    {
    case MK_STATE_HEAD_MODIFY:
        MK_GenericDialog_SetCondition(39,
            MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC) &&
                (!GetIsCraftingDisabled(oPC, 17)));
        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, GetCreatureBodyPart(CREATURE_PART_HEAD, oTarget), "mk_cb_hd_label", FALSE);
//        MK_DEBUG_TRACE("3");
        MK_SetBodyPartTokens(oPC, oTarget);
        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oTarget));
        SetCustomToken(14432, MK_HEAD_GetSelectedFilterAsText(oPC, oTarget));
        MK_DELIMITER_Initialize();
        MK_GenericDialog_SetCondition(40, !GetLocalInt(oPC, MK_HEAD_DISABLE_CHANGE_FILTER));
//        MK_DEBUG_TRACE("4");
        break;
    case MK_STATE_HEAD_FILTER:
        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, -1, "mk_cb_hd_f_label", FALSE);
        SetCustomToken(14432, MK_HEAD_GetSelectedFilterAsText(oPC, oTarget));
        SetCustomToken(14433, MK_HEAD_Get2DAFile(oPC));
        MK_DELIMITER_Initialize();
        break;
    }


    return TRUE;
}
