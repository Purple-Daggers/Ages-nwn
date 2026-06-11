#include "gs_inc_token"

int StartingConditional()
{
    //slot 9

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_9") != -1)
    {
        gsTKRecallToken(109);
        gsTKRecallToken(119);

        return TRUE;
    }

    return FALSE;
}
