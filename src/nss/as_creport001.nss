#include "as_inc_report"
int StartingConditional()
{
    object oPlayer    = GetPCSpeaker();
    object oReport    = GetItemPossessedBy(oPlayer, "as_report");
    if(GetIsObjectValid(oReport))
    {
        int nValue     = asRPTGetReportValue(oReport);
        SetCustomToken(1000, IntToString(nValue));
        return TRUE;
    }
    return FALSE;
}
