/* PORTAL Library by Gigaschatten */

//void main() {}

#include "gs_inc_pc"

//register oPortal
void gsPORegisterPortal(object oPortal);
//return portal by nIndex
object gsPOGetPortal(int nIndex);
//return first portal that is active for oPC at or after nIndex, return -1 if at end
int gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF);
//internally used
int _gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF, int nStep = 1);
//return portal that is active for oPC following nIndex, return -1 if at end
int gsPOGetNextActivePortal(int nIndex, object oPC = OBJECT_SELF);
//return portal that is active for oPC preceding nIndex, return -1 if at start
int gsPOGetPreviousActivePortal(int nIndex, object oPC = OBJECT_SELF);
//return name of oPortal
string gsPOGetPortalName(object oPortal);
//return number of portals
int gsPOGetPortalCount();
//activate oPortal for oPC
void gsPOActivatePortal(object oPortal, object oPC = OBJECT_SELF);
//return TRUE if oPortal is active for oPC
int gsPOGetIsPortalActive(object oPortal, object oPC = OBJECT_SELF);

void gsPORegisterPortal(object oPortal)
{
    object oModule = GetModule();
    int nIndex     = gsPOGetPortalCount();

    SetLocalObject(oModule, "GS_PO_" + IntToString(nIndex), oPortal);
    SetLocalInt(oModule, "GS_PO_COUNT", nIndex + 1);
}
//----------------------------------------------------------------
object gsPOGetPortal(int nIndex)
{
    return GetLocalObject(GetModule(), "GS_PO_" + IntToString(nIndex));
}
//----------------------------------------------------------------
int gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex, oPC);
}
//----------------------------------------------------------------
int _gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF, int nStep = 1)
{
    object oPortal = OBJECT_INVALID;
    int nCount     = gsPOGetPortalCount();

    for (; nIndex >= 0 && nIndex < nCount; nIndex += nStep)
    {
        oPortal = gsPOGetPortal(nIndex);

        if (GetIsObjectValid(oPortal) &&
            oPortal != OBJECT_SELF &&
            gsPOGetIsPortalActive(oPortal, oPC))
        {
            return nIndex;
        }
    }

    return -1;
}
//----------------------------------------------------------------
int gsPOGetNextActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex + 1, oPC);
}
//----------------------------------------------------------------
int gsPOGetPreviousActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex - 1, oPC, -1);
}
//----------------------------------------------------------------
string gsPOGetPortalName(object oPortal)
{
    return GetName(GetArea(oPortal));
}
//----------------------------------------------------------------
int gsPOGetPortalCount()
{
    return GetLocalInt(GetModule(), "GS_PO_COUNT");
}
//----------------------------------------------------------------
void gsPOActivatePortal(object oPortal, object oPC = OBJECT_SELF)
{
    string sTag      = GetTag(GetArea(oPortal));
    string sPlayerID = gsPCGetPlayerID(oPC);

    SetCampaignInt("GS_PO_" + sTag, sPlayerID, TRUE);
}
//----------------------------------------------------------------
int gsPOGetIsPortalActive(object oPortal, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return TRUE;

    string sTag      = GetTag(GetArea(oPortal));
    string sPlayerID = gsPCGetPlayerID(oPC);

    return GetCampaignInt("GS_PO_" + sTag, sPlayerID);
}
