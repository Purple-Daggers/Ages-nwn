#include "gs_inc_craft"

void main()
{
    int nSkill  = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nRecipe = GetLocalInt(OBJECT_SELF, "GS_RECIPE");

    gsCRRemoveRecipeInSlot(nSkill, nRecipe);
}
