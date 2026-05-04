#include "gs_inc_time"
#include "gs_inc_shop"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nCost       = GetLocalInt(OBJECT_SELF, "GS_COST");
    int nTimeout    = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

    if (nCost > 0) TakeGoldFromCreature(nCost, oSpeaker, TRUE);

    gsSHSetOwner(OBJECT_SELF, oSpeaker, nTimeout);
    gsSHSetSalePrice(OBJECT_SELF, FALSE);

    SetCustomToken(100, IntToString(nTimeout / 86400));
    SetCustomToken(101, IntToString(gsTIGetHour(nTimeout)));
    SetCustomToken(102, IntToString(gsTIGetMinute(nTimeout)));

    return TRUE;
}
