#include "gs_inc_booksh"
#include "gs_inc_token"

int StartingConditional()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_BO_ENABLED"))
    {
        gsBOLoadContent();
        SetLocalInt(OBJECT_SELF, "GS_BOOK", -1);
        SetLocalInt(OBJECT_SELF, "GS_BO_ENABLED", TRUE);
    }

    string sMessageID = "";
    int nNth          = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");
    nNth              = gsBOGetFirstBook(nNth);
    int nSlot         = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            sMessageID = gsBOGetBook(nNth);
            gsTKSetToken(100 + nSlot, "<cþë¦>" + GetLocalString(OBJECT_SELF, sMessageID + "_NAME") + "<câÛÂ>");
            gsTKSetToken(105 + nSlot, "<c(”þ>" + IntToString(GetLocalInt(OBJECT_SELF, sMessageID + "_COUNT")));
        }

        if (++nSlot > 5) break;

        if (nNth != -1)  nNth = gsBOGetNextBook(nNth);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END", nNth);

    nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");
    if (nNth != -1)
    {
        sMessageID = gsBOGetBook(nNth);
        SetCustomToken(100, gsBOGetBookDescription(sMessageID));
        return TRUE;
    }

    return FALSE;
}
