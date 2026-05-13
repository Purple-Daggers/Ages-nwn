#include "gs_inc_subrace"

void main()
{
    object oSpeaker  = GetPCSpeaker();
    object oProperty = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSpeaker);
    object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");
    int nSubRace     = GetLocalInt(oSpeaker, "GS_SU_SELECTION");
    string nGift     = GetLocalString(oSpeaker, "GS_SU_GIFT1");
    string nGift2    = GetLocalString(oSpeaker, "GS_SU_GIFT2");
    string nGift3    = GetLocalString(oSpeaker, "GS_SU_GIFT3");
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

    if (nGift != "")
    {
        if(nGift == "CHARISMA"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_CHA, 2);
        }
        else if(nGift == "STRENGTH"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_STR, 2);
        }
        else if(nGift == "DEXTERITY"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_DEX, 2);
        }
        else if(nGift == "CONSTITUTION"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_CON, 2);
        }
        else if(nGift == "INTELLIGENCE"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_INT, 2);
        }
        else if(nGift == "WISDOM"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, 2);
        }
        else if(nGift == "MINORCHARISMA"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_CHA, 1);
        }
        else if(nGift == "MINORSTRENGTH"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_STR, 1);
        }
        else if(nGift == "MINORDEXTERITY"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_DEX, 1);
        }
        else if(nGift == "MINORCONSTITUTION"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_CON, 1);
        }
        else if(nGift == "MINORINTELLIGENCE"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_INT, 1);
        }
        else if(nGift == "MINORWISDOM"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, 1);
        }
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
