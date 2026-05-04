#include "gs_inc_subrace"

void main()
{
    object oSpeaker  = GetPCSpeaker();
    object oProperty = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSpeaker);
    object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");
    int nSubRace     = GetLocalInt(oSpeaker, "GS_SU_SELECTION");
    int nLevel       = GetHitDice(oSpeaker);
    int nFlag        = FALSE;

    if (! GetIsObjectValid(oProperty))
    {
        oProperty = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oSpeaker);
        nFlag     = TRUE;
    }

    if (! GetIsObjectValid(oAbility))
    {
        oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oSpeaker);
    }

    if (GetIsObjectValid(oProperty))
    {
        gsSUApplyProperty(oProperty, nSubRace, nLevel);
        if (nFlag) AssignCommand(oSpeaker, ActionEquipItem(oProperty, INVENTORY_SLOT_CARMOUR));
    }

    if (GetIsObjectValid(oAbility))
    {
        gsSUApplyAbility(oAbility, nSubRace, nLevel);
    }

    SetSubRace(oSpeaker, gsSUGetNameBySubRace(nSubRace));

    switch (nSubRace)
    {
    case GS_SU_SPECIAL_FEY:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_FAIRY);
        break;

    case GS_SU_SPECIAL_GOBLIN:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_GOBLIN_A);
        break;

    case GS_SU_SPECIAL_KOBOLD:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_KOBOLD_A);
        break;
    }
}
