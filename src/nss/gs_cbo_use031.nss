int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_BOOK");
    if (nNth != -1)
    {
        string sMessageID = GetLocalString(OBJECT_SELF, "GS_BS_BOOK_" + IntToString(nNth));
        if(GetLocalString(OBJECT_SELF, sMessageID + "_NOTEBOOK") != "")
        {
            return TRUE;
        }
    }
    return FALSE;
}
