///////////////////////////////////////////////////////////////////////////////
// mk_cb_iprp_ftchk
///////////////////////////////////////////////////////////////////////////////
// callback itemproperty feat check
///////////////////////////////////////////////////////////////////////////////

#include "mk_inc_2da_disp"
#include "mk_inc_iprp"

void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int nFeatIndex = MK_Get2DAInt("iprp_feats", "FeatIndex", nRow);
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    int bCheck = !GetHasFeat(nFeatIndex, oPC) || MK_IPRP_GetItemHasFeat(oItem, nRow);

    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bCheck);
}
