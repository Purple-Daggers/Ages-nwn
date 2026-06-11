#include "gs_inc_booksh"
#include "gs_inc_token"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");
    if (nNth != -1)
    {
        string sMessageID = gsBSGetBook(nNth);
        SetCustomToken(100, gsBSGetBookDescription(sMessageID));
        SetCustomToken(1000, GetLocalString(OBJECT_SELF, sMessageID + "_NAME"));
        return TRUE;
    }
    return FALSE;
}
