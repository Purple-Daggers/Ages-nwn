#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();

    if (GetGold(oSpeaker) >= 7500)
    {
        TakeGoldFromCreature(7500, oSpeaker, TRUE);
        gsCMTeleportToObject(
            oSpeaker,
            GetWaypointByTag("GS_TARGET_046_01"),
            FALSE);
    }
}
