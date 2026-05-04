#include "gs_inc_common"
#include "gs_inc_listener"
#include "gs_inc_pc"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oPlayer  = GetFirstPC();
    string sName1   = GetStringLowerCase(gsCMCleanWhitespace(gsLIGetLastMessage(oSpeaker)));
    string sName2   = "";

    gsLIClearLastMessage(oSpeaker);

    while (GetIsObjectValid(oPlayer))
    {
        if (oPlayer != oSpeaker && ! GetIsDM(oPlayer))
        {
            sName2 = gsCMCleanWhitespace(GetName(oPlayer));
            if (GetStringLowerCase(sName2) == sName1) break;
        }

        oPlayer = GetNextPC();
    }

    if (GetIsObjectValid(oPlayer))
    {
        SetLocalString(OBJECT_SELF, "GS_JU_DEFENDANT_ID", gsPCGetPlayerID(oPlayer));
        SetLocalString(OBJECT_SELF, "GS_JU_DEFENDANT_NAME", sName2);
        SetCustomToken(100, sName2);
        return TRUE;
    }

    return FALSE;
}
