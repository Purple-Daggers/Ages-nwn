#include "gs_inc_encounter"

void main()
{
    gsENRemoveCreature(GetLocalInt(OBJECT_SELF, "GS_EN_SLOT"), GetArea(OBJECT_SELF));
}
