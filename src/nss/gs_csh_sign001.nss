#include "gs_inc_shop"

int StartingConditional()
{
    if (! gsSHGetIsVacant(OBJECT_SELF))
    {
        SetCustomToken(100, gsSHGetOwnerName(OBJECT_SELF));
        SetCustomToken(101, IntToString(gsSHGetSalePrice(OBJECT_SELF)));
        return TRUE;
    }

    return FALSE;
}
