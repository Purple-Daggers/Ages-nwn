#include "gs_inc_time"
#include "gs_inc_shop"

int StartingConditional()
{
    if (gsSHGetIsOwner(OBJECT_SELF, GetPCSpeaker()))
    {
        int nTimeout = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

        gsSHTouch(OBJECT_SELF);

        SetCustomToken(100, IntToString(gsSHGetSalePrice(OBJECT_SELF)));
        SetCustomToken(101, IntToString(nTimeout / 86400));
        SetCustomToken(102, IntToString(gsTIGetHour(nTimeout)));
        SetCustomToken(103, IntToString(gsTIGetMinute(nTimeout)));

        return TRUE;
    }

    return FALSE;
}
