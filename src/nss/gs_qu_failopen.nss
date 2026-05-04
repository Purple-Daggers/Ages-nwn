#include "gs_inc_quarter"

void main()
{
    object oPC = GetClickingObject();
    int nOwner = gsQUGetIsOwner(OBJECT_SELF, oPC);

    if (nOwner || (! nOwner && gsQUGetIsAvailable(OBJECT_SELF)) ||
        GetIsDM(oPC) ||
        GetIsObjectValid(GetItemPossessedBy(oPC, gsQUGetKeyTag(OBJECT_SELF))))
    {
        if (nOwner) gsQUTouch(OBJECT_SELF);

        ActionDoCommand(SetLocked(OBJECT_SELF, FALSE));
        ActionOpenDoor(OBJECT_SELF);
        ActionDoCommand(SetLocked(OBJECT_SELF, TRUE));
    }
}
