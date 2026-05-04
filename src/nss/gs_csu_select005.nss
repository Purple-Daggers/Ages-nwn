int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nRacialType = GetRacialType(oSpeaker);

    return nRacialType == RACIAL_TYPE_ELF;
}
