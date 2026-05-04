int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetRacialType(oSpeaker) == RACIAL_TYPE_ELF &&
           GetAlignmentGoodEvil(oSpeaker) != ALIGNMENT_GOOD;
}
