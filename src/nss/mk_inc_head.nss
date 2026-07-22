/////////////////////////////////////////////////////////////////////////////
//
// mk_inc_head.nss
//
/////////////////////////////////////////////////////////////////////////////

#include "mk_inc_debug"
#include "mk_inc_tools"
#include "mk_inc_array"
#include "mk_inc_body"

// name of the local that stores the  head filter definition 2da file
const string MK_DEF_HEAD = "mk_def_head";

const string MK_HEAD_MAX_HEAD_ID = "MK_HEAD_MAX_ID";

const string MK_HEAD_SELECTED_FILTER = "MK_HEAD_SELECTED_FILTER";

const string MK_HEAD_VALID_HEADS = "MK_HEAD_VALID_HEADS";

const string MK_HEAD_DISABLE_CHANGE_FILTER = "MK_HEAD_DISABLE_CHANGE_FILTER";
const string MK_HEAD_DEFAULT_FILTER = "MK_HEAD_DEFAULT_FILTER";

const int MK_HEAD_NEXT = 1;
const int MK_HEAD_PREV = 2;
const int MK_HEAD_MODEL = 3;

/////////////////////////////////////////////////////////////////////////////

// initializes the head filter system
// sets the 2da file used (mk_sys_head.2da or mk_def_head.2da)
// returns FALSE if none of these files were found.
int MK_HEAD_Initialize(object oPC, object oTarget);

// returns the 2DA file used to store the valid filters (mk_sys_head or mk_def_head)
string MK_HEAD_Get2DAFile(object oPC);

// returns the max head ID. If no max head ID is set then 255 is returned
int MK_HEAD_GetMaxHeadID(object oPC);

// returns Get2DAString("mk_def_head", "2DAFILE", nFilterID)
string MK_HEAD_GetFilter2DAFile(object oPC, int nFilterID);

// returns RacialType_Gender
string MK_HEAD_GetBaseColumn(object oTarget);

// returns the column name for the specified object (racialtype, gender) and
// the specified filter ID (row in "mk_def_head")
string MK_HEAD_GetColumn(object oPC, object oTarget, int nFilterID);

// returns TRUE if the specified filter provides no heads for oTarget
int MK_HEAD_GetIsFilterEmpty(object oPC, object oTarget, int nFilterID);

// sets the head model to be used on the creature specified
// - oTarget: the creature to change the head for
// - nMode: MK_HEAD_NEXT: next valid head model number
//          MK_HEAD_PREV: previous valid head model number
//          MK_HEAD_MODEL: set head model number to nModelNumber
// - nModelNumber: model number used for mode MK_HEAD_MODEL
int MK_HEAD_SetCreatureHead(object oTarget, int nMode, int nModelNumber=-1);

string MK_HEAD_GetSelectedFilterAsText(object oPC, object oTarget);

// creates the valid heads string for oTarget on oTarget
string MK_HEAD_CreateValidHeadsString(object oTarget, object oPC);

string MK_HEAD_GetSelectedFilterString(object oTarget);

void MK_HEAD_SetSelectedFilterString(object oTarget, string sSelectedFilter);


int MK_HEAD_GetMaxHeadID(object oPC)
{
    int nMaxID = GetLocalInt(oPC, MK_HEAD_MAX_HEAD_ID);
    if (nMaxID==0)
    {
        nMaxID = 255;
    }
    return nMaxID;
}


