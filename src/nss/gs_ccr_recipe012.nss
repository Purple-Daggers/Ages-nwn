#include "gs_inc_token"

int StartingConditional()
{
    //slot 1

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_1") != -1)
    {
        gsTKRecallToken(103);
        gsTKRecallToken(108);

        return TRUE;
    }

    return FALSE;
}
