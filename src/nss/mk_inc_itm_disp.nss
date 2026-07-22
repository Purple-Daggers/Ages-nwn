#include "mk_inc_debug"
#include "mk_inc_tools"
#include "mk_inc_math"
#include "mk_inc_generic"
#include "mk_inc_delimiter"
#include "mk_inc_iprp"
#include "mk_inc_tlk"

const int MK_ITM_DISPLAY_DEBUG = FALSE;

const string MK_ITM_DISP_ITEM_COUNT = "MK_ITM_DISP_ITEM_COUNT";
const string MK_ITM_DISP_CURRENT_PAGE = "MK_ITM_DISP_CURRENT_PAGE";
const string MK_ITM_DISP_ITEMS_PER_PAGE = "MK_ITM_DISP_ITEMS_PER_PAGE";

const string MK_ITM_DISP_CALLBACK_CHECK = "MK_ITM_DISP_CALLBACK_CHECK";
const string MK_ITM_DISP_CALLBACK_LABEL = "MK_ITM_DISP_CALLBACK_LABEL";
const string MK_ITM_DISP_CALLBACK_OBJECT = "MK_ITM_DISP_CALLBACK_OBJECT";

const string MK_ITM_DISP_ITEMS = "MK_ITM_DISP_ITEM_";

const int MK_ITM_DISP_MAX_PAGE_LENGTH = 20;

const int MK_ITM_DISP_SLOTS = 1;
const int MK_ITM_DISP_INVENTORY = 2;
const int MK_ITM_DISP_ALL = 3;
const int MK_ITM_DISP_HIDDENSLOTS = 4;

const int MK_ITM_DISP_DISALLOW_UNIDENTIFIED = 256;
const int MK_ITM_DISP_DISALLOW_PLOTITEMS = 512;

const int MK_ITM_DISP_TOKEN_BASE = 14440;
const int MK_ITM_DISP_TOKEN_CURRENT_PAGE = 14431;´

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_UpdatePage(int nAction);

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_DisplayPage(int nPage, string sCallbackScript="");

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_GetPageCount();

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_GetItemCount();

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_GetPageLength();

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_SetPageLength(int nPageLength);

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_GetCurrentPage();

//////////////////////////////////////////////////////////////////////////////
int MK_ITM_DISPLAY_GetMaxPageLength();

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_SetCurrentPage(int nPage);

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_SetItemCount(int nItemCount);

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_SetItem(object oItem, int nPos);

//////////////////////////////////////////////////////////////////////////////
object MK_ITM_DISPLAY_GetItem(int nPos);

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_Cleanup();


void MK_ITM_DISPLAY_DEBUG_TRACE(string sMessage)
{
    if (MK_ITM_DISPLAY_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}


int MK_ITM_DISPLAY_GetMaxPageLength()
{
    return MK_ITM_DISP_MAX_PAGE_LENGTH;
}

void MK_ITM_DISPLAY_SetCurrentPage(int nPage)
{
    int nPageCount = MK_ITM_DISPLAY_GetPageCount();
    int nCurrentPage = (nPageCount>0 ? MK_MATH_MinInt(nPage, nPageCount) : nPage);

    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_CURRENT_PAGE, nCurrentPage);
}

int MK_ITM_DISPLAY_GetCurrentPage()
{
    return GetLocalInt(OBJECT_SELF, MK_ITM_DISP_CURRENT_PAGE);
}

int MK_ITM_DISPLAY_GetPageLength()
{
    return GetLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEMS_PER_PAGE);
}

void MK_ITM_DISPLAY_SetPageLength(int nPageLength)
{
    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEMS_PER_PAGE, nPageLength);
}

void MK_ITM_DISPLAY_SetItemCount(int nItemCount)
{
    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEM_COUNT, nItemCount);
}

int MK_ITM_DISPLAY_GetItemCount()
{
    return GetLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEM_COUNT);
}

int MK_ITM_DISPLAY_GetPageCount()
{
    int nPageLength = MK_ITM_DISPLAY_GetPageLength();
    int nPageCount = (nPageLength>0 ? (((MK_ITM_DISPLAY_GetItemCount() - 1) / nPageLength) + 1) : -1);
    return nPageCount;
}

void MK_ITM_DISPLAY_SetItem(object oItem, int nPos)
{
    SetLocalObject(OBJECT_SELF, MK_ITM_DISP_ITEMS + MK_IntToString(nPos, 3, "0"), oItem);
}

