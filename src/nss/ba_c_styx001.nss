void main()
{
    object oSpeaker = GetPCSpeaker();
    int nLevel      = GetHitDice(oSpeaker) - 1;
    int nXPLevel    = nLevel * (nLevel - 1) / 2 * 1000;

    if (nXPLevel >= 0) SetXP(oSpeaker, nXPLevel);
}
