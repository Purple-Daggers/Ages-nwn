const int GS_TIMEOUT = 600; //TIME UPDATE: 10 minutes

void main()
{
    object oPlayer = GetPCSpeaker();
    if(!GetIsPC(oPlayer))
    {
        return;
    }
    int nTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    int nTimestampTrade = GetLocalInt(oPlayer, "AS_REPORT_TIMESTAMP");
    int nTimeout = nTimestamp - nTimestampTrade > GS_TIMEOUT;

    if(nTimeout)
    {
        //Create prospect item
        object oProspectPapers = CreateItemOnObject("as_report", oPlayer);
        SetLocalInt(oPlayer, "AS_REPORT_TIMESTAMP", nTimestamp);
    }
    else
    {
        SendMessageToPC(oPlayer, "You can only get one stack of report papers every ten minutes.");
    }
}



