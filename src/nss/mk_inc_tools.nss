//::///////////////////////////////////////////////
//:: FileName mk_inc_tools
//:: Copyright (c) 2008 Kamiryn
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Kamiryn
//:: Created On: 08.03.2008
//:://////////////////////////////////////////////

// mk_inc_tools

#include "mk_inc_debug"


// ----------------------------------------------------------------------------
// Converts an integer to a right aligned string with length nLen, prefixed with c
// ----------------------------------------------------------------------------
string MK_IntToString(int nInteger, int nLen, string c=" ");

// ----------------------------------------------------------------------------
// Gets a value from a 2DA file on the server and returns it as a integer
// - s2DA: the name of the 2da file, 16 chars max
// - sColumn: the name of the column in the 2da
// - nRow: the row in the 2da
// - nDefault: default value
// * returns the default value if Get2DAString(s2DA, sColumn, nRow) would
// * return an empty string
// ----------------------------------------------------------------------------
int MK_Get2DAInt(string s2DA, string sColumn, int nRow, int nDefault=0);

// ----------------------------------------------------------------------------
// Gets a value from a 2DA file on the server and returns it as a float
// - s2DA: the name of the 2da file, 16 chars max
// - sColumn: the name of the column in the 2da
// - nRow: the row in the 2da
// - fDefault: default value
// * returns the default value if Get2DAString(s2DA, sColumn, nRow) would
// * return an empty string
// ----------------------------------------------------------------------------
float MK_Get2DAFloat(string s2DA, string sColumn, int nRow, float fDefault=0.0);

/*
const float fDeltaCeil = 0.999;

void TestCeilQ(float fValue, float fDeltaQ)
{
    MK_DEBUG_TRACE(" > " + FloatToString(fValue)+" + "+FloatToString(fDeltaQ)+" = "+FloatToString(fValue+fDeltaQ)
    + " = " + IntToString(FloatToInt(fValue+fDeltaQ)));
}

int MK_Ceil(float fValue)
{
    float fFractal = fValue - FloatToInt(fValue);
    TestCeilQ(fValue, 0.999999);
    TestCeilQ(fValue, 0.99999);
    TestCeilQ(fValue, 0.9999);
    TestCeilQ(fValue, 0.999);
    TestCeilQ(fValue, 0.99);
    TestCeilQ(fValue, 0.9);
    MK_DEBUG_TRACE(" > IntToString(-1*FloatToInt(-1.0 * fValue))="+ IntToString(-1*FloatToInt(-1.0 * fValue)));
    return FloatToInt(fValue+fDeltaCeil);
}
*/

int MK_Get2DALength(string s2DA, string sColumn, int nMaxRangeOfEmptyRows=10);

int MK_Search2DAFile(string s2DA, string sColumn, string sSearchString, int nMaxRangeOfEmptyRows=10);

int MK_GetIsHenchman(object oHench, object oPC);

// Get oObject's local float variable sVarName
// * Returns fDefault if GetLocalFloat would return 0.0f
float MK_GetLocalFloat(object oObject, string sVarName, float fDefault=0.0f);

int MK_Get2DAInt(string s2DA, string sColumn, int nRow, int nDefault)
{
    string sValue = Get2DAString(s2DA, sColumn, nRow);
    return (sValue!="" ? StringToInt(sValue) : nDefault);
}

float MK_Get2DAFloat(string s2DA, string sColumn, int nRow, float fDefault)
{
    string sValue = Get2DAString(s2DA, sColumn, nRow);
    return (sValue!="" ? StringToFloat(sValue) : fDefault);
}

string MK_IntToString(int nInteger, int nLen, string c)
{
    string s = IntToString(nInteger);
    while (GetStringLength(s)<nLen)
    {
        s=c+s;
    }
    return s;
}

int MK_Get2DALength(string s2DA, string sColumn, int nMaxRangeOfEmptyRows)
{
    MK_DEBUG_TRACE("MK_Get2DALength("+s2DA+", "+sColumn+", "+IntToString(nMaxRangeOfEmptyRows)+")");
    int iRow=-1;
    int bContinue=TRUE;
    int nLength=0;
    int nEmptyRows=0;
    string s;
    do
    {
//        if (Get2DAString(s2DA, sColumn, ++iRow)!="")
        s = Get2DAString(s2DA, sColumn, ++iRow);
        if (s!="")
        {
            nLength = iRow+1;
            nEmptyRows = 0;
        }
        else
        {
            nEmptyRows++;
        }
//        if (iRow<50) MK_DEBUG_TRACE(" > s='"+s+"', iRow="+IntToString(iRow)+", nEmptyRows="+IntToString(nEmptyRows)+", nLength="+IntToString(nLength));
        bContinue = (nEmptyRows<nMaxRangeOfEmptyRows);
    }
    while (bContinue);
    MK_DEBUG_TRACE(" > length="+IntToString(nLength));
    return nLength;
}

int MK_Search2DAFile(string s2DA, string sColumn, string sSearchString, int nMaxRangeOfEmptyRows)
{
    int nLength = MK_Get2DALength(s2DA, sColumn, nMaxRangeOfEmptyRows);
    int iRow;
    for (iRow=0; iRow<nLength; iRow++)
    {
        if (Get2DAString(s2DA, sColumn, iRow) == sSearchString)
        {
            return iRow;
        }
    }
    return -1;
}

int MK_GetIsHenchman(object oHench, object oPC)
{
    int nHenchMax = GetMaxHenchmen();
    int i;
    for (i=1; i<=nHenchMax; i++)
    {
        if (GetHenchman(oPC, i)==oHench)
        {
            return TRUE;
        }
    }
    return FALSE;
}

float MK_GetLocalFloat(object oObject, string sVarName, float fDefault)
{
    float fReturn = GetLocalFloat(oObject, sVarName);
    if (fReturn==0.0f) fReturn = fDefault;
    return fDefault;
}

/*
void main()
{

}
/**/

