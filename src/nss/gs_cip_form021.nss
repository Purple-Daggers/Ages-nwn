#include "gs_inc_token"

int StartingConditional()
{
    //slot 1

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_1") >= 0)
    {
        gsTKRecallToken(100);
        return TRUE;
    }

    return FALSE;
}
