int StartingConditional()
{
/*
    object oSpeaker = GetPCSpeaker();
    string sName    = GetPCPlayerName(oSpeaker);

    return sName == "Gigaschatten";
*/

    return GetIsDM(GetPCSpeaker());
}
