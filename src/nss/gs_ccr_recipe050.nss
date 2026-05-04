#include "gs_inc_craft"

int StartingConditional()
{
    return gsCRGetCraftPoints(GetPCSpeaker()) > 0;
}
