#include "gs_inc_token"

int StartingConditional()
{
    //slot 7

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_7") != -1)
    {
        gsTKRecallToken(107);
        gsTKRecallToken(117);

        return TRUE;
    }

    return FALSE;
}
