#include "gs_inc_common"
#include "gs_inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    int nValue      = 0;

    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "GS_HEAD_EVIL")
        {
            nValue = gsCMGetItemValue(oItem);
            gsCMCreateGold(nValue, oSpeaker);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oSpeaker);
    }
}
