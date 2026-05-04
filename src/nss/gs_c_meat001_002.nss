#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    string sResRef  = "";
    int nGold       = 0;

    while (GetIsObjectValid(oItem))
    {
        sResRef = GetResRef(oItem);

        if (sResRef == "gs_item897") //meat big
        {
            nGold += 15;
            DestroyObject(oItem);
        }
        else if (sResRef == "gs_item898") //meat medium
        {
            nGold += 10;
            DestroyObject(oItem);
        }
        else if (sResRef == "gs_item899") //meat small
        {
            nGold += 5;
            DestroyObject(oItem);
        }

        oItem   = GetNextItemInInventory(oSpeaker);
    }

    gsCMCreateGold(nGold, oSpeaker);
}
