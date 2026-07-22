#include "mk_inc_init"
#include "mk_inc_tools_s"
#include "mk_inc_craft"
#include "mk_inc_body"
#include "mk_inc_hex"
#include "mk_inc_scale"
#include "mk_inc_iprp"

// name of global database
const string MK_CCOH_DB_DATABASE_NAME = "MK_CCOH";

// Get/SetLocalString(oPC, MK_CCOH_DB_DATABASE, MK_CCOH_DB_DATABASE_NAME)
// or
// Get/SetLocalString(oPC, MK_CCOH_DB_DATABASE, "")
// empty string: use local string
// "MK_CCOH"   : use database "MK_CCOH"
const string MK_CCOH_DB_DATABASE = "MK_CCOH_DATABASE_NAME";
const string MK_CCOH_DB_READWRITE = "MK_CCOH_DATABASE_READWRITE";
const string MK_CCOH_DB_CURRENT_SLOTNR = "MK_CCOH_DATABASE_CURRENT_SLOTNR";
const string MK_CCOH_DB_CURRENT_SLOTNAME = "MK_CCOH_DATABASE_CURRENT_SLOTNAME";
const string MK_CCOH_DB_CURRENT_APPRTYPE = "MK_CCOH_DATABASE_CURRENT_APPRTYPE";
const string MK_CCOH_DB_SAVED_BODY_APPEARANCE = "MK_CCOH_DATABASE_BODY_TEMP_SAVE";


const int MK_CCOH_DB_ITEM_APPR_MODEL = 1;
const int MK_CCOH_DB_ITEM_APPR_COLOR = 2;
const int MK_CCOH_DB_ITEM_APPR_ALL = 3;

const int ITEM_APPR_WEAPON_NUM_MODELS = 3;

const int MK_CCOH_DB_BODY_APPR_HEAD = 1;
const int MK_CCOH_DB_BODY_APPR_TAIL = 4;
const int MK_CCOH_DB_BODY_APPR_WINGS = 8;
const int MK_CCOH_DB_BODY_APPR_PHENO = 16;
const int MK_CCOH_DB_BODY_APPR_PORTRAIT = 64;
const int MK_CCOH_DB_BODY_APPR_BODY = 128;
const int MK_CCOH_DB_BODY_APPR_HORSE = 256;
const int MK_CCOH_DB_BODY_APPR_COLOR = 512;
const int MK_CCOH_DB_BODY_APPR_TYPE = 1024;
const int MK_CCOH_DB_BODY_APPR_SCALE = 2048;
const int MK_CCOH_DB_BODY_APPR_FOOTSTEP = 4096;
const int MK_CCOH_DB_BOFY_APPR_DEITY = 8192;


const int MK_CCOH_DB_READ = 1;
const int MK_CCOH_DB_WRITE = 2;
const int MK_CCOH_DB_ADMIN = 255;

// int g_bDbUsesHexData;

const int g_nCCOH_DB_DbVersion    = 1;
int g_bCCOH_DB_UseLocalDb   = TRUE;

int MK_CCOH_DB_GetUseLocalDb(object oPC);

string MK_CCOH_DB_GetDatabaseName(object oPC);

void MK_CCOH_DB_SetDatabaseName(object oPC, string sDatabaseName);

void MK_CCOH_DB_SetReadWriteMode(object oPC, int nMode);

int MK_CCOH_DB_GetReadWriteMode(object oPC);

int MK_CCOH_DB_GetIsSlotUsed(object oPC, int iSlot);

int MK_CCOH_DB_GetIsSlotValid(object oPC, int iSlot, object oItem);

string MK_CCOH_DB_CreateSlotName(object oPC, int iSlot, int bAppendApprType=FALSE);

string MK_CCOH_DB_GetVarName(object oPC, int nSlot);

int MK_CCOH_DB_GetBaseItemTypeFromIAStr(string sIAStr);

int MK_CCOH_DB_GetACBonusFromIAStr(string sIAStr);

int MK_CCOH_DB_GetVersionFromIAStr(string sIAStr);

string MK_CCOH_DB_GetSlotData(object oPC, int iSlot);

string MK_CCOH_DB_GetSlotName(object oPC, int iSlot);

void MK_CCOH_DB_SetSlotData(object oPC, int iSlot, string sIAStr);

void MK_CCOH_DB_SetSlotName(object oPC, int iSlot, string sName);

int MK_CCOH_DB_GetIsIAStrValid(string sIAStr);

void MK_CCOH_DB_SetCurrentSlot(object oPC, int nSlot);

void MK_CCOH_DB_SetCurrentSlotName(object oPC, string sSlotName);

int MK_CCOH_DB_GetCurrentSlot(object oPC);

string MK_CCOH_DB_GetCurrentSlotName(object oPC);

void MK_CCOH_DB_DeleteCurrentSlot(object oPC);

// int MK_CCOH_DB_GetIASStrTypesFromIAStr(string sIAStr);

int MK_CCOH_DB_GetIASStrTypesFromSlot(object oPC, int nSlot);

void MK_CCOH_DB_SetCurrentAppearanceType(object oPC, int nAppearanceType);

int MK_CCOH_DB_GetCurrentAppearanceType(object oPC);

int MK_CCOH_DB_StringToInt(string s, int nPos, int nLen=-1);

object MK_CCOH_DB_IAStrToItemAppearance(object oItem, string sIAStr, int nMask=-1);

int MK_CCOH_DB_IAStrToBodyAppearance(object oCreature, string sIAStr, int nMask=65279, float fDelay=0.0);

int MK_CCOH_DB_GetIsItemAppearance(string sIAStr);

int MK_CCOH_DB_GetIsBodyAppearance(string sIAStr);

int MK_CCOH_DB_IASStrToBodyPart(object oCreature, string sIASStr, float fDelay=0.0);

void MK_CCOH_DB_DeleteSlot(object oPC, int iSlot);

// ----------------------------------------------------------------------------
// Stores body appearance of creature into a string
// - oCreature: creature whose appearance is to be stored
// - nMask: use one or more from
//     const int MK_CCOH_DB_BODY_APPR_HEAD = 1;
//     const int MK_CCOH_DB_BODY_APPR_TAIL = 4;
//     const int MK_CCOH_DB_BODY_APPR_WINGS = 8;
//     const int MK_CCOH_DB_BODY_APPR_PHENO = 16;
//     const int MK_CCOH_DB_BODY_APPR_PORTRAIT = 64;
//     const int MK_CCOH_DB_BODY_APPR_BODY = 128;
//     const int MK_CCOH_DB_BODY_APPR_HORSE = 256;
//     const int MK_CCOH_DB_BODY_APPR_COLOR = 512;
//     const int MK_CCOH_DB_BODY_APPR_TYPE = 1024;
//   default value is 65279 = all but MK_CCOH_DB_BODY_APPR_HORSE
//   MK_CCOH_DB_BODY_APPR_HORSE is not required anyway as it is
//   covered by MK_CCOH_DB_BODY_APPR_TAIL, MK_CCOH_DB_BODY_APPR_PHENO
//   and MK_CCOH_DB_BODY_APPR_TYPE
// ----------------------------------------------------------------------------
string MK_CCOH_DB_BodyAppearanceToIAStr(object oCreature, int nMask=65279);

// ----------------------------------------------------------------------------
// Stores the appearance of the specified item
// into a string
// - oItem: item whose appearance should be stored
// - mask: MK_CCOH_DB_ITEM_APPR_...
// ----------------------------------------------------------------------------
string MK_CCOH_DB_ItemToString(object oItem, int nMask=-1);


// ----------------------------------------------------------------------------
// Writes the appearance of the specified item to database
// - oPC: player
// - oItem: item whose appearance should be stored
// - nSlot: slot used for storing the appearance
// - mask: MK_CCOH_DB_ITEM_APPR_...
// - sName: optional name for the stored appearance
// ----------------------------------------------------------------------------
int MK_CCOH_DB_WriteItemAppearanceToDatabase(object oPC, object oItem, int nSlot, int nMask=-1, string sName="");


// ----------------------------------------------------------------------------
// Reads appearance of the specified item from database
// - oPC: player
// - oItem: item whose appearance should be changed
// - nSlot: slot used for reading the appearance
// - mask: MK_CCOH_DB_ITEM_APPR_...
// ----------------------------------------------------------------------------
object MK_CCOH_DB_ReadItemAppearanceFromDatabase(object oPC, object oItem, int nSlot, int nMask=-1);


