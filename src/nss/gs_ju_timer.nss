#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_pc"
#include "gs_inc_text"
#include "gs_inc_time"

int gsDetermineTrial()
{
    struct gsJUTrial stTrial;
    struct gsJUJudgement stJudgement;
    string sMessage = "";
    int nTrial      = gsJUGetFirstTrial(OBJECT_SELF);
    int nTimestamp  = gsTIGetActualTimestamp();
    int nDuration   = 0;
    int nJudgement  = 0;
    int nFlag       = FALSE;

    while (nTrial)
    {
        stTrial = gsJUGetTrial(OBJECT_SELF, nTrial);

        if (nTimestamp > stTrial.nTimestamp)
        {
            sMessage   = gsCMReplaceString(GS_T_16777511,
                                           stTrial.sPlaintiffName,
                                           stTrial.sDefendantName,
                                           stTrial.sAccusation) + " ";
            nJudgement = gsJUCloseTrial(OBJECT_SELF, nTrial);

            //punish plaintiff
            if (nJudgement < 25)
            {
                nDuration                 = gsTIGetGameTimestamp(stTrial.nPenalty) / 25 * (25 - nJudgement);
                if (nDuration < 3600) nDuration = 3600;

                stJudgement.sConvictID    = stTrial.sPlaintiffID;
                stJudgement.sConvictName  = stTrial.sPlaintiffName;
                stJudgement.nTimestamp    = nTimestamp + nDuration;

                sMessage                 += GS_T_16777512;

                gsJUAddJudgement(OBJECT_SELF, stJudgement);
                nFlag                     = TRUE;
            }

            //acquittal
            else if (nJudgement < 75)
            {
                sMessage                 += GS_T_16777513;
            }

            //punish defendant
            else
            {
                nDuration                 = gsTIGetGameTimestamp(stTrial.nPenalty) / 25 * (nJudgement - 75);
                if (nDuration < 3600) nDuration = 3600;

                stJudgement.sConvictID    = stTrial.sDefendantID;
                stJudgement.sConvictName  = stTrial.sDefendantName;
                stJudgement.nTimestamp    = nTimestamp + nDuration;

                sMessage                 += GS_T_16777514;

                gsJUAddJudgement(OBJECT_SELF, stJudgement);
                nFlag                     = TRUE;
            }

            gsCMSendMessageToAllPCs(sMessage);
            return nFlag;
        }

        nTrial = gsJUGetNextTrial(OBJECT_SELF);
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsDetermineJudgement()
{
    struct gsJUJudgement stJudgement;
    object oConvict    = OBJECT_INVALID;
    int nJudgement     = gsJUGetFirstJudgement(OBJECT_SELF);
    int nTimestamp     = gsTIGetActualTimestamp();
    int nFlag          = FALSE;

    while (nJudgement)
    {
        stJudgement = gsJUGetJudgement(OBJECT_SELF, nJudgement);
        oConvict    = gsPCGetPlayerByID(stJudgement.sConvictID);

        if (stJudgement.nTimestamp < nTimestamp)
        {
            gsJUEndJudgement(OBJECT_SELF, nJudgement);
            nFlag = TRUE;
        }

        nJudgement = gsJUGetNextJudgement(OBJECT_SELF);
    }

    return nFlag;
}
//----------------------------------------------------------------
void main()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsJULoadJudgement(OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }

    if ((GetTimeHour() != GetLocalInt(GetModule(), "GS_HOUR")) &&
        (gsDetermineTrial() || gsDetermineJudgement()))
    {
        gsJUSaveJudgement(OBJECT_SELF);
    }
}
