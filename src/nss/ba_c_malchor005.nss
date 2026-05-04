int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetLevelByClass(CLASS_TYPE_ROGUE, oSpeaker) > 0;
}
