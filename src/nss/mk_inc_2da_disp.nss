//////////////////////////////////////////////////////////////////////////////
// mk_inc_2da_disp.nss
//////////////////////////////////////////////////////////////////////////////

//#include "x3_inc_string"
#include "mk_inc_debug"
#include "mk_inc_tools"
#include "mk_inc_math"
#include "mk_inc_array"
#include "mk_inc_generic"
#include "mk_inc_tlk"
#include "mk_inc_delimiter"

// const int MK_2DA_DISP_DEBUG = TRUE;
const int MK_2DA_DISP_DEBUG = FALSE;

const int MK_2DA_DISP_USE_CACHE = TRUE;
const int MK_2DA_DISP_CACHE_ITEM_SIZE = 4;

const string MK_2DA_DISP_ITEM_COUNT = "MK_2DA_DISP_ITEM_COUNT";
const string MK_2DA_DISP_CURRENT_PAGE = "MK_2DA_DISP_CURRENT_PAGE";
const string MK_2DA_DISP_ITEMS_PER_PAGE = "MK_2DA_DISP_ITEMS_PER_PAGE";
const string MK_2DA_DISP_2DA_FILENAME = "MK_2DA_DISP_2DA_FILENAME";
const string MK_2DA_DISP_2DA_COL_LABEL = "MK_2DA_DISP_2DA_COL_LABEL";
const string MK_2DA_DISP_2DA_COL_STRREF = "MK_2DA_DISP_2DA_COL_STRREF";
const string MK_2DA_DISP_2DA_COL_NOTEMPTY = "MK_2DA_DISP_2DA_COL_NOTEMPTY";
const string MK_2DA_DISP_2DA_COL_VALUE = "MK_2DA_DISP_2DA_COL_VALUE";

const string MK_2DA_DISP_CURRENT_COLOR = "MK_2DA_DISP_CURRENT_COLOR";
const string MK_2DA_DISP_DEFAULT_COLOR = "MK_2DA_DISP_DEFAULT_COLOR";

const string MK_2DA_DISP_2DA_CACHE = "MK_2DA_DISP_2DA_CACHE";

const string MK_2DA_DISP_CALLBACK_ROW = "MK_2DA_DISP_CALLBACK_ROW";
const string MK_2DA_DISP_CALLBACK_LABEL = "MK_2DA_DISP_CALLBACK_LABEL";
const string MK_2DA_DISP_CALLBACK_CHECK = "MK_2DA_DISP_CALLBACK_CHECK";

const string MK_2DA_DISP_DIALOG_TEXT = "MK_2DA_DISP_2DA_DISLOG_TEXT";

const int MK_2DA_DISP_TOKEN_BASE = 14440;
const int MK_2DA_DISP_TOKEN_CURRENT_PAGE = 14431;
const int MK_2DA_DISP_TOKEN_CURRENT_VALUE = 14430;

const int MK_2DA_DISPLAY_MAX_PAGE_LENGTH = 20;

//////////////////////////////////////////////////////////////////////////////
// Initializes the 2DA display system
// - s2DAfile: name of the 2DA file
// - s2DAColValue: name of the value column (if empty row number is returned
//    by MK_2DA_DISPLAY_GetValueAsInt(). MK_2DA_DISPLAY_GetValueAsString will
//    return an empty string in case s2DAColValue is empty).
// - s2DAColLabel: name of the label column
// - s2DAColStrRef: name of StrRef column
//    if s2DAColStrRef is not empty that column will be used to read the label
//    from tlk. If it's empty the text in s2DAColLabel will be used as label.
// - s2DAColNotEmpty: column that's always not empty so it can be used to
//    get the number of rows in the 2DA file. If s2DAColNotEmpty is empty
//    s2DAColLabel will be used instead.
void MK_2DA_DISPLAY_Initialize(string s2DAFile, string s2DAColValue, string s2DAColLabel, string s2DAColStrRef,
    string s2DAColNotEmpty="", int nAllowedEmptyRowsInARow=10, string sCallbackScript="");


//////////////////////////////////////////////////////////////////////////////
// returns the label for an item
//  - nItem: item whose label should be returned
//  - bShowItemID: if TRUE ' (nItem)' is added to the label
string MK_2DA_DISPLAY_GetItemLabel(int nRow, int bShowItemID = FALSE);


//////////////////////////////////////////////////////////////////////////////
string MK_2DA_DISPLAY_GetValueAsString(int nLine);

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetValueAsInt(int nLine);

