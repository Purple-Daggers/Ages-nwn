#include "gs_inc_common"

void main()
{
    object oClosedBy = GetLastClosedBy();
    object oItem     = GetFirstItemInInventory();
    int nValue       = 0;

    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_GEM &&
            GetIdentified(oItem))
        {
            nValue = gsCMGetItemValue(oItem) * 50 / 100;

            gsCMCreateGold(nValue, oClosedBy);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory();
    }
}
