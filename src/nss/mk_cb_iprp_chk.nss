#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_iprp"
#include "mk_inc_cheats"
#include "mk_inc_states"

const string s2DAfile = "itempropdef";
const string sColumnStrRef = "Name";


void main()
{
    object oPC = OBJECT_SELF;

    int bCheck=TRUE;
    int bShowCurrentOnly = GetLocalInt(oPC, "MK_CHEATS_ITEMPROPS_SHOWCURRENTONLY");

    if (bShowCurrentOnly)
    {
        int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

        object oItem = MK_CHEATS_GetCurrentItem();
        int nIProp = MK_CHEATS_GetCurrentItemPropertyID();
        int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
        int nCostTableValue = MK_CHEATS_GetCurrentItemPropertyCostTableValue();

        int nState = MK_GenericDialog_GetState();

        itemproperty iProp;
        switch (nState)
        {
        case MK_STATE_CHEATS_ITEMPROPS_PROPERTY:
            iProp = MK_IPRP_GetItemProperty(oItem, nRow);
            break;
        case MK_STATE_CHEATS_ITEMPROPS_SUBTYPE:
            iProp = MK_IPRP_GetItemProperty(oItem, nIProp, nRow);
            break;
        case MK_STATE_CHEATS_ITEMPROPS_COSTTABLE:
            iProp = MK_IPRP_GetItemProperty(oItem, nIProp, nSubType, nRow);
            break;
        case MK_STATE_CHEATS_ITEMPROPS_PARAM1:
            iProp = MK_IPRP_GetItemProperty(oItem, nIProp, nSubType, nCostTableValue, nRow);
            break;
        }
        bCheck = GetIsItemPropertyValid(iProp);
    }

    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bCheck);
}
