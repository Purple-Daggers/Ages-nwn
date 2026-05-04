#include "gs_inc_craft"

int StartingConditional()
{
    int nSkill    = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nCategory = GetLocalInt(OBJECT_SELF, "GS_CATEGORY");
    int nNth      = GetLocalInt(OBJECT_SELF, "GS_PAGE_START_2");

    return nNth > 0 && gsCRGetPreviousRecipe(nSkill, nCategory, nNth) != -1;
}