//////////////////////////////////////////////////////////////////////////////
void MK_2DA_DISPLAY_DisplayPage(int nPage, int nCurrentValue=-1, string sCallbackScript="", int bShowItemID=TRUE);

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetPageCount();

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetItemCount();

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetPageLength();

//////////////////////////////////////////////////////////////////////////////
void MK_2DA_DISPLAY_SetPageLength(int nPageLength);

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetCurrentPage();

//////////////////////////////////////////////////////////////////////////////
int MK_2DA_DISPLAY_GetMaxPageLength();

//////////////////////////////////////////////////////////////////////////////
void MK_2DA_DISPLAY_SetCurrentPage(int nPage);

//////////////////////////////////////////////////////////////////////////////
string MK_2DA_DISPLAY_GetCache();

//////////////////////////////////////////////////////////////////////////////
void MK_2DA_DISPLAY_SetCache(string sCache);

//////////////////////////////////////////////////////////////////////////////
void MK_2DA_DISPLAY_Initialize(string s2DAFile, string s2DAColValue, string s2DAColLabel, string s2DAColStrRef, string s2DAColNotEmpty, int nAllowedEmptyRowsInARow, string sCallbackScript);

//////////////////////////////////////////////////////////////////////////////
string MK_2DA_DISPLAY_Get2DAFileName();

void MK_2DA_DISPLAY_DEBUG_TRACE(string sMessage)
{
    if (MK_2DA_DISP_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}


string MK_2DA_DISPLAY_GetCache()
{
    return MK_ARRAY_GetLocalArrayBuffer(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE);
//    return GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE);
}

void MK_2DA_DISPLAY_SetCache(string sCache)
{
    MK_ARRAY_SetLocalArrayBuffer(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE, sCache);
//    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE, sCache);
}

int MK_2DA_DISPLAY_GetMaxPageLength()
{
    return MK_2DA_DISPLAY_MAX_PAGE_LENGTH;
}

void MK_2DA_DISPLAY_SetCurrentPage(int nPage)
{
    int nPageCount = MK_2DA_DISPLAY_GetPageCount();
    int nCurrentPage = (nPageCount>0 ? MK_MATH_MinInt(nPage, nPageCount) : nPage);

    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CURRENT_PAGE, nCurrentPage);
//    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CURRENT_PAGE, MK_MATH_MinInt(nPage, MK_2DA_DISPLAY_GetPageCount()));
}

int MK_2DA_DISPLAY_GetCurrentPage()
{
    return GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CURRENT_PAGE);
}

int MK_2DA_DISPLAY_GetPageLength()
{
    return GetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEMS_PER_PAGE);
}

void MK_2DA_DISPLAY_SetPageLength(int nPageLength)
{
    if (nPageLength==-1)
    {
        if (MK_2DA_DISPLAY_GetItemCount()<=MK_2DA_DISPLAY_MAX_PAGE_LENGTH)
        {
            nPageLength = MK_2DA_DISPLAY_MAX_PAGE_LENGTH;
        }
        else
        {
            nPageLength = MK_2DA_DISPLAY_MAX_PAGE_LENGTH-5;
        }
    }
    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEMS_PER_PAGE, nPageLength);
}


int MK_2DA_DISPLAY_GetItemCount()
{
    return GetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEM_COUNT);
}

int MK_2DA_DISPLAY_GetPageCount()
{
    int nPageLength = MK_2DA_DISPLAY_GetPageLength();
    int nPageCount = (nPageLength>0 ? (((MK_2DA_DISPLAY_GetItemCount() - 1) / nPageLength) + 1) : -1);
    return nPageCount;
//    return (((MK_2DA_DISPLAY_GetItemCount() - 1) / MK_2DA_DISPLAY_GetPageLength()) + 1);
}

string MK_2DA_DISPLAY_Get2DAFileName()
{
    return GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME);
}

int MK_2DA_DISPLAY_ItemToRow(int nItem)
{
    int nRow;
    if (nItem==-1)
    {
        nRow = -1;
    }
    else if (MK_2DA_DISP_USE_CACHE)
    {
        nRow = MK_ARRAY_GetLocalArraySortedInt(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE, nItem);
//        string sCache = MK_2DA_DISPLAY_GetCache();
//        int nPos = nItem*MK_2DA_DISP_CACHE_ITEM_SIZE;
//        nRow = StringToInt(GetSubString(sCache, nPos, MK_2DA_DISP_CACHE_ITEM_SIZE));
    }
    else
    {
        nRow = nItem;
    }
    return nRow;
}