// ----------------------------------------------------------------------------
// Format of hex DB string
/*

Hex Header:

0123456789012
HvvmmTMMMbba!

Dec Header:

01234567890123
DvvmmTMMMbbba!

H/D: hex or decimal
vv: version of Db (currently 1)
mm; modmode
T : type (I=Item, B=Body)
M : mask (I: item appr type (1=Model, 2=Color, 3=Both), B: body type)
bb: base item type
a : AC bonus
! : delimiter




*/
// ----------------------------------------------------------------------------

const int g_nVersionPos           = 1;
const int g_nVersionLen           = 2;

const int g_nModModePos           = 3;
const int g_nModModeLen           = 2;

const int g_nApprTypePos          = 5;
const int g_nApprTypeLen          = 1;

const int g_nMaskPos      = 6;
const int g_nMaskLen      = 3;

const string g_cHexDbMode = "H";
const int g_nHexBaseItemTypePos   = 9;
const int g_nHexBaseItemTypeLen   = 2;
const int g_nHexACBonusPos        = 11;
const int g_nHexACBonusLen        = 1;
const int g_nHexDelimiterPos      = 12;
const int g_nHexModelLen          = 2;
const int g_nHexArmorColorLen     = 2;
const int g_nHexWeaponColorLen    = 1;

const string g_cDecDbMode = "D";
const int g_nDecBaseItemTypePos   = 9;
const int g_nDecBaseItemTypeLen   = 3;
const int g_nDecACBonusPos        = 12;
const int g_nDecACBonusLen        = 1;
const int g_nDecDelimiterPos      = 13;
const int g_nDecModelLen          = 3;
const int g_nDecArmorColorLen     = 3;
const int g_nDecWeaponColorLen    = 2;


struct IASTR_FORMAT_DEFINITION
{
    int bUseHexData;
    string cDbMode;
    int nVersionPos;
    int nVersionLen;
    int nModModePos;
    int nModModeLen;
    int nApprTypePos;
    int nApprTypeLen;
    int nMaskPos;
    int nMaskLen;
    int nBaseItemTypePos;
    int nBaseItemTypeLen;
    int nACBonusPos;
    int nACBonusLen;
    int nDelimiterPos;

    int nModelLen;
    int nArmorColorLen;
    int nWeaponColorLen;
};

struct IASTR_FORMAT_DEFINITION g_iastrFmtDef;

const int MK_CCOH_DB_HexMode = 1;
const int MK_CCOH_DB_DecMode = 2;

string MK_CCOH_DB_GetIASStrTypeName(int nModMode, int nApprType)
{
    string s2DAFile = "mk_apprtype_" + Get2DAString("mk_modmode", "TYPE2DA", nModMode);
    int nStrRef = StringToInt(Get2DAString(s2DAFile, "StrRef", nApprType));
    return MK_TLK_GetStringByStrRef(nStrRef);
}

void MK_CCOH_DB_SetValidIASStrTypes(object oPC, int nValidIASStrTypes)
{
    SetLocalInt(oPC, "MK_CCOH_DB_VALID_IASSTR_TYPES", nValidIASStrTypes);
//    MK_DEBUG_TRACE("MK_CCOH_DB_SetValidIASStrTypes: "+IntToString(nValidIASStrTypes));
}

void MK_CCOH_DB_SetSelectedIASStrTypes(object oPC, int nSelectedIASStrTypes)
{
    SetLocalInt(oPC, "MK_CCOH_DB_SELECTED_IASSTR_TYPES", nSelectedIASStrTypes);
//    MK_DEBUG_TRACE("MK_CCOH_DB_SetSelectedIASStrTypes: "+IntToString(nSelectedIASStrTypes));
}

int MK_CCOH_DB_GetValidIASStrTypes(object oPC)
{
    return GetLocalInt(oPC, "MK_CCOH_DB_VALID_IASSTR_TYPES");
}

int MK_CCOH_DB_GetSelectedIASStrTypes(object oPC)
{
    return GetLocalInt(oPC, "MK_CCOH_DB_SELECTED_IASSTR_TYPES");
}

int MK_CCOH_DB_ToggleSelectedIASStrType(object oPC, int nIASStrType)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_ToggleSelectedIASStrType("+IntToString(nIASStrType)+"):");
    int nSelectedIASStrTypes = MK_CCOH_DB_GetSelectedIASStrTypes(oPC);
    int nIASStrTypeFlag = FloatToInt(pow(2.0, IntToFloat(nIASStrType)));
//    MK_DEBUG_TRACE(" > nSelectedIASStrTypes="+IntToString(nSelectedIASStrTypes));
//    MK_DEBUG_TRACE(" > nIASStrTypeFlag="+IntToString(nIASStrTypeFlag));

    if (nSelectedIASStrTypes & nIASStrTypeFlag)
    {
        nSelectedIASStrTypes = (nSelectedIASStrTypes & ~nIASStrTypeFlag);
    }
    else
    {
        nSelectedIASStrTypes = (nSelectedIASStrTypes | nIASStrTypeFlag);
    }
//    MK_DEBUG_TRACE(" > nSelectedIASStrTypes="+IntToString(nSelectedIASStrTypes));

    MK_CCOH_DB_SetSelectedIASStrTypes(oPC, nSelectedIASStrTypes);
    return nSelectedIASStrTypes;
}

int MK_CCOH_DB_GetUseLocalDb(object oPC)
{
    return (MK_CCOH_DB_GetDatabaseName(oPC) == "");
}

string MK_CCOH_DB_GetDatabaseName(object oPC)
{
    return GetLocalString(oPC, MK_CCOH_DB_DATABASE);
}

void MK_CCOH_DB_SetDatabaseName(object oPC, string sDatabaseName)
{
    SetLocalString(oPC, MK_CCOH_DB_DATABASE, sDatabaseName);
    g_bCCOH_DB_UseLocalDb = MK_CCOH_DB_GetUseLocalDb(oPC);
}

void MK_CCOH_DB_SetReadWriteMode(object oPC, int nMode)
{
    SetLocalInt(oPC, MK_CCOH_DB_READWRITE, nMode);
}

int MK_CCOH_DB_GetReadWriteMode(object oPC)
{
    return GetLocalInt(oPC, MK_CCOH_DB_READWRITE);
}

string MK_CCOH_DB_GetString(object oPC, string sVarName)
{
    string s="";
    if (g_bCCOH_DB_UseLocalDb)
    {
        s = GetLocalString(oPC, sVarName);
    }
    else
    {
        s = GetCampaignString(MK_CCOH_DB_GetDatabaseName(oPC),
                sVarName);
    }
    return s;
}

void MK_CCOH_DB_SetString(object oPC, string sVarName, string sValue)
{
    if (g_bCCOH_DB_UseLocalDb)
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_SetString(LOCAL, "+GetName(oPC)+", '"+sVarName+"', '"+sValue+"')");
        SetLocalString(oPC, sVarName, sValue);
    }
    else
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_SetString(GLOBAL, "+GetName(oPC)+", '"+sVarName+"', '"+sValue+"')");
        SetCampaignString(MK_CCOH_DB_GetDatabaseName(oPC),
            sVarName, sValue);
    }
}

string MK_CCOH_DB_GetSlotData(object oPC, int iSlot)
{
    string sVarName = MK_CCOH_DB_GetVarName(oPC, iSlot);
    string sSlotData = MK_CCOH_DB_GetString(oPC, sVarName+"D");
    MK_DEBUG_TRACE("MK_CCOH_DB_GetSlotData("+GetName(oPC)+", "+IntToString(iSlot)+")='"+sSlotData+"'");
    return sSlotData;
}

string MK_CCOH_DB_GetSlotName(object oPC, int iSlot)
{
    string sVarName = MK_CCOH_DB_GetVarName(oPC, iSlot);
    return MK_CCOH_DB_GetString(oPC, sVarName+"N");
}

void MK_CCOH_DB_SetSlotData(object oPC, int iSlot, string sIAStr)
{
    string sVarName = MK_CCOH_DB_GetVarName(oPC, iSlot);
    MK_DEBUG_TRACE("MK_CCOH_DB_SetSlotData("+GetName(oPC)+", "+IntToString(iSlot)+", '"+sIAStr+"')");
    MK_CCOH_DB_SetString(oPC, sVarName+"D", sIAStr);
}

