int StartingConditional()
{
    if(GetLocalString(OBJECT_SELF, "GS_FX_ID") != "")
    {
        return TRUE;
    }
    return FALSE;
}

