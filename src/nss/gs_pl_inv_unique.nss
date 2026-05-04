#include "gs_inc_common"

const int GS_LIMIT_GOLD = 5000;

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED"))      return;
    if (GetIsObjectValid(GetFirstItemInInventory())) return;

    //create inventory
    string sTag       = GetTag(OBJECT_SELF);
    sTag              = "GS_INVENTORY_" + GetStringRight(sTag, GetStringLength(sTag) - 3);
    object oInventory = GetObjectByTag(sTag);
    int nOpened       = ! GetIsObjectValid(GetLastKiller());

    if (GetIsObjectValid(oInventory))
    {
        object oItem = GetFirstItemInInventory(oInventory);

        if (GetIsObjectValid(oItem))
        {
            int nGold  = 0;
            int nCount = 0;

            //generate item list
            do
            {
                nGold = (nGold + gsCMGetItemValue(oItem)) / 2;

                SetLocalObject(
                    oInventory,
                    "GS_PL_INVENTORY_ITEM_" + IntToString(nCount++),
                    oItem);

                oItem = GetNextItemInInventory(oInventory);
            }
            while (GetIsObjectValid(oItem));

            //create item
            if (nOpened)
            {
                object oCopy = OBJECT_INVALID;

                oItem = GetLocalObject(
                    oInventory,
                    "GS_PL_INVENTORY_ITEM_" + IntToString(Random(nCount)));
                oCopy = CopyItem(oItem, OBJECT_SELF);

                if (GetIsObjectValid(oCopy))
                {
                    SetIdentified(oCopy, FALSE);
                    SetStolenFlag(oCopy, FALSE);

                    DestroyObject(oItem);
                    ExecuteScript("gs_co_close", oInventory);
                }
            }

            //create gold
            nGold /= 10;
            if (nGold > GS_LIMIT_GOLD) nGold = GS_LIMIT_GOLD;
            gsCMCreateGold(Random(nGold));
        }
    }

    if (nOpened) SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
