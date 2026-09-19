const int GS_TIMEOUT = 3600; //TIME UPDATE: 1 Hour

void main()
{
    object oSelf = OBJECT_SELF;
    object oPlayer = GetPCSpeaker();
    if(!GetIsPC(oPlayer))
    {
        return;
    }
    string sTradeGood;
    int nWillBuy;
    string sTradeName;
    int nTradePrice;
    string sDestination;
    int nTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    int nTimestampTrade = GetLocalInt(oPlayer, "AS_PROSPECT_TIMESTAMP");
    int nTimeout = nTimestamp - nTimestampTrade > GS_TIMEOUT;

    if(nTimeout)
    {
        //Pick a random tradegood to sell
        sTradeGood = "as_tradegood001";
        switch((1 + Random(11)))
        {
            case 1: sTradeGood = "as_tradegood001"; nTradePrice = 200; break;
            case 2: sTradeGood = "as_tradegood002"; nTradePrice = 200; break;
            case 3: sTradeGood = "as_tradegood003"; nTradePrice = 200; break;
            case 4: sTradeGood = "as_tradegood004"; nTradePrice = 200; break;
            case 5: sTradeGood = "as_tradegood005"; nTradePrice = 200; break;
            case 6: sTradeGood = "as_tradegood006"; nTradePrice = 200; break;
            case 7: sTradeGood = "as_tradegood007"; nTradePrice = 200; break;
            case 8: sTradeGood = "as_tradegood008"; nTradePrice = 200; break;
            case 9: sTradeGood = "as_tradegood009"; nTradePrice = 200; break;
            case 10: sTradeGood = "as_tradegood010"; nTradePrice = 200; break;
            case 11: sTradeGood = "as_tradegood011"; nTradePrice = 200; break;
            case 12: sTradeGood = "as_tradegood012"; nTradePrice = 200; break;

            default: sTradeGood = "as_tradegood001"; nTradePrice = 200; break;
        }
        object oTradeGood = CreateItemOnObject(sTradeGood);
        if(!GetIsObjectValid(oTradeGood))
        {
            sTradeGood = "as_tradegood001";
            nTradePrice = 200;
            oTradeGood = CreateItemOnObject(sTradeGood);
        }

        nWillBuy = 10 + Random(11);
        sTradeName = GetName(oTradeGood);
        DestroyObject(oTradeGood);

        //Pick a random destination
        switch((1+ Random(2)))
        {
            case 1: sDestination = "Loralon"; break;
            case 2: sDestination = "Somewhere"; break;
            case 3: sDestination = "Elsewhere"; break;
            default: sDestination = "Loralon"; break;
        }

        //Create prospect item
        object oProspectPapers = CreateItemOnObject("as_prospect", oPlayer);

        SetLocalInt(oProspectPapers, "AS_ENABLED", TRUE);
        SetLocalString(oProspectPapers, "AS_TRADEGOOD", sTradeGood);
        SetLocalInt(oProspectPapers, "AS_PRICE", nTradePrice);
        SetLocalInt(oProspectPapers, "AS_WILLBUY", nWillBuy);
        SetLocalString(oProspectPapers, "AS_TRADENAME", sTradeName);
        SetLocalString(oProspectPapers, "AS_DESTINATION", sDestination);

        SetDescription(oProspectPapers, "This trading prospect says I can deliver up to " + IntToString(nWillBuy) + " crates of " + sTradeName + " to " + sDestination + " for " + IntToString(nTradePrice) + " coins each.");

        SetLocalInt(oPlayer, "AS_PROSPECT_TIMESTAMP", nTimestamp);
    }
    else
    {
        SendMessageToPC(oPlayer, "You cannot get another trading prospect at this time.");
    }
}


