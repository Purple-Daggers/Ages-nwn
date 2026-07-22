#include "mk_inc_tools"

// ----------------------------------------------------------------------------
// Reads the 2da initialization file mk_init.2da
// ----------------------------------------------------------------------------
void MK_INIT_Initialize(object oPC, string sDefaultFile, string sUserFile);

void MK_INIT_Cleanup(object oPC, string sDefaultFile, string sUserFile);

/*
        Key                   Value              Variable                        TypeID         Type
0       ColorGroups           11                 MK_NUMBER_OF_COLOR_GROUPS       1              INTEGER
1       ColorsPerGroup        16                 MK_NUMBER_OF_COLORS_PER_GROUP   1              INTEGER
2       ColorHighlight        "<cþ¥ >"           14436                           4              TOKEN
3       ColorBack             "<cþ þ>"           14437                           4              TOKEN
4       ColorModelName        "<c ¿þ>"           14438                           4              TOKEN
5       ColorMakeChanges      "<cþþ >"           14439                           4              TOKEN
6       ColorMaterialToDye    "<c ¿þ>"           MK_TOKEN_COLOR1                 3              STRING
7       ColorMaterial         "<c¥¥¥>"           MK_TOKEN_COLOR2                 3              STRING
8       PortraitDelay         0.2                MK_PORTRAIT_DELAY               2              FLOAT
9       ****                  ****               ****                            ****           ****
*/

const string MK_INIT_2DA_FILE = "mk_init";
const string MK_INIT_COL_NAME = "Variable";
const string MK_INIT_COL_VALUE = "Value";
const string MK_INIT_COL_TYPEID = "TypeID";

const int MK_INIT_TYPE_INT = 1;
const int MK_INIT_TYPE_FLOAT = 2;
const int MK_INIT_TYPE_STRING = 3;
const int MK_INIT_TYPE_TOKEN = 4;

const int MK_INIT_VAR_TYPES = 31;

const string MK_DISABLE_EE_FEATURES = "MK_DISABLE_EE_FEATURES";

/*
int MK_INIT_GetAreEEFeaturesDisabled()
{
    return GetLocalInt(GetPCSpeaker(), MK_DISABLE_EE_FEATURES);
}
*/

int MK_INIT_ProcessLine(object oPC, string s2DAfile, int nLine, int bReset=FALSE)
{
    string sVariable = Get2DAString(s2DAfile, MK_INIT_COL_NAME,nLine);
    if (sVariable=="*END*") return FALSE;
    if (nLine>200) return FALSE; //

    string sValue = Get2DAString(s2DAfile, MK_INIT_COL_VALUE,nLine);
    int nTypeID = MK_Get2DAInt(s2DAfile, MK_INIT_COL_TYPEID,nLine);

    object oObject = (nTypeID & 64 ? GetModule() : oPC);

    switch (nTypeID & MK_INIT_VAR_TYPES)
    {
    case MK_INIT_TYPE_INT:
        if (!bReset)
        {
            SetLocalInt(oObject, sVariable, StringToInt(sValue));
        }
        else if (!(nTypeID & 128))
        {
            DeleteLocalInt(oObject, sVariable);
        }
        break;
    case MK_INIT_TYPE_FLOAT:
        if (!bReset)
        {
            SetLocalFloat(oObject, sVariable, StringToFloat(sValue));
        }
        else if (!(nTypeID & 128))
        {
            DeleteLocalFloat(oObject, sVariable);
        }
        break;
    case MK_INIT_TYPE_STRING:
        if (!bReset)
        {
            SetLocalString(oObject, sVariable, sValue);
        }
        else if (!(nTypeID & 128))
        {
            DeleteLocalString(oObject, sVariable);
        }
        break;
    case MK_INIT_TYPE_TOKEN:
        if (!bReset)
        {
            SetCustomToken(StringToInt(sVariable), sValue);
        }
        else if (!(nTypeID & 128))
        {
            SetCustomToken(StringToInt(sVariable), "");
        }
        break;
    }
    return TRUE;
}

void MK_INIT_Initialize(object oPC, string sDefaultFile, string sUserFile)
{
    int nLine=0;
    while (MK_INIT_ProcessLine(oPC, sDefaultFile, nLine++)) {}

    nLine=0;
    while (MK_INIT_ProcessLine(oPC, sUserFile, nLine++)) {}
}

void MK_INIT_Cleanup(object oPC, string sDefaultFile, string sUserFile)
{
    int nLine=0;
    while (MK_INIT_ProcessLine(oPC, sDefaultFile, nLine++, TRUE)) {}

    nLine=0;
    while (MK_INIT_ProcessLine(oPC, sUserFile, nLine++, TRUE)) {}
}

/*
void main()
{

}
/**/
