int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    int nRacialType = GetRacialType(oSpeaker);

    return nRacialType == RACIAL_TYPE_HALFELF || nRacialType == RACIAL_TYPE_ELF || nRacialType == RACIAL_TYPE_HUMAN;
}

