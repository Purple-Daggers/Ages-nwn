#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_time"

int StartingConditional()
{
    if (! GetIsPC(GetPCSpeaker())) return FALSE;

    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);
    string sText    = GS_T_16777515;

    if (GetIsObjectValid(oJustice))
    {
        struct gsJUTrial stTrial;
        string sPenalty   = "";
        string sJudgement = "";
        int nTrial        = gsJUGetFirstTrial(oJustice);
        int nTimestamp    = gsTIGetActualTimestamp();
        int nDuration     = 0;
        int nJudgement    = 0;
        int nNth          = 0;

        while (nTrial)
        {
            stTrial     = gsJUGetTrial(oJustice, nTrial);

            nDuration   = stTrial.nTimestamp - nTimestamp;
            if (nDuration < 0)                                        nDuration  = 0;

            if (stTrial.nPenalty >= GS_JU_TRIAL_PENALTY_CAPITAL)      sPenalty   = GS_T_16777526;
            else if (stTrial.nPenalty >= GS_JU_TRIAL_PENALTY_SERIOUS) sPenalty   = GS_T_16777527;
            else                                                      sPenalty   = GS_T_16777528;

            nJudgement  = stTrial.nJudgementCount ?
                          stTrial.nJudgement / stTrial.nJudgementCount : 0;
            if (nJudgement < 40)                                      sJudgement = GS_T_16777518;
            else if (nJudgement < 80)                                 sJudgement = GS_T_16777519;
            else                                                      sJudgement = GS_T_16777520;

            sText      += gsCMReplaceString(GS_T_16777516,
                                            IntToString(++nNth),
                                            stTrial.sAccusation,
                                            stTrial.sPlaintiffName,
                                            stTrial.sDefendantName) +
                          gsCMReplaceString(GS_T_16777517,
                                            sPenalty,
                                            IntToString(nTrial),
                                            IntToString(stTrial.nJudgementCount),
                                            sJudgement) +
                          gsCMReplaceString(GS_T_16777521,
                                            IntToString(gsTIGetMonth(nDuration) - 1),
                                            IntToString(gsTIGetDay(nDuration) - 1),
                                            IntToString(gsTIGetHour(nDuration)),
                                            IntToString(gsTIGetMinute(nDuration)));

            nTrial      = gsJUGetNextTrial(oJustice);
        }
    }

    SetCustomToken(100, sText);

    return TRUE;
}
