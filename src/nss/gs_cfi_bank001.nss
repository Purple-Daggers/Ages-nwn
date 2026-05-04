#include "gs_inc_finance"

int StartingConditional()
{
    SetCustomToken(100, IntToString(gsFIGetBalance(GetPCSpeaker())));
    return TRUE;
}
