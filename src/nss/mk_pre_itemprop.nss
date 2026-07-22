#include "x2_inc_craft"
#include "mk_inc_modmodes"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_generic"
#include "mk_inc_debug"
#include "mk_inc_states"
#include "mk_inc_delimiter"
#include "mk_inc_itm_disp"
#include "mk_inc_2da_disp"
#include "mk_inc_cheats"

/*
int MK_ITEMPROP_GetIsModified()
{
    int bResult = FALSE;
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);
    object oBackup = CIGetCurrentModBackup(oPC);
    if (GetIsObjectValid(oItem) && GetIsObjectValid(oBackup))
    {
        string sIASStrBackup = MK_CCOH_DB_ItemPropertiesToIASStr(oBackup);
        string sIASStrCurrent = MK_CCOH_DB_ItemPropertiesToIASStr(oItem);
        bResult = (sIASStrBackup != sIASStrCurrent);
    }
    return bResult;
}
*/

/*
int MK_ITEMPROP_GetRequiredGold(int nCurrentValue=-1)
{
    object oPC = GetPCSpeaker();
    int nRequiredGold = 0;
    object oBackup = CIGetCurrentModBackup(oPC);
    if (GetIsObjectValid(oBackup))
    {
        if (nCurrentValue==-1)
        {
            nCurrentValue = MK_CHEATS_CalculateCurrentGoldPieceValue();
        }
        int nBackupValue = MK_IPRP_GetGoldPieceValue(oBackup);
        nRequiredGold = nCurrentValue - nBackupValue;
        float fFactor = 1.0f;
        if (nRequiredGold > 0)
        {
            fFactor = GetLocalFloat(oPC, "MK_CHEATS_ITEM_BUY");
        }
        else if (nRequiredGold < 0)
        {
            fFactor = GetLocalFloat(oPC, "MK_CHEATS_ITEM_SELL");
        }
        nRequiredGold = FloatToInt(fFactor * nRequiredGold);
        MK_DEBUG_TRACE("MK_ITEMPROP_GetRequiredGold: nCurrentValue="+IntToString(nCurrentValue)
            +", nBackupValue="+IntToString(nBackupValue)
            +", fFactor="+FloatToString(fFactor)
            +", nRequiredGold="+IntToString(nRequiredGold));
    }
    return nRequiredGold;
}
*/

void MK_ITEMPROP_SetCustomToken(int nState)
{
    MK_CHEATS_SetCustomToken();

//    string sItemName;
//    string sItemValue = "-";
    string sItemPropertyName;
//    string sRequiredGold = "-";
//    int nRequiredGold = 0;
//    int nGold = GetGold();

//    object oItem = MK_CHEATS_GetCurrentItem();
//    if (GetIsObjectValid(oItem))
//    {
//        int nCurrentValue = MK_CHEATS_CalculateCurrentGoldPieceValue();
//        int nGoldPieceValue = MK_CHEATS_GetCurrentGoldPieceValue();
//        sItemValue = IntToString(nCurrentValue) + " / " + IntToString(nGoldPieceValue);

//        nRequiredGold = MK_CHEATS_GetRequiredGold(nCurrentValue);
//        sRequiredGold = IntToString(nRequiredGold);
//    }
//    sRequiredGold += (" ("+IntToString(nGold)+")");

//    sItemName=MK_CHEATS_GetCurrentItemName("-");
    sItemPropertyName = MK_CHEATS_GetCurrentItemPropertyName("-");

//    SetCustomToken(14422, sItemName);
//    SetCustomToken(14423, sItemValue);
    SetCustomToken(14424, sItemPropertyName);
//    SetCustomToken(14426, sRequiredGold);

 //   if (nRequiredGold>nGold)
 //   {
//        string sDisabledOptionsColor = GetLocalString(OBJECT_SELF, "MK_DISABLED_OPTIONS_COLOR");
//        string sCloseColor = (sDisabledOptionsColor!="" ? "</c>" : "");

//        SetCustomToken(14460, sDisabledOptionsColor);
//        SetCustomToken(14470, " "+MK_TLK_GetStringByStrRef(-474)+"</c>");
//    }


    int nStrRef = 0;
    switch (nState)
    {
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
        nStrRef = MK_CHEATS_GetCurrentParam1TableStrRef();
        break;
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
        nStrRef = -471;
        break;
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
        nStrRef = -470;
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
        nStrRef = -469;
        break;
    case MK_STATE_CHEATS_ITEMPROPS_ITEM:
        nStrRef = -468;
        break;
    }
    SetCustomToken(14425, MK_TLK_GetStringByStrRef(nStrRef));
}

