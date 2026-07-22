// mk_inc_cheats

#include "x2_inc_itemprop"
#include "mk_inc_debug"
#include "mk_inc_tools"
#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_iprp"
#include "mk_inc_array"
#include "mk_inc_ipwrkcntn"

//const int MK_CHEATS_DEBUG = TRUE;
const int MK_CHEATS_DEBUG = FALSE;


const int MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT = 1001;
const int MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT = 1002;
const int MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT = 1003;
const int MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT = 1004;
const int MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT = 1005;
const int MK_STATE_CHEATS_ITEMPROPS_FILTERITEMS_INIT = 1006;

/*
string MK_CHEATS_CreateItemPropertyTag(int nType, int nSubType, int nCostTable=-1, int nParam1=-1)
{
    return "MK_CHEATS_ITEMPROP_" + MK_IntToString(nType, 4, "0")
        + MK_IntToString(nSubType, 4, "0")
//        + MK_IntToString(nCostTable, 4, "0")
        + (nParam1!=-1 ? MK_IntToString(nParam1, 4, "0") : "");
}
*/

object MK_CHEATS_GetCurrentItem();

int MK_CHEATS_GetCurrentItemPropertyID();

void MK_CHEATS_SetCurrentItemPropertyID(int nIPropID);

int MK_CHEATS_GetCurrentItemPropertySubType();

void MK_CHEATS_SetCurrentItemPropertySubType(int nSubType);

int MK_CHEATS_GetCurrentItemPropertyCostTableValue();

void MK_CHEATS_SetCurrentItemPropertyCostTableValue(int nCostTableValue);

string MK_CHEATS_GetCurrentItemName(string sDefault="");

string MK_CHEATS_GetCurrentGoldPieceValueAsString(string sDefault="");

string MK_CHEATS_GetCurrentItemPropertyName(string sDefault="");

int MK_CHEATS_GetCurrentItemPropertyCount(int nType=-1, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

int MK_CHEATS_GetHasCurrentItemValidNumberOfCastSpellProps(int bDisplayMessage=TRUE);

///////////////////////////////////////////////////////////////////////////////

void MK_CHEATS_DEBUG_TRACE(string sMessage)
{
    if (MK_CHEATS_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}

int MK_CHEATS_GetCurrentItemPropertyCount(int nType, int nSubType, int nCostTableValue, int nParam1Value)
{
    return MK_IPRP_GetItemPropertyCount(MK_CHEATS_GetCurrentItem(), nType, nSubType, nCostTableValue, nParam1Value);
}

int MK_CHEATS_GetSkillCount()
{
    return MK_Get2DALength("skills", "Label", 10);
}

void MK_CHEATS_SetCurrentSkill(int nSkill)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_SKILL", nSkill);
}

int MK_CHEATS_GetCurrentSkill()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_SKILL");
}

void MK_CHEATS_SetCurrentStore(int nStoreID)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_STORE", nStoreID);
}

int MK_CHEATS_GetCurrentStore()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_STORE");
}

string MK_CHEATS_GetCurrentStoreResRef()
{
    int nStoreID = MK_CHEATS_GetCurrentStore();
    return Get2DAString("mk_cheat_stores", "RESREF", nStoreID);
}

string MK_CHEATS_GetCurrentStoreTag()
{
    int nStoreID = MK_CHEATS_GetCurrentStore();
    return Get2DAString("mk_cheat_stores", "TAG", nStoreID);
}

string MK_CHEATS_GetStoreNameByID(int nStoreID)
{
    string s2DAFile = "mk_cheat_stores";
    int nStrRef = MK_Get2DAInt(s2DAFile, "STRREF", nStoreID, 0);
    string sStoreName;
    if (nStrRef!=0)
    {
        sStoreName = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
        string sPostfix = Get2DAString(s2DAFile, "POSTFIX", nStoreID);
        if (sPostfix!="")
        {
            sStoreName += (" " + sPostfix);
        }
    }
    else
    {
        sStoreName = Get2DAString(s2DAFile, "Name", nStoreID);
    }
    return sStoreName;
}

string MK_CHEATS_GetCurrentStoreName()
{
    return MK_CHEATS_GetStoreNameByID(MK_CHEATS_GetCurrentStore());
}

