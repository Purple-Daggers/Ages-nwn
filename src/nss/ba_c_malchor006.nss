int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetLevelByClass(CLASS_TYPE_SORCERER, oSpeaker) > 0 ||
           GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker) > 0;
}
