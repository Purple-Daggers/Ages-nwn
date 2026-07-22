#include "mk_inc_states"
#include "mk_inc_delimiter"
#include "mk_inc_itm_disp"
#include "mk_inc_swp_iprop"

const int MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1_INIT = 1001;
const int MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2_INIT = 1002;
const int MK_STATE_CHEATS_SWAPITEMPROPS_SWAP_INIT = 1003;

void MK_SWAPIPROP_CalculateSwapCost()
{
    object oItem1 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
    object oItem2 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);

    int nCost = 0;
    if (GetIsObjectValid(oItem1) && GetIsObjectValid(oItem2))
    {
        nCost = MK_SWAPIPROP_CalculateItemPropertySwapCost(oItem1, oItem2);
    }
    MK_SWAPIPROP_SetCost(nCost);
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    MK_DEBUG_TRACE("mk_pre_itemprop: nState="+IntToString(nState)+", nAction="+IntToString(nAction));
//    DisplayDebugOutput(oPC);

    switch (nState)
    {
    case MK_STATE_CHEATS:
        switch (nAction)
        {
        case 27:
            MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1_INIT);
            break;
        }
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_ITM_DISPLAY_UpdatePage(nAction);
            break;
        default:
            if ((nAction>=0) && (nAction<MK_ITM_DISPLAY_GetItemCount()))
            {
                object oItem = MK_ITM_DISPLAY_GetSelectedItem(nAction);
                MK_DEBUG_TRACE("Selected item is '"+GetName(oItem)+"'");
                if (GetIsObjectValid(oItem))
                {
                    MK_SWAPIPROP_SetItem(oItem, nState);
                    MK_GenericDialog_SetCurrentPage(nState, MK_ITM_DISPLAY_GetCurrentPage());
                    MK_ITM_DISPLAY_Cleanup();
                    MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2_INIT);
                }
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_ITM_DISPLAY_UpdatePage(nAction);
            break;
        case 30: // swap itemproperties
        {
            object oItem1 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
            object oItem2 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);
            if (GetIsObjectValid(oItem1) && GetIsObjectValid(oItem2))
            {
                int nCost = MK_SWAPIPROP_GetCost();
                int nGold = GetGold(oPC);
                if (nGold>=nCost)
                {
                    MK_SWAPIPROP_SwapItemProperties(oItem1, oItem2);
                    if (nCost>0)
                    {
                        TakeGoldFromCreature(nCost, oPC, TRUE);
                    }
                    else if (nCost<0)
                    {
                        GiveGoldToCreature(oPC, -nCost);
                    }

                    MK_SWAPIPROP_SetItem(OBJECT_INVALID, MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
                    MK_SWAPIPROP_SetItem(OBJECT_INVALID, MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);
                    MK_SWAPIPROP_CalculateSwapCost();

                    MK_ITM_DISPLAY_Cleanup();
                    MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1_INIT);
                }
            }
            break;
        }
        case 255: // Back
            MK_ITM_DISPLAY_Cleanup();
            MK_SWAPIPROP_SetItem(OBJECT_INVALID, MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
            MK_SWAPIPROP_SetItem(OBJECT_INVALID, MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);
            MK_SWAPIPROP_CalculateSwapCost();
            MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1_INIT);
            break;
        default:
            if ((nAction>=0) && (nAction<MK_ITM_DISPLAY_GetItemCount()))
            {
                object oItem = MK_ITM_DISPLAY_GetSelectedItem(nAction);
                MK_DEBUG_TRACE("Selected item is '"+GetName(oItem)+"'");
                if (GetIsObjectValid(oItem))
                {
                    MK_SWAPIPROP_SetItem(oItem, nState);
                    MK_SWAPIPROP_CalculateSwapCost();
                }
            }
            break;
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1_INIT:
        MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
        MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL|MK_ITM_DISP_DISALLOW_PLOTITEMS|MK_ITM_DISP_DISALLOW_UNIDENTIFIED, 10, "mk_cb_swpip_chk");
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2_INIT:
        MK_GenericDialog_SetState(nState=MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);
        MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL|MK_ITM_DISP_DISALLOW_PLOTITEMS|MK_ITM_DISP_DISALLOW_UNIDENTIFIED, 10, "mk_cb_swpip_chk");
        break;
    }

    switch (nState)
    {
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1:
        MK_ITM_DISPLAY_DisplayPage(MK_ITM_DISPLAY_GetCurrentPage());
        MK_GenericDialog_SetCondition(30, FALSE);
        MK_GenericDialog_SetCondition(100, TRUE);
        MK_GenericDialog_SetCondition(101, FALSE);
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2:
    {
        MK_ITM_DISPLAY_DisplayPage(MK_ITM_DISPLAY_GetCurrentPage());
        int bEnable30 = GetIsObjectValid(MK_SWAPIPROP_GetItem(nState))
            && (MK_SWAPIPROP_GetCost()<=GetGold(oPC));
        MK_GenericDialog_SetCondition(30, bEnable30);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, TRUE);
        break;
    }
    }

    MK_SWAPIPROP_SetCustomToken();

    MK_DELIMITER_Initialize();

    return TRUE;
}
