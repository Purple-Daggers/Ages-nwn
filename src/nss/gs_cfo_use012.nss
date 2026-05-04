#include "gs_inc_forum"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_MESSAGE");

    if (nNth != -1)
    {
        string sMessageID = gsFOGetMessage(nNth);

        if (sMessageID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker)) return TRUE;
            return gsFOGetOwner(sMessageID) == gsPCGetPlayerID(oSpeaker);
        }
    }

    return FALSE;
}
