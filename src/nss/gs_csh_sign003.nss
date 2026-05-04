#include "gs_inc_shop"

int StartingConditional()
{
    if (gsSHGetIsAvailable(OBJECT_SELF))
    {
        SetCustomToken(100, IntToString(GetLocalInt(OBJECT_SELF, "GS_COST")));

        return TRUE;
    }

    return FALSE;
}
