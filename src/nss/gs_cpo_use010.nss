#include "gs_inc_common"
#include "gs_inc_portal"

void main()
{
    //slot 2

    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_SLOT_2");
    object oPortal  = gsPOGetPortal(nNth);

    gsCMTeleportToObject(oSpeaker, oPortal);
}
