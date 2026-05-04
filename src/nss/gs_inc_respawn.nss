/* RESPAWN Library by Gigaschatten */

//void main() {}

#include "gs_inc_location"
#include "gs_inc_pc"

//set current position of oPC as respawn location
void gsRESetRespawnLocation(object oPC = OBJECT_SELF);
//return respawn location of oPC
location gsREGetRespawnLocation(object oPC = OBJECT_SELF);

void gsRESetRespawnLocation(object oPC = OBJECT_SELF)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    if (sPlayerID != "") gsLOSetDBLocationOf("GS_RESPAWN", sPlayerID, oPC);
}
//----------------------------------------------------------------
location gsREGetRespawnLocation(object oPC = OBJECT_SELF)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    if (sPlayerID != "")
    {
        location lLocation = gsLOGetDBLocation("GS_RESPAWN", sPlayerID);
        if (GetIsObjectValid(GetAreaFromLocation(lLocation))) return lLocation;

        object oObject     = GetObjectByTag("GS_TARGET_RESPAWN");
        if (GetIsObjectValid(oObject))                        return GetLocation(oObject);

        oObject            = GetObjectByTag("GS_TARGET_START");
        if (GetIsObjectValid(oObject))                        return GetLocation(oObject);
    }

    return Location(OBJECT_INVALID, Vector(), 0.0);
}
