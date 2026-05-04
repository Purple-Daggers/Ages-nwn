int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetRacialType(oSpeaker) == RACIAL_TYPE_DWARF;
}
