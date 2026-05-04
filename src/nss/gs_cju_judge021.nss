#include "gs_inc_common"
#include "gs_inc_justice"

int StartingConditional()
{
    string sTag              = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice          = gsCMGetNearestObject(sTag);
    int nTrial               = GetLocalInt(OBJECT_SELF, "GS_JU_TRIAL");
    struct gsJUTrial stTrial = gsJUGetTrial(oJustice, nTrial);

    stTrial.nTimestamp       =   0;
    stTrial.nJudgement       = 100;
    stTrial.nJudgementCount  =   1;

    gsJUSetTrial(oJustice, nTrial, stTrial);
    ExecuteScript("gs_run_justice", oJustice);

    return TRUE;
}
