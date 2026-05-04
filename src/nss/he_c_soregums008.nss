#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();

    if (GetGold(oSpeaker) >= 10000)
    {
        TakeGoldFromCreature(10000, oSpeaker, TRUE);
        gsCMTeleportToObject(
            oSpeaker,
            GetWaypointByTag("GS_TARGET_052_01"),
            FALSE);
    }
}
