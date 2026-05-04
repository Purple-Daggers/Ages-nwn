#include "gs_inc_common"
#include "gs_inc_justice"
#include "gs_inc_listener"

int StartingConditional()
{
    struct gsJUJudgement stJudgement;
    string sTag     = GetLocalString(OBJECT_SELF, "GS_JUSTICE");
    object oJustice = gsCMGetNearestObject(sTag);
    object oSpeaker = GetPCSpeaker();
    string sName1   = GetStringLowerCase(gsCMCleanWhitespace(gsLIGetLastMessage(oSpeaker)));
    string sName2   = "";
    int nJudgement  = gsJUGetFirstJudgement(oJustice);

    gsLIClearLastMessage(oSpeaker);

    while (nJudgement)
    {
        stJudgement = gsJUGetJudgement(oJustice, nJudgement);
        sName2      = GetStringLowerCase(gsCMCleanWhitespace(stJudgement.sConvictName));

        if (sName1 == sName2)
        {
            gsJUEndJudgement(oJustice, nJudgement);
            gsJUSaveJudgement(oJustice);
            return TRUE;
        }

        nJudgement  = gsJUGetNextJudgement(oJustice);
    }

    return FALSE;
}