int MK_2DA_DISPLAY_RowToItem(int nRow)
{
    int nItem;
    if (nRow==-1)
    {
        nItem=-1;
    }
    else if (MK_2DA_DISP_USE_CACHE)
    {
        nItem = MK_ARRAY_SearchLocalArraySortedInt(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE, nRow);
    }
    else
    {
        nItem = nRow;
    }
    return nItem;
}

string MK_2DA_DISPLAY_GetItemLabel(int nRow, int bShowItemID)
{
//    string sLabel;
    string s2DAFile = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME);
    string sColumnStrRef = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_STRREF);
    string sColumnLabel = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_LABEL);

//    int nRow = MK_2DA_DISPLAY_ItemToRow(nItem);

    string sLabel = MK_TLK_Get2DAStringByStrRef(s2DAFile, nRow, sColumnStrRef, sColumnLabel, GetGender(OBJECT_SELF));

//    int nStrRef = MK_Get2DAInt(s2DAFile, sColumnStrRef, nRow, 0);
//    if (nStrRef!=0)
//    {
//        sLabel = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
//        if (GetStringLeft(sLabel, 9) == "BadStrRef")
//        {
//            sLabel = Get2DAString(s2DAFile, sColumnLabel, nRow);
//        }
//    }
//    else
//    {
//        sLabel = Get2DAString(s2DAFile, sColumnLabel, nRow);
//    }

    if (bShowItemID)
    {
        sLabel += (" ("+IntToString(nRow)+")");
    }
    return sLabel;
}

int MK_2DA_DISPLAY_CalculateItemCount(string s2DAFile, string sColumn, int nAllowedEmptyRowsInARow=10, string sCallbackScript="")
{
    int nCount = 0;
    int nRow = 0;
    int nMaxRow = -1;
    string sValue;
    int bOk;
    int nEmptyRows = 0;
    string sCache = "";
    do
    {
        sValue = Get2DAString(s2DAFile, sColumn, nRow);
//        MK_DEBUG_TRACE("MK_2DA_DISPLAY_CalculateItemCount: s2DA="+s2DAFile+", col="+sColumn+", nRow="+IntToString(nRow)+", sValue="+sValue);
        if (sValue!="")
        {
            bOk = TRUE;
            nEmptyRows = 0;

            if (MK_2DA_DISP_USE_CACHE)
            {
                int bCheck=TRUE;
                if (sCallbackScript!="")
                {
                    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW, nRow);
//                    MK_DEBUG_TRACE("Running callback script '"+sCallbackScript+"'...");
                    ExecuteScript(sCallbackScript);
                    bCheck = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK);
                }

                if (bCheck)
                {
                    sCache+=MK_ARRAY_LocalArraySortedInt_IntToString(nRow);
//                    sCache+=MK_IntToString(nRow, MK_2DA_DISP_CACHE_ITEM_SIZE, "0");
                    nCount++;
                }
            }
            else
            {
                nMaxRow = nRow;
            }
        }
        else
        {
            bOk = ((++nEmptyRows) <= nAllowedEmptyRowsInARow);
        }
//        MK_DEBUG_TRACE("MK_2DA_DISPLAY_CalculateItemCount: nRow="+IntToString(nRow)
//            +", sValue='"+sValue+"', nCount="+IntToString(nCount)+", nMaxRow="
//            +IntToString(nMaxRow));

        nRow++;

    }
    while (bOk);

    if (MK_2DA_DISP_USE_CACHE)
    {
        MK_2DA_DISPLAY_SetCache(sCache);
    }
    else
    {
        nCount = nMaxRow+1;
    }
//    MK_DEBUG_TRACE("MK_2DA_DISPLAY_CalculateItemCount(): "+IntToString(nCount)+".");

    return nCount;
}


void MK_2DA_DISPLAY_Initialize(string s2DAFile, string s2DAColValue, string s2DAColLabel, string s2DAColStrRef, string s2DAColNotEmpty, int nAllowedEmptyRowsInARow, string sCallbackScript)
{
    MK_2DA_DISPLAY_DEBUG_TRACE("Initializing 2DA display system...");
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME, s2DAFile);
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_VALUE, s2DAColValue);
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_LABEL, s2DAColLabel);
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_STRREF, s2DAColStrRef);
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_NOTEMPTY, (s2DAColNotEmpty != "" ? s2DAColNotEmpty : s2DAColLabel));

    if (s2DAFile!="")
    {
        SetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEM_COUNT,
            MK_2DA_DISPLAY_CalculateItemCount(s2DAFile, GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_NOTEMPTY), nAllowedEmptyRowsInARow, sCallbackScript));
    }
    else
    {
        SetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEM_COUNT, 0);
    }

    MK_2DA_DISPLAY_SetCurrentPage(1);
    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEMS_PER_PAGE, 20);
    MK_2DA_DISPLAY_DEBUG_TRACE("2DA display system initialized (nItemCount="+IntToString(MK_2DA_DISPLAY_GetItemCount())+").");
}

