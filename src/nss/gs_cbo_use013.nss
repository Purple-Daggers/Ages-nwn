#include "gs_inc_booksh"

const string GS_TEMPLATE_BOOK = "book";
const string GS_TEMPLATE_NOTEBOOK = "gs_item410";

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");

    if (nNth != -1)
    {
        string sBookID = gsBSGetBook(nNth);
        string sNotebookID = gsBSGetBookNotebook(nNth);

        if (sBookID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker)||
                TRUE/*gsFOGetOwner(sBookID) == gsPCGetPlayerID(oSpeaker)*/)
            {
                if (sNotebookID == "")
                {
                     object oObject = CreateItemOnObject(GS_TEMPLATE_BOOK,
                                                         oSpeaker,
                                                         1);
                }
                else
                {
                     object oObject = CreateItemOnObject(GS_TEMPLATE_NOTEBOOK,
                                                         oSpeaker,
                                                         1);
                }

                if (GetIsObjectValid(oObject))
                {
                    string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

                    SetName(oObject, gsBSGetBookName(sBookID));
                    SetDescription(oObject, gsBSGetBookDescription(sBookID));
                    if (sNotebookID != "")
                    {
                        SetLocalString(oObject, "GS_NB_ID", sNotebookID);
                    }
                    gsBSRemoveBook(sBookID);
                    DeleteLocalInt(OBJECT_SELF, "GS_BOOK");
                }
            }
        }
    }
}