void MK_CCOH_DB_SetSlotName(object oPC, int iSlot, string sName)
{
    string sVarName = MK_CCOH_DB_GetVarName(oPC, iSlot);
    MK_CCOH_DB_SetString(oPC, sVarName+"N", sName);
}

int MK_CCOH_DB_GetIsSlotUsed(object oPC, int iSlot)
{
    return (MK_CCOH_DB_GetSlotData(oPC, iSlot)!="");
}

int MK_CCOH_DB_GetIsSlotValid(object oPC, int iSlot, object oItem)
{
//    string sVarName = MK_CCOH_DB_GetVarName(iSlot);
    string sIAStr = MK_CCOH_DB_GetSlotData(oPC, iSlot);
//    MK_DEBUG_TRACE("MK_CCOH_DB_GetSLotData("+GetName(oPC)+", iSlot="+IntToString(iSlot)+
//        ", '"+GetName(oItem)+"')="+sIAStr);
    if (sIAStr=="")
    {
        return FALSE;
    }
    if (!MK_CCOH_DB_GetIsIAStrValid(sIAStr))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_GetIsSlotValid(): sIAstr is invalid!");
        return FALSE;
    }
    if (GetIsObjectValid(oItem))
    {
        if (!MK_CCOH_DB_GetIsItemAppearance(sIAStr))
        {
            return FALSE;
        }
        int nBaseItemType = MK_CCOH_DB_GetBaseItemTypeFromIAStr(sIAStr);
        if (nBaseItemType != GetBaseItemType(oItem))
        {
//            MK_DEBUG_TRACE("MK_CCOH_DB_GetIsSlotValid(): base item types do not match ("+
//                IntToString(nBaseItemType)+" != "+IntToString(GetBaseItemType(oItem))+")");
            return FALSE;
        }
    }
    else
    {
        if (!MK_CCOH_DB_GetIsBodyAppearance(sIAStr))
        {
            return FALSE;
        }
    }
    return TRUE;
}

void MK_CCOH_DB_DeleteSlot(object oPC, int iSlot)
{
    MK_CCOH_DB_SetSlotName(oPC, iSlot, "");
    MK_CCOH_DB_SetSlotData(oPC, iSlot, "");
}


int MK_CCOH_DB_GetApprTypesFromIAStr(string sIAStr)
{
    return MK_CCOH_DB_StringToInt(sIAStr,
        g_iastrFmtDef.nMaskPos,
        g_iastrFmtDef.nMaskLen);
}

int MK_CCOH_DB_GetModModeFromIAStr(string sIAStr)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_GetModModeFromIAStr("+sIAStr+"):");
//    MK_DEBUG_TRACE("> nModModPod="+IntToString(g_iastrFmtDef.nModModePos)
//        +", nModModeLen="+IntToString(g_iastrFmtDef.nModModeLen));
//    MK_DEBUG_TRACE("> SubStr='"+GetSubString(sIAStr, g_iastrFmtDef.nModModePos, g_iastrFmtDef.nModModeLen)+"'");
    return MK_CCOH_DB_StringToInt(sIAStr,
        g_iastrFmtDef.nModModePos,
        g_iastrFmtDef.nModModeLen);
}

string MK_CCOH_DB_GetDescriptionFromIAStr(string sIAStr)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_GetDescriptionFromIAStr("+sIAStr+")");

    string sDescription="";
    int nModMode = MK_CCOH_DB_GetModModeFromIAStr(sIAStr);

    string s2DAFile = "mk_apprtype_" + Get2DAString("mk_modmode", "TYPE2DA", nModMode);
    int nCount = MK_Get2DAInt("mk_modmode", "TYPECOUNT", nModMode, 0);
    int nApprTypes = MK_CCOH_DB_GetApprTypesFromIAStr(sIAStr);

//    MK_DEBUG_TRACE("> nModMode="+IntToString(nModMode)+", s2DAFile='"+s2DAFile+"', nCount="+IntToString(nCount)+", nApprTypes="+IntToString(nApprTypes));

    int iApprType;
    int nFlag=1;
    for (iApprType=1; iApprType<=nCount; iApprType++)
    {
        if (nApprTypes & nFlag)
        {
            sDescription += Get2DAString(s2DAFile, "Token", iApprType);
        }
        nFlag*=2;
    }
//    MK_DEBUG_TRACE("> sDescription='"+sDescription+"'");
    return sDescription;
}

string MK_CCOH_DB_CreateSlotName(object oPC, int iSlot, int bAppendApprType)
{
//    string sVarName = MK_CCOH_DB_GetVarName(iSlot);

//    string sSlotName = "Slot "+MK_IntToString(iSlot, 2, " ")+": ";
    string sSlotName="";

    string sName=MK_CCOH_DB_GetSlotName(oPC, iSlot);
    string sData=MK_CCOH_DB_GetSlotData(oPC, iSlot);

    int bItemAppr = MK_CCOH_DB_GetIsItemAppearance(sData);
    int bBodyAppr = MK_CCOH_DB_GetIsBodyAppearance(sData);

    if (sData == "")
    {
        sSlotName += "<not used>";
    }
    else if (sName!="")
    {
        sSlotName += sName;
    }
    else if (bItemAppr)
    {
        int nBaseItemType = MK_CCOH_DB_GetBaseItemTypeFromIAStr(sData);
        int nACBonus = MK_CCOH_DB_GetACBonusFromIAStr(sData);
        string sItem = Get2DAString("baseitems", "Name", nBaseItemType);
        if (nBaseItemType == 16)
        {
            sItem += (" (AC="+IntToString(nACBonus)+")");
        }
        sSlotName += ("Unknown "+sItem);
    }
    else if (bBodyAppr)
    {
        sSlotName = "Body Appearance";
    }


    if ((sData!="") && bAppendApprType)
    {
        sSlotName += ( " ("+MK_CCOH_DB_GetDescriptionFromIAStr(sData)+")");
    }

    return sSlotName;
}

void MK_CCOH_DB_SetCurrentSlot(object oPC, int nSlot)
{
    SetLocalInt(oPC, MK_CCOH_DB_CURRENT_SLOTNR, nSlot);
}

void MK_CCOH_DB_SetCurrentSlotName(object oPC, string sSlotName)
{
    SetLocalString(oPC, MK_CCOH_DB_CURRENT_SLOTNAME, sSlotName);
}

void MK_CCOH_DB_DeleteCurrentSlot(object oPC)
{
    int nSlot = MK_CCOH_DB_GetCurrentSlot(oPC);
    MK_CCOH_DB_DeleteSlot(oPC, nSlot);
    MK_CCOH_DB_SetCurrentSlot(oPC, -1);
    MK_CCOH_DB_SetCurrentSlotName(oPC, "");
}

int MK_CCOH_DB_GetCurrentSlot(object oPC)
{
    return GetLocalInt(oPC, MK_CCOH_DB_CURRENT_SLOTNR);
}

string MK_CCOH_DB_GetCurrentSlotName(object oPC)
{
    return GetLocalString(oPC, MK_CCOH_DB_CURRENT_SLOTNAME);
}

void MK_CCOH_DB_SetCurrentAppearanceType(object oPC, int nAppearanceType)
{
    SetLocalInt(oPC, MK_CCOH_DB_CURRENT_APPRTYPE, nAppearanceType);
}

int MK_CCOH_DB_GetCurrentAppearanceType(object oPC)
{
    return GetLocalInt(oPC, MK_CCOH_DB_CURRENT_APPRTYPE);
}

struct IASTR_FORMAT_DEFINITION MK_CCOH_DB_SetDbMode(int nDbMode)
{
    struct IASTR_FORMAT_DEFINITION iastrFmtDef;
    iastrFmtDef.nVersionPos = g_nVersionPos;
    iastrFmtDef.nVersionLen = g_nVersionLen;
    iastrFmtDef.nApprTypePos = g_nApprTypePos;
    iastrFmtDef.nApprTypeLen = g_nApprTypeLen;
    iastrFmtDef.nModModePos = g_nModModePos;
    iastrFmtDef.nModModeLen = g_nModModeLen;
    iastrFmtDef.nMaskPos = g_nMaskPos;
    iastrFmtDef.nMaskLen = g_nMaskLen;

