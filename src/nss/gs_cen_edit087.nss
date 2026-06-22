#include "gs_inc_encounter"

void main()
{
    gsENSetCreatureTimeflag(GetLocalInt(OBJECT_SELF, "GS_EN_SLOT"), GS_EN_TIMEFLAG_NOT_NIGHT, GetArea(OBJECT_SELF));
}