int MK_ITEMPROP_Finish()
{
    int nState = MK_GenericDialog_GetState();
    if (MK_CHEATS_FinishModifyItem())
    {
        object oPC = GetPCSpeaker();

        MK_GenericDialog_SetCurrentPage(nState, 1);
        MK_2DA_DISPLAY_Cleanup();
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT);
    }
    return nState;
}

int MK_ITEMPROP_Cancel()
{
    MK_DEBUG_TRACE("MK_ITEMPROP_Cancel() *start*");
    object oPC = GetPCSpeaker();
    int nState = MK_GenericDialog_GetState();
    MK_GenericDialog_SetCurrentPage(nState, 1);
    MK_2DA_DISPLAY_Cleanup();

    MK_CHEATS_CancelModifyItem();

    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT);
    MK_DEBUG_TRACE("MK_ITEMPROP_Cancel(): *terminate*");
    return nState;
}

/*
void DisplayDebugOutputQ(string sMsg, object oItem)
{
    string sIASStr = "";
    int nCalculatedValue = -1;
    int nGoldPieceValue = -1;
    if (GetIsObjectValid(oItem))
    {
        sIASStr = MK_CCOH_DB_ItemPropertiesToIASStr(oItem);
        nCalculatedValue = MK_IPRP_CalculateGoldPieceValue(oItem, 0);
        nGoldPieceValue = MK_IPRP_GetGoldPieceValue(oItem);
    }
    MK_DEBUG_TRACE(sMsg+": oItem='"+GetName(oItem)
        +"', sIASStr='"+sIASStr
        +"', nCalculatedValue="+IntToString(nCalculatedValue)
        +"', nGoldPieceValue="+IntToString(nGoldPieceValue));
}

void DisplayDebugOutput(object oPC)
{
    object oItem = CIGetCurrentModItem(oPC);
    object oBackup = CIGetCurrentModBackup(oPC);
    DisplayDebugOutputQ("Current item", oItem);
    DisplayDebugOutputQ("Backup item ", oBackup);
    object oContainer = IPGetIPWorkContainer();
    if (GetIsObjectValid(oContainer))
    {
        int iItem=0;
        object oItemQ = GetFirstItemInInventory(oContainer);
        while (GetIsObjectValid(oItemQ))
        {
            DisplayDebugOutputQ("Item "+IntToString(++iItem), oItemQ);
            oItemQ = GetNextItemInInventory(oContainer);
        }
    }
}
*/

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
        MK_CHEATS_SetCurrentItem(OBJECT_INVALID);
        MK_CHEATS_SetCurrentItemPropertyID(-1);
        MK_CHEATS_SetCurrentItemPropertySubType(-1);
        MK_CHEATS_SetCurrentItemPropertyCostTableValue(-1);
        MK_CHEATS_SetCurrentItemPropertyParam1Value(-1);
        MK_GenericDialog_SetCurrentPage(MK_STATE_CHEATS_ITEMPROPS_ITEM, 1);
        MK_GenericDialog_SetCurrentPage(MK_STATE_CHEATS_ITEMPROPS_PROPERTY, 1);
        MK_GenericDialog_SetCurrentPage(MK_STATE_CHEATS_ITEMPROPS_SUBTYPE, 1);
        MK_GenericDialog_SetCurrentPage(MK_STATE_CHEATS_ITEMPROPS_COSTTABLE, 1);

        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT);
        break;
    case MK_STATE_CHEATS_ITEMPROPS_ITEM:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_ITM_DISPLAY_UpdatePage(nAction);
            break;
        case 31: // filter items
            MK_ITM_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS_INIT);
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_FILTERITEMS_SHOWALL", MK_CHEATS_GetAreAllItemTypesSelected(oPC));
            break;
        default:
            if ((nAction>=0) && (nAction<MK_ITM_DISPLAY_GetPageLength()))
            {
                object oItem = MK_ITM_DISPLAY_GetSelectedItem(nAction);
//                CISetCurrentModMode(oPC, MK_CI_MODMODE_ITEM);
//                MK_StartModifyItem(oPC, oItem, FALSE, FALSE);
                MK_DEBUG_TRACE("Selected item is '"+GetName(oItem)+"'");
                if (MK_CHEATS_SetCurrentItem(oItem))
                {
                    MK_GenericDialog_SetCurrentPage(nState, MK_ITM_DISPLAY_GetCurrentPage());
                    MK_ITM_DISPLAY_Cleanup();
                    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT);
                }
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT);
            break;
        case 32:
        {
            int bSelectAll = !GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_FILTERITEMS_SHOWALL");
            MK_CHEATS_SelectAllItemTypes(oPC, bSelectAll);
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_FILTERITEMS_SHOWALL", bSelectAll);
            break;
        }
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nItemType = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                MK_CHEATS_SelectItemType(oPC, nItemType, !MK_CHEATS_GetIsItemTypeSelected(oPC, nItemType));
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
        MK_CHEATS_CalculateCurrentItemAdditionalCost();
        // the calculation of the current item's additional cost is initialized
        // within MK_CHEATS_SetCurrentItem(). The additional cost are calculated
        // only once, later calls of that function will return immediately.
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 254:
        case 255:
            nState = MK_ITEMPROP_Finish();
            break;
        case 257:
            nState = MK_ITEMPROP_Cancel();
            break;
        case 30:
        {
            MK_IPRP_RemoveAllItemProperties(MK_CHEATS_GetCurrentItem());
            break;
        }
        case 33:
        {
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY", !GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY"));
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT);
            break;
        }
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nIProp = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                string sSubTypeResRef = MK_IPRP_GetSubTypeResRefByID(nIProp);
                if (sSubTypeResRef=="")
                {
                    string sCostTableResRef = MK_IPRP_GetCostTableResRefByID(nIProp);
                    if (sCostTableResRef=="")
                    {
                        string sParam1ResRef = MK_IPRP_GetParam1ResRefByID(nIProp);
                        if (sParam1ResRef=="")
                        {
                            object oItem = MK_CHEATS_GetCurrentItem();
                            MK_CHEATS_ToggleItemProperty(oItem, nIProp);
                        }
                        else
                        {
                            MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                            MK_2DA_DISPLAY_Cleanup();
                            MK_CHEATS_SetCurrentItemPropertyID(nIProp);
                            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT);
                        }
                    }
                    else
                    {
                        MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                        MK_2DA_DISPLAY_Cleanup();
                        MK_CHEATS_SetCurrentItemPropertyID(nIProp);
                        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT);
                    }
                }
                else
                {
                    MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                    MK_2DA_DISPLAY_Cleanup();
                    MK_CHEATS_SetCurrentItemPropertyID(nIProp);
                    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT);
                }
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 254:
            nState = MK_ITEMPROP_Finish();
            break;
        case 255:
            MK_GenericDialog_SetCurrentPage(nState, 1);
            MK_2DA_DISPLAY_Cleanup();
            MK_CHEATS_SetCurrentItemPropertyID(-1);
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT);
            break;
        case 257:
            nState = MK_ITEMPROP_Cancel();
            break;
        case 30:
        {
            MK_IPRP_RemoveAllItemProperties(MK_CHEATS_GetCurrentItem(),
                MK_CHEATS_GetCurrentItemPropertyID());
            break;
        }
        case 33:
        {
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY", !GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY"));
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT);
            break;
        }
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nIProp = MK_CHEATS_GetCurrentItemPropertyID();
                int nSubType = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                string sCostTableResRef = MK_IPRP_GetCostTableResRefByID(nIProp);
                if (sCostTableResRef=="")
                {
                    string sParam1ResRef = MK_IPRP_GetParam1ResRefByID(nIProp, nSubType);
                    if (sParam1ResRef=="")
                    {
                        object oItem = MK_CHEATS_GetCurrentItem();
                        MK_CHEATS_ToggleItemProperty(oItem, nIProp, nSubType);
                    }
                    else
                    {
                        MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                        MK_2DA_DISPLAY_Cleanup();
                        MK_CHEATS_SetCurrentItemPropertySubType(nSubType);
                        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT);
                    }
                }
                else
                {
                    MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                    MK_2DA_DISPLAY_Cleanup();
                    MK_CHEATS_SetCurrentItemPropertySubType(nSubType);
                    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT);
                }
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 254:
            nState = MK_ITEMPROP_Finish();
            break;
        case 255:
        {
            MK_GenericDialog_SetCurrentPage(nState, 1);
            MK_2DA_DISPLAY_Cleanup();
            int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
            if (nSubType!=-1)
            {
                MK_CHEATS_SetCurrentItemPropertySubType(-1);
                MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT);
            }
            else
            {
                MK_CHEATS_SetCurrentItemPropertyID(-1);
                MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT);
            }
            break;
        }
        case 257:
            nState = MK_ITEMPROP_Cancel();
            break;
        case 30:
        {
            MK_IPRP_RemoveAllItemProperties(MK_CHEATS_GetCurrentItem(),
                MK_CHEATS_GetCurrentItemPropertyID(),
                MK_CHEATS_GetCurrentItemPropertySubType());
            break;
        }
        case 33:
        {
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY", !GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY"));
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT);
            break;
        }
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nIProp = MK_CHEATS_GetCurrentItemPropertyID();
                int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
                int nCostTableValue = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                string sParam1ResRef = MK_IPRP_GetParam1ResRefByID(nIProp, nSubType);
                if (sParam1ResRef=="")
                {
                    object oItem = MK_CHEATS_GetCurrentItem();
                    MK_CHEATS_ToggleItemProperty(oItem, nIProp, nSubType, nCostTableValue);
               }
                else
                {
                    MK_GenericDialog_SetCurrentPage(nState, MK_2DA_DISPLAY_GetCurrentPage());
                    MK_2DA_DISPLAY_Cleanup();
                    MK_CHEATS_SetCurrentItemPropertyCostTableValue(nCostTableValue);
                    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT);
                }
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 254:
            nState = MK_ITEMPROP_Finish();
            break;
        case 255:
        {
            MK_GenericDialog_SetCurrentPage(nState, 1);
            MK_2DA_DISPLAY_Cleanup();
            int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
            int nCostTableValue = MK_CHEATS_GetCurrentItemPropertyCostTableValue();
            if (nCostTableValue != -1)
            {
                MK_CHEATS_SetCurrentItemPropertyCostTableValue(-1);
                MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT);
            }
            else if (nSubType != -1)
            {
                MK_CHEATS_SetCurrentItemPropertySubType(-1);
                MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT);
            }
            else
            {
                MK_CHEATS_SetCurrentItemPropertyID(-1);
                MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT);
            }
            break;
        }
        case 257:
            nState = MK_ITEMPROP_Cancel();
            break;
        case 30:
        {
            MK_IPRP_RemoveAllItemProperties(MK_CHEATS_GetCurrentItem(),
                MK_CHEATS_GetCurrentItemPropertyID(),
                MK_CHEATS_GetCurrentItemPropertySubType(),
                MK_CHEATS_GetCurrentItemPropertyCostTableValue());
            break;
        }
        case 33:
        {
            SetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY", !GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY"));
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT);
            break;
        }
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nIProp = MK_CHEATS_GetCurrentItemPropertyID();
                int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
                int nCostTableValue = MK_CHEATS_GetCurrentItemPropertyCostTableValue();
                int nParam1 = MK_2DA_DISPLAY_GetValueAsInt(nAction);

                object oItem = MK_CHEATS_GetCurrentItem();
                MK_CHEATS_ToggleItemProperty(oItem, nIProp, nSubType, nCostTableValue, nParam1);
            }
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM);
        MK_CHEATS_InitializeFilterItemArray(oPC);
        MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL | MK_ITM_DISP_HIDDENSLOTS | MK_ITM_DISP_DISALLOW_UNIDENTIFIED | MK_ITM_DISP_DISALLOW_PLOTITEMS, MK_ITM_DISP_MAX_PAGE_LENGTH, "mk_cb_iprp_itchk");
        MK_ITM_DISPLAY_SetCurrentPage(MK_GenericDialog_GetCurrentPage(nState));
        MK_CHEATS_SetCurrentItem(OBJECT_INVALID);
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_ITEM, new state="+IntToString(nState));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS);
        MK_2DA_DISPLAY_Initialize("mk_iprp_cols", "", "Column", "StrRef1", "StrRef1", 10);
        MK_2DA_DISPLAY_SetPageLength(11);
        MK_2DA_DISPLAY_SetCurrentPage(1);
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS, new state="+IntToString(nState));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PROPERTY);
        MK_2DA_DISPLAY_Initialize("itemprops", "", "Label", "StringRef", MK_CHEATS_GetCurrentPropColumn(), 100, "mk_cb_iprp_chk");
        MK_2DA_DISPLAY_SetPageLength(-1);
        MK_2DA_DISPLAY_SetCurrentPage(MK_GenericDialog_GetCurrentPage(nState));
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_PROPERTY, new state="+IntToString(nState));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_SUBTYPE);
        MK_2DA_DISPLAY_Initialize(MK_CHEATS_GetCurrentSubTypeResRef(), "", "Label", "Name", "Name", 50, "mk_cb_iprp_chk");
        MK_2DA_DISPLAY_SetPageLength(-1);
        MK_2DA_DISPLAY_SetCurrentPage(MK_GenericDialog_GetCurrentPage(nState));
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_SUBTYPE, new state="+IntToString(nState));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_COSTTABLE);
        MK_2DA_DISPLAY_Initialize(MK_CHEATS_GetCurrentCostTableResRef(), "", "Label", "Name", "Name", 50, "mk_cb_iprp_chk");
        MK_2DA_DISPLAY_SetPageLength(-1);
        MK_2DA_DISPLAY_SetCurrentPage(MK_GenericDialog_GetCurrentPage(nState));
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_COSTTABLE, new state="+IntToString(nState));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT:
        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_PARAM1);
        MK_2DA_DISPLAY_Initialize(MK_CHEATS_GetCurrentParam1ResRef(), "", "Label", "Name", "Name", 50, "mk_cb_iprp_chk");
        MK_2DA_DISPLAY_SetPageLength(-1);
        MK_DEBUG_TRACE("mk_pre_itemprop: initializing MK_STATE_CHEATS_ITEMPROPS_PARAM1, new state="+IntToString(nState));
        break;
    }

    int bIsModified = MK_CHEATS_GetIsCurrentItemModified();

    switch (nState)
    {
    case MK_STATE_CHEATS_ITEMPROPS_ITEM:
        MK_ITM_DISPLAY_DisplayPage(MK_ITM_DISPLAY_GetCurrentPage(), "mk_cb_iprp_inlbl");
        MK_GenericDialog_SetCondition(100, TRUE);
        MK_GenericDialog_SetCondition(101, FALSE);
        MK_GenericDialog_SetCondition(30, FALSE);
        MK_GenericDialog_SetCondition(31, TRUE);
        MK_GenericDialog_SetCondition(32, FALSE);
        MK_GenericDialog_SetCondition(33, FALSE);
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    case MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_iflbl", FALSE);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, TRUE);
        MK_GenericDialog_SetCondition(30, FALSE);
        MK_GenericDialog_SetCondition(31, FALSE);
        MK_GenericDialog_SetCondition(32, TRUE);
        MK_GenericDialog_SetCondition(33, FALSE);

        SetCustomToken(14427, MK_TLK_GetStringByStrRef( GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_FILTERITEMS_SHOWALL") ? -39 : -40 ));

        MK_GenericDialog_SetCondition(127, FALSE);
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_iplbl", FALSE);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, !bIsModified);
        MK_GenericDialog_SetCondition(30, MK_CHEATS_GetCurrentItemPropertyCount()>0);
        MK_GenericDialog_SetConditionRange(31, 32, FALSE);
        MK_GenericDialog_SetCondition(33, TRUE);
        MK_GenericDialog_SetCondition(127, FALSE);
        SetCustomToken(14427, MK_TLK_GetStringByStrRef( GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY") ? -39 : -40 ));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_stlbl", FALSE);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, TRUE);
        MK_GenericDialog_SetCondition(30, MK_CHEATS_GetCurrentItemPropertyCount(MK_CHEATS_GetCurrentItemPropertyID())>0);
        MK_GenericDialog_SetConditionRange(31, 32, FALSE);
        MK_GenericDialog_SetCondition(33, TRUE);
        MK_GenericDialog_SetCondition(127, FALSE);
        SetCustomToken(14427, MK_TLK_GetStringByStrRef( GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY") ? -39 : -40 ));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_ctlbl", FALSE);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, TRUE);
        MK_GenericDialog_SetCondition(30, MK_CHEATS_GetCurrentItemPropertyCount(
            MK_CHEATS_GetCurrentItemPropertyID(), MK_CHEATS_GetCurrentItemPropertySubType())>0);
        MK_GenericDialog_SetConditionRange(31, 32, FALSE);
        MK_GenericDialog_SetCondition(33, TRUE);
        MK_GenericDialog_SetCondition(127, FALSE);
        SetCustomToken(14427, MK_TLK_GetStringByStrRef( GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY") ? -39 : -40 ));
        break;
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_p1lbl", FALSE);
        MK_GenericDialog_SetCondition(100, FALSE);
        MK_GenericDialog_SetCondition(101, TRUE);
        MK_GenericDialog_SetCondition(30, MK_CHEATS_GetCurrentItemPropertyCount(
            MK_CHEATS_GetCurrentItemPropertyID(), MK_CHEATS_GetCurrentItemPropertySubType(), MK_CHEATS_GetCurrentItemPropertyCostTableValue())>0);
        MK_GenericDialog_SetConditionRange(31, 32, FALSE);
        MK_GenericDialog_SetCondition(33, TRUE);
        MK_GenericDialog_SetCondition(127, FALSE);
        SetCustomToken(14427, MK_TLK_GetStringByStrRef( GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY") ? -39 : -40 ));
        break;
    }

    MK_GenericDialog_SetCondition(254, bIsModified);
    MK_GenericDialog_SetCondition(257, bIsModified);

    MK_DELIMITER_Initialize();
    MK_ITEMPROP_SetCustomToken(nState);

//    DisplayDebugOutput(oPC);

    return TRUE;
}