object MK_ITM_DISPLAY_GetItem(int nPos)
{
    return GetLocalObject(OBJECT_SELF, MK_ITM_DISP_ITEMS + MK_IntToString(nPos, 3, "0"));
}

int _MK_DISP_AppendItem(int nPos, object oItem, int nBaseItemType, int nMode, string sCallbackScript)
{
    int nResult=FALSE;

    int bAppend=FALSE;
    if (!GetIsObjectValid(oItem))
    {
        bAppend = FALSE;
    }
    else if (GetLocalInt(oItem, "MK_ITEM_DESTROYED")==1)
    {
//      Item is about to be destroyed
//        bAppend = FALSE;
    }
    else if ((nBaseItemType!=BASE_ITEM_INVALID) && (nBaseItemType!=GetBaseItemType(oItem)))
    {
//      wrong baseitem type
//        bAppend = FALSE;
    }
    else if ((nMode & MK_ITM_DISP_DISALLOW_UNIDENTIFIED) && !GetIdentified(oItem))
    {
        SendMessageToPC(OBJECT_SELF, MK_IPRP_GetItemName(oItem)+" not allowed (*unidentified*)!");
//        bAppend = FALSE;
    }
    else if ((nMode & MK_ITM_DISP_DISALLOW_PLOTITEMS) && GetPlotFlag(oItem))
    {
        SendMessageToPC(OBJECT_SELF, MK_IPRP_GetItemName(oItem)+" not allowed (*plot item*)!");
//        bAppend = FALSE;
    }
    else if (sCallbackScript!="")
    {
        SetLocalObject(OBJECT_SELF, MK_ITM_DISP_CALLBACK_OBJECT, oItem);
        ExecuteScript(sCallbackScript, OBJECT_SELF);
        bAppend = GetLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK);
        DeleteLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK);
        DeleteLocalObject(OBJECT_SELF, MK_ITM_DISP_CALLBACK_OBJECT);
    }
    else
    {
        bAppend = TRUE;
    }

    if (bAppend)
    {
        MK_ITM_DISPLAY_SetItem(oItem, nPos);
        nResult=TRUE;
    }
    MK_ITM_DISPLAY_DEBUG_TRACE("_MK_DISP_AppendItem("+IntToString(nPos)+", '"+GetName(oItem)+"', "+IntToString(nBaseItemType)+", '"+sCallbackScript+"')");
    return nResult;
}

