void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");
    if (nNth != -1)
    {
        string sMessageID = GetLocalString(OBJECT_SELF, "GS_BS_BOOK_" + IntToString(nNth));
        string sNotebookID = GetLocalString(OBJECT_SELF, sMessageID + "_NOTEBOOK");
        if (sNotebookID != ""){
            SetLocalString(OBJECT_SELF, "GS_NB_ID", sNotebookID);
        }
    }
}