int MK_HEAD_Initialize(object oPC, object oTarget)
{
    MK_DEBUG_TRACE("MK_HEAD:Initialize('"+GetName(oPC)+"')");
    int bReturn = TRUE;
    string s2DA = "mk_def_head";
    if (Get2DAString(s2DA, "NAME", 0) == "MK_HEAD_DEFAULT")
    {
        MK_DEBUG_TRACE(" > "+s2DA+".2DA found ("+Get2DAString(s2DA, "NAME", 0)+").");
        SetLocalString(oPC, MK_DEF_HEAD, s2DA);
    }
    else
    {
        s2DA = "mk_sys_head";
        if (Get2DAString(s2DA, "NAME", 0) == "MK_HEAD_DEFAULT")
        {
            MK_DEBUG_TRACE(" > "+s2DA+".2DA found.");
            SetLocalString(oPC, MK_DEF_HEAD, s2DA);
        }
        else
        {
            MK_DEBUG_TRACE(" > "+s2DA+".2DA not found.");
            DeleteLocalString(oPC, MK_DEF_HEAD);
            SendMessageToPC(oPC, "Head filter definition files 'mk_def_head.2da' or 'mk_sys_head.2da' not found!");
            bReturn = FALSE;
        }
    }
    if (MK_HEAD_GetSelectedFilterString(oTarget)=="")
    {
        MK_HEAD_SetSelectedFilterString(oTarget, GetLocalString(oPC, MK_HEAD_DEFAULT_FILTER));
    }
    return bReturn;
}

string MK_HEAD_Get2DAFile(object oPC)
{
    return GetLocalString(oPC, MK_DEF_HEAD);
}

int MK_HEAD_GetIsCCOHFilter(object oPC, int nFilterID)
{
    return MK_Get2DAInt(MK_HEAD_Get2DAFile(oPC), "CCOH", nFilterID);
}

string MK_HEAD_GetFilter2DAFile(object oPC, int nFilterID)
{
    return Get2DAString(MK_HEAD_Get2DAFile(oPC), "2DAFILE", nFilterID);
}

string MK_HEAD_GetBaseColumn(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);
    int nGender = GetGender(oTarget);
    string sColumn = Get2DAString("racialtypes", "Label", nRacialType)
                        +"_"
                        +MK_GetGenderAsString(oTarget);
    return sColumn;
}

string MK_HEAD_GetColumn(object oPC, object oTarget, int nFilterID)
{
    string sBaseColumn = MK_HEAD_GetBaseColumn(oTarget);
    string sColumn = Get2DAString(MK_HEAD_Get2DAFile(oPC), sBaseColumn, nFilterID);
    if (sColumn=="")
    {
        sColumn = sBaseColumn;
    }
    return sColumn;
}

string MK_HEAD_GetFilterLabel(object oPC, int nFilterID, object oTarget = OBJECT_SELF)
{
    string sLabel="";
    string s2DA = MK_HEAD_Get2DAFile(oPC);
    int nStrRef = MK_Get2DAInt(s2DA, "STRREF", nFilterID);
    if (nStrRef!=0)
    {
        sLabel = MK_TLK_GetStringByStrRef(nStrRef, GetGender(oTarget));
    }
    else
    {
        sLabel = Get2DAString(s2DA, "LABEL", nFilterID);
    }
    return sLabel;
}

int MK_HEAD_GetIsFilterEmpty(object oPC, object oTarget, int nFilterID)
{
    string s2DAFile = MK_HEAD_GetFilter2DAFile(oPC, nFilterID);

    if (MK_Get2DAInt(s2DAFile, "DISABLE", FALSE))
    {
        return TRUE;
    }

    string sColumn = MK_HEAD_GetColumn(oPC, oTarget, nFilterID);

//    MK_DEBUG_TRACE("MK_HEAD_GetIsFilterEmpty("+IntToString(nFilterID)+"): s2DAfile='"+s2DAFile+"', sColumn='"+sColumn+"', CCOH="+(MK_HEAD_GetIsCCOHFilter(oPC, nFilterID) ? "J" : "N"));

    if (MK_HEAD_GetIsCCOHFilter(oPC, nFilterID))
    {
        if (Get2DAString(s2DAFile, sColumn, 256)=="")
        {
            return TRUE;
        }
    }

//    MK_DEBUG_TRACE("MK_HEAD_GetIsFilterEmpty: s2DAFile='"+s2DAFile+"', sColumn='"+sColumn+"'");
    int iRow;
//    MK_DEBUG_TRACE(" > MaxHeadID="+IntToString(MK_HEAD_GetMaxHeadID(oPC)));

    for (iRow=1; iRow<=MK_HEAD_GetMaxHeadID(oPC); iRow++)
    {
        if (Get2DAString(s2DAFile, sColumn, iRow)!="")
        {
//            MK_DEBUG_TRACE(" > iRow="+IntToString(iRow)+", sValue='"+Get2DAString(s2DAFile, sColumn, iRow)+"'");
            return FALSE;
        }
    }
    return TRUE;
}

