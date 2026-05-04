#include "gs_inc_craft"

void main()
{
    int nSkill = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nNth1  = GetLocalInt(OBJECT_SELF, "GS_PAGE_START_1");

    if (nNth1 > 0)
    {
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 5; nNth2++)
        {
            nNth3 = gsCRGetPreviousCategory(nSkill, nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }

        SetLocalInt(OBJECT_SELF, "GS_PAGE_START_1", nNth1);
    }
}
