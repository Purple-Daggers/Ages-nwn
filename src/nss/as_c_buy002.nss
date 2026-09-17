#include "gs_inc_common"
void main()
{
    object oPlayer = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    string sTradeGood = GetLocalString(oSelf, "AS_TRADEGOOD");
    int nStock = GetLocalInt(oSelf, "AS_STOCK");
    int nTradePrice = GetLocalInt(oSelf, "AS_PRICE");

    if((GetGold(oPlayer) >= nTradePrice)  && (nStock > 0))
    {
        TakeGoldFromCreature(nTradePrice, oPlayer, TRUE);
        CreateItemOnObject(sTradeGood, oPlayer);
        SetLocalInt(oSelf, "AS_STOCK", nStock - 1);
    }
}
