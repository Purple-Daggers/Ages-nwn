#include "gs_inc_booksh"

void main()
{
    object oShelf = OBJECT_SELF;
    object oItem = GetFirstItemInInventory(oShelf);
    int nChanged = FALSE;
    while (GetIsObjectValid(oItem) == TRUE)
    {
        if(GetBaseItemType(oItem) == BASE_ITEM_BOOK)
        {
            if(gsBSPostBook(GetName(oItem), GetDescription(oItem), oShelf))
            {
                nChanged = TRUE;
                DestroyObject(oItem);
            }
        }
        oItem = GetNextItemInInventory(oShelf);
    }
    if(nChanged == TRUE)
    {
        gsBSUnloadContent(oShelf);
    }
}
