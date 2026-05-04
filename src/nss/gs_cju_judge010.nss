#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_listener"

int StartingConditional()
{
    string sTag              = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice          = gsCMGetNearestObject(sTag);
    object oSpeaker          = GetPCSpeaker();
    int nTrial               = StringToInt(gsCMCleanWhitespace(gsLIGetLastMessage(oSpeaker)));
    struct gsJUTrial stTrial = gsJUGetTrial(oJustice, nTrial);

    if (stTrial.nPenalty)
    {
        SetLocalInt(OBJECT_SELF, "GS_JU_TRIAL", nTrial);
        SetCustomToken(100, stTrial.sAccusation);
        SetCustomToken(101, stTrial.sDefendantName);
        return TRUE;
    }

    return FALSE;
}
