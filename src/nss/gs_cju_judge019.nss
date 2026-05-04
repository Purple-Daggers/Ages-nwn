#include "gs_inc_common"
#include "gs_inc_listener"

int StartingConditional()
{
    object oSpeaker    = GetPCSpeaker();
    string sAccusation = gsCMCleanWhitespace(gsLIGetLastMessage(oSpeaker));

    if (GetStringLength(sAccusation) >= 20)
    {
        SetLocalString(OBJECT_SELF, "GS_JU_ACCUSATION", sAccusation);
        return TRUE;
    }

    return FALSE;
}
