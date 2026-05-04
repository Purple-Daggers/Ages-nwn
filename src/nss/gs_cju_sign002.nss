#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_time"

int StartingConditional()
{
    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);
    string sText    = GS_T_16777522;

    if (GetIsObjectValid(oJustice))
    {
        struct gsJUJudgement stJudgement;
        int nJudgement = gsJUGetFirstJudgement(oJustice);
        int nTimestamp = gsTIGetActualTimestamp();
        int nDuration  = 0;
        int nNth       = 0;

        while (nJudgement)
        {
            stJudgement  = gsJUGetJudgement(oJustice, nJudgement);

            nDuration    = stJudgement.nTimestamp - nTimestamp;
            if (nDuration < 0) nDuration = 0;

            sText       += gsCMReplaceString(GS_T_16777523,
                                             IntToString(++nNth),
                                             stJudgement.sConvictName) +
                           gsCMReplaceString(GS_T_16777521,
                                             IntToString(gsTIGetMonth(nDuration) - 1),
                                             IntToString(gsTIGetDay(nDuration) - 1),
                                             IntToString(gsTIGetHour(nDuration)),
                                             IntToString(gsTIGetMinute(nDuration)));

            nJudgement   = gsJUGetNextJudgement(oJustice);
        }
    }

    SetCustomToken(100, sText);

    return TRUE;
}
