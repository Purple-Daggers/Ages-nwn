#include "gs_inc_worship"

int StartingConditional()
{
    return gsWOGetIsDeityAvailable(GS_WO_HOAR, GetPCSpeaker());
}
