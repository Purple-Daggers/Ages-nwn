#include "gs_inc_craft"

const int GS_VALUE = 1;

void gsAnimation(object oObject)
{
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.5);
    ActionStartConversation(oObject, "gs_cr_recipe", TRUE, FALSE);
}
//----------------------------------------------------------------
void main()
{
    object oSpeaker = GetPCSpeaker();
    object oSelf    = OBJECT_SELF;
    object oItem    = GetLocalObject(OBJECT_SELF, "GS_ITEM");
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");

    gsCRProduce(oItem, oSpeaker, GS_VALUE);
    gsCRPlaySound(nSkill);

    AssignCommand(oSpeaker, gsAnimation(oSelf));
}
