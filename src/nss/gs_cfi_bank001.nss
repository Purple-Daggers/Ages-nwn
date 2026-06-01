#include "gs_inc_finance"
#include "gs_inc_listener"

int StartingConditional()
{
    gsLIClearLastMessage(GetPCSpeaker());
    SetCustomToken(100, IntToString(gsFIGetBalance(GetPCSpeaker())));
    return TRUE;
}
