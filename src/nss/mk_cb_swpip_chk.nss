#include "mk_inc_debug"
#include "mk_inc_itm_disp"
#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_swp_iprop"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);
    int nState = MK_GenericDialog_GetState();

    int nBaseItemType = GetBaseItemType(oItem);
    int nCharges = GetItemCharges(oItem);
    int nItemType = MK_Get2DAInt("baseitems", "PropColumn", nBaseItemType, -1);

    int bCheck=FALSE;

    switch (nState)
    {
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1:
        bCheck = MK_Get2DAInt("mk_iprp_cols", "SwpIPrp", nItemType, 0);
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2:
    {
        object oItem1 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
        if (GetIsObjectValid(oItem1) && (oItem1!=oItem))
        {
            int nItemType1 = MK_Get2DAInt("baseitems", "PropColumn", GetBaseItemType(oItem1), -1);
            int nCharges1 = GetItemCharges(oItem1);
            bCheck = (nItemType == nItemType1) && (((nCharges1==0) && (nCharges==0)) || ((nCharges1>0) && (nCharges>0)));
        }
        break;
    }
    }

    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK, bCheck);
}
