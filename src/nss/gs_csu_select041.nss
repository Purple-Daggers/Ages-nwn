#include "gs_inc_subrace"

void main()
{
    object oSpeaker  = GetPCSpeaker();
    object oProperty = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSpeaker);
    object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");

    if (GetIsObjectValid(oProperty))
    {
        gsIPRemoveAllProperties(oProperty);
    }
    else
    {
        oProperty = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oSpeaker);

        if (GetIsObjectValid(oProperty))
        {
            AssignCommand(oSpeaker, ActionEquipItem(oProperty, INVENTORY_SLOT_CARMOUR));
        }
    }

    if (GetIsObjectValid(oAbility)) DestroyObject(oAbility);

    SetSubRace(oSpeaker, "");
}
