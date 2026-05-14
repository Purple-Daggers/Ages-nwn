int StartingConditional()
{
    object oSpeaker  = GetPCSpeaker();
    string sGift1    = GetLocalString(oSpeaker, "GS_SU_GIFT1");
    string sGift2    = GetLocalString(oSpeaker, "GS_SU_GIFT2");
    string sGift3    = GetLocalString(oSpeaker, "GS_SU_GIFT3");
    string sGift4    = GetLocalString(oSpeaker, "GS_SU_GIFT4");
    string sGift5    = GetLocalString(oSpeaker, "GS_SU_GIFT5");
    string sCheck1   = "STRENGTH";
    string sCheck2   = "MINORSTRENGTH";
    int iResult;

    iResult = (sGift1 != sCheck1) && (sGift1 != sCheck2) &&
              (sGift2 != sCheck1) && (sGift2 != sCheck2) &&
              (sGift3 != sCheck1) && (sGift3 != sCheck2) &&
              (sGift4 != sCheck1) && (sGift4 != sCheck2) &&
              (sGift5 != sCheck1) && (sGift5 != sCheck2);
    return iResult;
}