object MK_CHEATS_SearchCurrentStore()
{
    object oStore = OBJECT_INVALID;
    string sTag = MK_CHEATS_GetCurrentStoreTag();
    if (sTag!="")
    {
        oStore = GetObjectByTag(sTag);
    }
    return oStore;
}

int MK_CHEATS_InitializeItemAdditionalCostCalculation(object oItem)
{
    int bReturn = FALSE;
    object oContainer = MK_IPGetIPWorkContainer();
    if (GetIsObjectValid(oContainer))
    {
        object oTempCopy = CopyItem(oItem, oContainer, FALSE);
        if (GetIsObjectValid(oTempCopy))
        {
//            SetItemStackSize(oTempCopy, 1);
//          seems to have no impact because when calculating the additional costs stacksize is the original stacksize again???
//          So we set stack size before we calculate the additional costs.
            SetPlotFlag(oTempCopy, TRUE);
            MK_IPRP_RemoveAllItemProperties(oTempCopy);
            SetLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM_TEMPCOPY", oTempCopy);
            SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_ADDITIONAL_COST", -1);
//            MK_CHEATS_DEBUG_TRACE("MK_CHEATS_InitializeItemAdditionalCostCalculation: stackSize="+IntToString(GetItemStackSize(oTempCopy)));
//            MK_CHEATS_DEBUG_TRACE("MK_CHEATS_InitializeItemAdditionalCostCalculation: stackSize="+IntToString(GetItemStackSize(GetLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM_TEMPCOPY"))));
            bReturn = TRUE;
            MK_CHEATS_DEBUG_TRACE("Item Additional Cost Calculation initialized!");
        }
    }
    if (!bReturn)
    {
        MK_CHEATS_DEBUG_TRACE("Failed to initialize Item Additional Cost Calculation!");
    }
    return bReturn;
}

int MK_CHEATS_SetCurrentItem(object oItem)
{
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_SetCurrentItem('"+GetName(oItem)+"')");
    int bReturn=FALSE;

    object oPC = GetPCSpeaker();
    int nState = MK_GenericDialog_GetState();

    if (GetIsObjectValid(oItem))
    {
        switch (nState)
        {
        case MK_STATE_CHEATS_CHARGES:
            CISetCurrentModMode(oPC, MK_CI_MODMODE_ITEM);
            MK_StartModifyItem(oPC, oItem, FALSE, FALSE);
            break;
        case MK_STATE_CHEATS_ITEMPROPS:
//        case MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT:
//        case MK_STATE_CHEATS_ITEMPROPS_PROPERTY_INIT:
//        case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE_INIT:
//        case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE_INIT:
//        case MK_STATE_CHEATS_ITEMPROPS_PARAM1_INIT:
        {
            MK_CHEATS_DEBUG_TRACE("MK_CHEATS_SetCurrentItem('"+GetName(oItem)+"'");
            int nBaseItemType = GetBaseItemType(oItem);
            if (nBaseItemType != BASE_ITEM_INVALID)
            {
                MK_CHEATS_DEBUG_TRACE(" > nBaseItemType="+IntToString(nBaseItemType));
                int nPropColumn = MK_Get2DAInt("baseitems", "PropColumn", nBaseItemType, -1);
                if (nPropColumn!=-1)
                {
                    MK_CHEATS_DEBUG_TRACE(" > nPropColumn="+IntToString(nPropColumn));
                    string sPropColumn = Get2DAString("mk_iprp_cols", "Column", nPropColumn);
                    if (sPropColumn!="")
                    {
                        MK_CHEATS_DEBUG_TRACE(" > sPropColumn='"+sPropColumn+"'");
                        SetLocalString(oPC, "MK_CHEATS_CURRENT_PROPCOL", sPropColumn);
//                        SetLocalObject(oPC, "MK_CHEATS_CURRENT_ITEM", oItem);
                        MK_CHEATS_InitializeItemAdditionalCostCalculation(oItem);

                        CISetCurrentModMode(oPC, MK_CI_MODMODE_ITEM);
                        MK_StartModifyItem(oPC, oItem, FALSE, FALSE);

                        MK_CHEATS_SetCurrentItemPropertyID(-1);
                        MK_CHEATS_SetCurrentItemPropertySubType(-1);
                        MK_CHEATS_SetCurrentItemPropertyCostTableValue(-1);

                        bReturn = TRUE;
                    }
                }
            }
            break;
        }
        default:
            CISetCurrentModItem(oPC, oItem);
//            SetLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM", oItem);
            bReturn = TRUE;
        }
    }
    else
    {
        DeleteLocalString(OBJECT_SELF, "MK_CHEATS_CURRENT_PROPCOL");
//        DeleteLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM");
        DeleteLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_ADDITIONAL_COST");
        DeleteLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROPID");
        DeleteLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_SUBTYPE");
        DeleteLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_COSTTABLEVALUE");
        CISetCurrentModItem(oPC, OBJECT_INVALID);
        CISetCurrentModBackup(oPC, OBJECT_INVALID);
        CISetCurrentModMode(oPC, 0);
    }
    return bReturn;
}

