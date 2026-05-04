#include "gs_inc_arena"
#include "gs_inc_common"
#include "gs_inc_text"
#include "gs_inc_time"

int StartingConditional()
{
    string sTag     = GetTag(OBJECT_SELF);
    sTag            = GetStringLeft(sTag, GetStringLength(sTag) - 5);
    object oArena   = GetObjectByTag(sTag);
    string sMessage = "";
    int nPlacement  = gsAEGetContest(oArena);

    if (nPlacement > 0)
    {
        struct gsAEParticipant stDefender   = gsAEGetParticipant(oArena, nPlacement);
        struct gsAEParticipant stChallenger = gsAEGetParticipant(oArena, nPlacement + 1);

        sMessage  = gsCMReplaceString(GS_T_16777499,
                                      stChallenger.sName,
                                      stDefender.sName);
        if (gsAEGetContestState(oArena) == GS_AE_CONTEST_STATE_ACTIVE)
            sMessage += "\n" + GS_T_16777500;
        sMessage += "\n\n";
    }

    sMessage       += GS_T_16777501;
    struct gsAEParticipant stParticipant;
    string sEntry   = "";
    int nNth        = 0;

    do
    {
        stParticipant  = gsAEGetParticipant(oArena, ++nNth);
        if (stParticipant == GS_AE_PARTICIPANT_INVALID) break;
        sEntry         = stParticipant.sName;
        sEntry         = gsCMReplaceString(GS_T_16777502,
                                           (nNth == nPlacement ? "<cþ((>" : "<câÛÂ>") + IntToString(nNth),
                                           (GetIsObjectValid(stParticipant.oCreature) ? "<câÛÂ>" : "<c°°°>") + stParticipant.sName,
                                           IntToString(stParticipant.nSuccess),
                                           IntToString(stParticipant.nDefeat));
        sMessage      += "\n" + sEntry;
    }
    while (nNth < 11);

    if (nNth <= 1) sMessage = "";
    if (nNth <= 2) sMessage += "\n\n" + GS_T_16777503;

    SetCustomToken(100, sMessage);

    return TRUE;
}