void MK_2DA_DISPLAY_InitializeVirtual(string sCache)
{
    MK_2DA_DISPLAY_SetCache(sCache);
    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEM_COUNT, GetStringLength(sCache) / MK_2DA_DISP_CACHE_ITEM_SIZE);
    MK_2DA_DISPLAY_SetCurrentPage(1);
    MK_DEBUG_TRACE("virtual 2DA display system initialized (nItemCount="+IntToString(MK_2DA_DISPLAY_GetItemCount())+").");
}

int MK_2DA_DISPLAY_UpdatePage(int nAction)
{
    int nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
    int nPageCount = MK_2DA_DISPLAY_GetPageCount();
    int nPageOld=nCurrentPage;
    switch (nAction)
    {
        case 250:
            // First Page
            MK_2DA_DISPLAY_SetCurrentPage(nCurrentPage=1);
            break;
        case 251:
            // Prev Page
            if (nCurrentPage>1)
                MK_2DA_DISPLAY_SetCurrentPage(--nCurrentPage);
            break;
        case 252:
            // Next Page
            if (nCurrentPage<nPageCount)
                MK_2DA_DISPLAY_SetCurrentPage(++nCurrentPage);
            break;
        case 253:
            // Last Page
            MK_2DA_DISPLAY_SetCurrentPage(nCurrentPage=nPageCount);
            break;
    }
//    MK_2DA_DISPLAY_DEBUG_TRACE("UpdatePage: nAction="+IntToString(nAction)
//        +", nCurrentPageOld="+IntToString(nPageOld)
//        +", nCurrentPage="+IntToString(nCurrentPage)
//        +", nCurrentPageNow="+IntToString(MK_2DA_DISPLAY_GetCurrentPage()));
    return nCurrentPage;
}

void MK_2DA_DISPLAY_DisplayNavigationOption(int nCondition, int nStrRef, int nToken, int bEnable)
{
    int nPageCount = MK_2DA_DISPLAY_GetPageCount();
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
//        MK_2DA_DISPLAY_DEBUG_TRACE("DispOptions: nToken="+IntToString(nToken)+", sText='"+sText+"', bEnable="+IntToString(bEnable));
    }
    else
    {
        bEnable = FALSE;
    }
    MK_GenericDialog_SetCondition(nCondition, bEnable);
}

void MK_2DA_DISPLAY_DisplayNavigationOptions(int nPage, int nPageCount)
{
    MK_2DA_DISPLAY_DisplayNavigationOption(250, -71, 14402, nPage>1);
    MK_2DA_DISPLAY_DisplayNavigationOption(251, -72, 14403, nPage>1);
    MK_2DA_DISPLAY_DisplayNavigationOption(252, -73, 14404, nPage<nPageCount);
    MK_2DA_DISPLAY_DisplayNavigationOption(253, -74, 14405, nPage<nPageCount);

//    MK_DELIMITER_Initialize(nPageCount>1, 249);
    MK_DELIMITER_Initialize(TRUE, 249);
//    MK_GenericDialog_SetCondition(249, (nPageCount>1) && MK_DELIMITER_GetUseDelimiter());
}