object MK_CHEATS_GetCurrentItem()
{
    return CIGetCurrentModItem(GetPCSpeaker());
}

string MK_CHEATS_GetCurrentItemName(string sDefault)
{
    string sName=sDefault;
    object oItem = MK_CHEATS_GetCurrentItem();
    if (GetIsObjectValid(oItem))
    {
        sName = GetName(oItem);
    }
    return sName;
}

int MK_CHEATS_CalculateCurrentItemAdditionalCost()
{
    int bReturn = FALSE;
    object oTempCopy = GetLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM_TEMPCOPY");
    if (GetIsObjectValid(oTempCopy))
    {
//        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_CalculateCurrentItemAdditionalCost: stackSize="+IntToString(GetItemStackSize(oTempCopy)));
        SetItemStackSize(oTempCopy, 1);
//        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_CalculateCurrentItemAdditionalCost: stackSize="+IntToString(GetItemStackSize(oTempCopy)));

        int nAdditionalCost = MK_IPRP_GetItemAdditionalCostValue(oTempCopy);

        DeleteLocalObject(OBJECT_SELF, "MK_CHEATS_CURRENT_ITEM_TEMPCOPY");
        DestroyObject(oTempCopy);

        if (nAdditionalCost!=-1)
        {
            bReturn = TRUE;
            MK_CHEATS_DEBUG_TRACE("Item Additional Cost Calculation successful!");
        }
        else
        {
            MK_CHEATS_DEBUG_TRACE("Falied to calculate Item Additional Cost!");
        }
        SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_ADDITIONAL_COST", MK_MATH_MaxInt(nAdditionalCost,0));
    }
    return bReturn;
}

int MK_CHEATS_GetCurrentItemAdditionalCost()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_ADDITIONAL_COST");
}

int MK_CHEATS_GetCurrentGoldPieceValue()
{
    return MK_IPRP_GetGoldPieceValue(MK_CHEATS_GetCurrentItem());
}

int MK_CHEATS_CalculateCurrentGoldPieceValue()
{
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_CalculateCurrentGoldPieceValue()");
    int nItemValue=-1;
    int nAdditionalCost = MK_CHEATS_GetCurrentItemAdditionalCost();
    MK_CHEATS_DEBUG_TRACE(" > nAdditionalCost="+IntToString(nAdditionalCost));
    if (nAdditionalCost == -1)
    {
        nItemValue = MK_CHEATS_GetCurrentGoldPieceValue();
    }
    else
    {
        nItemValue = MK_IPRP_CalculateGoldPieceValue(MK_CHEATS_GetCurrentItem(), nAdditionalCost);
    }
    MK_CHEATS_DEBUG_TRACE(" > nItemValue="+IntToString(nItemValue));
    return nItemValue;
}

string MK_CHEATS_GetCurrentGoldPieceValueAsString(string sDefault)
{
    string sItemValue = sDefault;
    object oItem = MK_CHEATS_GetCurrentItem();
    if (GetIsObjectValid(oItem))
    {
        int nValue1 = MK_CHEATS_CalculateCurrentGoldPieceValue();
        int nValue2 = MK_CHEATS_GetCurrentGoldPieceValue();
        sItemValue = IntToString(nValue1) + " (" + IntToString(nValue2) +")";
    }
    return sItemValue;
}

