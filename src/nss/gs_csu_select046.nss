int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetRacialType(oSpeaker) == RACIAL_TYPE_HALFLING &&
           GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_NEUTRAL &&
           GetAlignmentGoodEvil(oSpeaker) != ALIGNMENT_EVIL;
}
