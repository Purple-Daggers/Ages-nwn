#include "gs_inc_message"

int StartingConditional()
{
    object oTarget    = GetLocalObject(OBJECT_SELF, "GS_TARGET");
    string sMessageID = GetSubString(GetTag(oTarget), 6, -1);
    string sMessage   = gsMEGetMessage(sMessageID);

    if (sMessage != "")
    {
        SetCustomToken(100, sMessage);
        return TRUE;
    }

    return FALSE;
}
