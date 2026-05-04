#include "gs_inc_craft"

int StartingConditional()
{
    struct gsCRRecipe stRecipe;
    int nSkill  = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nRecipe = GetLocalInt(OBJECT_SELF, "GS_RECIPE");
    stRecipe    = gsCRGetRecipeInSlot(nSkill, nRecipe);

    SetCustomToken(100, stRecipe.sName);
    return TRUE;
}