string MK_HEAD_GetSelectedFilterString(object oTarget)
{
    return GetLocalString(oTarget, MK_HEAD_SELECTED_FILTER);
}

int MK_HEAD_GetFilterCount(object oTarget)
{
    return MK_ARRAY_GetLocalArrayBoolLength(oTarget, MK_HEAD_SELECTED_FILTER);
}

void MK_HEAD_SetSelectedFilterString(object oTarget, string sSelectedFilter)
{
    SetLocalString(oTarget, MK_HEAD_SELECTED_FILTER, sSelectedFilter);
}

void MK_HEAD_SelectFilter(object oTarget, int nFilterID, int bSelect)
{
    MK_ARRAY_SetLocalArrayBool(oTarget, MK_HEAD_SELECTED_FILTER, nFilterID, bSelect);
}

int MK_HEAD_GetIsFilterSelected(object oTarget, int nFilterID)
{
    return MK_ARRAY_GetLocalArrayBool(oTarget, MK_HEAD_SELECTED_FILTER, nFilterID);
}

string MK_HEAD_GetSelectedFilterAsText(object oPC, object oTarget)
{
    string sSelectedFilter = MK_HEAD_GetSelectedFilterString(oTarget);
    string s="";
    int nLen = MK_HEAD_GetFilterCount(oTarget);
    int iFilter;
//    MK_DEBUG_TRACE("MK_HEAD_GetSelectedFilterAsText: sSelectedFilter='"+sSelectedFilter+"', nLen="+IntToString(nLen));
    for (iFilter=0; iFilter<nLen; iFilter++)
    {
        if (MK_HEAD_GetIsFilterSelected(oTarget, iFilter))
        {
            s += MK_HEAD_GetFilterLabel(oPC, iFilter, oTarget);
            s += ", ";
        }
    }
    if (s=="")
    {
        s = "none";
    }
    else
    {
        s = GetStringLeft(s, GetStringLength(s)-2);
    }
//    MK_DEBUG_TRACE(" > sToken='"+s+"'");
    return s;
}

int MK_HEAD_ToggleFilter(object oTarget, int nFilterID)
{
    int bSelect = !MK_HEAD_GetIsFilterSelected(oTarget, nFilterID);
    MK_HEAD_SelectFilter(oTarget, nFilterID, bSelect);
    return bSelect;
}

string MK_HEAD_GetHeadsString(object oPC, object oTarget, int nFilterID, string sHeadsString="")
{
    string s2DAFile =  MK_HEAD_GetFilter2DAFile(oPC, nFilterID);
    string sColumn = MK_HEAD_GetColumn(oPC, oTarget, nFilterID);
    string s="";
    int nLength = GetStringLength(sHeadsString);
    int iRow;
    for (iRow=0; iRow<MK_HEAD_GetMaxHeadID(oPC); iRow++)
    {
        string sValue = Get2DAString(s2DAFile, sColumn, iRow);
        if ((sValue!="") ||
            ((iRow<nLength) && (GetSubString(sHeadsString, iRow, 1)=="1") ) )
        {
            s+="1";
        }
        else
        {
            s+="0";
        }
    }
    return s;
}

void MK_HEAD_SetValidHeadsString(object oTarget, string sValidHeads)
{
    MK_ARRAY_SetLocalArrayBuffer(oTarget, MK_HEAD_VALID_HEADS, sValidHeads);
//    SetLocalString(oPC, MK_HEAD_VALID_HEADS, sValidHeads);
}

string MK_HEAD_GetValidHeadsString(object oTarget)
{
    return MK_ARRAY_GetLocalArrayBuffer(oTarget, MK_HEAD_VALID_HEADS);
//    return GetLocalString(oPC, MK_HEAD_VALID_HEADS);
}

