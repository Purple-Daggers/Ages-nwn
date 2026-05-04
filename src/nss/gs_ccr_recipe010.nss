#include "gs_inc_craft"

void main()
{
    int nSkill = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nNth   = GetLocalInt(OBJECT_SELF, "GS_PAGE_END_1");

    if (nNth != -1)
    {
        nNth = gsCRGetNextCategory(nSkill, nNth);
        if (nNth != -1) SetLocalInt(OBJECT_SELF, "GS_PAGE_START_1", nNth);
    }
}
