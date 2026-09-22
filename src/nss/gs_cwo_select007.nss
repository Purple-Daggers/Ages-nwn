#include "gs_inc_worship"

int StartingConditional()
{
    return gsWOGetIsDeityAvailable(GS_WO_SCHOOL_OF_FLOWERS, GetPCSpeaker());
}
