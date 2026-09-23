const int GS_TIMEOUT = 10800; //TIME UPDATE: 3 Hours

int StartingConditional()
{
    object oPlayer = GetPCSpeaker();
    object oProspect = GetItemPossessedBy(oPlayer, "as_prospect");
    if(!GetIsObjectValid(oProspect))
    {
        return FALSE;
    }
    string sTradeGood = GetLocalString(oProspect, "AS_TRADEGOOD");
    int nWillBuy = GetLocalInt(oProspect, "AS_WILLBUY");
    string sTradeName = GetLocalString(oProspect, "AS_TRADENAME");
    int nTradePrice = GetLocalInt(oProspect, "AS_PRICE");

    SetCustomToken(1000, sTradeName);
    SetCustomToken(1001, IntToString(nTradePrice));
    SetCustomToken(1002, IntToString(nWillBuy));

    if(nWillBuy > 0)
    {
        return TRUE;
    }
    else
    {
        DestroyObject(oProspect);
        return FALSE;
    }
}

