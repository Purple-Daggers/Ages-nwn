#include "gs_inc_fixture"

void main()
{
    object oSpeaker = GetPCSpeaker();
    gsFXPickupFixture(oSpeaker, OBJECT_SELF);
}
