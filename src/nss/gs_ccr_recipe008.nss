#include "gs_inc_craft"

int StartingConditional()
{
    int nSkill = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nNth   = GetLocalInt(OBJECT_SELF, "GS_PAGE_END_1");

    return nNth > 0 && gsCRGetNextCategory(nSkill, nNth) != -1;
}