string MK_CHEATS_GetCurrentItemPropertyName(string sDefault)
{
    string sItemPropertyName = sDefault;
    if (GetIsObjectValid(MK_CHEATS_GetCurrentItem()))
    {
        int nType = MK_CHEATS_GetCurrentItemPropertyID();
        int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
        int nCostTableValue = MK_CHEATS_GetCurrentItemPropertyCostTableValue();
        sItemPropertyName = MK_IPRP_GetItemPropertyNameByID(nType, nSubType, nCostTableValue);
//        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetCurrentItemPropertyName(): nType="+IntToString(nType)
//            +", nSubType="+IntToString(nSubType)
//            +", nCostTableValue="+IntToString(nCostTableValue)
//            +", name='"+sItemPropertyName+"'");
    }
    return sItemPropertyName;
}

string MK_CHEATS_GetCurrentPropColumn()
{
    return GetLocalString(OBJECT_SELF, "MK_CHEATS_CURRENT_PROPCOL");
}

void MK_CHEATS_SetCurrentItemPropertyID(int nIPropID)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROPID", nIPropID);
}

int MK_CHEATS_GetCurrentItemPropertyID()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROPID");
}

string MK_CHEATS_GetCurrentItemPropertyTypeName()
{
    string sIPropName="";
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    if (nIPropID!=-1)
    {
        int nStrRef = MK_Get2DAInt("itempropdef", "Name", nIPropID, 0);
        sIPropName = GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
    }
    return sIPropName;
}

string MK_CHEATS_GetCurrentItemPropertyGameName()
{
    string sIPropName="";
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    if (nIPropID!=-1)
    {
        int nStrRef = MK_Get2DAInt("itempropdef", "GameStrRef", nIPropID, 0);
        sIPropName = GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
    }
    return sIPropName;
}

string MK_CHEATS_GetCurrentSubTypeResRef()
{
    string sSubTypeResRef="";
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    if (nIPropID!=-1)
    {
        sSubTypeResRef= Get2DAString("itempropdef", "SubTypeResRef", nIPropID);
    }
    return sSubTypeResRef;
}

void MK_CHEATS_SetCurrentItemPropertySubType(int nSubType)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_SUBTYPE", nSubType);
}

int MK_CHEATS_GetCurrentItemPropertySubType()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_SUBTYPE");
}

string MK_CHEATS_GetCurrentItemPropertySubTypeName()
{
    string sSubTypeName="";
    int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();

    if (nSubType!=-1)
    {
        string sSubTypeResRef = MK_CHEATS_GetCurrentSubTypeResRef();
        sSubTypeName = GetStringByStrRef(MK_Get2DAInt(sSubTypeResRef, "Name", nSubType, 0), GetGender(OBJECT_SELF));
    }
    return sSubTypeName;
}

int MK_CHEATS_GetCurrentParam1ResRefID()
{
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();

    return MK_IPRP_GetParam1ResRefIDByID(nIPropID, nSubType);
}

string MK_CHEATS_GetCurrentParam1ResRef()
{
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();

    return MK_IPRP_GetParam1ResRefByID(nIPropID, nSubType);
}

string MK_CHEATS_GetCurrentCostTableResRef()
{
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    return MK_IPRP_GetCostTableResRefByID(nIPropID);
}

int MK_CHEATS_GetCurrentParam1TableStrRef()
{
    int nStrRef = 0;
    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();

    int nParam1ResRefID = MK_IPRP_GetParam1ResRefIDByID(nIPropID, nSubType);
    if (nParam1ResRefID!=-1)
    {
        nStrRef = MK_Get2DAInt("iprp_paramtable", "Name", nParam1ResRefID, 0);
    }
    return nStrRef;
}

void MK_CHEATS_SetCurrentItemPropertyParam1Value(int nParam1)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_PARAM1", nParam1);
}

int MK_CHEATS_GetCurrentItemPropertyParam1Value()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_PARAM1");
}

string MK_CHEATS_GetCurrentItemPropertyParam1Name()
{
    string sParam1Name="";
    int nParam1 = MK_CHEATS_GetCurrentItemPropertyParam1Value();
    if (nParam1!=-1)
    {
        string s2DAFile = MK_CHEATS_GetCurrentParam1ResRef();

        int nStrRef = MK_Get2DAInt(s2DAFile, "Name", nParam1, 0);

        sParam1Name = GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
    }
    return sParam1Name;
}

int MK_CHEATS_GetCurrentItemPropertyCostTableValue()
{
    return GetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_COSTTABLEVALUE");
}