    if (nDbMode == MK_CCOH_DB_HexMode)
    {
        iastrFmtDef.bUseHexData = TRUE;
        iastrFmtDef.cDbMode = g_cHexDbMode;
        iastrFmtDef.nBaseItemTypePos = g_nHexBaseItemTypePos;
        iastrFmtDef.nBaseItemTypeLen = g_nHexBaseItemTypeLen;
        iastrFmtDef.nACBonusPos = g_nHexACBonusPos;
        iastrFmtDef.nACBonusLen = g_nHexACBonusLen;
        iastrFmtDef.nDelimiterPos = g_nHexDelimiterPos;
        iastrFmtDef.nModelLen = g_nHexModelLen;
        iastrFmtDef.nArmorColorLen = g_nHexArmorColorLen;
        iastrFmtDef.nWeaponColorLen = g_nHexWeaponColorLen;
    int nColorLen;
    }
    else if (nDbMode == MK_CCOH_DB_DecMode)
    {
        iastrFmtDef.bUseHexData = FALSE;
        iastrFmtDef.cDbMode = g_cDecDbMode;
        iastrFmtDef.nBaseItemTypePos = g_nDecBaseItemTypePos;
        iastrFmtDef.nBaseItemTypeLen = g_nDecBaseItemTypeLen;
        iastrFmtDef.nACBonusPos = g_nDecACBonusPos;
        iastrFmtDef.nACBonusLen = g_nDecACBonusLen;
        iastrFmtDef.nDelimiterPos = g_nDecDelimiterPos;
        iastrFmtDef.nModelLen = g_nDecModelLen;
        iastrFmtDef.nArmorColorLen = g_nDecArmorColorLen;
        iastrFmtDef.nWeaponColorLen = g_nDecWeaponColorLen;
    }
    return iastrFmtDef;
}


string MK_CCOH_DB_IntToHexString(int nInteger, int nLen)
{
    string sHex = IntToHexString(nInteger);
    if (nLen<=8)
        return GetStringRight(sHex, nLen);
    return GetStringRight(sHex,8);
}

string MK_CCOH_DB_IntToString(int nValue, int nLen)
{
    if (g_iastrFmtDef.bUseHexData)
    {
        return MK_CCOH_DB_IntToHexString(nValue, nLen);
    }
    else
    {
        if (nValue==-1) nValue = 255;
        return MK_IntToString(nValue, nLen, "0");
    }
}

string MK_CCOH_DB_FloatToString(float fValue, int nWidth, int nDecimals)
{
    return FloatToString(fValue, nWidth, nDecimals);
}

int MK_CCOH_DB_StringToInt(string s, int nPos, int nLen)
{
    if (nLen==-1)
    {
        nLen = (GetStringLength(s)-nPos);
    }
    if (g_iastrFmtDef.bUseHexData)
    {
        return MK_HEX_HexStringToInt(GetSubString(s, nPos, nLen));
    }
    else
    {
        return StringToInt(GetSubString(s, nPos, nLen));
    }
}

float MK_CCOH_DB_StringToFloat(string s, int nPos, int nLen)
{
    if (nLen==-1)
    {
        nLen = (GetStringLength(s)-nPos);
    }
    return StringToFloat(GetSubString(s, nPos, nLen));
}


int MK_CCOH_DB_GetACBonus(object oItem)
{
    int nACBonus = 0;
    if (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem)==BASE_ITEM_ARMOR)
        {
            int nTorso = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL,
                                ITEM_APPR_ARMOR_MODEL_TORSO);
            string sACBonus = Get2DAString("parts_chest", "ACBONUS", nTorso);
            nACBonus = FloatToInt(StringToFloat(sACBonus));
        }
    }
    return nACBonus;
}

string MK_CCOH_DB_ItemColorToIASStr(object oItem)
{
    int nType = GetBaseItemType(oItem);
    string sResult="C";
    int nItemAppearance;
    int iColor;
    int iPart;
    switch (nType)
    {
    case BASE_ITEM_ARMOR:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_HELMET:
        for (iColor=0; iColor<ITEM_APPR_ARMOR_NUM_COLORS; iColor++)
        {
            sResult += MK_CCOH_DB_IntToString(
                GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iColor),
                g_iastrFmtDef.nArmorColorLen);
        }
        if ((nType == BASE_ITEM_ARMOR) && (MK_VERSION_GetIsVersionGreaterEqual_1_74()))
        {
            for (iColor=0; iColor<ITEM_APPR_ARMOR_NUM_COLORS; iColor++)
            {
                for (iPart=0; iPart<ITEM_APPR_ARMOR_NUM_MODELS; iPart++)
                {
                    int iIndex = MK_CalculateColorIndex(iColor, iPart);
                    sResult += MK_CCOH_DB_IntToString(
                        MK_GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iIndex),
                        g_iastrFmtDef.nArmorColorLen);
                }
            }
        }
        break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        for (iPart=0; iPart<ITEM_APPR_WEAPON_NUM_MODELS; iPart++)
        {
            sResult += MK_CCOH_DB_IntToString(
                GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, iPart),
                g_iastrFmtDef.nWeaponColorLen);
        }
        break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        sResult += MK_CCOH_DB_IntToString(
                GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, 0),
                g_iastrFmtDef.nWeaponColorLen);
        break;
    }
    return sResult;
}

string MK_CCOH_DB_ItemModelToIASStr(object oItem)
{
    int nType = GetBaseItemType(oItem);
    string sResult="M";
    int iPart;
    switch (nType)
    {
    case BASE_ITEM_ARMOR:
        for (iPart=0; iPart<ITEM_APPR_ARMOR_NUM_MODELS; iPart++)
        {
            sResult += MK_CCOH_DB_IntToString(
                GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL,iPart),
                g_iastrFmtDef.nModelLen);
        }
        break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        for (iPart=0; iPart<ITEM_APPR_WEAPON_NUM_MODELS; iPart++)
        {
            sResult += MK_CCOH_DB_IntToString(
               GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, iPart),
               g_iastrFmtDef.nModelLen);
        }
        break;
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_HELMET:
        sResult += MK_CCOH_DB_IntToString(
               GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0),
               g_iastrFmtDef.nModelLen);
        break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        sResult += MK_CCOH_DB_IntToString(
               GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, 0),
               g_iastrFmtDef.nModelLen);
        break;
    }
    return sResult;
}

object MK_CCOH_DB_IASStrToItemModel(object oItem, string sIASStr)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_IASStrToItemModel('"+GetName(oItem)+"', '"+sIASStr+"')");
    int nType = GetBaseItemType(oItem);
    int nPos = 1;
    int nLen = g_iastrFmtDef.nModelLen;
    int iModel;
    string sModel;
    object oItemQ;
    int iPart;

    switch (nType)
    {
    case BASE_ITEM_ARMOR:
    {
        int bCopy;
        for (iPart=0; iPart<ITEM_APPR_ARMOR_NUM_MODELS; iPart++)
        {
            iModel = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);

            if (iPart==ITEM_APPR_ARMOR_MODEL_TORSO)
            {
                int nDBAC = MK_Get2DAInt("parts_chest", "ACBONUS", iModel);
                int nItemAC = MK_Get2DAInt("parts_chest", "ACBONUS",
                    GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO));
                bCopy = (nDBAC == nItemAC);
            }
            else
            {
                bCopy = TRUE;
            }

            if (bCopy)
            {
                oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL,
                    iPart, iModel, TRUE, FALSE);
                if (!GetIsObjectValid(oItemQ))
                {
                    return OBJECT_INVALID;
                }
                DestroyObject(oItem);
                oItem = oItemQ;
            }
            nPos += nLen;
        }
        break;
    }
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        for (iPart=0; iPart<ITEM_APPR_WEAPON_NUM_MODELS; iPart++)
        {
            iModel = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
            oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL,
                iPart, iModel, TRUE, FALSE);
            if (!GetIsObjectValid(oItemQ))
            {
                return OBJECT_INVALID;
            }
            DestroyObject(oItem);
            oItem = oItemQ;
            nPos += nLen;
        }
        break;
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_HELMET:
        iModel = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
        oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iModel, TRUE, FALSE);
        if (!GetIsObjectValid(oItemQ))
        {
            return OBJECT_INVALID;
        }
        DestroyObject(oItem);
        oItem = oItemQ;
        break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        iModel = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
        oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL,
            0, iModel, TRUE, FALSE);
        if (!GetIsObjectValid(oItemQ))
        {
            return OBJECT_INVALID;
        }
        DestroyObject(oItem);
        oItem = oItemQ;
        break;
    }
    return oItem;
}

