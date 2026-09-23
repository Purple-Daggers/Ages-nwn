#include "gs_inc_common"
void main()
{
    object oPlayer = GetPCSpeaker();
    object oProspect = GetItemPossessedBy(oPlayer, "as_prospect");
    if(!GetIsObjectValid(oProspect))
    {
        return;
    }
    string sTradeGood = GetLocalString(oProspect, "AS_TRADEGOOD");
    int nWillBuy = GetLocalInt(oProspect, "AS_WILLBUY");
    int nTradePrice = GetLocalInt(oProspect, "AS_PRICE");
    object oItem = GetItemPossessedBy(oPlayer, sTradeGood);

    if((GetIsObjectValid(oItem))  && (nWillBuy > 0))
    {
        gsCMCreateGold(nTradePrice, oPlayer);
        DestroyObject(oItem);
        SetLocalInt(oProspect, "AS_WILLBUY", nWillBuy - 1);
        if(nWillBuy <= 1)
        {
            DestroyObject(oProspect);
        }
    }
}
