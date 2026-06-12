#include "gs_inc_token"

int StartingConditional()
{
    //slot 10

    if (GetLocalInt(OBJECT_SELF, "GS_FO_SLOT_10") != -1)
    {
        gsTKRecallToken(110);
        gsTKRecallToken(120);

        return TRUE;
    }

    return FALSE;
}