object MK_CCOH_DB_IASStrToItemColor(object oItem, string sIASStr)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_IASStrToItemColor('"+GetName(oItem)+"', '"+sIASStr+"')");
    int nType = GetBaseItemType(oItem);
    int nPos = 1;
    int nLen;
    int nValue;
    object oItemQ;
    int iPart;
    int iColor;

    switch (nType)
    {
    case BASE_ITEM_ARMOR:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_HELMET:
        nLen = g_iastrFmtDef.nArmorColorLen;
        for (iColor=0; iColor<ITEM_APPR_ARMOR_NUM_COLORS; iColor++)
        {
            nValue = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
            oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR,
                iColor, nValue , TRUE, FALSE);
            if (!GetIsObjectValid(oItemQ))
            {
                return OBJECT_INVALID;
            }
            DestroyObject(oItem);
            oItem = oItemQ;
            nPos += nLen;
        }
        if ((nType == BASE_ITEM_ARMOR) && (MK_VERSION_GetIsVersionGreaterEqual_1_74()))
        {
            for (iColor=0; iColor<ITEM_APPR_ARMOR_NUM_COLORS; iColor++)
            {
                for (iPart=0; iPart<ITEM_APPR_ARMOR_NUM_MODELS; iPart++)
                {
                    nValue = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
                    int iIndex = MK_CalculateColorIndex(iColor, iPart);
                    oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR,
                        iIndex, nValue , TRUE, TRUE);
                    if (!GetIsObjectValid(oItemQ))
                    {
                        return OBJECT_INVALID;
                    }
                    DestroyObject(oItem);
                    oItem = oItemQ;
                    nPos += nLen;
                }
            }
        }
        break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        nLen = g_iastrFmtDef.nWeaponColorLen;
        for (iPart=0; iPart<ITEM_APPR_WEAPON_NUM_MODELS; iPart++)
        {
            nValue = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
            oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR,
                iPart, nValue , TRUE, FALSE);
            if (!GetIsObjectValid(oItemQ))
            {
                return OBJECT_INVALID;
            }
            DestroyObject(oItem);
            oItem = oItemQ;
            nPos += nLen;
        }
        break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        nLen = g_iastrFmtDef.nWeaponColorLen;
        nValue = MK_CCOH_DB_StringToInt(sIASStr, nPos, nLen);
        oItemQ = MK_CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR,
            0, nValue , TRUE, FALSE);
        if (!GetIsObjectValid(oItemQ))
        {
            return OBJECT_INVALID;
        }
        DestroyObject(oItem);
        oItem = oItemQ;
        break;
    }
    return oItem;
}

int MK_CCOH_DB_IASStrToBodyPart(object oCreature, string sIASStr, float fDelay)
{
    int nResult = TRUE;

    int nBodyPart = MK_CCOH_DB_StringToInt(sIASStr, 0, 2);
    string sBodyPart;
//    MK_DEBUG_TRACE("MK_CCOH_DB_IASStrToBodyPart("+sIASStr+"): nBodyPart="+IntToString(nBodyPart));
    switch (nBodyPart)
    {
    case MK_CRAFTBODY_HEAD:
        SetCreatureBodyPart(CREATURE_PART_HEAD,
            MK_CCOH_DB_StringToInt(sIASStr, 2, 3),
            oCreature);
        break;
    case MK_CRAFTBODY_BODY:
    {
        int i;
        int nNewBodyPart;
        int nCurrentBodyPart;
        for (i=0; i<=17; i++)
        {
            nNewBodyPart = MK_CCOH_DB_StringToInt(sIASStr, 2+i*3, 3);
            nCurrentBodyPart = GetCreatureBodyPart(i, oCreature);

            if (nNewBodyPart!=nCurrentBodyPart)
            {
                SetCreatureBodyPart(i, nNewBodyPart, oCreature);
                if (fDelay>0.0)
                {
                    ActionPauseConversation();
                    ActionWait(fDelay);
                    ActionResumeConversation();
                }
            }
        }
        break;
    }
    case MK_CRAFTBODY_COLOR:
    {
        int i, nNewColor, nCurrentColor;
        for (i=0; i<=3; i++)
        {
            nNewColor = MK_CCOH_DB_StringToInt(sIASStr, 2+i*3, 3);
            nCurrentColor = GetColor(oCreature, i);

            if (nNewColor!=nCurrentColor)
            {
                MK_SetColor(oCreature, i, nNewColor);
                if (fDelay>0.0)
                {
                    ActionPauseConversation();
                    ActionWait(fDelay);
                    ActionResumeConversation();
                }
            }
        }
        break;
    }
    case MK_CRAFTBODY_TAIL:
        SetCreatureTailType(MK_CCOH_DB_StringToInt(sIASStr, 2, 3), oCreature);
        break;
    case MK_CRAFTBODY_WINGS:
        SetCreatureWingType(MK_CCOH_DB_StringToInt(sIASStr, 2, 3), oCreature);
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        SetPhenoType(MK_CCOH_DB_StringToInt(sIASStr, 2, 3), oCreature);
        break;
    case MK_CRAFTBODY_APPRTYPE:
        SetCreatureAppearanceType(oCreature, MK_CCOH_DB_StringToInt(sIASStr, 2, 4));
        break;
    case MK_CRAFTBODY_HORSE:
        SetPhenoType(MK_CCOH_DB_StringToInt(sIASStr, 2, 3), oCreature);
        SetCreatureTailType(MK_CCOH_DB_StringToInt(sIASStr, 5, 3), oCreature);
        SetCreatureAppearanceType(oCreature, MK_CCOH_DB_StringToInt(sIASStr, 8, 4));
        SetFootstepType(MK_CCOH_DB_StringToInt(sIASStr, 12, 3)-1, oCreature);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        if (GetSubString(sIASStr, 2, 3)=="ID=")
        {
            int nId = MK_CCOH_DB_StringToInt(sIASStr, 5, 4);
            SetPortraitId(oCreature, nId);
        }
        else if (GetSubString(sIASStr, 2, 7)=="ResRef=")
        {
            string sResRef = GetSubString(sIASStr, 9, GetStringLength(sIASStr)-10);
            SetPortraitResRef(oCreature, sResRef);
        }
        break;
    case MK_CRAFTBODY_SCALE:
        MK_SCALE_SetScaleFactor(oCreature, MK_CCOH_DB_StringToFloat(sIASStr, 2, 5));
        break;
    case MK_CRAFTBODY_FOOTSTEP:
        SetFootstepType(MK_CCOH_DB_StringToInt(sIASStr, 2, 3)-1, oCreature);
        break;
    case MK_CRAFTBODY_DEITY:
    {
        string sDeity = MK_ReplaceSubString(GetSubString(sIASStr, 2, GetStringLength(sIASStr)-3), "#", "!");
        SetDeity(oCreature, sDeity);
        break;
    }
    }
    return nResult;
}

int MK_CCOH_DB_IASStrToItemProperties(object oItem, string sIASStr, int bReplaceProperties=TRUE)
{
    if (bReplaceProperties)
    {
        MK_IPRP_RemoveAllItemProperties(oItem);
    }
    int iPos = 0;
    int nDataSize = (3+3+3+3+1);
    int nCount = GetStringLength(sIASStr) / nDataSize;
    int nIProps=0;
    for (iPos=0; iPos<nCount; iPos++)
    {
        int nType = MK_CCOH_DB_StringToInt(sIASStr, iPos*nDataSize + 0, 3);
        int nSubType = MK_CCOH_DB_StringToInt(sIASStr, iPos*nDataSize + 3, 3);
        int nCostTableValue = MK_CCOH_DB_StringToInt(sIASStr, iPos*nDataSize + 6, 3);
        int nParam1Value = MK_CCOH_DB_StringToInt(sIASStr, iPos*nDataSize + 9, 3);
        itemproperty iProp = MK_IPRP_CreateItemPropertyByID(nType, nSubType, nCostTableValue, nParam1Value);
        if (GetIsItemPropertyValid(iProp))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oItem);
            nIProps++;
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "Failed create item property '"
                +MK_IPRP_GetItemPropertyNameByID(nType, nSubType, nCostTableValue, nParam1Value)+"'!");
        }
    }
    return nIProps;
}

