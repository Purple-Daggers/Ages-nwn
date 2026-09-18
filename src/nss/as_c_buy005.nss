#include "gs_inc_common"
void main()
{
    object oPlayer = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    string sTradeGood = GetLocalString(oSelf, "AS_TRADEGOOD");
    int nWillBuy = GetLocalInt(oSelf, "AS_WILLBUY");
    int nTradePrice = GetLocalInt(oSelf, "AS_PRICE");
    object oItem = GetItemPossessedBy(oPlayer, sTradeGood);

    if((GetIsObjectValid(oItem))  && (nWillBuy > 0))
    {
        gsCMCreateGold(nTradePrice, oPlayer);
        DestroyObject(oItem);
        SetLocalInt(oSelf, "AS_WILLBUY", nWillBuy - 1);
    }
}
