int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    if (GetIsPC(oSpeaker) &&
        GetAlignmentGoodEvil(oSpeaker) == ALIGNMENT_EVIL)
    {
        return TRUE;
    }

    return FALSE;
}
