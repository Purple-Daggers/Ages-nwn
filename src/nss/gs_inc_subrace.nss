/* SUBRACE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_iprop"
#include "gs_inc_text"

//void main() {}

const string GS_SU_TEMPLATE_PROPERTY      = "gs_item317";
const string GS_SU_TEMPLATE_ABILITY       = "gs_item318";

const int GS_SU_NONE                      =   0;
const int GS_SU_DWARF_GOLD                =   1;
const int GS_SU_DWARF_GRAY                =   2;
const int GS_SU_DWARF_SHIELD              =   3;
const int GS_SU_ELF_DROW                  =   4;
const int GS_SU_ELF_MOON                  =   5;
const int GS_SU_ELF_SUN                   =   6;
const int GS_SU_ELF_WILD                  =   7;
const int GS_SU_ELF_WOOD                  =   8;
const int GS_SU_GNOME_DEEP                =   9;
const int GS_SU_GNOME_ROCK                =  10;
const int GS_SU_HALFLING_GHOSTWISE        =  11;
const int GS_SU_HALFLING_LIGHTFOOT        =  12;
const int GS_SU_HALFLING_STRONGHEART      =  13;
const int GS_SU_PLANETOUCHED_AASIMAR      =  14;
const int GS_SU_PLANETOUCHED_GENASI_AIR   =  15;
const int GS_SU_PLANETOUCHED_GENASI_EARTH =  16;
const int GS_SU_PLANETOUCHED_GENASI_FIRE  =  17;
const int GS_SU_PLANETOUCHED_GENASI_WATER =  18;
const int GS_SU_PLANETOUCHED_TIEFLING     =  19;

const int GS_SU_SPECIAL_FEY               = 100;
const int GS_SU_SPECIAL_GOBLIN            = 101;
const int GS_SU_SPECIAL_KOBOLD            = 102;
const int GS_SU_SPECIAL_BAATEZU           = 103;

//apply properties for nSubrace of nLevel to oItem
void gsSUApplyProperty(object oItem, int nSubRace, int nLevel);
//apply abilities for nSubrace of nLevel to oItem
void gsSUApplyAbility(object oItem, int nSubRace, int nLevel);
//return subrace constant resembling sSubRace
int gsSUGetSubRaceByName(string sSubRace);
//return name of nSubRace
string gsSUGetNameBySubRace(int nSubRace);
//return effective character level for nSubRace of nLevel
int gsSUGetECL(int nSubRace, int nLevel);
//return favored class of nSubRace and nGender
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE);

void gsSUApplyProperty(object oItem, int nSubRace, int nLevel)
{
    object oPossessor = GetItemPossessor(oItem);
    int nRacialType   = GetIsObjectValid(oPossessor) ?
                        GetRacialType(oPossessor) : -1;

    gsIPRemoveAllProperties(oItem);

    switch (nSubRace)
    {
    case GS_SU_NONE:
        break;

    case GS_SU_DWARF_GOLD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 1),
                        oItem);
        break;

    case GS_SU_DWARF_GRAY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, -2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 1),
                        oItem);
        break;

    case GS_SU_DWARF_SHIELD: //default
        break;

    case GS_SU_ELF_DROW:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);

        switch (nLevel)
        {
        case  1:
        case  2:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12),
                            oItem);
            break;

        case  3:
        case  4:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                            oItem);
            break;

        case  5:
        case  6:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);
            break;

        case  7:
        case  8:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                            oItem);
            break;

        case  9:
        case 10:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            break;

        case 11:
        case 12:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                            oItem);
            break;

        case 13:
        case 14:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                            oItem);
            break;

        case 15:
        case 16:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26),
                            oItem);
            break;

        case 17:
        case 18:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28),
                            oItem);
            break;

        case 19:
        case 20:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_30),
                            oItem);
            break;

        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);
            break;
        }

        break;

    case GS_SU_ELF_MOON: //default
        break;

    case GS_SU_ELF_SUN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                        oItem);
        break;

    case GS_SU_ELF_WILD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                        oItem);
        break;

    case GS_SU_ELF_WOOD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        break;

    case GS_SU_GNOME_DEEP:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);

        switch (nLevel)
        {
        case  1:
        case  2:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12),
                            oItem);
            break;

        case  3:
        case  4:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                            oItem);
            break;

        case  5:
        case  6:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);
            break;

        case  7:
        case  8:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                            oItem);
            break;

        case  9:
        case 10:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            break;

        case 11:
        case 12:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                            oItem);
            break;

        case 13:
        case 14:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                            oItem);
            break;

        case 15:
        case 16:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26),
                            oItem);
            break;

        case 17:
        case 18:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28),
                            oItem);
            break;

        case 19:
        case 20:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_30),
                            oItem);
            break;

        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);
            break;
        }

        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 4),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem);
        break;

    case GS_SU_GNOME_ROCK: //default
        break;

    case GS_SU_HALFLING_GHOSTWISE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        break;

    case GS_SU_HALFLING_LIGHTFOOT: //default
        break;

    case GS_SU_HALFLING_STRONGHEART:
        //predefined bonus talent
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusFeat(IP_CONST_FEAT_ALERTNESS),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_AASIMAR:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_GENASI_AIR:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_GENASI_EARTH:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_GENASI_FIRE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_GENASI_WATER:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_PLANETOUCHED_TIEFLING:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                     IP_CONST_DAMAGERESIST_5),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_BLUFF, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_SPECIAL_FEY: //subrace of halfling, generic
        //STR -4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 2),
                        oItem);
        //DEX +4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2),
                        oItem);
        //CHA +4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 4),
                        oItem);
        //Hide +4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 4),
                        oItem);
        //Move Silently +4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        //SR 16
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                        oItem);
        //neutralize racial traits
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_LISTEN, 2),
                        oItem);
        break;

    case GS_SU_SPECIAL_GOBLIN: //subrace of halfling
        //STR -2
        //DEX +2
        //CHA -2
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 2),
                        oItem);
        //Move Silently +4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        //Alertness (Listen +2, Spot +2)
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_SPOT, 2),
                        oItem);
        //Darkvision
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        //neutralize racial traits
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        break;

    case GS_SU_SPECIAL_KOBOLD: //subrace of halfling
        //STR -4
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 2),
                        oItem);
        //DEX +2
        //Craft Trap +2
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_CRAFT_TRAP, 2),
                        oItem);
        //Alertness (Listen +2, Spot +2)
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_SPOT, 2),
                        oItem);
        //Darkvision
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        //neutralize racial traits
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        break;

    case GS_SU_SPECIAL_BAATEZU: //subrace of human

        //common baatezu traits
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,
                                                   IP_CONST_DAMAGEIMMUNITY_100_PERCENT),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oItem);

        //soul shell
        if (nLevel <= 3)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_WRAITH);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777538));
        }

        //lemure
        else if (nLevel <= 6)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_GOLEM_FLESH);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777539));
        }

        //barbazu
        else if (nLevel <= 9)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_ASABI_WARRIOR);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777541));
        }

        //erinyes
        else if (nLevel <= 12)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_SUCCUBUS);
            SetCreatureWingType(CREATURE_WING_TYPE_ANGEL, oPossessor);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyTrueSeeing(),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777540));
        }

        //osyluth
        else if (nLevel <= 15)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_GHAST);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777542));
        }

        //hamatula
        else if (nLevel <= 18)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_SLAAD_GREEN);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777543));
        }

        //gelugon
        else if (nLevel <= 21)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_VROCK);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777545));
        }

        //cornugon
        else if (nLevel <= 24)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_ASABI_CHIEFTAIN);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777544));
        }

        //pit fiend
        else if (nLevel <= 27)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_DEVIL);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_15_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777546));
        }

        //hell lord
        else
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_MEPHISTO_NORM);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_15_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777547));
        }
        break;
    }
}
//----------------------------------------------------------------
void gsSUApplyAbility(object oItem, int nSubRace, int nLevel)
{
    gsIPRemoveAllProperties(oItem);

    switch (nSubRace)
    {
    case GS_SU_NONE:
        DestroyObject(oItem);
        break;

    case GS_SU_DWARF_GOLD:
        break;

    case GS_SU_DWARF_GRAY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_DWARF_SHIELD:
        break;

    case GS_SU_ELF_DROW:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_ELF_MOON:
        break;

    case GS_SU_ELF_SUN:
        break;

    case GS_SU_ELF_WILD:
        break;

    case GS_SU_ELF_WOOD:
        break;

    case GS_SU_GNOME_DEEP:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_GNOME_ROCK:
        break;

    case GS_SU_HALFLING_GHOSTWISE:
        break;

    case GS_SU_HALFLING_LIGHTFOOT:
        break;

    case GS_SU_HALFLING_STRONGHEART:
        break;

    case GS_SU_PLANETOUCHED_AASIMAR:
        switch (nLevel)
        {
        case 1:
        case 2:
        case 3:
        case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_1,
                                                  IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                            oItem);
            break;

        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_5,
                                                  IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                            oItem);
            break;
        }
        break;

    case GS_SU_PLANETOUCHED_GENASI_AIR:
        break;

    case GS_SU_PLANETOUCHED_GENASI_EARTH:
        break;

    case GS_SU_PLANETOUCHED_GENASI_FIRE:
        break;

    case GS_SU_PLANETOUCHED_GENASI_WATER:
        break;

    case GS_SU_PLANETOUCHED_TIEFLING:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_SPECIAL_FEY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_2,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_SPECIAL_GOBLIN:
        break;

    case GS_SU_SPECIAL_KOBOLD:
        break;

    case GS_SU_SPECIAL_BAATEZU:


        //...
        break;
    }

    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_10_PERCENT),
                    oItem);
}
//----------------------------------------------------------------
int gsSUGetSubRaceByName(string sSubRace)
{
    if (sSubRace == GS_T_16777263) return GS_SU_DWARF_GOLD;
    if (sSubRace == GS_T_16777264) return GS_SU_DWARF_GRAY;
    if (sSubRace == GS_T_16777265) return GS_SU_DWARF_SHIELD;
    if (sSubRace == GS_T_16777266) return GS_SU_ELF_DROW;
    if (sSubRace == GS_T_16777267) return GS_SU_ELF_MOON;
    if (sSubRace == GS_T_16777268) return GS_SU_ELF_SUN;
    if (sSubRace == GS_T_16777269) return GS_SU_ELF_WILD;
    if (sSubRace == GS_T_16777270) return GS_SU_ELF_WOOD;
    if (sSubRace == GS_T_16777271) return GS_SU_GNOME_DEEP;
    if (sSubRace == GS_T_16777272) return GS_SU_GNOME_ROCK;
    if (sSubRace == GS_T_16777273) return GS_SU_HALFLING_GHOSTWISE;
    if (sSubRace == GS_T_16777274) return GS_SU_HALFLING_LIGHTFOOT;
    if (sSubRace == GS_T_16777275) return GS_SU_HALFLING_STRONGHEART;
    if (sSubRace == GS_T_16777276) return GS_SU_PLANETOUCHED_AASIMAR;
    if (sSubRace == GS_T_16777277) return GS_SU_PLANETOUCHED_GENASI_AIR;
    if (sSubRace == GS_T_16777278) return GS_SU_PLANETOUCHED_GENASI_EARTH;
    if (sSubRace == GS_T_16777279) return GS_SU_PLANETOUCHED_GENASI_FIRE;
    if (sSubRace == GS_T_16777280) return GS_SU_PLANETOUCHED_GENASI_WATER;
    if (sSubRace == GS_T_16777281) return GS_SU_PLANETOUCHED_TIEFLING;
    if (sSubRace == GS_T_16777427) return GS_SU_SPECIAL_FEY;
    if (sSubRace == GS_T_16777428) return GS_SU_SPECIAL_GOBLIN;
    if (sSubRace == GS_T_16777429) return GS_SU_SPECIAL_KOBOLD;
    if (sSubRace == GS_T_16777536) return GS_SU_SPECIAL_BAATEZU;

    return GS_SU_NONE;
}
//----------------------------------------------------------------
string gsSUGetNameBySubRace(int nSubRace)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return GS_T_16777263;
    case GS_SU_DWARF_GRAY:                return GS_T_16777264;
    case GS_SU_DWARF_SHIELD:              return GS_T_16777265;
    case GS_SU_ELF_DROW:                  return GS_T_16777266;
    case GS_SU_ELF_MOON:                  return GS_T_16777267;
    case GS_SU_ELF_SUN:                   return GS_T_16777268;
    case GS_SU_ELF_WILD:                  return GS_T_16777269;
    case GS_SU_ELF_WOOD:                  return GS_T_16777270;
    case GS_SU_GNOME_DEEP:                return GS_T_16777271;
    case GS_SU_GNOME_ROCK:                return GS_T_16777272;
    case GS_SU_HALFLING_GHOSTWISE:        return GS_T_16777273;
    case GS_SU_HALFLING_LIGHTFOOT:        return GS_T_16777274;
    case GS_SU_HALFLING_STRONGHEART:      return GS_T_16777275;
    case GS_SU_PLANETOUCHED_AASIMAR:      return GS_T_16777276;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return GS_T_16777277;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return GS_T_16777278;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return GS_T_16777279;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return GS_T_16777280;
    case GS_SU_PLANETOUCHED_TIEFLING:     return GS_T_16777281;
    case GS_SU_SPECIAL_FEY:               return GS_T_16777427;
    case GS_SU_SPECIAL_GOBLIN:            return GS_T_16777428;
    case GS_SU_SPECIAL_KOBOLD:            return GS_T_16777429;
    case GS_SU_SPECIAL_BAATEZU:           return GS_T_16777536;
    }

    return "";
}
//----------------------------------------------------------------
int gsSUGetECL(int nSubRace, int nLevel)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return nLevel;
    case GS_SU_DWARF_GRAY:                return nLevel + 2;
    case GS_SU_DWARF_SHIELD:              return nLevel;
    case GS_SU_ELF_DROW:                  return nLevel + 2;
    case GS_SU_ELF_MOON:                  return nLevel;
    case GS_SU_ELF_SUN:                   return nLevel;
    case GS_SU_ELF_WILD:                  return nLevel;
    case GS_SU_ELF_WOOD:                  return nLevel;
    case GS_SU_GNOME_DEEP:                return nLevel + 3;
    case GS_SU_GNOME_ROCK:                return nLevel;
    case GS_SU_HALFLING_GHOSTWISE:        return nLevel;
    case GS_SU_HALFLING_LIGHTFOOT:        return nLevel;
    case GS_SU_HALFLING_STRONGHEART:      return nLevel;
    case GS_SU_PLANETOUCHED_AASIMAR:      return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return nLevel + 1;
    case GS_SU_PLANETOUCHED_TIEFLING:     return nLevel + 1;
    case GS_SU_SPECIAL_FEY:               return nLevel + 2;
    case GS_SU_SPECIAL_GOBLIN:            return nLevel;
    case GS_SU_SPECIAL_KOBOLD:            return nLevel;
    case GS_SU_SPECIAL_BAATEZU:           return nLevel + 4;
    }

    return nLevel;
}
//----------------------------------------------------------------
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return CLASS_TYPE_FIGHTER;
    case GS_SU_DWARF_GRAY:                return CLASS_TYPE_FIGHTER;
    case GS_SU_DWARF_SHIELD:              return CLASS_TYPE_FIGHTER;
    case GS_SU_ELF_DROW:
        if (nGender == GENDER_MALE)   return CLASS_TYPE_WIZARD;
        if (nGender == GENDER_FEMALE) return CLASS_TYPE_CLERIC;
        return CLASS_TYPE_INVALID;
    case GS_SU_ELF_MOON:                  return CLASS_TYPE_WIZARD;
    case GS_SU_ELF_SUN:                   return CLASS_TYPE_WIZARD;
    case GS_SU_ELF_WILD:                  return CLASS_TYPE_SORCERER;
    case GS_SU_ELF_WOOD:                  return CLASS_TYPE_RANGER;
    case GS_SU_GNOME_DEEP:                return CLASS_TYPE_WIZARD;
    case GS_SU_GNOME_ROCK:                return CLASS_TYPE_WIZARD;
    case GS_SU_HALFLING_GHOSTWISE:        return CLASS_TYPE_BARBARIAN;
    case GS_SU_HALFLING_LIGHTFOOT:        return CLASS_TYPE_ROGUE;
    case GS_SU_HALFLING_STRONGHEART:      return CLASS_TYPE_ROGUE;
    case GS_SU_PLANETOUCHED_AASIMAR:      return CLASS_TYPE_PALADIN;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_TIEFLING:     return CLASS_TYPE_ROGUE;
    case GS_SU_SPECIAL_FEY:               return CLASS_TYPE_DRUID;
    case GS_SU_SPECIAL_GOBLIN:            return CLASS_TYPE_ROGUE;
    case GS_SU_SPECIAL_KOBOLD:            return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_BAATEZU:           return CLASS_TYPE_FIGHTER;
    }

    return CLASS_TYPE_INVALID;
}
