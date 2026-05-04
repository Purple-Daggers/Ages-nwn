#include "gs_inc_text"
#include "gs_inc_worship"
#include "gs_inc_xp"

int StartingConditional()
{
    object oSpeaker     = GetPCSpeaker();
    string sDeity       = GetDeity(oSpeaker);
    int nDeitySelection = GetLocalInt(oSpeaker, "GS_WO_SELECTION");

    if (nDeitySelection &&
        gsWOGetIsDeityAvailable(nDeitySelection, oSpeaker))
    {
        //penalty
        if (sDeity != "")
        {
            int nDeity = gsWOGetDeityByName(sDeity);

            if (nDeity && nDeitySelection != nDeity)
            {
                SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777331, sDeity));
                gsXPGiveExperience(oSpeaker, -500);
            }
        }

        //set deity
        sDeity = gsWOGetNameByDeity(nDeitySelection);
        SetDeity(oSpeaker, sDeity);
        DeleteLocalInt(oSpeaker, "GS_WO_SELECTION");
    }

    if (sDeity == "") SetCustomToken(100, GS_T_16777332);
    else              SetCustomToken(100, sDeity);

    return TRUE;
}
