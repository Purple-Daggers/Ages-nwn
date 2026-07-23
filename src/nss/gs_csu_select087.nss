int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetRacialType(oSpeaker) == RACIAL_TYPE_HUMAN && GetGender(oSpeaker) == GENDER_FEMALE;
}

