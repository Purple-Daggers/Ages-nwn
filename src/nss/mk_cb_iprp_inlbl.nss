#include "mk_inc_itm_disp"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);

    string sLabel = GetName(oItem);
    int nBaseItemType = GetBaseItemType(oItem);
    if ((GetItemStackSize(oItem)>1) || (MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1) > 1))
    {
        sLabel += (" #" + IntToString(GetItemStackSize(oItem)));
    }
    SetLocalString(OBJECT_SELF, MK_ITM_DISP_CALLBACK_LABEL, sLabel);
}
