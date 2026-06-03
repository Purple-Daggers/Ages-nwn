#include "gs_inc_fixture"

void main()
{
    object oSpeaker = GetPCSpeaker();
    string sTag     = GetTag(OBJECT_SELF);
    sTag            = GetStringRight(sTag, GetStringLength(sTag) - 6);
    object oFixture = CreateItemOnObject(sTag, oSpeaker);
    SetName(oFixture, GetName(OBJECT_SELF));
    SetDescription(oFixture, GetDescription(OBJECT_SELF));

    if (GetIsObjectValid(oFixture))
    {
        AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
        gsFXDeleteFixture(GetTag(GetArea(OBJECT_SELF)));
        DestroyObject(OBJECT_SELF);
    }
}