string MK_CCOH_DB_ItemPropertiesToIASStr(object oItem)
{
    string sResult="";
    if (GetIsObjectValid(oItem))
    {
        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            if (GetItemPropertyDurationType(iProp) == DURATION_TYPE_PERMANENT)
            {
                sResult+=MK_CCOH_DB_IntToString(MK_IPRP_GetItemPropertyType(iProp), 3);
                sResult+=MK_CCOH_DB_IntToString(MK_IPRP_GetItemPropertySubType(iProp), 3);
                sResult+=MK_CCOH_DB_IntToString(MK_IPRP_GetItemPropertyCostTableValue(iProp), 3);
                sResult+=MK_CCOH_DB_IntToString(MK_IPRP_GetItemPropertyParam1Value(iProp), 3);
                sResult+="!";
            }
            iProp = GetNextItemProperty(oItem);
        }
    }
    return sResult;
}

string MK_CCOH_DB_BodyAppearanceToIASStr(object oCreature, int nBodyPart)
{
    string sResult = MK_CCOH_DB_IntToString(nBodyPart, 2);

    switch (nBodyPart)
    {
    case MK_CRAFTBODY_HEAD:
        sResult += MK_CCOH_DB_IntToString(GetCreatureBodyPart(CREATURE_PART_HEAD, oCreature), 3);
        break;
    case MK_CRAFTBODY_BODY:
    {
        int i;
        for (i=0; i<=17; i++)
        {
            sResult += MK_CCOH_DB_IntToString(GetCreatureBodyPart(i,oCreature),3);
        }
        break;
    }
    case MK_CRAFTBODY_COLOR:
    {
        int i;
        for (i=0; i<=3; i++)
        {
            sResult += MK_CCOH_DB_IntToString(GetColor(oCreature, i),3);
        }
        break;
    }
    case MK_CRAFTBODY_TAIL:
        sResult += MK_CCOH_DB_IntToString(GetCreatureTailType(oCreature), 3);
        break;
    case MK_CRAFTBODY_WINGS:
        sResult += MK_CCOH_DB_IntToString(GetCreatureWingType(oCreature), 3);
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        sResult += MK_CCOH_DB_IntToString(GetPhenoType(oCreature), 3);
        break;
    case MK_CRAFTBODY_APPRTYPE:
        sResult += MK_CCOH_DB_IntToString(GetAppearanceType(oCreature), 4);
        break;
    case MK_CRAFTBODY_HORSE:
        sResult += (MK_CCOH_DB_IntToString(GetPhenoType(oCreature),3)
                  + MK_CCOH_DB_IntToString(GetCreatureTailType(oCreature),3)
                  + MK_CCOH_DB_IntToString(GetAppearanceType(oCreature), 4)
                  + MK_CCOH_DB_IntToString(GetFootstepType(oCreature)+1, 3));
        break;
    case MK_CRAFTBODY_PORTRAIT:
    {
        int nId = GetPortraitId(oCreature);
        if (nId!=PORTRAIT_INVALID)
        {
            sResult += ("ID="+MK_CCOH_DB_IntToString(nId, 4));
        }
        else
        {
            sResult += ("ResRef="+GetPortraitResRef(oCreature));
        }
        break;
    }
    case MK_CRAFTBODY_SCALE:
        sResult += MK_CCOH_DB_FloatToString(MK_SCALE_GetScaleFactor(oCreature), 5, 2);
        break;
    case MK_CRAFTBODY_FOOTSTEP:
        // to avoid -1 being stored Footstep Type + 1 is stored instead.
        sResult += MK_CCOH_DB_IntToString(GetFootstepType(oCreature)+1, 3);
        break;
    case MK_CRAFTBODY_DEITY:
    {
        string sDeity = MK_ReplaceSubString(GetDeity(oCreature), "!", "#");
        sResult += sDeity;
    }
    }

    sResult += "!";

    return sResult;
}

string MK_CCOH_DB_CreateHeader(int nModMode, object oItem, int nMask)
{
    string sHeader = g_iastrFmtDef.cDbMode +
        MK_CCOH_DB_IntToString(g_nCCOH_DB_DbVersion, g_iastrFmtDef.nVersionLen) +
        MK_CCOH_DB_IntToString(nModMode, g_iastrFmtDef.nModModeLen);

    if (GetIsObjectValid(oItem))
    {
        sHeader += ("I" +
            MK_CCOH_DB_IntToString(nMask, g_iastrFmtDef.nMaskLen) +
            MK_CCOH_DB_IntToString(GetBaseItemType(oItem), g_iastrFmtDef.nBaseItemTypeLen) +
            MK_CCOH_DB_IntToString(MK_CCOH_DB_GetACBonus(oItem), g_iastrFmtDef.nACBonusLen) +
                  "!");
    }
    else
    {
        sHeader += ("B" +
            MK_CCOH_DB_IntToString(nMask, g_iastrFmtDef.nMaskLen) +
            MK_CCOH_DB_IntToString(0, g_iastrFmtDef.nBaseItemTypeLen) +
            MK_CCOH_DB_IntToString(0, g_iastrFmtDef.nACBonusLen) +
                  "!");
    }
//    MK_DEBUG_TRACE("MK_CCOH_DB_CreateHeader("+IntToString(nModMode)+", .. ,"+IntToString(nMask)+")="+sHeader);
    return sHeader;
}

string MK_CCOH_DB_BodyAppearanceToIAStr(object oCreature, int nMask)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_BodyAppearanceToIAStr('"+GetName(oCreature)+"', nMask="+IntToString(nMask)+")");
    string sResult = "";
    if (GetIsObjectValid(oCreature))
    {
        sResult = MK_CCOH_DB_CreateHeader(MK_CI_MODMODE_BODY, OBJECT_INVALID, nMask);
//        MK_DEBUG_TRACE(" > Header='"+sResult+"'");
        int iBodyPart;
        int nBit=1;
        for (iBodyPart=1; iBodyPart<=MK_CRAFTBODY_NUMBER_OF_BODYPARTS; iBodyPart++)
        {
//            MK_DEBUG_TRACE(" > iBodyPart="+IntToString(iBodyPart)+", nBit="+IntToString(nBit));
            if (nMask & nBit)
            {
                sResult += (MK_CCOH_DB_BodyAppearanceToIASStr(oCreature, iBodyPart));
//                MK_DEBUG_TRACE("   > sResult='"+sResult+"'");
            }
            nBit *= 2;
        }
    }
    return sResult;
}

int MK_CCOH_DB_ItemToModMode(object oItem)
{
    int nModMode = X2_CI_MODMODE_INVALID;
    int nBaseItemType = GetBaseItemType(oItem);
    switch (nBaseItemType)
    {
    case BASE_ITEM_ARMOR:
        nModMode = X2_CI_MODMODE_ARMOR;
        break;
    case BASE_ITEM_CLOAK:
        nModMode = MK_CI_MODMODE_CLOAK;
        break;
    case BASE_ITEM_HELMET:
        nModMode = MK_CI_MODMODE_HELMET;
        break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        nModMode = X2_CI_MODMODE_WEAPON;
        break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        nModMode = MK_CI_MODMODE_SHIELD;
        break;
    }
    return nModMode;
}

string MK_CCOH_DB_ItemAppearanceToIAStr(object oItem, int nMask)
{
    string sResult = "";
    if (GetIsObjectValid(oItem))
    {
        sResult = MK_CCOH_DB_CreateHeader(MK_CCOH_DB_ItemToModMode(oItem), oItem, nMask);
/*      int nType = GetBaseItemType(oItem);
        int nACBonus = MK_CCOH_DB_GetACBonus(oItem);


        sResult = g_iastrFmtDef.cDbMode +
                  MK_CCOH_DB_IntToString(g_nCCOH_DB_DbVersion, g_iastrFmtDef.nVersionLen) +
                  "I"+
                  MK_CCOH_DB_IntToString(nMask, g_iastrFmtDef.nItemApprTypeLen);


        sResult += (MK_CCOH_DB_IntToString(nType, g_iastrFmtDef.nBaseItemTypeLen)
                  +  MK_CCOH_DB_IntToString(nACBonus, g_iastrFmtDef.nACBonusLen)
                  +  "!");
*/
        if (nMask &  MK_CCOH_DB_ITEM_APPR_MODEL)
        {
            sResult += (MK_CCOH_DB_ItemModelToIASStr(oItem) + "!");
        }
        if (nMask &  MK_CCOH_DB_ITEM_APPR_COLOR)
        {
            sResult += (MK_CCOH_DB_ItemColorToIASStr(oItem) + "!");
        }
    }
    return sResult;
}

