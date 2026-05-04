#include "gs_inc_craft"
#include "gs_inc_token"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_START_1");
    nNth            = gsCRGetFirstCategory(nSkill, nNth);
    int nSlot       = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START_1", nNth);
    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START_2");

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            gsTKSetToken(102 + nSlot, gsCRGetCategoryName(nNth));
            gsTKSetToken(107 + nSlot, IntToString(gsCRGetCategoryCount(nSkill, nNth)));
        }

        if (++nSlot > 5) break;

        if (nNth != -1)  nNth = gsCRGetNextCategory(nSkill, nNth);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END_1", nNth);

    SetCustomToken(100, gsCRGetSkillName(nSkill));
    SetCustomToken(101, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));

    return TRUE;
}
