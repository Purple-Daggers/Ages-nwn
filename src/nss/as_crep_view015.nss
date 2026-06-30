int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "AS_REP_REPUTATION") != -1;
    return iResult;
}