string MK_CCOH_DB_GetVarName(object oPC, int nSlot)
{
    string sPrefix = "";
    if (!g_bCCOH_DB_UseLocalDb)
    {
        sPrefix = GetPCPublicCDKey(oPC, FALSE);
//        MK_DEBUG_TRACE("MK_CCOH_DB_GetVarName: cdkey for '"+GetName(oPC)+"' is: "+sPrefix);
    }
    if (g_iastrFmtDef.bUseHexData)
    {
        return sPrefix+"MK_CCOH_IA_DB_"+MK_CCOH_DB_IntToHexString(nSlot,4);
    }
    else
    {
        return sPrefix+"MK_CCOH_IA_DB_"+MK_IntToString(nSlot,4, "0");
    }
}

int MK_CCOH_DB_WriteBodyAppearanceToDatabase(object oPC, object oCreature, int nSlot, int nMask, string sName)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    if (GetIsObjectValid(oCreature))
    {
        MK_CCOH_DB_SetSlotData(oPC, nSlot, MK_CCOH_DB_BodyAppearanceToIAStr(oCreature, nMask));
        MK_CCOH_DB_SetSlotName(oPC, nSlot, sName);
    }
    else
    {
        MK_CCOH_DB_SetSlotData(oPC, nSlot, "");
        MK_CCOH_DB_SetSlotName(oPC, nSlot, "");
    }
    return TRUE;
}

int MK_CCOH_DB_WriteItemAppearanceToDatabase(object oPC, object oItem, int nSlot, int nMask, string sName)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
//    string sVarName= MK_CCOH_DB_GetVarName(nSlot);
    if (GetIsObjectValid(oItem))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_WriteToDatabase("+GetName(oPC)+", "+GetName(oItem)+", slot="+IntToString(nSlot)+
//            ", nMark="+IntToString(nMask)+", sName='"+sName+"')");
        MK_CCOH_DB_SetSlotData(oPC, nSlot, MK_CCOH_DB_ItemAppearanceToIAStr(oItem, nMask));
        MK_CCOH_DB_SetSlotName(oPC, nSlot, sName);
    }
    else
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_WriteToDatabase("+GetName(oPC)+", '', slot="+IntToString(nSlot)+
//            ", nMark="+IntToString(nMask)+", sName='"+sName+"')");
        MK_CCOH_DB_SetSlotData(oPC, nSlot, "");
        MK_CCOH_DB_SetSlotName(oPC, nSlot, "");
    }
    return TRUE;
}

int MK_CCOH_DB_ReadBodyAppearanceFromDatabase(object oPC, object oCreature, int nSlot, int nMask)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_ReadFromDatabase('"+GetName(oPC)+"', '"+GetName(oItem)+"', nSlot="
//        +IntToString(nSlot)+", nMask="+IntToString(nMask)+")");
    if (!GetIsObjectValid(oPC)) return FALSE;
    if (!GetIsObjectValid(oCreature)) return FALSE;

    string sIAStr = MK_CCOH_DB_GetSlotData(oPC, nSlot);

    float fDelay = GetLocalFloat(oPC, "MK_RESTOREBODY_DELAY");

    return MK_CCOH_DB_IAStrToBodyAppearance(oCreature, sIAStr, nMask, fDelay);
}

object MK_CCOH_DB_ReadItemAppearanceFromDatabase(object oPC, object oItem, int nSlot, int nMask)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_ReadFromDatabase('"+GetName(oPC)+"', '"+GetName(oItem)+"', nSlot="
//        +IntToString(nSlot)+", nMask="+IntToString(nMask)+")");
    if (!GetIsObjectValid(oPC)) return OBJECT_INVALID;
    if (!GetIsObjectValid(oItem)) return OBJECT_INVALID;

    string sIAStr = MK_CCOH_DB_GetSlotData(oPC, nSlot);

    return MK_CCOH_DB_IAStrToItemAppearance(oItem, sIAStr, nMask);
}

int MK_CCOH_DB_GetIsIAStrValid(string sIAStr)
{
    string s = GetStringLeft(sIAStr, 1);
    if ((s!=g_cHexDbMode) && (s!=g_cDecDbMode))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_GetIsIAStrValid: s='"+s+"' != '"+g_cHexDbMode+"'/'"+g_cDecDbMode+"'");
        return FALSE;
    }
    if (GetSubString(sIAStr, g_iastrFmtDef.nDelimiterPos, 1) != "!")
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_GetIsIAStrValid: d='"+GetSubString(sIAStr, g_iastrFmtDef.nDelimiterPos, 1)+"' != '!'");
        return FALSE;
    }
    return TRUE;
}

int MK_CCOH_DB_GetIsItemAppearance(string sIAStr)
{
    return (GetSubString(sIAStr, g_iastrFmtDef.nApprTypePos, g_iastrFmtDef.nApprTypeLen) == "I");
}

int MK_CCOH_DB_GetIsBodyAppearance(string sIAStr)
{
    return (GetSubString(sIAStr, g_iastrFmtDef.nApprTypePos, g_iastrFmtDef.nApprTypeLen) == "B");
}

int MK_CCOH_DB_GetBaseItemTypeFromIAStr(string sIAStr)
{
    return MK_CCOH_DB_StringToInt(sIAStr, g_iastrFmtDef.nBaseItemTypePos, g_iastrFmtDef.nBaseItemTypeLen);
}

int MK_CCOH_DB_GetACBonusFromIAStr(string sIAStr)
{
    return MK_CCOH_DB_StringToInt(sIAStr, g_iastrFmtDef.nACBonusPos, g_iastrFmtDef.nACBonusLen);
}

int MK_CCOH_DB_GetVersionFromIAStr(string sIAStr)
{
    return MK_CCOH_DB_StringToInt(sIAStr,g_iastrFmtDef.nVersionPos,g_iastrFmtDef.nVersionLen);
}

string MK_CCOH_DB_GetNextIASStr(string sIAStr, int iStart)
{
    int iEnd=iStart;
    int nLen = GetStringLength(sIAStr);
    while (GetSubString(sIAStr,iEnd,1)!="!")
    {
        iEnd++;
//        MK_DEBUG_TRACE(">  iEnd="+IntToString(iEnd)+", c="+GetSubString(sIAStr,iEnd,1)
//            +", nLen="+IntToString(nLen));
        if (iEnd>=nLen)
        {
            return "";
        }
    }
    return GetSubString(sIAStr, iStart, iEnd-iStart+1);
}

int MK_CCOH_DB_ReadDbMode(string sIAStr)
{
    string c = GetStringLeft(sIAStr,1);
    if (c == g_cHexDbMode)
    {
        g_iastrFmtDef = MK_CCOH_DB_SetDbMode(MK_CCOH_DB_HexMode);
        return TRUE;
    }
    else if (c == g_cDecDbMode)
    {
        g_iastrFmtDef = MK_CCOH_DB_SetDbMode(MK_CCOH_DB_DecMode);
        return TRUE;
    }
    return FALSE;
}

