/* THEFT Library by Gigaschatten */

//void main() {}

//set oStolenFrom as previous owner of oItem
void gsTHSetStolenFrom(object oItem, object oStolenFrom);
//return previous owner of oItem
object gsTHGetStolenFrom(object oItem);
//return TRUE if oCreature possesses an item of oStolenFrom
int gsTHGetHasItemStolenFrom(object oCreature, object oStolenFrom);
//reset stolen state of oItem
void gsTHResetStolenItem(object oItem);
//return items from oCreature to oStolenFrom
void gsTHReturnStolenItems(object oCreature, object oStolenFrom);

void gsTHSetStolenFrom(object oItem, object oStolenFrom)
{
    if (! GetIsObjectValid(gsTHGetStolenFrom(oItem)) &&
        GetObjectType(oStolenFrom) == OBJECT_TYPE_CREATURE)
    {
        SetLocalObject(oItem, "GS_TH_STOLEN_FROM", oStolenFrom);
    }
}
//----------------------------------------------------------------
object gsTHGetStolenFrom(object oItem)
{
    return GetLocalObject(oItem, "GS_TH_STOLEN_FROM");
}
//----------------------------------------------------------------
int gsTHGetHasItemStolenFrom(object oCreature, object oStolenFrom)
{
    object oItem = GetFirstItemInInventory(oCreature);

    while (GetIsObjectValid(oItem))
    {
        if (gsTHGetStolenFrom(oItem) == oStolenFrom) return TRUE;

        oItem = GetNextItemInInventory(oCreature);
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsTHResetStolenItem(object oItem)
{
    DeleteLocalObject(oItem, "GS_TH_STOLEN_FROM");
    SetStolenFlag(oItem, FALSE);
}
//----------------------------------------------------------------
void gsTHReturnStolenItems(object oCreature, object oStolenFrom)
{
    object oItem = GetFirstItemInInventory(oCreature);
    object oCopy = OBJECT_INVALID;

    while (GetIsObjectValid(oItem))
    {
        if (gsTHGetStolenFrom(oItem) == oStolenFrom)
        {
            oCopy = CopyItem(oItem, oStolenFrom, TRUE);

            if (GetIsObjectValid(oCopy))
            {
                gsTHResetStolenItem(oCopy);
                DestroyObject(oItem);
            }
        }

        oItem = GetNextItemInInventory(oCreature);
    }
}