void MK_CHEATS_SetCurrentItemPropertyCostTableValue(int nCostTableValue)
{
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_CURRENT_IPROP_COSTTABLEVALUE", nCostTableValue);
}

string MK_CHEATS_GetCurrentItemPropertyCostTableValueName()
{
    string sCostTableValueName="";
    int nCostTableValue = MK_CHEATS_GetCurrentItemPropertyCostTableValue();
    if (nCostTableValue>0)
    {
        string s2DAFile = MK_CHEATS_GetCurrentCostTableResRef();

        int nStrRef = MK_Get2DAInt(s2DAFile, "Name", nCostTableValue, 0);

        sCostTableValueName = GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
    }
    return sCostTableValueName;
}

void MK_CHEATS_ToggleItemProperty(object oItem, int nIPropID, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=0)
{
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_ToggleItemProperty('"+GetName(oItem)+"', nIPropID="+IntToString(nIPropID)
        +", nSubType="+IntToString(nSubType)
        +", nCostTableValue="+IntToString(nCostTableValue)
        +", nParam1Value="+IntToString(nParam1Value));

    itemproperty iProp = MK_IPRP_GetItemProperty(oItem, nIPropID, nSubType, nCostTableValue, nParam1Value);
    if (GetIsItemPropertyValid(iProp))
    {
        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_ToggleItemProperty: property removed.");
        RemoveItemProperty(oItem, iProp);
    }
    else if (MK_IPRP_CreateItemPropertyOnItem(oItem, nIPropID, nSubType, nCostTableValue, nParam1Value))
    {
        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_ToggleItemProperty: property created.");
    }
    else
    {
       MK_CHEATS_DEBUG_TRACE("MK_CHEATS_ToggleItemProperty: failed to create property.");
    }
}

int MK_CHEATS_GetIsCurrentItemModified()
{
    int bResult = FALSE;
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);
    object oBackup = CIGetCurrentModBackup(oPC);

//    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetIsCurrentItemModified(): '"
//        +GetName(oItem)+"', '"+GetName(oBackup)+"'");

    if (GetIsObjectValid(oItem) && GetIsObjectValid(oBackup))
    {
        int nState = MK_GenericDialog_GetState();

        switch (nState)
        {
        case MK_STATE_CHEATS_ITEMPROPS_ITEM:
        case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
        case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
        case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
        case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
        {
            string sIASStrBackup = MK_CCOH_DB_ItemPropertiesToIASStr(oBackup);
            string sIASStrCurrent = MK_CCOH_DB_ItemPropertiesToIASStr(oItem);
            bResult = (sIASStrBackup != sIASStrCurrent);
//            MK_CHEATS_DEBUG_TRACE(" > '"+sIASStrCurrent+"', '"+sIASStrBackup+"': bResult="+IntToString(bResult));
            break;
        }
        case MK_STATE_CHEATS_CHARGES:
            bResult = GetItemCharges(oItem)!=GetItemCharges(oBackup);
//            MK_CHEATS_DEBUG_TRACE(" > '"+IntToString(GetItemCharges(oItem))+"', '"+IntToString(GetItemCharges(oBackup))+"': bResult="+IntToString(bResult));
            break;
        }
    }
    return bResult;
}

int MK_CHEATS_GetRequiredGold(int nCurrentValue=-1)
{
//    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetRequiredGold("+IntToString(nCurrentValue)+")");
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
//        MK_CHEATS_DEBUG_TRACE(" > nCurrentValue="+IntToString(nCurrentValue));
//        MK_CHEATS_DEBUG_TRACE(" > nBackupValue="+IntToString(nBackupValue));
//        MK_CHEATS_DEBUG_TRACE(" > nRequiredGold="+IntToString(nRequiredGold));
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
//        MK_CHEATS_DEBUG_TRACE(" > fFactor="+FloatToString(fFactor));
//        MK_CHEATS_DEBUG_TRACE(" > nRequiredGold="+IntToString(nRequiredGold));
//        MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetRequiredGold: nCurrentValue="+IntToString(nCurrentValue)
//            +", nBackupValue="+IntToString(nBackupValue)
//            +", fFactor="+FloatToString(fFactor)
//            +", nRequiredGold="+IntToString(nRequiredGold));
//        MK_CHEATS_DEBUG_TRACE(" > oBackup='"+GetName(oBackup)+"', nCalculatedValue="+IntToString(MK_IPRP_CalculateGoldPieceValue(oBackup)));
    }
    return nRequiredGold;
}

