#include "gs_inc_common"
void main()
{
   object oPlayer = GetPCSpeaker();
   object oItem = GetFirstItemInInventory(oPlayer);
   while (GetIsObjectValid(oItem) == TRUE)
   {
        //as_tradegood006
        if(GetStringLeft(GetTag(oItem), 12) == "as_tradegood")
        {
            gsCMCreateGold(120, oPlayer);
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oPlayer);
   }
}
