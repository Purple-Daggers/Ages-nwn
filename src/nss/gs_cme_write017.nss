int StartingConditional()
{
    string sString = GetLocalString(OBJECT_SELF, "GS_ME_TITLE");
    string sString2 = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1");

    if (sString != "")
    {
        SetCustomToken(100, sString);
        SetCustomToken(101, sString);
        return TRUE;
    }

    return FALSE;
}
