const int GS_TIMEOUT = 10800; //TIME UPDATE: 3 Hours

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    string sTradeGood = GetLocalString(oSelf, "AS_TRADEGOOD");
    int nStock = GetLocalInt(oSelf, "AS_STOCK");
    string sTradeName = GetLocalString(oSelf, "AS_TRADENAME");
    int nTradePrice = GetLocalInt(oSelf, "AS_PRICE");
    int nTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    int nTimestampTrade = GetLocalInt(oSelf, "GS_TIMESTAMP");
    int nTimeout = nTimestamp - nTimestamp > GS_TIMEOUT;

    if(!GetLocalInt(oSelf, "AS_ENABLED") || nTimeout)
    {
        //Pick a random tradegood to sell
        sTradeGood = "as_tradegood001";
        switch((1 + Random(11)))
        {
            case 1: sTradeGood = "as_tradegood001"; nTradePrice = 100; break;
            case 2: sTradeGood = "as_tradegood002"; nTradePrice = 100; break;
            case 3: sTradeGood = "as_tradegood003"; nTradePrice = 100; break;
            case 4: sTradeGood = "as_tradegood004"; nTradePrice = 100; break;
            case 5: sTradeGood = "as_tradegood005"; nTradePrice = 100; break;
            case 6: sTradeGood = "as_tradegood006"; nTradePrice = 100; break;
            case 7: sTradeGood = "as_tradegood007"; nTradePrice = 100; break;
            case 8: sTradeGood = "as_tradegood008"; nTradePrice = 100; break;
            case 9: sTradeGood = "as_tradegood009"; nTradePrice = 100; break;
            case 10: sTradeGood = "as_tradegood010"; nTradePrice = 100; break;
            case 11: sTradeGood = "as_tradegood011"; nTradePrice = 100; break;
            case 12: sTradeGood = "as_tradegood012"; nTradePrice = 100; break;

            default: sTradeGood = "as_tradegood001"; nTradePrice = 100; break;
        }
        object oTradeGood = CreateItemOnObject(sTradeGood);
        if(!GetIsObjectValid(oTradeGood))
        {
            sTradeGood = "as_tradegood001";
            nTradePrice = 100;
            oTradeGood = CreateItemOnObject(sTradeGood);
        }

        nStock = 10 + Random(11);
        sTradeName = GetName(oTradeGood);

        SetLocalInt(oSelf, "AS_ENABLED", TRUE);
        SetLocalString(oSelf, "AS_TRADEGOOD", sTradeGood);
        SetLocalInt(oSelf, "AS_PRICE", nTradePrice);
        SetLocalInt(oSelf, "AS_STOCK", nStock);
        SetLocalString(oSelf, "AS_TRADENAME", sTradeName);
        SetLocalInt(oSelf, "GS_TIMESTAMP", nTimestamp);
    }

    SetCustomToken(1000, sTradeName);
    SetCustomToken(1001, IntToString(nTradePrice));
    SetCustomToken(1002, IntToString(nStock));

    if(nStock > 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
