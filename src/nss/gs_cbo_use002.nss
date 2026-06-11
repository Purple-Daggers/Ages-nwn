#include "gs_inc_token"

int StartingConditional()
{
    //slot 1

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_1") != -1)
    {
        gsTKRecallToken(101);
        gsTKRecallToken(111);

        return TRUE;
    }

    return FALSE;
}
