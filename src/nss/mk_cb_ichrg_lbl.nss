#include "mk_inc_itm_disp"
#include "mk_inc_cheats"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);
    object oCurrentItem = MK_CHEATS_GetCurrentItem();

    int bIsCurrentItem = (oItem == oCurrentItem);
    string sColorTag = GetLocalString(oPC, (bIsCurrentItem ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"));

    string sLabel = sColorTag+GetName(oItem);
    int nCharges = GetItemCharges(oItem);
    if (nCharges>0)
    {
        sLabel += (" #" + IntToString(nCharges));
    }
    sLabel += "</c>";

    SetLocalString(OBJECT_SELF, MK_ITM_DISP_CALLBACK_LABEL, sLabel);
}
