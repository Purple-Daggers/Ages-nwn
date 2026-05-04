#include "gs_inc_shop"

void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oPC = GetLastClosedBy();

    if (GetIsDM(oPC) ||
        gsSHGetIsOwner(OBJECT_SELF, oPC))
    {
        DelayCommand(0.5, gsSHSave(OBJECT_SELF));
    }
}
