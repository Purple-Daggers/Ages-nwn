#include "gs_inc_booksh"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");

    if (nNth != -1)
    {
        string sBookID = gsBSGetBook(nNth);

        if (sBookID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker)) return TRUE;
            return TRUE;
        }
    }
    return FALSE;
}

