#include "gs_inc_token"

int StartingConditional()
{
    //slot 4

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_4") >= 0)
    {
        gsTKRecallToken(103);
        return TRUE;
    }

    return FALSE;
}
