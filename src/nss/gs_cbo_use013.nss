#include "gs_inc_booksh"

const string GS_TEMPLATE_BOOK = "book";

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");

    if (nNth != -1)
    {
        string sBookID = gsBSGetBook(nNth);

        if (sBookID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker)||
                TRUE/*gsFOGetOwner(sBookID) == gsPCGetPlayerID(oSpeaker)*/)
            {
                object oObject = CreateItemOnObject(GS_TEMPLATE_BOOK,
                                                    oSpeaker,
                                                    1);

                if (GetIsObjectValid(oObject))
                {
                    string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

                    SetName(oObject, gsBSGetBookName(sBookID));
                    SetDescription(oObject, gsBSGetBookDescription(sBookID));
                    gsBSRemoveBook(sBookID);
                    DeleteLocalInt(OBJECT_SELF, "GS_BOOK");
                }
            }
        }
    }
}

