#include "mk_inc_debug"
#include "mk_inc_cheats"
#include "mk_inc_itm_disp"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);

    int nBaseItemType = GetBaseItemType(oItem);
    int nItemType = MK_Get2DAInt("baseitems", "PropColumn", nBaseItemType);
    int bCheck = MK_CHEATS_GetIsItemTypeSelected(oPC, nItemType);

    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK, bCheck);
}