string MK_HEAD_CreateValidHeadsString(object oTarget, object oPC)
{
    string sSelectedFilter = MK_HEAD_GetSelectedFilterString(oTarget);
    int nFilterCount = GetStringLength(sSelectedFilter);
//    MK_DEBUG_TRACE("MK_HEAD_CreateValidHeadsString: sSelectedFilter='"+sSelectedFilter+"', nCount="+IntToString(nFilterCount));
    int iFilter;
    string sHeadsString="";
    int nCount=0;
    for (iFilter=0; iFilter<nFilterCount; iFilter++)
    {
        if (MK_HEAD_GetIsFilterSelected(oTarget, iFilter))
        {
            sHeadsString = MK_HEAD_GetHeadsString(oPC, oTarget, iFilter, sHeadsString);
//            MK_DEBUG_TRACE(" > sHeadsString='"+sHeadsString+"'");
            nCount++;
        }
    }
    int iHeads;
    string sValidHeads = "";
    if (nCount>0)
    {
        int nHeadCount = GetStringLength(sHeadsString);
        for (iHeads=0; iHeads<nHeadCount; iHeads++)
        {
            if (GetSubString(sHeadsString, iHeads, 1)=="1")
            {
                sValidHeads+=MK_ARRAY_LocalArraySortedInt_IntToString(iHeads);
            }
        }
    }
    else
    {
        int nHeadCount = MK_HEAD_GetMaxHeadID(oPC)+1;
        for (iHeads=1; iHeads<nHeadCount; iHeads++)
        {
            sValidHeads+=MK_ARRAY_LocalArraySortedInt_IntToString(iHeads);
        }
    }
    MK_HEAD_SetValidHeadsString(oTarget, sValidHeads);
    return sValidHeads;
}

int MK_HEAD_SearchModelNumber(object oTarget, int nModelNumber)
{
    return MK_ARRAY_SearchLocalArraySortedInt(oTarget, MK_HEAD_VALID_HEADS, nModelNumber);
}

int MK_HEAD_SetCreatureHead(object oTarget, int nMode, int nModelNumber)
{
    int nReturn = -1;
//    MK_DEBUG_TRACE("MK_HEAD_SetCreatureHead:");
    switch (nMode)
    {
    case MK_HEAD_MODEL:
        SetCreatureBodyPart(CREATURE_PART_HEAD, nModelNumber, oTarget);
        nReturn = nModelNumber;
        break;
    case MK_HEAD_NEXT:
    case MK_HEAD_PREV:
    {
        int nCurrent = GetCreatureBodyPart(CREATURE_PART_HEAD, oTarget);
        int nPosCurrent = MK_HEAD_SearchModelNumber(oTarget, nCurrent);
        int nPosNew, nNew;
        int nHeadCount = MK_ARRAY_GetLocalArraySortedIntLength(oTarget, MK_HEAD_VALID_HEADS);

        if (nPosCurrent==-1)
        {
            nPosNew = 0;
        }
        else
        {
            switch (nMode)
            {
            case MK_HEAD_PREV:
                nPosNew = (nPosCurrent + nHeadCount - 1) % nHeadCount;
                break;
            case MK_HEAD_NEXT:
                nPosNew = (nPosCurrent + 1) % nHeadCount;
                break;
            }
        }

        if (nPosNew>=0)
        {
            nNew = MK_ARRAY_GetLocalArraySortedInt(oTarget, MK_HEAD_VALID_HEADS, nPosNew);
        }

        if (nNew!=-1)
        {
            SetCreatureBodyPart(CREATURE_PART_HEAD, nNew, oTarget);
            nReturn = nNew;
        }
//        MK_DEBUG_TRACE(" > nCurrent="+IntToString(nCurrent)+
//            ", ValidHeads='"+sValidHeads+"', nPos="+IntToString(nPos)+
//            ", nNew="+IntToString(nNew));

        break;
    }
    }
    return nReturn;
}


/*
void main()
{
}
/**/

