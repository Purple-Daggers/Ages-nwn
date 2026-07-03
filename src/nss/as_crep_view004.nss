#include "gs_inc_token"

int StartingConditional()
{
    //slot 3

    if (GetLocalInt(OBJECT_SELF, "AS_REP_SLOT_3") != -1)
    {
        gsTKRecallToken(103);
        gsTKRecallToken(113);

        return TRUE;
    }

    return FALSE;
}