int MK_CCOH_DB_IAStrToBodyAppearance(object oCreature, string sIAStr, int nMask, float fDelay)
{
    int nReturn=TRUE;

//    MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToBodyAppearance('"+GetName(oCreature)+"', '"+sIAStr+"', nMask="+IntToString(nMask)+")");
    if (!GetIsObjectValid(oCreature))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance: creature is invalid");
        return FALSE;
    }
    if (!MK_CCOH_DB_ReadDbMode(sIAStr))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance: MK_CCOH_DB_ReadDbMode returns FALSE");
        return FALSE;
    }
    if (!MK_CCOH_DB_GetIsBodyAppearance(sIAStr))
    {
        return FALSE;
    }

    string sIASStr;
    int nLen = GetStringLength(sIAStr);
    int iPos = g_iastrFmtDef.nDelimiterPos+1;
    int nCount = 0;
    do
    {
        sIASStr = MK_CCOH_DB_GetNextIASStr(sIAStr, iPos);
        iPos+=GetStringLength(sIASStr);

//        MK_DEBUG_TRACE("> iPos="+IntToString(iPos)+", sIASStr("+IntToString(nCount)+")='"+sIASStr+"'");

        if (sIASStr!="")
        {
 //           int nBodyPart = MK_CCOH_DB_IntToString(sIASStr, 0, 2);
            nReturn = MK_CCOH_DB_IASStrToBodyPart(oCreature, sIASStr);
        }
        nCount++;

    } while ((sIASStr!="") && (iPos<nLen) && nReturn);

    return nReturn;
}

object MK_CCOH_DB_IAStrToItemAppearance(object oItem, string sIAStr, int nMask)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance('"+GetName(oItem)+"', '"+sIAStr+"', nMask="+IntToString(nMask)+")");
    if (!GetIsObjectValid(oItem))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance: item is invalid");
        return OBJECT_INVALID;
    }
    if (!MK_CCOH_DB_ReadDbMode(sIAStr))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance: MK_CCOH_DB_ReadDbMode returns FALSE");
        return OBJECT_INVALID;
    }

    if (!MK_CCOH_DB_GetIsItemAppearance(sIAStr))
    {
        return OBJECT_INVALID;
    }

    int nLen = GetStringLength(sIAStr);
    int nItemType = GetBaseItemType(oItem);
    if (nItemType != MK_CCOH_DB_GetBaseItemTypeFromIAStr(sIAStr))
    {
//        MK_DEBUG_TRACE("MK_CCOH_DB_IAStrToItemAppearance: itemType = "
//            +IntToString(nItemType)
//            +" != stored item type = "
//            +IntToString(MK_CCOH_DB_GetBaseItemTypeFromIAStr(sIAStr)));
        return OBJECT_INVALID;
    }
    int nACBonus = MK_CCOH_DB_GetACBonusFromIAStr(sIAStr);

    object oItemQ = MK_CopyItem(oItem, OBJECT_INVALID, TRUE);
    string sIASStr;
    int iPos = g_iastrFmtDef.nDelimiterPos+1;
    int nCount = 0;
    do
    {
        sIASStr = MK_CCOH_DB_GetNextIASStr(sIAStr, iPos);
        iPos+=GetStringLength(sIASStr);

//        MK_DEBUG_TRACE("> iPos="+IntToString(iPos)+", sIASStr("+IntToString(nCount)+")='"+sIASStr+"'");

        if (sIASStr!="")
        {
            string c = GetStringLeft(sIASStr,1);
            if ((c=="M") && (nMask & MK_CCOH_DB_ITEM_APPR_MODEL))
            {
                SendMessageToPC(GetPCSpeaker(), "Reading model...");
                oItemQ = MK_CCOH_DB_IASStrToItemModel(oItemQ, sIASStr);
                if (!GetIsObjectValid(oItemQ))
                {
                    SendMessageToPC(GetPCSpeaker(),
                        "Failed to read model from database!");
                }
            }
            else if ((c=="C") && (nMask & MK_CCOH_DB_ITEM_APPR_COLOR))
            {
                SendMessageToPC(GetPCSpeaker(), "Reading color...");
                oItemQ = MK_CCOH_DB_IASStrToItemColor(oItemQ, sIASStr);
                if (!GetIsObjectValid(oItemQ))
                {
                    SendMessageToPC(GetPCSpeaker(),
                        "Failed to read color from database!");
                }
            }
        }
        nCount++;

    } while ((sIASStr!="") && (iPos<nLen) && GetIsObjectValid(oItemQ));

    return oItemQ;
}

/*
int MK_CCOH_DB_GetIASStrTypesFromIAStr(string sIAStr)
{
    int nResult = 0;

    if (MK_CCOH_DB_GetIsIAStrValid(sIAStr))
    {
        string sIASStr;
        int nLen = GetStringLength(sIAStr);
        int iPos = g_iastrFmtDef.nDelimiterPos+1;
        int nCount = 0;
        do
        {
            sIASStr = MK_CCOH_DB_GetNextIASStr(sIAStr, iPos);
            iPos+=GetStringLength(sIASStr);
            if (sIASStr!="")
            {
                string c = GetStringLeft(sIASStr,1);
                if (c=="M")
                {
                    nResult |= MK_CCOH_DB_ITEM_APPR_MODEL;
                }
                else if (c=="C")
                {
                    nResult |= MK_CCOH_DB_ITEM_APPR_COLOR;
                }
            }
            nCount++;
        } while ((sIASStr!="") && (iPos<nLen));
    }

    return nResult;
}
*/

int MK_CCOH_DB_GetIASStrTypesFromSlot(object oPC, int nSlot)
{
    string sIAStr = MK_CCOH_DB_GetSlotData(oPC, nSlot);
    return MK_CCOH_DB_GetApprTypesFromIAStr(sIAStr);
//    return MK_CCOH_DB_GetIASStrTypesFromIAStr(sIAStr);
}

void MK_CCOH_DB_Init(object oPC)
{
    g_iastrFmtDef = MK_CCOH_DB_SetDbMode(MK_CCOH_DB_HexMode);

    MK_CCOH_DB_SetDatabaseName(oPC,
        (GetLocalInt(oPC, "MK_SAVERESTORE_USE_DATABASE") ? MK_CCOH_DB_DATABASE_NAME : "") );

    g_bCCOH_DB_UseLocalDb = MK_CCOH_DB_GetUseLocalDb(oPC);
}

int MK_CCOH_DB_SaveBody(object oPC)
{
//    MK_DEBUG_TRACE("MK_CCOH_DB_SaveBody('"+GetName(oPC)+"')");
    string sIAStr =MK_CCOH_DB_BodyAppearanceToIAStr(oPC, 65279);
    MK_DEBUG_TRACE("MK_CCOH_DB_SaveBody: saving current body as '"+sIAStr+"'");
    SetLocalString(oPC, MK_CCOH_DB_SAVED_BODY_APPEARANCE, sIAStr);
    return TRUE;
}

int MK_CCOH_DB_RestoreBody(object oPC)
{
    if ((MK_GetBodyPartToBeModified(oPC) != MK_CRAFTBODY_HORSE)
        ||  (MK_HORSE_GetHorseSystem() != MK_HORSE_BIOWARE_HORSE_SYSTEM))
    {
        string sIAStr = GetLocalString(oPC, MK_CCOH_DB_SAVED_BODY_APPEARANCE);
        if (sIAStr!="")
        {
            DeleteLocalString(oPC, MK_CCOH_DB_SAVED_BODY_APPEARANCE);
            float fDelay = GetLocalFloat(oPC, "MK_RESTOREBODY_DELAY");
//        MK_DEBUG_TRACE("MK_CCOH_DB_RestoreBody: restoring from '"+sIAStr+"'");
            MK_CCOH_DB_IAStrToBodyAppearance(oPC, sIAStr, 65279, fDelay);
        }
    }
    return TRUE;
}

int MK_CCOH_DB_GetIsBodyChanged(object oPC)
{
    string sIAStr1 = GetLocalString(oPC, MK_CCOH_DB_SAVED_BODY_APPEARANCE);
    string sIAStr2 = MK_CCOH_DB_BodyAppearanceToIAStr(oPC, 65279);
//    MK_DEBUG_TRACE("MK_CCOH_DB_GetIsBodyChanged: saved: "+sIAStr1+", current: "+sIAStr2);
    return (sIAStr1!=sIAStr2);
}

void MK_CCOH_DB_Cleanup(object oPC)
{
    DeleteLocalInt(oPC, "MK_CCOH_DB_VALID_IASSTR_TYPES");
    DeleteLocalInt(oPC, "MK_CCOH_DB_SELECTED_IASSTR_TYPES");
    DeleteLocalInt(oPC, MK_CCOH_DB_READWRITE);
    DeleteLocalInt(oPC, MK_CCOH_DB_CURRENT_SLOTNR);
    DeleteLocalInt(oPC, MK_CCOH_DB_CURRENT_APPRTYPE);
}

/*
void main()
{
}
/**/


