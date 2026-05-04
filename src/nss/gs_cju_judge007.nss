#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_pc"
#include "gs_inc_time"

int StartingConditional()
{
    struct gsJUTrial stTrial;
    string sTag            = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice        = gsCMGetObject(sTag, OBJECT_TYPE_PLACEABLE);
    object oSpeaker        = GetPCSpeaker();
    stTrial.sPlaintiffID   = gsPCGetPlayerID(oSpeaker);
    stTrial.sPlaintiffName = GetName(oSpeaker);
    stTrial.sDefendantID   = GetLocalString(OBJECT_SELF, "GS_JU_DEFENDANT_ID");
    stTrial.sDefendantName = GetLocalString(OBJECT_SELF, "GS_JU_DEFENDANT_NAME");
    stTrial.sAccusation    = GetLocalString(OBJECT_SELF, "GS_JU_ACCUSATION");
    stTrial.nPenalty       = GetLocalInt(OBJECT_SELF, "GS_JU_PENALTY");
    stTrial.nTimestamp     = gsTIGetActualTimestamp() + gsTIGetGameTimestamp(GS_JU_TRIAL_DURATION);
    int nTrial             = gsJUOpenTrial(oJustice, stTrial);

    gsCMSendMessageToAllPCs(
        gsCMReplaceString(
            GS_T_16777509,
            stTrial.sPlaintiffName,
            stTrial.sDefendantName,
            stTrial.sAccusation) +
        " " +
        gsCMReplaceString(
            GS_T_16777510,
            GetName(OBJECT_SELF),
            GetName(GetArea(OBJECT_SELF))));

    SetCustomToken(100, IntToString(nTrial));
    SetCustomToken(101, stTrial.sDefendantName);
    SetCustomToken(102, stTrial.sAccusation);

    return TRUE;
}
