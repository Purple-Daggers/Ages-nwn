int StartingConditional()
{
    object oPlayer = GetPCSpeaker();
    object oProspect = GetItemPossessedBy(oPlayer, "as_prospect");
    if(!GetIsObjectValid(oProspect))
    {
        return FALSE;
    }
    string sTradeName = GetLocalString(oProspect, "AS_TRADENAME");
    string sTradeGood = GetLocalString(oProspect, "AS_TRADEGOOD");
    int nWillBuy = GetLocalInt(oProspect, "AS_WILLBUY");

    if((GetIsObjectValid(GetItemPossessedBy(oPlayer, sTradeGood))) && (nWillBuy > 0))
    {
        SetCustomToken(1000, sTradeName);
        return TRUE;
    }
    return FALSE;
}