int MK_CHEATS_CanModifyItem(int bDisplayMessage)
{
    object oPC = GetPCSpeaker();
    int nState = MK_GenericDialog_GetState();
    switch (nState)
    {
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
        if (!GetLocalInt(oPC, "MK_CHEATS_IGNORE_MINMAX_PROPS"))
        {
            if (!MK_CHEATS_GetHasCurrentItemValidNumberOfCastSpellProps(bDisplayMessage))
            {
                return FALSE;
            }
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
    case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
    case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
    case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
    case MK_STATE_CHEATS_CHARGES:
    {
        int nRequiredGold = MK_CHEATS_GetRequiredGold();
        int nGold = GetGold(oPC);
        if (nRequiredGold > nGold)
        {
            if (bDisplayMessage)
            {
                SendMessageToPC(oPC, "Not enough gold to modify item!");
            }
            return FALSE;
        }
        break;
    }
    }
    return TRUE;
}

int MK_CHEATS_FinishModifyItem()
{
    int bReturn = FALSE;
    object oPC = GetPCSpeaker();

    if (MK_CHEATS_CanModifyItem(FALSE))
    {
        int nRequiredGold = MK_CHEATS_GetRequiredGold();
        int nGold = GetGold(oPC);
        if (nGold >= nRequiredGold)
        {
            MK_FinishModifyItem(oPC, oPC);

            if (nRequiredGold > 0)
            {
                TakeGoldFromCreature(nRequiredGold, oPC, TRUE);
            }
            else if (nRequiredGold < 0)
            {
                GiveGoldToCreature(oPC, -nRequiredGold);
            }
            MK_CHEATS_SetCurrentItem(OBJECT_INVALID);

        //        CISetCurrentModItem(oPC, OBJECT_INVALID);
        //        CISetCurrentModMode(oPC, 0);
        //        MK_CHEATS_SetCurrentItemPropertyID(-1);
        //        MK_CHEATS_SetCurrentItemPropertySubType(-1);
        //        MK_CHEATS_SetCurrentItemPropertyCostTableValue(-1);

            bReturn = TRUE;
        }
    }
    return bReturn;
}

void MK_CHEATS_CancelModifyItem()
{
    object oPC = GetPCSpeaker();
//    int nState = MK_GenericDialog_GetState();

//    MK_GenericDialog_SetCurrentPage(nState, 1);
//    MK_2DA_DISPLAY_Cleanup();
    MK_CancelModifyItem(oPC, oPC);
    MK_CHEATS_SetCurrentItem(OBJECT_INVALID);
//    CISetCurrentModItem(oPC, OBJECT_INVALID);
//    CISetCurrentModMode(oPC, 0);
//    MK_CHEATS_SetCurrentItemPropertyID(-1);
//    MK_CHEATS_SetCurrentItemPropertySubType(-1);
//    MK_CHEATS_SetCurrentItemPropertyCostTableValue(-1);
//    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS_ITEM_INIT);
//    MK_CHEATS_DEBUG_TRACE("MK_ITEMPROP_Cancel(): *terminate*");
//    return nState;
}

int MK_CHEATS_GetHasCurrentItemValidNumberOfCastSpellProps(int bDisplayMessage)
{
    int bResult = FALSE;
    object oItem = MK_CHEATS_GetCurrentItem();

    int nBaseItemType = GetBaseItemType(oItem);
    int nMinProps = MK_Get2DAInt("baseitems", "MinProps", nBaseItemType, 0);
    int nMaxProps = MK_Get2DAInt("baseitems", "MaxProps", nBaseItemType, 0);

    int nCastSpellProps = MK_IPRP_GetItemPropertyCount(oItem, ITEM_PROPERTY_CAST_SPELL);

    if ((nMinProps<=nCastSpellProps) && (nMaxProps>=nCastSpellProps))
    {
        bResult = TRUE;
    }
    else if (bDisplayMessage)
    {
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "Item has invalid number of Cast Spell properties: "+IntToString(nCastSpellProps)+"!");
        SendMessageToPC(oPC, "Allowed number of Cast Spell properties for this item: "+IntToString(nMinProps)+".."+IntToString(nMaxProps)+"!");
    }

    return bResult;
}

