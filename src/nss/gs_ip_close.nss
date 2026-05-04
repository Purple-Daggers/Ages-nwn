#include "gs_inc_text"

void main()
{
    if (GetIsObjectValid(GetFirstItemInInventory()))
    {
        object oUser = GetLastClosedBy();

        if (GetIsObjectValid(GetNextItemInInventory()))
            FloatingTextStringOnCreature(GS_T_16777232, oUser, FALSE);
        else
            ActionStartConversation(oUser, "", TRUE, FALSE);
    }
}
