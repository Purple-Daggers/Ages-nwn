#include "mk_inc_debug"
#include "mk_inc_language"
#include "mk_inc_tlk"
#include "mk_inc_tools"
#include "mk_inc_color"

const int MK_ITEM_APPR_ARMOR_COLOR_LEATHER = 6;
const int MK_ITEM_APPR_ARMOR_COLOR_CLOTH = 7;
const int MK_ITEM_APPR_ARMOR_COLOR_METAL = 8;
const int MK_ITEM_APPR_ARMOR_COLOR_LEATHERCLOTH = 9;
const int MK_ITEM_APPR_ARMOR_COLOR_ALL = 10;

const int MK_ITEM_APPR_ARMOR_NUM_COLORS = 11;

const string MK_IAAC_2DA_FILE = "mk_iaac_def";

//---------------------------------------------------------------------------
// a) in this include file color always means the material (leather 1,
// leather 2, cloth 1, ... or one of the composed materials (leather 1+2,..).
// b) the actual color is colorValue
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// returns TRUE if the specified color is valid
//---------------------------------------------------------------------------
int MK_IAAC_GetIsValid(int nColor);

//---------------------------------------------------------------------------
// returns TRUE if the specified color is a base color
// means: 0 <= nCOLOR < ITEM_APPR_ARMOR_NUM_COLORS
//---------------------------------------------------------------------------
int MK_IAAC_GetIsBase(int nColor);

//---------------------------------------------------------------------------
// returns the color count for the specified armor color
//---------------------------------------------------------------------------
int MK_IAAC_GetColorCount(int nColor);

//---------------------------------------------------------------------------
// returns color no nNumber for the specified color
//---------------------------------------------------------------------------
int MK_IAAC_GetColor(int nColor, int nNumber);

//---------------------------------------------------------------------------
// returns TRUE if specified color contains specified color
// nColor: >=0, <MK_ITEM_APPR_ARMOR_NUM_COLORS
// iCOlor: >=0, <ITEM_APPR_ARMOR_NUM_COLORS
//---------------------------------------------------------------------------
int MK_IAAC_GetContainsColor(int nColor, int iColor);


//---------------------------------------------------------------------------
// returns the name of the specified color
//---------------------------------------------------------------------------
string MK_IAAC_GetName(int nColor);

//---------------------------------------------------------------------------
// returns the column in mk_colorgroups.2da for the specified color
//---------------------------------------------------------------------------
string MK_IAAC_GetColorGroupColumn(int nColor);

//---------------------------------------------------------------------------
// returns the column in mk_colornames.2da for the specified color
//---------------------------------------------------------------------------
string MK_IAAC_GetColorNamesColumn(int nColor);


//---------------------------------------------------------------------------
// returns the name of colorValue for the specified color and colorValue
//---------------------------------------------------------------------------
string MK_IAAC_GetColorValueName(int nColor, int nValue);

string MK_IAAC_GetColorGroupName(int nCOlor, int nGroup);


string MK_IAAC_Get2DAString(string sCol, int nRow)
{
    return Get2DAString(MK_IAAC_2DA_FILE, sCol, nRow);
}

int MK_IAAC_Get2DAInt(string sCol, int nRow)
{
    return StringToInt(MK_IAAC_Get2DAString(sCol, nRow));
}

int MK_IAAC_GetIsValid(int nColor)
{
    return (MK_IAAC_GetColorCount(nColor)>0);
}

int MK_IAAC_GetIsBase(int nColor)
{
    return (0<=nColor) && (nColor<ITEM_APPR_ARMOR_NUM_COLORS);
}

int MK_IAAC_GetColorCount(int nColor)
{
    int nCount = MK_IAAC_Get2DAInt("Count", nColor);
//    MK_DEBUG_TRACE("MK_IAAC_GetColorCount("+IntToString(nColor)+")="+IntToString(nCount));
    return nCount;
}

int MK_IAAC_GetColor(int nColor, int nNumber)
{
    int iColor = -1;
    if ((nNumber>=0) && (nNumber<MK_IAAC_GetColorCount(nColor)))
    {
        iColor = MK_IAAC_Get2DAInt("Color"+IntToString(nNumber), nColor);
    }
    return iColor;
}

int MK_IAAC_GetContainsColor(int nColor, int iColor)
{
    int i;
    int nCount = MK_IAAC_GetColorCount(nColor);
    for (i=0; i<nCount; i++)
    {
        if (MK_IAAC_GetColor(nColor, i)==iColor)
        {
            return TRUE;
        }
    }
    return FALSE;
}


string MK_IAAC_GetName(int nColor)
{
    int nStrRef = MK_IAAC_Get2DAInt("StrRef", nColor);
    return MK_TLK_GetStringByStrRef(nStrRef);
//    return (MK_IAAC_Get2DAString("Name", nColor));
}

string MK_IAAC_GetColorColumn(int nColor)
{
    return MK_IAAC_Get2DAString("Column", nColor);
}

string MK_IAAC_GetColorGroupColumn(int nColor)
{
    return (MK_IAAC_Get2DAString("CGroupCol", nColor)
        + "_" + MK_LANG_GetLanguageID());
}

string MK_IAAC_GetColorNamesColumn(int nColor)
{
    return (MK_IAAC_Get2DAString("CNamesCol", nColor)
        + "_" + MK_LANG_GetLanguageID());
}

string MK_IAAC_GetColorValueName(int nColor, int nValue)
{
    string sColorName = MK_COLOR_GetColorName2(X2_CI_MODMODE_ARMOR, -1, nColor, nValue);

//    string sCol = MK_IAAC_GetColorColumn(nColor);
//    int nStrRef = MK_Get2DAInt("mk_colors", sCol, nValue, 0);
//    string sColorName = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));

//    string sCol = MK_IAAC_GetColorNamesColumn(nColor);
//    string sColorName = Get2DAString("mk_colornames", sCol, nValue);
//    if ((sColorName=="") && (sCol!=MK_IAAC_GetColorNamesColumn(0)))
//    {
//        sColorName =  Get2DAString("mk_colornames", MK_IAAC_GetColorNamesColumn(0), nValue);
//    }
    return sColorName;
}

string MK_IAAC_GetColorGroupName(int nColor, int nGroup)
{
    string sCol = MK_IAAC_GetColorGroupColumn(nColor);
    string sColorGroup = Get2DAString("mk_colorgroups", sCol, nGroup);
    if ((sColorGroup=="") && (sCol!=MK_IAAC_GetColorGroupColumn(0)))
    {
        sColorGroup =  Get2DAString("mk_colorgroups", MK_IAAC_GetColorGroupColumn(0), nGroup);
    }
    return sColorGroup;
}


