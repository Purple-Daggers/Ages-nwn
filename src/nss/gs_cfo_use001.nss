#include "gs_inc_forum"
#include "gs_inc_message"
#include "gs_inc_token"

int StartingConditional()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsFOLoadContent();
        SetLocalInt(OBJECT_SELF, "GS_MESSAGE", -1);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }

    string sMessageID = "";
    int nNth          = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");
    nNth              = gsFOGetFirstMessage(nNth);
    int nSlot         = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            sMessageID = gsFOGetMessage(nNth);
            gsTKSetToken(100 + nSlot, "<cþë¦>" + gsMEGetTitle(sMessageID) + "<câÛÂ>");
            gsTKSetToken(105 + nSlot, "<c(”þ>" + gsMEGetAuthor(sMessageID));
        }

        if (++nSlot > 5) break;

        if (nNth != -1)  nNth = gsFOGetNextMessage(nNth);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END", nNth);

    nNth = GetLocalInt(OBJECT_SELF, "GS_MESSAGE");
    if (nNth != -1)
    {
        sMessageID = gsFOGetMessage(nNth);
        SetCustomToken(100, gsMEGetMessage(sMessageID));
        return TRUE;
    }

    return FALSE;
}
