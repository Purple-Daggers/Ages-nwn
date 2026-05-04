#include "gs_inc_encounter"

void main()
{
    gsENSetCreatureChance(GetLocalInt(OBJECT_SELF, "GS_EN_SLOT"), 1, GetArea(OBJECT_SELF));
}
