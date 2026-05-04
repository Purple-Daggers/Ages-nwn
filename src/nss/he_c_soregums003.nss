#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();

    if (GetGold(oSpeaker) >= 5000)
    {
        TakeGoldFromCreature(5000, oSpeaker, TRUE);
        gsCMTeleportToObject(
            oSpeaker,
            GetWaypointByTag("GS_TARGET_013_01"),
            FALSE);
    }
}
