#include "gs_inc_craft"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    gsCRLoadRecipeList(GS_CR_SKILL_CARPENTER);
    gsCRLoadRecipeList(GS_CR_SKILL_COOK);
    gsCRLoadRecipeList(GS_CR_SKILL_CRAFT_ART);
    gsCRLoadRecipeList(GS_CR_SKILL_FORGE);
    gsCRLoadRecipeList(GS_CR_SKILL_MELD);
    gsCRLoadRecipeList(GS_CR_SKILL_SEW);
    ActionDoCommand(gsCRLoadCategoryList());

    ActionDoCommand(DestroyObject(OBJECT_SELF));
}
