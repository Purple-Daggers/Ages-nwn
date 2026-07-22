#include "mk_inc_debug"
#include "mk_inc_itm_disp"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);

    int bShowAllItems = GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS");

    int bCheck = bShowAllItems || (GetItemCharges(oItem)>0);

    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK, bCheck);
}
