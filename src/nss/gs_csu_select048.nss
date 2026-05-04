int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetRacialType(oSpeaker) == RACIAL_TYPE_HUMAN &&
           GetAlignmentGoodEvil(oSpeaker) == ALIGNMENT_EVIL &&
           GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_LAWFUL;
}
