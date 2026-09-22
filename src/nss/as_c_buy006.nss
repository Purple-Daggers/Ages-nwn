int StartingConditional()
{
    object oPlayer = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    string sTradeGood = GetLocalString(oSelf, "AS_TRADEGOOD");
    int nWillBuy = GetLocalInt(oSelf, "AS_WILLBUY");

    if((GetIsObjectValid(GetItemPossessedBy(oPlayer, sTradeGood))) && (nWillBuy > 0))
    {
        return TRUE;
    }
    return FALSE;
}

