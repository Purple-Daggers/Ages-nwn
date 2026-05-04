#include "gs_inc_craft"

int StartingConditional()
{
    struct gsCRRecipe stRecipe;
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nCategory   = GetLocalInt(OBJECT_SELF, "GS_CATEGORY");
    int nRecipe     = GetLocalInt(OBJECT_SELF, "GS_RECIPE");
    stRecipe        = gsCRGetRecipeInSlot(nSkill, nRecipe);

    SetCustomToken(102, stRecipe.sName);
    SetCustomToken(103, IntToString(gsCRGetRecipeDC(stRecipe)));
    SetCustomToken(104, IntToString(gsCRGetRecipeCraftPoints(stRecipe)));
    SetCustomToken(105, IntToString(stRecipe.nValue));
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF))
    {
        struct gsCRQuantity stQuantity = gsCRGetQuantity(stRecipe);
        SetCustomToken(106, gsCRGetQuantityList(stRecipe, stQuantity));
    }
    else
    {
        SetCustomToken(106, gsCRGetRecipeInputList(stRecipe));
    }
    SetCustomToken(107, gsCRGetRecipeOutputList(stRecipe));
    SetCustomToken(100, gsCRGetSkillName(nSkill));
    SetCustomToken(101, gsCRGetCategoryName(nCategory));
    SetCustomToken(108, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));

    return TRUE;
}
