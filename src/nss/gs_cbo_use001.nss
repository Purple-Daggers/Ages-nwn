#include "gs_inc_booksh"
#include "gs_inc_token"

int StartingConditional()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_BS_ENABLED"))
    {
        gsBSLoadContent();
        SetLocalInt(OBJECT_SELF, "GS_BOOK", -1);
        SetLocalInt(OBJECT_SELF, "GS_BS_ENABLED", TRUE);
    }

    string sMessageID = "";
    int nNth          = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");
    nNth              = gsBSGetFirstBook(nNth);
    int nSlot         = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            sMessageID = gsBSGetBook(nNth);
            gsTKSetToken(100 + nSlot, "<cþë¦>" + GetLocalString(OBJECT_SELF, sMessageID + "_NAME") + "<câÛÂ>");
            gsTKSetToken(110 + nSlot, IntToString(GetLocalInt(OBJECT_SELF, sMessageID + "_COUNT")));
        }

        if (++nSlot > 10) break;

        if (nNth != -1)  nNth = gsBSGetNextBook(nNth);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END", nNth);

    return TRUE;
}
