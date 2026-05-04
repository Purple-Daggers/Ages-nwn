#include "gs_inc_craft"

int StartingConditional()
{
    return gsCRGetSkillPoints(GetPCSpeaker()) > 0;
}
