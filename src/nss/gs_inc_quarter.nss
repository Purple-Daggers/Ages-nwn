/* QUARTER library by Gigaschatten */

#include "gs_inc_class"

const string GS_QU_TEMPLATE_KEY = "gs_item038";

//void main() {}

//return TRUE if oPC is owner of oQuarter
int gsQUGetIsOwner(object oQuarter, object oPC);
//return owner id of oQuarter
string gsQUGetOwnerID(object oQuarter);
//make oPC own oQuarter
void gsQUSetOwner(object oQuarter, object oPC, int nTimeout = 0);
//return owner name of oQuarter
string gsQUGetOwnerName(object oQuarter);
//update timestamp of oQuarter
void gsQUTouch(object oQuarter);
//return TRUE if oQuarter is vacant
int gsQUGetIsVacant(object oQuarter);
//return TRUE if oQuarter is available
int gsQUGetIsAvailable(object oQuarter);
//abandon oQuarter
void gsQUAbandon(object oQuarter);
//return key tag of oQuarter
string gsQUGetKeyTag(object oQuarter);
//create access key for oQuarter on oTarget
void gsQUCreateKey(object oQuarter, object oTarget);

int gsQUGetIsOwner(object oQuarter, object oPC)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetIsOwner(sID, nInstance, oPC);
}
//----------------------------------------------------------------
string gsQUGetOwnerID(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetOwnerID(sID, nInstance);
}
//----------------------------------------------------------------
void gsQUSetOwner(object oQuarter, object oPC, int nTimeout = 0)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    gsCLSetOwner(sID, nInstance, oPC);
    gsCLSetTimeout(sID, nInstance, gsTIGetGameTimestamp(nTimeout));
}
//----------------------------------------------------------------
string gsQUGetOwnerName(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetName(sID, nInstance);
}
//----------------------------------------------------------------
void gsQUTouch(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    gsCLSetActualTimestamp(sID, nInstance);
}
//----------------------------------------------------------------
int gsQUGetIsVacant(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetIsVacant(sID, nInstance);
}
//----------------------------------------------------------------
int gsQUGetIsAvailable(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetIsAvailable(sID, nInstance);
}
//----------------------------------------------------------------
void gsQUAbandon(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    gsCLRelease(sID, nInstance);
}
//----------------------------------------------------------------
string gsQUGetKeyTag(object oQuarter)
{
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    return gsCLGetUniqueID(sID, nInstance);
}
//----------------------------------------------------------------
void gsQUCreateKey(object oQuarter, object oTarget)
{
    string sID       = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance    = GetLocalInt(oQuarter, "GS_INSTANCE");
    string sUniqueID = gsCLGetUniqueID(sID, nInstance);

    if (sUniqueID != "")
    {
        object oObject = CreateItemOnObject(GS_QU_TEMPLATE_KEY,
                                            oTarget,
                                            1,
                                            sUniqueID);

        if (GetIsObjectValid(oObject))
        {
            SetName(oObject,
                    gsCMReplaceString(
                        GS_T_16777477,
                        gsQUGetOwnerName(oQuarter)));
        }
    }
}
