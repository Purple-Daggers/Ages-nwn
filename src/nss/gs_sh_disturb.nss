#include "gs_inc_shop"
#include "gs_inc_text"
#include "gs_inc_listener"

void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oDisturbed = GetLastDisturbed();
    object oItem      = GetInventoryDisturbItem();
    object oCopy      = OBJECT_INVALID;
    string sTag       = GetTag(oItem);

    switch (GetInventoryDisturbType())
    {
    case INVENTORY_DISTURB_TYPE_ADDED:
        if (GetIsDM(oDisturbed) ||
            gsSHGetIsOwner(OBJECT_SELF, oDisturbed))
        {
            string sMessage = gsLIGetLastMessage(oDisturbed);
            int nPrice = StringToInt(sMessage);
            if(nPrice != 0)
            {
                SetLocalInt(oItem, "GS_CUSTOM_PRICE", nPrice);
                SendMessageToPC(oDisturbed, "Set price of item " + GetName(oItem) + " to " + sMessage);
            }
            gsSHImportItem(oItem, OBJECT_SELF);
        }
        else
        {
            oCopy = CopyItem(oItem, oDisturbed);

            if (GetIsObjectValid(oCopy))
            {
                DestroyObject(oItem);
                SendMessageToPC(oDisturbed, GS_T_16777420);
            }
        }
        break;

    case INVENTORY_DISTURB_TYPE_REMOVED:
    case INVENTORY_DISTURB_TYPE_STOLEN:
        //bug workaround: moved to gs_m_acquired because event is not raised
        //if items are dragged from a shop into an inventory subcontainer
        break;
    }
}
