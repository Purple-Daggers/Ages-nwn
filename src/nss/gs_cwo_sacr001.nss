#include "gs_inc_text"
#include "gs_inc_worship"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sDeity   = GetDeity(oSpeaker);

    if (sDeity == "")
    {
        SendMessageToPC(oSpeaker, GS_T_16777282);
        return FALSE;
    }

    AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));

    SetCustomToken(100, sDeity);
    SetCustomToken(101, IntToString(gsWOGetPresence(sDeity)));
    SetCustomToken(102, IntToString(gsWOGetPower(sDeity)));

    return TRUE;
}
