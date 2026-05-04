#include "gs_inc_craft"

int StartingConditional()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE &&
        GetHasInventory(OBJECT_SELF))
    {
        struct gsCRRecipe stRecipe;
        struct gsCRQuantity stQuantity;
        int nSkill  = GetLocalInt(OBJECT_SELF, "GS_SKILL");
        int nRecipe = GetLocalInt(OBJECT_SELF, "GS_RECIPE");
        stRecipe    = gsCRGetRecipeInSlot(nSkill, nRecipe);
        stQuantity  = gsCRGetQuantity(stRecipe);

        return gsCRGetIsQuantitySufficient(stRecipe, stQuantity);
    }

    return FALSE;
}
