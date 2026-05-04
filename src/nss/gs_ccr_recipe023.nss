#include "gs_inc_craft"
#include "gs_inc_token"

int StartingConditional()
{
    struct gsCRRecipe stRecipe;
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nCategory   = GetLocalInt(OBJECT_SELF, "GS_CATEGORY");
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_START_2");
    nNth            = gsCRGetFirstRecipe(nSkill, nCategory, nNth);
    int nSlot       = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START_2", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            stRecipe = gsCRGetRecipeInSlot(nSkill, nNth);
            gsTKSetToken(102 + nSlot, stRecipe.sName);
            gsTKSetToken(107 + nSlot, IntToString(gsCRGetRecipeDC(stRecipe)));
        }

        if (++nSlot > 5) break;

        if (nNth != -1)  nNth = gsCRGetNextRecipe(nSkill, nCategory, nNth);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END_2", nNth);

    SetCustomToken(100, gsCRGetSkillName(nSkill));
    SetCustomToken(101, gsCRGetCategoryName(nCategory));
    SetCustomToken(102, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));

    return TRUE;
}
