#include "gs_inc_fixture"

void main()
{
    object oSpeaker = GetPCSpeaker();
    string sTag     = GetTag(OBJECT_SELF);
    sTag            = GetStringRight(sTag, GetStringLength(sTag) - 6);
    object oFixture = CreateItemOnObject(sTag, oSpeaker);
    SetName(oFixture, GetName(OBJECT_SELF));
    SetDescription(oFixture, GetDescription(OBJECT_SELF));
    SetLocalString(oFixture, "GS_FX_ID", GetLocalString(OBJECT_SELF, "GS_FX_ID"));

    if (GetIsObjectValid(oFixture) && (GetLocalString(oFixture, "GS_FX_ID") != ""))
    {
        AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
        gsFXDeleteFixture(GetLocalString(OBJECT_SELF, "GS_FX_ID"));
        DestroyObject(OBJECT_SELF);
    }
    else
    {
        DestroyObject(oFixture);
    }
}
