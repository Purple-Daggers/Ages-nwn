void main()
{
    object oSpeaker = GetPCSpeaker();

    if (GetIsPC(oSpeaker))
    {
        object oItem = GetItemPossessedBy(oSpeaker, "dspeedy4");

        if (GetIsObjectValid(oItem))
        {
            GiveGoldToCreature(oSpeaker, 10);
            GiveXPToCreature(oSpeaker, 500);

            DestroyObject(oItem);
        }
    }
}
