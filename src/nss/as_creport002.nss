#include "as_inc_report"
#include "gs_inc_common"
void main()
{
    object oPlayer    = GetPCSpeaker();
    object oReport    = GetItemPossessedBy(oPlayer, "as_report");
    if(GetIsObjectValid(oReport))
    {
        int nValue     = asRPTGetReportValue(oReport);
        gsCMCreateGold(nValue, oPlayer);
        DestroyObject(oReport);
    }
    return;
}

