#include "gs_inc_common"

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "PORTAL_NUMBER");

    if (nNth > 12)
    {
        if (nNth % 2 == 0) nNth += 9;
        else               nNth += 5;
    }
    else
    {
        if (nNth % 2 == 0) nNth += 5;
        else               nNth += 9;
    }

    while (nNth > 19) nNth -= 19;

    object oUser     = GetLastUsedBy();
    object oWaypoint = GetWaypointByTag("GS_TARGET_DWTHRONE_" + IntToString(nNth));

    gsCMTeleportToObject(oUser, oWaypoint);
}
