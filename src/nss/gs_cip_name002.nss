#include "gs_inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage(GetPCSpeaker());
    sMessage        = GetStringLeft(sMessage, 100);

    gsLIClearLastMessage(GetPCSpeaker());
    object oItem = GetFirstItemInInventory();
    if (GetIsObjectValid(oItem))
    {
        SetName(oItem, sMessage);
    }
}

