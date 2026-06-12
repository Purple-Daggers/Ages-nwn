#include "gs_inc_token"

int StartingConditional()
{
    //slot 8

    if (GetLocalInt(OBJECT_SELF, "GS_FO_SLOT_8") != -1)
    {
        gsTKRecallToken(108);
        gsTKRecallToken(118);

        return TRUE;
    }

    return FALSE;
}

