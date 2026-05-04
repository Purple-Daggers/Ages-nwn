int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetCreatureSize(oSpeaker) == CREATURE_SIZE_MEDIUM;
}
