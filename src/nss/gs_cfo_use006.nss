#include "gs_inc_token"

int StartingConditional()
{
    //slot 5

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_5") != -1)
    {
        gsTKRecallToken(105);
        gsTKRecallToken(110);

        return TRUE;
    }

    return FALSE;
}