void MK_CHEATS_SetCustomToken(/*int nState*/)
{
    object oPC = GetPCSpeaker();
    string sItemName;
    string sItemValue = "-";
    string sRequiredGold = "-";
    int nRequiredGold = 0;
    int nGold = GetGold();

    object oItem = MK_CHEATS_GetCurrentItem();
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_SetCustomToken('"+GetName(oItem)+"'): valid="+IntToString(GetIsObjectValid(oItem)));
    if (GetIsObjectValid(oItem))
    {
        int nCurrentValue = MK_CHEATS_CalculateCurrentGoldPieceValue();
        nRequiredGold = MK_CHEATS_GetRequiredGold(nCurrentValue);
        if (MK_DEBUG_GetDebugMode())
        {
            int nGoldPieceValue = MK_CHEATS_GetCurrentGoldPieceValue();
            sItemValue = IntToString(nCurrentValue) + " / " + IntToString(nGoldPieceValue);
            MK_CHEATS_DEBUG_TRACE(" > nCurrentValue="+IntToString(nCurrentValue)+", nGoldPieceValue="+IntToString(nGoldPieceValue)+", nRequiredGold="+IntToString(nRequiredGold));
        }
        else
        {
            sItemValue = IntToString(nCurrentValue);
        }
        sRequiredGold = IntToString(nRequiredGold);
    }
    sRequiredGold += (" ("+IntToString(nGold)+")");

    sItemName=MK_CHEATS_GetCurrentItemName("-");

    SetCustomToken(14422, sItemName);
    SetCustomToken(14423, sItemValue);
    SetCustomToken(14426, sRequiredGold);

    string sDisabledOptionsColor = GetLocalString(OBJECT_SELF, "MK_DISABLED_OPTIONS_COLOR");
    string sCloseColor = (sDisabledOptionsColor!="" ? "</c>" : "");

    if (!GetLocalInt(oPC, "MK_CHEATS_IGNORE_MINMAX_PROPS") && !MK_CHEATS_GetHasCurrentItemValidNumberOfCastSpellProps())
    {
        SetCustomToken(14460, sDisabledOptionsColor);
        SetCustomToken(14470, " "+MK_TLK_GetStringByStrRef(-500)+"</c>");
    }
    else if (nRequiredGold>nGold)
    {
        SetCustomToken(14460, sDisabledOptionsColor);
        SetCustomToken(14470, " "+MK_TLK_GetStringByStrRef(-474)+"</c>");
    }
    else
    {
        SetCustomToken(14460, "");
        SetCustomToken(14470, "");
    }
}

void MK_CHEATS_InitializeFilterItemArray(object oPC)
{
    if (MK_ARRAY_GetLocalArrayBuffer(oPC, "MK_CHEATS_IPROP_ITEMFILTER") == "")
    {
        MK_ARRAY_InitializeLocalArrayBool(oPC, "MK_CHEATS_IPROP_ITEMFILTER", MK_Get2DALength("mk_iprp_cols", "Column"), TRUE);
//        MK_ARRAY_SetLocalArrayBool(oPC, "MK_CHEATS_IPROP_ITEMFILTER", 17, FALSE); // no properties
    }
}


int MK_CHEATS_GetIsItemTypeSelected(object oPC, int nItemType)
{
    return MK_ARRAY_GetLocalArrayBool(oPC, "MK_CHEATS_IPROP_ITEMFILTER", nItemType);
}

int MK_CHEATS_GetAreAllItemTypesSelected(object oPC)
{
    return MK_ARRAY_GetIsLocalArrayBoolEqual(oPC, "MK_CHEATS_IPROP_ITEMFILTER", TRUE);
}

void MK_CHEATS_SelectItemType(object oPC, int nItemType, int bSelect)
{
    MK_ARRAY_SetLocalArrayBool(oPC, "MK_CHEATS_IPROP_ITEMFILTER", nItemType, bSelect);
}

void MK_CHEATS_SelectAllItemTypes(object oPC, int bSelect)
{
    MK_ARRAY_InitializeLocalArrayBool(oPC, "MK_CHEATS_IPROP_ITEMFILTER", MK_Get2DALength("mk_iprp_cols", "Column"), bSelect);
}

/*
void main()
{

}
/**/
