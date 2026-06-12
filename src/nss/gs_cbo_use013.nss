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

                if (GetIsObjectValid(oObject))
                {
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
            else
            {
                object oObject = CreateItemOnObject(GS_TEMPLATE_NOTEBOOK,
                                                    oSpeaker,
                                                    1);

                if (GetIsObjectValid(oObject))
                {
                    SetName(oObject, gsBSGetBookName(sBookID));
                    SetDescription(oObject, gsBSGetBookDescription(sBookID));
                    if (sNotebookID != "")
                    {
                        //Freshly created objects need time to fully instantiate, so we add it to the action queue.
                        AssignCommand(oSpeaker, ActionDoCommand(SetLocalString(oObject, "GS_NB_ID", sNotebookID)));
                    }
                    gsBSRemoveBook(sBookID);
                    DeleteLocalInt(OBJECT_SELF, "GS_BOOK");
                }
            }
        }
    }
}

