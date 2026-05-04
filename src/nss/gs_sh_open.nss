#include "gs_inc_shop"

void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oPC = GetLastOpenedBy();

    if (gsSHGetIsOwner(OBJECT_SELF, oPC))
    {
        gsSHTouch(OBJECT_SELF);
    }

    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsSHLoad(OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }
}
