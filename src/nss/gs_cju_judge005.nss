#include "gs_inc_justice"
#include "gs_inc_text"

int StartingConditional()
{
    string sPenalty = "";
    int nPenalty    = GetLocalInt(OBJECT_SELF, "GS_JU_PENALTY");

    if (nPenalty >= GS_JU_TRIAL_PENALTY_CAPITAL)      sPenalty = GS_T_16777526;
    else if (nPenalty >= GS_JU_TRIAL_PENALTY_SERIOUS) sPenalty = GS_T_16777527;
    else                                              sPenalty = GS_T_16777528;

    SetCustomToken(100, GetLocalString(OBJECT_SELF, "GS_JU_DEFENDANT_NAME"));
    SetCustomToken(101, sPenalty);
    SetCustomToken(102, GetLocalString(OBJECT_SELF, "GS_JU_ACCUSATION"));

    return TRUE;
}
