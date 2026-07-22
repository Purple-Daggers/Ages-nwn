// mk_pre_color

#include "mk_inc_generic"

#include "mk_inc_body"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_color"
#include "mk_inc_states"
#include "mk_inc_delimiter"
#include "mk_inc_2da_disp"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();

    int nAction = MK_GenericDialog_GetAction();

    string sColumn="";

//    int nCurrentPage=-1;

    MK_DEBUG_TRACE("mk_pre_color2: nState="+IntToString(nState)
        +", nAction="+IntToString(nAction));

    switch (nState)
    {
    case MK_STATE_BODY_SELECT:
        MK_GenericDialog_SetState(nState = MK_STATE_COLOR_SELECT);
        // So the finish/cancel scripts work properly
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        MK_SetBodyPartToBeModified(oPC, MK_CRAFTBODY_COLOR, TRUE);
        MK_SetSubPartToBeModified(oPC, -1, oPC==oTarget);
        MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, FALSE, oTarget);
        break;
    case MK_STATE_COLOR_SELECT:
        switch (nAction)
        {
        case 0:
        case 1:
        case 2:
        case 3:
            MK_SetSubPartToBeModified(oPC, nAction, oPC==oTarget);
            sColumn = MK_COLOR_Get2DAColumn(MK_CI_MODMODE_BODY, MK_CRAFTBODY_COLOR, nAction);
            MK_GenericDialog_SetState(nState = MK_STATE_COLOR_MODIFY);
            MK_2DA_DISPLAY_Initialize(MK_COLOR_2DAFILE, sColumn, "", sColumn, sColumn, 10);
            MK_2DA_DISPLAY_SetPageLength(GetLocalInt(oPC, "MK_NUMBER_OF_COLORS_PER_GROUP"));
            MK_2DA_DISPLAY_EnsureVisible(GetColor(oTarget, nAction));
            MK_COLOR_SetValidColors(oPC, MK_2DA_DISPLAY_GetCache());
//            nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();

            break;
        case 250:
            MK_SwapTattooColors(oTarget);
            break;
        }
        break;
    case MK_STATE_COLOR_MODIFY:
        switch (nAction)
        {
        case 31:
        case 32:
            MK_2DA_DISPLAY_EnsureVisible(MK_COLOR_SetColor(oTarget, MK_GetSubPartToBeModified(oPC), nAction-30, -1, oPC));
            break;
        case 250:
        case 251:
        case 252:
        case 253:
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case -1:
            MK_GenericDialog_SetState(nState = MK_STATE_COLOR_SELECT);
            MK_SetSubPartToBeModified(oPC, -1, oPC==oTarget);
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nRow = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                MK_COLOR_SetColor(oTarget, MK_GetSubPartToBeModified(oPC), MK_COLOR_NUMBER, nRow, oPC);
            }
            break;
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_COLOR_SELECT:
        break;
    case MK_STATE_COLOR_MODIFY:
    {
        int nColorChannel = MK_GetSubPartToBeModified(oPC);
        sColumn = MK_COLOR_Get2DAColumn(MK_CI_MODMODE_BODY, MK_CRAFTBODY_COLOR, nColorChannel);
        int nColor = GetColor(oTarget, nColorChannel);
        MK_COLOR_SetCustomToken(sColumn, nColor);
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), nColor);
        break;
    }
    }

    MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oTarget));

    return TRUE;
}
