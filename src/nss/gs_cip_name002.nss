#include "gs_inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage();
    sMessage        = GetStringLeft(sMessage, 100);

    gsLIClearLastMessage();
    object oItem = GetFirstItemInInventory();
    if (GetIsObjectValid(oItem))
    {
        SetName(oObject, sMessage);
    }
}

