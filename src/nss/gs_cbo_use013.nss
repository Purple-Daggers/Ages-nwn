#include "gs_inc_booksh"

const string GS_TEMPLATE_BOOK = "book";
const string GS_TEMPLATE_NOTEBOOK = "gs_item410";

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");

    if (nNth != -1)
    {
        string sBookID = gsBSGetBook(nNth);
        string sNotebookID = gsBSGetBookNotebook(sBookID);

        if (sBookID != "")
        {
            object oSpeaker = GetPCSpeaker();
            //removed get owner stuff here
            if (sNotebookID == "")
            {  
                object oObject = CreateItemOnObject(GS_TEMPLATE_BOOK,
                                                    oSpeaker,
                                                    1);
                SetName(oObject, gsBSGetBookName(sBookID));
                SetDescription(oObject, gsBSGetBookDescription(sBookID));
                if (GetIsObjectValid(oObject))
                {
                    gsBSRemoveBook(sBookID);
                    DeleteLocalInt(OBJECT_SELF, "GS_BOOK");
                }
            }
            else
            {
                object oObject = CreateItemOnObject(GS_TEMPLATE_NOTEBOOK,
                                                    oSpeaker,
                                                    1);
                SetName(oObject, gsBSGetBookName(sBookID));
                SetDescription(oObject, gsBSGetBookDescription(sBookID));
                SetLocalString(oObject, "GS_NB_ID", sNotebookID);
                if (GetIsObjectValid(oObject))
                {
                    if(GetLocalString(oObject, "GS_NB_ID") != ""){
                        gsBSRemoveBook(sBookID);
                        DeleteLocalInt(OBJECT_SELF, "GS_BOOK");
                    } else {
                        DestroyObject(oObject);
                    }
                }
            }
        }
    }
}

