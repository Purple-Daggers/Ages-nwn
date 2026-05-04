#include "gs_inc_craft"

void gsAnimation(object oObject)
{
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.5);
    ActionStartConversation(oObject, "gs_cr_recipe", TRUE, FALSE);
}
//----------------------------------------------------------------
void main()
{
    struct gsCRRecipe stRecipe;
    object oSpeaker = GetPCSpeaker();
    object oSelf    = OBJECT_SELF;
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nRecipe     = GetLocalInt(OBJECT_SELF, "GS_RECIPE");
    stRecipe        = gsCRGetRecipeInSlot(nSkill, nRecipe);

    gsCRCreateProduction(stRecipe, oSpeaker);
    gsCRPlaySound(nSkill);

    AssignCommand(oSpeaker, gsAnimation(oSelf));
}
