#include "gs_inc_craft"

void main()
{
    int nSkill    = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nCategory = GetLocalInt(OBJECT_SELF, "GS_CATEGORY");
    int nNth      = GetLocalInt(OBJECT_SELF, "GS_PAGE_END_2");

    if (nNth != -1)
    {
        nNth = gsCRGetNextRecipe(nSkill, nCategory, nNth);
        if (nNth != -1) SetLocalInt(OBJECT_SELF, "GS_PAGE_START_2", nNth);
    }
}
