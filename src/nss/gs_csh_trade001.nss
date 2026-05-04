#include "gs_inc_common"
#include "gs_inc_shop"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
    int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
    int nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
    if (nValue < 1) nValue = 1;

    SetCustomToken(100, GetName(oItem));
    SetCustomToken(101, IntToString(nValue));

    return TRUE;
}
