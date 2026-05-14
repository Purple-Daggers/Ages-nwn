#include "gs_inc_subrace"

void gsParseGift(object oProperty, string sGift);

void gsSUParseGift(object oProperty, string sGift){
    if(sGift == "CHARISMA"){
            gsSUAddGift(oProperty, IP_CONST_ABILITY_CHA, 2);
    }
    else if(sGift == "STRENGTH"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_STR, 2);
    }
    else if(sGift == "DEXTERITY"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_DEX, 2);
    }
    else if(sGift == "CONSTITUTION"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_CON, 2);
    }
    else if(sGift == "INTELLIGENCE"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_INT, 2);
    }
    else if(sGift == "WISDOM"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, 2);
    }
    else if(sGift == "MINORCHARISMA"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_CHA, 1);
    }
    else if(sGift == "MINORSTRENGTH"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_STR, 1);
    }
    else if(sGift == "MINORDEXTERITY"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_DEX, 1);
    }
    else if(sGift == "MINORCONSTITUTION"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_CON, 1);
    }
    else if(sGift == "MINORINTELLIGENCE"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_INT, 1);
    }
    else if(sGift == "MINORWISDOM"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, 1);
    }
    else if(sGift == "LOSEMINORCHARISMA"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, -1);
    }
    else if(sGift == "LOSEMINORSTRENGTH"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_STR, -1);
    }
    else if(sGift == "LOSEMINORDEXTERITY"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_DEX, -1);
    }
    else if(sGift == "LOSEMINORCONSTITUTION"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_CON, -1);
    }
    else if(sGift == "LOSEMINORINTELLIGENCE"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_INT, -1);
    }
    else if(sGift == "LOSEMINORWISDOM"){
        gsSUAddGift(oProperty, IP_CONST_ABILITY_WIS, -1);
    }
}

void main()
{
    object oSpeaker  = GetPCSpeaker();
    object oProperty = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSpeaker);
    object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");
    int nSubRace     = GetLocalInt(oSpeaker, "GS_SU_SELECTION");
    string sGift1     = GetLocalString(oSpeaker, "GS_SU_GIFT1");
    string sGift2    = GetLocalString(oSpeaker, "GS_SU_GIFT2");
    string sGift3    = GetLocalString(oSpeaker, "GS_SU_GIFT3");
    string sGift4    = GetLocalString(oSpeaker, "GS_SU_GIFT4");
    string sGift5    = GetLocalString(oSpeaker, "GS_SU_GIFT5");
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

    gsSUParseGift(oProperty, sGift1);
    gsSUParseGift(oProperty, sGift2);
    gsSUParseGift(oProperty, sGift3);
    gsSUParseGift(oProperty, sGift4);
    gsSUParseGift(oProperty, sGift5);

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