void MK_2DA_DISPLAY_DisplayPage(int nPage, int nCurrentValue, string sCallbackScript, int bShowItemID)
{
    int iLine = 0;
    int nPageLength = MK_2DA_DISPLAY_GetPageLength();
    int nItemCount = MK_2DA_DISPLAY_GetItemCount();
    int nPageCount = MK_2DA_DISPLAY_GetPageCount();
    int nMaxPageLength = MK_2DA_DISPLAY_GetMaxPageLength();
    int iItem = (nPage-1) * nPageLength;

    object oPC = GetPCSpeaker();

    MK_2DA_DISPLAY_DEBUG_TRACE("DisplayPage: nPage="+IntToString(nPage)
        +", nPageCount="+IntToString(nPageCount)
        +", nPageLength="+IntToString(nPageLength)
        +", nItemCount="+IntToString(nItemCount)
        +", iItem="+IntToString(iItem)
        );

    MK_2DA_DISPLAY_DisplayNavigationOptions(nPage, nPageCount);

    string sLabel;
    int bEnable;
    while (iLine<nMaxPageLength)
    {
        if ((iItem<nItemCount) && (iLine < nPageLength))
        {
            sLabel = "";
            int iRow = MK_2DA_DISPLAY_ItemToRow(iItem);
            if (sCallbackScript!="")
            {
//                MK_DEBUG_TRACE("Running callback script '"+sCallbackScript+"'("
//                    +"iItem="+IntToString(iItem)+", iRow="+IntToString(iRow)+") ...");
                SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW, iRow);
                ExecuteScript(sCallbackScript);
                sLabel = GetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL);
            }
            else
            {
                sLabel = MK_2DA_DISPLAY_GetItemLabel(iRow, bShowItemID);
            }

            string sColorTag;
            if (iRow==nCurrentValue)
            {
                sColorTag = GetLocalString(oPC, MK_2DA_DISP_CURRENT_COLOR);
            }
            else
            {
                sColorTag = GetLocalString(oPC, MK_2DA_DISP_DEFAULT_COLOR);
            }
            if (sColorTag!="")
            {
                sLabel = sColorTag+sLabel+"</c>";
            }
//            MK_DEBUG_TRACE("Label("+IntToString(iLine)+")="+sLabel);
            SetCustomToken(MK_2DA_DISP_TOKEN_BASE + iLine, sLabel);
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
    if (MK_2DA_DISP_TOKEN_CURRENT_PAGE>0)
    {
        SetCustomToken(MK_2DA_DISP_TOKEN_CURRENT_PAGE, s);
    }

    if (nCurrentValue!=-1)
    {
        s = MK_2DA_DISPLAY_GetItemLabel(nCurrentValue, TRUE);
    }
    else
    {
        s = "";
    }
    if (MK_2DA_DISP_TOKEN_CURRENT_VALUE>0)
    {
        SetCustomToken(MK_2DA_DISP_TOKEN_CURRENT_VALUE, s);
    }

}

int MK_2DA_DISPLAY_GetSelectedItem(int nLine)
{
    int nPageLength = MK_2DA_DISPLAY_GetPageLength();
    if ((nLine<0) || (nLine>=nPageLength))
    {
        return -1;
    }
    return ((MK_2DA_DISPLAY_GetCurrentPage()-1) * nPageLength) + nLine;
}

int MK_2DA_DISPLAY_GetSelectedRow(int nLine)
{
    return MK_2DA_DISPLAY_ItemToRow(MK_2DA_DISPLAY_GetSelectedItem(nLine));
}

string MK_2DA_DISPLAY_GetValueAsString(int nLine)
{
    string sResult = "";
    int nRow = MK_2DA_DISPLAY_GetSelectedRow(nLine);

    string sColValue = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_VALUE);
    if (sColValue!="")
    {
        string s2DAFile = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME);
        sResult = Get2DAString(s2DAFile, sColValue, nRow);
    }
    return sResult;
}

int MK_2DA_DISPLAY_GetValueAsInt(int nLine)
{
    int nResult = MK_2DA_DISPLAY_GetSelectedRow(nLine);
    string sColValue = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_VALUE);
    if (sColValue!="")
    {
        string s2DAFile = GetLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME);
        nResult = StringToInt(Get2DAString(s2DAFile, sColValue, nResult));
    }
    return nResult;
}

int MK_2DA_DISPLAY_EnsureVisible(int nRow)
{
    int nItem = MK_2DA_DISPLAY_RowToItem(nRow);
    int nCurrentPage = ( (nItem!=-1) ? (nItem / MK_2DA_DISPLAY_GetPageLength()) + 1 : MK_2DA_DISPLAY_GetCurrentPage() );
//   MK_2DA_DISPLAY_DEBUG_TRACE("MK_2DA_DISPLAY_EnsureVisible: nRow="+IntToString(nRow)
//        +", nItem="+IntToString(nItem)
//        +", PageLength="+IntToString(MK_2DA_DISPLAY_GetPageLength())
//        +", nCurPage="+IntToString(nCurrentPage));
    MK_2DA_DISPLAY_SetCurrentPage(nCurrentPage);
    return nCurrentPage;
}

void MK_2DA_DISPLAY_Cleanup()
{
    DeleteLocalInt(OBJECT_SELF, MK_2DA_DISP_CURRENT_PAGE);
    DeleteLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEMS_PER_PAGE);
    DeleteLocalInt(OBJECT_SELF, MK_2DA_DISP_ITEM_COUNT);
    DeleteLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_FILENAME);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_VALUE);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_LABEL);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_STRREF);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_COL_NOTEMPTY);
    DeleteLocalString(OBJECT_SELF, MK_2DA_DISP_2DA_CACHE);
}
