#include "gs_inc_quarter"
#include "gs_inc_time"

int StartingConditional()
{
    if (gsQUGetIsOwner(OBJECT_SELF, GetPCSpeaker()))
    {
        int nTimeout = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

        gsQUTouch(OBJECT_SELF);

        SetCustomToken(100, IntToString(nTimeout / 86400));
        SetCustomToken(101, IntToString(gsTIGetHour(nTimeout)));
        SetCustomToken(102, IntToString(gsTIGetMinute(nTimeout)));

        return TRUE;
    }

    return FALSE;
}
