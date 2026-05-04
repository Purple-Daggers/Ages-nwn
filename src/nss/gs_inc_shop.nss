/* SHOP library by Gigaschatten */

#include "gs_inc_class"
#include "gs_inc_container"

//void main() {}

//return TRUE if oPC is owner of oShop
int gsSHGetIsOwner(object oShop, object oPC);
//return owner id of oShop
string gsSHGetOwnerID(object oShop);
//make oPC own oShop
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0);
//return owner name of oShop
string gsSHGetOwnerName(object oShop);
//update timestamp of oShop
void gsSHTouch(object oShop);
//return TRUE if oShop is vacant
int gsSHGetIsVacant(object oShop);
//return TRUE if oShop is available
int gsSHGetIsAvailable(object oShop);
//load inventory of oShop
void gsSHLoad(object oShop);
//save inventory of oShop
void gsSHSave(object oShop);
//abandon oShop
void gsSHAbandon(object oShop);
//import oItem to oShop
void gsSHImportItem(object oItem, object oShop);
//export oItem to oTarget
void gsSHExportItem(object oItem, object oTarget);
//set sale price of oShop to nValue
void gsSHSetSalePrice(object oShop, int nValue);
//return sale price of oShop
int gsSHGetSalePrice(object oShop);

int gsSHGetIsOwner(object oShop, object oPC)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCLGetIsOwner(sID, nInstance, oPC);
}
//----------------------------------------------------------------
string gsSHGetOwnerID(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCLGetOwnerID(sID, nInstance);
}
//----------------------------------------------------------------
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCLSetOwner(sID, nInstance, oPC);
    gsCLSetTimeout(sID, nInstance, gsTIGetGameTimestamp(nTimeout));
}
//----------------------------------------------------------------
string gsSHGetOwnerName(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCLGetName(sID, nInstance);
}
//----------------------------------------------------------------
void gsSHTouch(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCLSetActualTimestamp(sID, nInstance);
}
//----------------------------------------------------------------
int gsSHGetIsVacant(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCLGetIsVacant(sID, nInstance);
}
//----------------------------------------------------------------
int gsSHGetIsAvailable(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCLGetIsAvailable(sID, nInstance);
}
//----------------------------------------------------------------
void gsSHLoad(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCOLoad(sID + "_" + IntToString(nInstance), oShop, 20);

    object oItem  = GetFirstItemInInventory(oShop);

    while (GetIsObjectValid(oItem))
    {
        SetLocalObject(oItem, "GS_SH_CONTAINER", oShop);
        oItem = GetNextItemInInventory(oShop);
    }
}
//----------------------------------------------------------------
void gsSHSave(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCOSave(sID + "_" + IntToString(nInstance), oShop, 20);
}
//----------------------------------------------------------------
void gsSHAbandon(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCLRelease(sID, nInstance);
}
//----------------------------------------------------------------
void gsSHImportItem(object oItem, object oShop)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) != "GS_SH_")
    {
        object oCopy = CopyObject(oItem,
                                  GetLocation(oShop),
                                  oShop,
                                  "GS_SH_" + sTag);

        if (GetIsObjectValid(oCopy))
        {
            SetLocalObject(oCopy, "GS_SH_CONTAINER", oShop);
            DestroyObject(oItem);
        }
    }
}
//----------------------------------------------------------------
void gsSHExportItem(object oItem, object oTarget)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) == "GS_SH_")
    {
        object oCopy = CopyObject(oItem,
                                  GetLocation(oTarget),
                                  oTarget,
                                  GetStringRight(sTag, GetStringLength(sTag) - 6));

        if (GetIsObjectValid(oCopy))
        {
            DestroyObject(oItem);
        }
    }
}
//----------------------------------------------------------------
void gsSHSetSalePrice(object oShop, int nValue)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    if (nValue < 1)         nValue =    1;
    else if (nValue > 1000) nValue = 1000;

    SetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance), nValue);
}
//----------------------------------------------------------------
int gsSHGetSalePrice(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");
    int nValue    = GetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance));

    return nValue <= 0 ? 100 : nValue;
}
