#include "gs_inc_token"

int StartingConditional()
{
    //slot 6

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_6") != -1)
    {
        gsTKRecallToken(106);
        gsTKRecallToken(116);

        return TRUE;
    }

    return FALSE;
}

