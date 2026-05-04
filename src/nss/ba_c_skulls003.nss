int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "BA_RANDOM");

    if (nNth < 0) return FALSE;

    if (nNth > 0)
    {
        SetLocalInt(OBJECT_SELF, "BA_RANDOM", nNth - 1);
        return FALSE;
    }

    object oPC1 = GetFirstPC();
    object oPC2 = OBJECT_INVALID;

    while (GetIsObjectValid(oPC1))
    {
        if (! (GetIsDM(oPC1) || GetIsDMPossessed(oPC1)))
        {
            oPC2 = oPC1;
            if (Random(100) >= 50) break;
        }

        oPC1 = GetNextPC();
    }

    if (GetIsObjectValid(oPC2))
    {
        SetCustomToken(100, GetName(oPC2));
        SetLocalInt(OBJECT_SELF, "BA_RANDOM", -1);
        return TRUE;
    }

    return FALSE;
}
