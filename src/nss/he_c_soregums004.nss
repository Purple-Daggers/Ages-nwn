#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();

    if (GetGold(oSpeaker) >= 15000)
    {
        TakeGoldFromCreature(15000, oSpeaker, TRUE);
        gsCMTeleportToObject(
            oSpeaker,
            GetWaypointByTag("GS_TARGET_001_01"),
            FALSE);
    }
}