void MK_ITM_DISPLAY_Initialize(int nBaseItemType, int nMode= MK_ITM_DISP_ALL, int nPageLength=MK_ITM_DISP_MAX_PAGE_LENGTH, string sCallbackScript="")
{
//    MK_DEBUG_TRACE("MK_ITM_DISPLAY_Initialize("+IntToString(nBaseItemType)+", "+IntToString(nMode)+", "+IntToString(nPageLength)+", '"+sCallbackScript+"')");
    object oPC = OBJECT_SELF;
    int nItemCount=0;
    if (nMode & (MK_ITM_DISP_SLOTS | MK_ITM_DISP_HIDDENSLOTS))
    {
        int iSlot;
        for (iSlot=0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
        {
            switch (iSlot)
            {
            case INVENTORY_SLOT_CARMOUR:
            case INVENTORY_SLOT_CWEAPON_B:
            case INVENTORY_SLOT_CWEAPON_L:
            case INVENTORY_SLOT_CWEAPON_R:
                if (nMode & MK_ITM_DISP_HIDDENSLOTS)
                {
                    if (_MK_DISP_AppendItem(nItemCount, GetItemInSlot(iSlot, oPC), nBaseItemType, nMode, sCallbackScript))
                    {
                        nItemCount++;
                    }
                }
                break;
            default:
                if (nMode & MK_ITM_DISP_SLOTS)
                {
                    if (_MK_DISP_AppendItem(nItemCount, GetItemInSlot(iSlot, oPC), nBaseItemType, nMode, sCallbackScript))
                    {
                        nItemCount++;
                    }
                }
                break;
            }
        }
    }
    if (nMode & MK_ITM_DISP_INVENTORY)
    {
        object oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (_MK_DISP_AppendItem(nItemCount, oItem, nBaseItemType, nMode, sCallbackScript))
            {
                nItemCount++;
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }

    MK_ITM_DISPLAY_SetItemCount(nItemCount);
    MK_ITM_DISPLAY_SetPageLength(nPageLength);
    MK_ITM_DISPLAY_SetCurrentPage(1);
}

//////////////////////////////////////////////////////////////////////////////

int MK_ITM_DISPLAY_UpdatePage(int nAction)
{
    int nCurrentPage = MK_ITM_DISPLAY_GetCurrentPage();
    int nPageCount = MK_ITM_DISPLAY_GetPageCount();
    int nPageOld=nCurrentPage;
    switch (nAction)
    {
        case 250:
            // First Page
            MK_ITM_DISPLAY_SetCurrentPage(nCurrentPage=1);
            break;
        case 251:
            // Prev Page
            if (nCurrentPage>1)
                MK_ITM_DISPLAY_SetCurrentPage(--nCurrentPage);
            break;
        case 252:
            // Next Page
            if (nCurrentPage<nPageCount)
                MK_ITM_DISPLAY_SetCurrentPage(++nCurrentPage);
            break;
        case 253:
            // Last Page
            MK_ITM_DISPLAY_SetCurrentPage(nCurrentPage=nPageCount);
            break;
    }
//    MK_DEBUG_TRACE("UpdatePage: nAction="+IntToString(nAction)
//        +", nCurrentPageOld="+IntToString(nPageOld)
//        +", nCurrentPage="+IntToString(nCurrentPage)
//        +", nCurrentPageNow="+IntToString(MK_2DA_DISPLAY_GetCurrentPage()));
    return nCurrentPage;
}

//////////////////////////////////////////////////////////////////////////////
void MK_ITM_DISPLAY_DisplayNavigationOption(int nCondition, int nStrRef, int nToken, int bEnable)
{
    int nPageCount = MK_ITM_DISPLAY_GetPageCount();
    if (nPageCount>1)
    {
        string sText = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
        if (!bEnable)
        {
            string sColorTag = GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR);
            if (sColorTag!="")
            {
                sText = sColorTag + sText + "</c>";
                //StringToRGBString(sText, sRGB);
                bEnable = TRUE;
            }
        }

        SetCustomToken(nToken, sText);
//        MK_DEBUG_TRACE("DispOptions: nToken="+IntToString(nToken)+", sText='"+sText+"', bEnable="+IntToString(bEnable));
    }
    else
    {
        bEnable = FALSE;
    }
    MK_GenericDialog_SetCondition(nCondition, bEnable);
}

void MK_ITM_DISPLAY_HideNavigationOptions()
{
    MK_GenericDialog_SetConditionRange(249, 253, FALSE);
}

void MK_ITM_DISPLAY_DisplayNavigationOptions(int nPage, int nPageCount)
{
    MK_ITM_DISPLAY_DisplayNavigationOption(250, -71, 14402, nPage>1);
    MK_ITM_DISPLAY_DisplayNavigationOption(251, -72, 14403, nPage>1);
    MK_ITM_DISPLAY_DisplayNavigationOption(252, -73, 14404, nPage<nPageCount);
    MK_ITM_DISPLAY_DisplayNavigationOption(253, -74, 14405, nPage<nPageCount);

    MK_DELIMITER_Initialize(nPageCount>1, 249);
//    MK_GenericDialog_SetCondition(249, (nPageCount>1) && MK_DELIMITER_GetUseDelimiter());
}

void MK_ITM_DISPLAY_HidePage()
{
    MK_ITM_DISPLAY_HideNavigationOptions();

    MK_GenericDialog_SetConditionRange(0, MK_ITM_DISPLAY_GetMaxPageLength()-1, FALSE);

    SetCustomToken(MK_ITM_DISP_TOKEN_CURRENT_PAGE, "");
}

void MK_ITM_DISPLAY_DisplayPage(int nPage, string sCallbackScript)
{
    int iLine = 0;
    int nPageLength = MK_ITM_DISPLAY_GetPageLength();
    int nItemCount = MK_ITM_DISPLAY_GetItemCount();
    int nPageCount = MK_ITM_DISPLAY_GetPageCount();
    int nMaxPageLength = MK_ITM_DISPLAY_GetMaxPageLength();
    int iItem = (nPage-1) * nPageLength;

    MK_ITM_DISPLAY_DEBUG_TRACE("DisplayPage: nPage="+IntToString(nPage)
        +", nPageCount="+IntToString(nPageCount)
        +", nPageLength="+IntToString(nPageLength)
        +", nItemCount="+IntToString(nItemCount)
        +", iItem="+IntToString(iItem)
        );

    MK_ITM_DISPLAY_DisplayNavigationOptions(nPage, nPageCount);

    string sLabel;
    int bEnable;
    object oItem;
    while (iLine<nMaxPageLength)
    {
        if ((iItem<nItemCount) && (iLine < nPageLength))
        {
            oItem = MK_ITM_DISPLAY_GetItem(iItem);
            sLabel = "";
            if (sCallbackScript!="")
            {
//                MK_DEBUG_TRACE("Running callback script '"+sCallbackScript+"'("
//                    +"iItem="+IntToString(iItem)+", iRow="+IntToString(iRow)+") ...");
                SetLocalObject(OBJECT_SELF, MK_ITM_DISP_CALLBACK_OBJECT, oItem);
                ExecuteScript(sCallbackScript);
                DeleteLocalObject(OBJECT_SELF, MK_ITM_DISP_CALLBACK_OBJECT);
                sLabel = GetLocalString(OBJECT_SELF, MK_ITM_DISP_CALLBACK_LABEL);
            }
            else
            {
                sLabel = MK_IPRP_GetItemName(oItem, TRUE);
            }
/*
            string sColorTag;
            if (iRow==nCurrentValue)
            {
                sColorTag = GetLocalString(OBJECT_SELF, MK_2DA_DISP_CURRENT_COLOR);
            }
            else
            {
                sColorTag = GetLocalString(OBJECT_SELF, MK_2DA_DISP_DEFAULT_COLOR);
            }
            if (sColorTag!="")
            {
                sLabel = sColorTag+sLabel+"</c>";
            }
*/
//            MK_DEBUG_TRACE("Label("+IntToString(iLine)+")="+sLabel);
            SetCustomToken(MK_ITM_DISP_TOKEN_BASE + iLine, sLabel);
            bEnable = TRUE;
        }
        else
        {
            bEnable = FALSE;
        }

        MK_GenericDialog_SetCondition(iLine, bEnable);

        iItem++;
        iLine++;
    }

    string s = "";
    if (nPageCount>1)
    {
        s = "\n"+MK_TLK_GetStringByStrRef(-75)+" "+IntToString(nPage)+"/"+IntToString(nPageCount);
    }
    if (MK_ITM_DISP_TOKEN_CURRENT_PAGE>0)
    {
        SetCustomToken(MK_ITM_DISP_TOKEN_CURRENT_PAGE, s);
    }
/*
    if (nCurrentValue!=-1)
    {
        s = MK_ITM_DISPLAY_GetItemLabel(nCurrentValue, TRUE);
    }
    else
    {
        s = "";
    }
    if (MK_ITM_DISP_TOKEN_CURRENT_VALUE>0)
    {
        SetCustomToken(MK_2DA_DISP_TOKEN_CURRENT_VALUE, s);
    }
*/
}

//////////////////////////////////////////////////////////////////////////////

object MK_ITM_DISPLAY_GetSelectedItem(int nLine)
{
    int nPageLength = MK_ITM_DISPLAY_GetPageLength();
    if ((nLine<0) || (nLine>=nPageLength))
    {
        return OBJECT_INVALID;
    }
    int iItem = ((MK_ITM_DISPLAY_GetCurrentPage()-1) * nPageLength) + nLine;
    return MK_ITM_DISPLAY_GetItem(iItem);
}

//////////////////////////////////////////////////////////////////////////////

void MK_ITM_DISPLAY_Cleanup()
{
    int nItemCount = MK_ITM_DISPLAY_GetItemCount();
    int iItem;
    for (iItem=0; iItem<nItemCount; iItem++)
    {
        DeleteLocalObject(OBJECT_SELF, MK_ITM_DISP_ITEMS + MK_IntToString(iItem, 3, "0"));
    }
    DeleteLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEM_COUNT);
    DeleteLocalInt(OBJECT_SELF, MK_ITM_DISP_CURRENT_PAGE);
    DeleteLocalInt(OBJECT_SELF, MK_ITM_DISP_ITEMS_PER_PAGE);
}

/**
void main()
{
}
/**/
