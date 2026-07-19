/* SUBRACE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_iprop"
#include "gs_inc_text"
#include "gs_inc_pc"
#include "as_inc_ear"

//void main() {}

const string AS_SUBRACE_DATABASE = "AS_SUBRACES";

struct SubraceGifts
{
    int Str;
    int Dex;
    int Con;
    int Int;
    int Wis;
    int Cha;
};

const string GS_SU_TEMPLATE_PROPERTY      = "gs_item317";
const string GS_SU_TEMPLATE_ABILITY       = "gs_item318";

const int IP_CONST_FEAT_WEAPON_SPEC_UNARMED = 1196;
const int IP_CONST_FEAT_TOUGHNESS = 1197;
const int IP_CONST_FEAT_TRACKLESS_STEP = 1198;
const int IP_CONST_FEAT_WOODLAND_STRIDE = 1199;
const int IP_CONST_CASTSPELL_DEATH_ARMOR_6 = 540;
const int IP_CONST_CASTSPELL_MALARI_RAGE = 541;
const int IP_CONST_CASTSPELL_CLOUD_OF_BEWILDERMENT_6 = 542;
const int IP_CONST_CASTSPELL_HEALING_STING_10 = 543;
const int IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE = 544;
const int IP_CONST_CASTSPELL_VEYDRAN_LIGHTNING_BREATH = 545;
const int IP_CONST_CASTSPELL_VEYDRAN_COLD_BREATH = 546;
const int IP_CONST_CASTSPELL_VEYDRAN_FIRE_BREATH = 547;
const int IP_CONST_CASTSPELL_VEYDRAN_RAGE = 548;

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

//Ages Races
//Heartlander
const int GS_SU_HUMAN_PRASIENE = 20;
const int GS_SU_HUMAN_ORI = 21;
const int GS_SU_HUMAN_NAVARREE = 22;
//Imperial
const int GS_SU_HUMAN_ARCHONBLOODED_DAVURI = 23;
const int GS_SU_HUMAN_ARCHONBLOODED_ASHLANDER = 24;
const int GS_SU_HUMAN_CIVITAS_DAVURI = 76;
const int GS_SU_HUMAN_CIVITAS_ASHLANDER = 77;

//Nijaran
const int GS_SU_HUMAN_INEN = 25;
const int GS_SU_HUMAN_ASHARI = 26;
//Bholdic
const int GS_SU_HUMAN_FYRSTUMEN = 27;
const int GS_SU_HUMAN_KALANORF = 28;
//Adhean (half elves)
const int GS_SU_ADHEAN_JUDHEAN = 29;
const int GS_SU_ADHEAN_RUDHEAN = 30;
//Malari (orcs)
const int GS_SU_MALARI_ASHFORGED = 31;
const int GS_SU_MALARI_TUSKKIN = 32;
const int GS_SU_MALARI_VARTOARI = 33;
const int GS_SU_MALARI_UNBOWED = 34;
//Nujiit (khajiit)
const int GS_SU_NUJIIT_PADARR_TWILIGHTBORN = 35;
const int GS_SU_NUJIIT_PADARR_FANGLORD = 36;
const int GS_SU_NUJIIT_PADARR_WHISPERSTALKER = 37;
const int GS_SU_NUJIIT_PADARR_BRIGHTMOON = 78;
const int GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN = 38;
const int GS_SU_NUJIIT_KOMALARI_FANGLORD = 39;
const int GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER = 40;
const int GS_SU_NUJIIT_KOMALARI_BRIGHTMOON = 79;
const int GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN = 41;
const int GS_SU_NUJIIT_RIVERLORD_FANGLORD = 42;
const int GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER = 43;
const int GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON = 80;
const int GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN = 44;
const int GS_SU_NUJIIT_RESPLENDENT_FANGLORD = 45;
const int GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER = 46;
const int GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON = 81;
//Malosari (wood elves)
const int GS_SU_MALOSARI_GREENSWORN = 47;
const int GS_SU_MALOSARI_FREESWORN = 48;
const int GS_SU_MALOSARI_HORNSWORN = 49;
const int GS_SU_MALOSARI_EMERALD = 50;
//Eldari (high elves)
const int GS_SU_ELDARI_EMAELARI = 51;
const int GS_SU_ELDARI_AURARI = 52;
const int GS_SU_ELDARI_ALARI = 53;
//Dunari (dark elves)
const int GS_SU_DUNARI_FALLARI = 54;
const int GS_SU_DUNARI_VRAILSIARI = 55;
const int GS_SU_DUNARI_VULSWORN = 56;
const int GS_SU_DUNARI_LANTERNBEARER = 57;
//Veydran (dragonborn)
const int GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED = 58;
const int GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED = 59;
const int GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT = 60;
const int GS_SU_VEYDRAN_ABYSSALCOURT_TIMESWORN = 61;
const int GS_SU_VEYDRAN_ABYSSALCOURT_AETHERTOUCHED = 62;
const int GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED = 63;
const int GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED = 64;
const int GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT = 65;
const int GS_SU_VEYDRAN_WYRMBLOODED_TIMESWORN = 66;
const int GS_SU_VEYDRAN_WYRMBLOODED_AETHERTOUCHED = 67;
const int GS_SU_VEYDRAN_UNFADING_SKYBLESSED = 68;
const int GS_SU_VEYDRAN_UNFADING_SEAFORGED = 69;
const int GS_SU_VEYDRAN_UNFADING_STONEWROUGHT = 70;
const int GS_SU_VEYDRAN_UNFADING_TIMESWORN = 71;
const int GS_SU_VEYDRAN_UNFADING_AETHERTOUCHED = 72;
//Cipher
const int GS_SU_HUMAN_PRASIENE_CIPHER = 73;
const int GS_SU_HUMAN_ORI_CIPHER = 74;
const int GS_SU_HUMAN_NAVARREE_CIPHER = 75;



//apply properties for nSubrace of nLevel to oItem
void gsSUApplyProperty(object oItem, int nLevel);
//apply abilities for nSubrace of nLevel to oItem
void gsSUApplyAbility(object oItem, int nLevel);
//return subrace constant resembling sSubRace
int gsSUGetSubRaceByName(string sSubRace);
//return name of nSubRace
string gsSUGetNameBySubRace(int nSubRace);
//return effective character level for nSubRace of nLevel
int gsSUGetECL(int nSubRace, int nLevel);
//return favored class of nSubRace and nGender
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE);
//apply a gift local variable to a subrace item
void gsSUAddGift(object oItem, int nAbility, int nIncrease);
//remove a gift local variable to a subrace item
void gsSURemoveGift(object oItem, int nAbility, int nIncrease);
//record subrace and gifts to database
void gsSUSetSubRace(object oPlayer, int nSubrace, int nStrGift, int nDexGift, int nConGift, int nIntGift, int nWisGift, int nChaGift);
//return subrace integer
int gsSUGetSubRace(object oPlayer);
//return struct containing gift information
struct SubraceGifts gsSUGetGifts(object oPlayer);
//Apply subrace parts to player
void gsSUApplySubRaceParts(object oPlayer);
//return TRUE if player's race has digitigrade legs
int gsSUGetHasDigitigradeLegs(int nSubRace);
//return TRUE if player's race has a cat tail
int gsSUGetHasCatTail(int nSubRace);
//return TRUE if player's race has cat ears
int gsSUGetHasCatEars(int nSubRace);
//return TRUE if player's race has a tiger face
int gsSUGetHasTigerFace(int nSubRace);
//return TRUE if player's race has a 4-legged cat model.
int gsSUGetHasCatModel(int nSubRace);
//return TRUE if player's race is a skyblessed veydran
int gsSUGetSkyBlessed(int nSubRace);
//return TRUE if player's race is a stonewrought veydran
int gsSUGetStoneWrought(int nSubRace);
//return TRUE if player's race is a seaforged veydran
int gsSUGetSeaForged(int nSubRace);





void gsSUSetSubRace(object oPlayer, int nSubRace, int nStrGift, int nDexGift, int nConGift, int nIntGift, int nWisGift, int nChaGift)
{
    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(AS_SUBRACE_DATABASE, "CREATE TABLE IF NOT EXISTS subraces (id TEXT PRIMARY KEY, subrace INTEGER, str_gift INTEGER, dex_gift INTEGER, con_gift INTEGER, int_gift INTEGER, wis_gift INTEGER, cha_gift INTEGER);");
    SqlStep(sqlCreateTable);

    sqlquery sqlInitializeSubrace = SqlPrepareQueryCampaign(AS_SUBRACE_DATABASE, "INSERT INTO subraces (id, subrace, str_gift, dex_gift, con_gift, int_gift, wis_gift, cha_gift) VALUES (@id, @subrace, @str_gift, @dex_gift, @con_gift, @int_gift, @wis_gift, @cha_gift);");
    SqlBindString(sqlInitializeSubrace, "@id", gsPCGetPlayerID(oPlayer));
    SqlBindInt(sqlInitializeSubrace, "@subrace", nSubRace);
    SqlBindInt(sqlInitializeSubrace, "@str_gift", nStrGift);
    SqlBindInt(sqlInitializeSubrace, "@dex_gift", nDexGift);
    SqlBindInt(sqlInitializeSubrace, "@con_gift", nConGift);
    SqlBindInt(sqlInitializeSubrace, "@int_gift", nIntGift);
    SqlBindInt(sqlInitializeSubrace, "@wis_gift", nWisGift);
    SqlBindInt(sqlInitializeSubrace, "@cha_gift", nChaGift);
    SqlStep(sqlInitializeSubrace);
}

int gsSUGetSubRace(object oPlayer)
{
    int nSubRace = GS_SU_NONE;
    sqlquery sqlGetSubrace = SqlPrepareQueryCampaign(AS_SUBRACE_DATABASE, "SELECT subrace from subraces WHERE id = @id");
    SqlBindString(sqlGetSubrace, "@id", gsPCGetPlayerID(oPlayer));
    if(SqlStep(sqlGetSubrace))
    {
        nSubRace = SqlGetInt(sqlGetSubrace, 0);
    }
    return nSubRace;
}

struct SubraceGifts gsSUGetGifts(object oPlayer)
{
    struct SubraceGifts gGifts;
    gGifts.Str = 0;
    gGifts.Dex = 0;
    gGifts.Con = 0;
    gGifts.Int = 0;
    gGifts.Wis = 0;
    gGifts.Cha = 0;
    sqlquery sqlGetGifts = SqlPrepareQueryCampaign(AS_SUBRACE_DATABASE, "SELECT str_gift, dex_gift, con_gift, int_gift, wis_gift, cha_gift from subraces WHERE id = @id");
    SqlBindString(sqlGetGifts, "@id", gsPCGetPlayerID(oPlayer));
    if(SqlStep(sqlGetGifts))
    {
        gGifts.Str = SqlGetInt(sqlGetGifts, 0);
        gGifts.Dex = SqlGetInt(sqlGetGifts, 1);
        gGifts.Con = SqlGetInt(sqlGetGifts, 2);
        gGifts.Int = SqlGetInt(sqlGetGifts, 3);
        gGifts.Wis = SqlGetInt(sqlGetGifts, 4);
        gGifts.Cha = SqlGetInt(sqlGetGifts, 5);
    }
    return gGifts;
}



void gsSUAddGift(object oItem, int nAbility, int nIncrease)
{
    switch(nAbility)
    {
        case IP_CONST_ABILITY_CHA:
            SetLocalInt(oItem, "GS_SU_CHARISMA", GetLocalInt(oItem, "GS_SU_CHARISMA") + nIncrease);
        break;
        case IP_CONST_ABILITY_CON:
            SetLocalInt(oItem, "GS_SU_CONSTITUTION", GetLocalInt(oItem, "GS_SU_CONSTITUTION") + nIncrease);
        break;
        case IP_CONST_ABILITY_DEX:
            SetLocalInt(oItem, "GS_SU_DEXTERITY", GetLocalInt(oItem, "GS_SU_DEXTERITY") + nIncrease);
        break;
        case IP_CONST_ABILITY_INT:
            SetLocalInt(oItem, "GS_SU_INTELLIGENCE", GetLocalInt(oItem, "GS_SU_INTELLIGENCE") + nIncrease);
        break;
        case IP_CONST_ABILITY_STR:
            SetLocalInt(oItem, "GS_SU_STRENGTH", GetLocalInt(oItem, "GS_SU_STRENGTH") + nIncrease);
        break;
        case IP_CONST_ABILITY_WIS:
            SetLocalInt(oItem, "GS_SU_WISDOM", GetLocalInt(oItem, "GS_SU_WISDOM") + nIncrease);
        break;
        default:
        break;
    }
}

void gsSURemoveGifts(object oItem, int nAbility)
{
    switch(nAbility)
    {
        case IP_CONST_ABILITY_CHA:
            DeleteLocalInt(oItem, "GS_SU_CHARISMA");
        break;
        case IP_CONST_ABILITY_CON:
            DeleteLocalInt(oItem, "GS_SU_CONSTITUTION");
        break;
        case IP_CONST_ABILITY_DEX:
            DeleteLocalInt(oItem, "GS_SU_DEXTERITY");
        break;
        case IP_CONST_ABILITY_INT:
            DeleteLocalInt(oItem, "GS_SU_INTELLIGENCE");
        break;
        case IP_CONST_ABILITY_STR:
            DeleteLocalInt(oItem, "GS_SU_STRENGTH");
        break;
        case IP_CONST_ABILITY_WIS:
            DeleteLocalInt(oItem, "GS_SU_WISDOM");
        break;
        default:
        break;
    }
}

void gsSUApplyProperty(object oItem, int nLevel)
{
    object oPossessor = GetItemPossessor(oItem);
    int nSubRace = gsSUGetSubRace(oPossessor);
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
        //Ages Races
        case GS_SU_HUMAN_PRASIENE:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_SHIELD_PROFICIENCY),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ALL_SKILLS, 1),
                        oItem);
        break;

        case GS_SU_HUMAN_ORI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERFORM, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                        oItem);
        break;

        case GS_SU_HUMAN_NAVARREE:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LORE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_DISCIPLINE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_INTIMIDATE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_BLUFF, 4),
                        oItem);
        break;

        case GS_SU_HUMAN_ARCHONBLOODED_ASHLANDER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_OPEN_LOCK, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SEARCH, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_APPRAISE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                        oItem);
            
        break;
        case GS_SU_HUMAN_ARCHONBLOODED_DAVURI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SEARCH, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HEAL, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                        oItem);
            
        break;
        case GS_SU_HUMAN_CIVITAS_ASHLANDER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERFORM, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_OPEN_LOCK, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SEARCH, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_APPRAISE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                        oItem);
        break;
        case GS_SU_HUMAN_CIVITAS_DAVURI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERFORM, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SEARCH, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HEAL, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                        oItem);
        break;

        case GS_SU_HUMAN_INEN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_BLUFF, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PICK_POCKET, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        break;

        case GS_SU_HUMAN_ASHARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERFORM, 4),
                        oItem);
        break;

        case GS_SU_HUMAN_FYRSTUMEN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TOUGHNESS),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE),
                         oItem);
        break;
        case GS_SU_HUMAN_KALANORF:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TOUGHNESS),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 4),
                        oItem);
        break;

        case GS_SU_ADHEAN_JUDHEAN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HEAL, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 4),
                        oItem);
        switch (nLevel)
        {
        case  1:
        case  2:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10),
                            oItem);
            break;
        case  3:
        case  4:
        case  5:
        case  6:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12),
                            oItem);
            break;
        case  7:
        case  8:
        case  9:
        case 10:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                            oItem);
            break;

        case 11:
        case 12:
        case 13:
        case 14:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);
            break;
        case 15:
        case 16:
        case 17:
        case 18:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                            oItem);
            break;
        case 19:
        case 20:
        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            break;
        }
            
        break;

        case GS_SU_ADHEAN_RUDHEAN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HEAL, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY , 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                        oItem); 
        switch (nLevel)
        {
        case  1:
        case  2:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10),
                            oItem);
            break;
        case  3:
        case  4:
        case  5:
        case  6:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12),
                            oItem);
            break;
        case  7:
        case  8:
        case  9:
        case 10:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                            oItem);
            break;

        case 11:
        case 12:
        case 13:
        case 14:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);
            break;
        case 15:
        case 16:
        case 17:
        case 18:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                            oItem);
            break;
        case 19:
        case 20:
        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            break;
        }


        break;

        case GS_SU_MALARI_ASHFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 2),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem); 
        break;

        case GS_SU_MALARI_TUSKKIN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE),
                         oItem);
        break;

        case GS_SU_MALARI_UNBOWED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE),
                         oItem);
        break;

        case GS_SU_MALARI_VARTOARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem); 
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem); 
        break;
        

        case GS_SU_MALOSARI_EMERALD:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TRACKLESS_STEP),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WOODLAND_STRIDE),
                         oItem);
        break;

        case GS_SU_MALOSARI_FREESWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TRACKLESS_STEP),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                            oItem);
        break;

        case GS_SU_MALOSARI_GREENSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TRACKLESS_STEP),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HEAL, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
        break;

        case GS_SU_MALOSARI_HORNSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 2),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_TRACKLESS_STEP),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HIDE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                            oItem);
        break;

        case GS_SU_ELDARI_ALARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_COLD, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ACID, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 1),
                            oItem);
            switch (nLevel)
            {
                case 1:
                case 2:
                break;
                default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                    ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 2),
                                oItem);
                break;
            }

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_DIVINE,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 1),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 1),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 1),
                            oItem);


        break;

        case GS_SU_ELDARI_AURARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_COLD, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 4),
                         oItem);
            /*AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 4),
                         oItem);*/
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ACID, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 1),
                            oItem);
            switch (nLevel)
            {
                case 1:
                case 2:
                break;
                default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                    ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 2),
                                oItem);
                break;
            }

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);


            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERFORM, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_APPRAISE, 2),
                            oItem);     
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 2),
                            oItem);
        break;

        case GS_SU_ELDARI_EMAELARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_COLD, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_ACID, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 1),
                            oItem);
            switch (nLevel)
            {
                case 1:
                case 2:
                break;
                default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                    ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 2),
                                oItem);
                break;
            }

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 0),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 1),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 2),
                            oItem);
        break;

        case GS_SU_DUNARI_FALLARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SEARCH, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);
        break;

        case GS_SU_DUNARI_LANTERNBEARER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);
        break;

        //no info as of yet
        case GS_SU_DUNARI_VRAILSIARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyDarkvision(),
                            oItem);
        break;

        case GS_SU_DUNARI_VULSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_USE_POISON),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                         IP_CONST_DAMAGERESIST_10),
                         oItem);

        switch (nLevel)
        {
        case  1:
        case  2:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                            oItem);
            break;
        case  3:
        case  4:
        case  5:
        case  6:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);
            break;
        case  7:
        case  8:
        case  9:
        case 10:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                            oItem);
            break;

        case 11:
        case 12:
        case 13:
        case 14:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            break;
        case 15:
        case 16:
        case 17:
        case 18:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                            oItem);
            break;
        case 19:
        case 20:
        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                            oItem);
            break;
        }
        break;

        case GS_SU_NUJIIT_PADARR_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
        break;

        case GS_SU_NUJIIT_PADARR_FANGLORD:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_NUJIIT_PADARR_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HIDE, 8),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 8),
                            oItem);
        break;

        case GS_SU_NUJIIT_PADARR_BRIGHTMOON:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
        
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ALL_SKILLS, 1),
                        oItem);
        break;

        case GS_SU_NUJIIT_KOMALARI_FANGLORD:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
        break;

        case GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HIDE, 8),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 8),
                            oItem);
        break;

        case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ALL_SKILLS, 1),
                        oItem);
        break;

        case GS_SU_NUJIIT_RIVERLORD_FANGLORD:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
        break;

        case GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HIDE, 8),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 8),
                            oItem);
        break;

        case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SET_TRAP, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ALL_SKILLS, 1),
                        oItem);
        break;

        case GS_SU_NUJIIT_RESPLENDENT_FANGLORD:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SEARCH, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERFORM, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SEARCH, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERFORM, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_BLUFF, 2),
                            oItem);
        break;

        case GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SEARCH, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERFORM, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_HIDE, 8),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 8),
                            oItem);
        break;

        case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, 1),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SEARCH, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERFORM, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_PERSUADE, 4),
                            oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDarkvision(),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_ALL_SKILLS, 1),
                        oItem);
        break;

        case GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);
        break;
        
        case GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);

        break;

        case GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 4),
                            oItem);
        break;

        case GS_SU_VEYDRAN_UNFADING_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 2),
                            oItem);
        break;

        case GS_SU_VEYDRAN_UNFADING_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 2),
                            oItem);
        break;

        case GS_SU_VEYDRAN_UNFADING_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 4),
                        oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_CONCENTRATION, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LORE, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_SPOT, 2),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_LISTEN, 2),
                            oItem);
        break;

        case GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

        case GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPEC_UNARMED),
                         oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_DISCIPLINE, 4),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                     IP_CONST_DAMAGERESIST_15),
                        oItem);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertySkillBonus(SKILL_INTIMIDATE, 4),
                            oItem);
        break;

    }
    //Gift system

    struct SubraceGifts gGifts = gsSUGetGifts(oPossessor);

    int nCharismaGift = gGifts.Cha;
    int nConstitutionGift = gGifts.Con;
    int nIntelligenceGift = gGifts.Int;
    int nDexterityGift = gGifts.Dex;
    int nStrengthGift = gGifts.Str;
    int nWisdomGift = gGifts.Wis;

    if(nCharismaGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, nCharismaGift),
                         oItem);
    }
    if(nConstitutionGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, nConstitutionGift),
                         oItem);
    }
    if(nIntelligenceGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, nIntelligenceGift),
                         oItem);
    }
    if(nDexterityGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, nDexterityGift),
                         oItem);
    }
    if(nStrengthGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, nStrengthGift),
                         oItem);
    }
    if(nWisdomGift > 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, nWisdomGift),
                         oItem);
    }
    //negative
    if(nCharismaGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, abs(nCharismaGift)),
                         oItem);
    }
    if(nConstitutionGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON, abs(nConstitutionGift)),
                         oItem);
    }
    if(nIntelligenceGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, abs(nIntelligenceGift)),
                         oItem);
    }
    if(nDexterityGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX, abs(nDexterityGift)),
                         oItem);
    }
    if(nStrengthGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR, abs(nStrengthGift)),
                         oItem);
    }
    if(nWisdomGift < 0) {
        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, abs(nWisdomGift)),
                         oItem);
    }
    
}


//----------------------------------------------------------------
void gsSUApplyAbility(object oItem, int nLevel)
{
    gsIPRemoveAllProperties(oItem);

    object oPossessor = GetItemPossessor(oItem);
    int nSubRace = gsSUGetSubRace(oPossessor);

    switch (nSubRace)
    {
    case GS_SU_NONE:
        //We won't destroy it if there's no subrace.
        //DestroyObject(oItem);
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
        break;

    //Ages Races

    case GS_SU_HUMAN_PRASIENE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
            ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESISTANCE_5,
                                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
            oItem);

    break;

    case GS_SU_HUMAN_NAVARREE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
            ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1,
                                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
            oItem);
        switch (nLevel){
            case 1:
            case 2:
                break;
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_10,
                                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                                    oItem);
                break;
        }
    break;


    case GS_SU_HUMAN_ORI:
        AddItemProperty(DURATION_TYPE_PERMANENT,
            ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_5,
                                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
            oItem);
        switch (nLevel){
            case 1:
            case 2:
                break;
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_SEARING_LIGHT_5,
                                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                                    oItem);
                break;
        }
    break;

    case GS_SU_HUMAN_INEN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DAZE_1,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        oItem);
        switch (nLevel){
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_5,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_10,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
        }
    break;

    case GS_SU_HUMAN_ASHARI:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLARE_1,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        oItem);
        switch (nLevel){
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_5,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_10,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
        }
    break;

    case GS_SU_HUMAN_FYRSTUMEN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_HUMAN_KALANORF:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESISTANCE_5,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        oItem);
        switch (nLevel){
            case 1:
            case 2:
            break;
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
        }
    break;

    case GS_SU_ADHEAN_JUDHEAN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_ADHEAN_RUDHEAN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DEATH_ARMOR_6,
                                              IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                        oItem);
    break;

    case GS_SU_MALARI_TUSKKIN:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_MALARI_RAGE,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5,
                                              IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                        oItem);

    break;

    case GS_SU_MALARI_UNBOWED:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_MALARI_RAGE,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_MALARI_VARTOARI:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAY_OF_FROST_1,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        oItem);
        switch (nLevel){
            case 1:
            case 2:
            break;
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            default:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
            break;
        }
    break;

    case GS_SU_MALOSARI_EMERALD:
    break;

    case GS_SU_MALOSARI_FREESWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_10,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
    break;

    case GS_SU_MALOSARI_GREENSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_DAZE_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            switch (nLevel){
                case 1:
                case 2:
                break;
                default:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(IP_CONST_CASTSPELL_SLEEP_5,
                                                IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                            oItem);
                break;
            }
    break;

    case GS_SU_MALOSARI_HORNSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
    break;

    case GS_SU_ELDARI_ALARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESISTANCE_5,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHIELD_5,
                                        IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGE_ARMOR_2,
                                        IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                    oItem);
            switch (nLevel){
                case 1:
                case 2:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                break;
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                default:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_9,
                                            IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),
                        oItem);
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                break;
            }
    break;

    case GS_SU_ELDARI_AURARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESISTANCE_5,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGE_ARMOR_2,
                                        IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                    oItem);
            switch (nLevel){
                case 1:
                case 2:
                break;
                default:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLOUD_OF_BEWILDERMENT_6,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                break;
            }
    break;

    case GS_SU_ELDARI_EMAELARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESISTANCE_5,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGE_ARMOR_2,
                                        IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            switch (nLevel){
                case 1:
                case 2:
                break;
                default:
                    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                            IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
                break;
            }
    break;

    case GS_SU_DUNARI_FALLARI:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_IDENTIFY_3,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_VIRTUE_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
    break;

    case GS_SU_DUNARI_LANTERNBEARER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_FEAR_2,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_DUNARI_VRAILSIARI:
    break;

    case GS_SU_DUNARI_VULSWORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_POISON_5,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_HEALING_STING_10,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_PADARR_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_PADARR_FANGLORD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_NUJIIT_PADARR_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_PADARR_BRIGHTMOON:
    break;

    case GS_SU_NUJIIT_KOMALARI_FANGLORD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON:
    break;

    case GS_SU_NUJIIT_RIVERLORD_FANGLORD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_RESPLENDENT_FANGLORD:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON:
    break;

    case GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_COLD_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_BLESS_2,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_IDENTIFY_3,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;
        
    case GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_LIGHTNING_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_BLESS_2,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_IDENTIFY_3,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_FIRE_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_BLESS_2,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_IDENTIFY_3,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_VEYDRAN_UNFADING_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_COLD_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_VEYDRAN_UNFADING_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_LIGHTNING_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_VEYDRAN_UNFADING_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_FIRE_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHELGARNS_PERSISTENT_BLADE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
    break;

    case GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_COLD_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_RAGE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_LIGHTNING_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_RAGE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
    break;

    case GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_FIRE_BREATH,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_VEYDRAN_RAGE,
                                        IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                    oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
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

//Ages Races
//Heartlander
    if (sSubRace == GS_T_16777554) return GS_SU_HUMAN_PRASIENE;
    if (sSubRace == GS_T_16777555) return GS_SU_HUMAN_ORI;
    if (sSubRace == GS_T_16777556) return GS_SU_HUMAN_NAVARREE;
//Imperial
    if (sSubRace == GS_T_16777639) return GS_SU_HUMAN_ARCHONBLOODED_DAVURI;
    if (sSubRace == GS_T_16777641) return GS_SU_HUMAN_ARCHONBLOODED_ASHLANDER;
    if (sSubRace == GS_T_16777640) return GS_SU_HUMAN_CIVITAS_ASHLANDER;
    if (sSubRace == GS_T_16777638) return GS_SU_HUMAN_CIVITAS_DAVURI;
//Nijaran
    if (sSubRace == GS_T_16777561) return GS_SU_HUMAN_INEN ;
    if (sSubRace == GS_T_16777562) return GS_SU_HUMAN_ASHARI;
//Bholdic
    if (sSubRace == GS_T_16777564) return GS_SU_HUMAN_FYRSTUMEN;
    if (sSubRace == GS_T_16777565) return GS_SU_HUMAN_KALANORF;
//Adhean (half elves)
    if (sSubRace == GS_T_16777567) return GS_SU_ADHEAN_JUDHEAN;
    if (sSubRace == GS_T_16777568) return GS_SU_ADHEAN_RUDHEAN;
//Malari (orcs)
    if (sSubRace == GS_T_16777570) return GS_SU_MALARI_ASHFORGED;
    if (sSubRace == GS_T_16777571) return GS_SU_MALARI_TUSKKIN;
    if (sSubRace == GS_T_16777572) return GS_SU_MALARI_VARTOARI;
    if (sSubRace == GS_T_16777573) return GS_SU_MALARI_UNBOWED;
//Nujiit (khajiit)
    if (sSubRace == GS_T_16777609) return GS_SU_NUJIIT_PADARR_TWILIGHTBORN;
    if (sSubRace == GS_T_16777601) return GS_SU_NUJIIT_PADARR_FANGLORD;
    if (sSubRace == GS_T_16777605) return GS_SU_NUJIIT_PADARR_WHISPERSTALKER;
    if (sSubRace == GS_T_16777643) return GS_SU_NUJIIT_PADARR_BRIGHTMOON;
    if (sSubRace == GS_T_16777610) return GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN;
    if (sSubRace == GS_T_16777602) return GS_SU_NUJIIT_KOMALARI_FANGLORD;
    if (sSubRace == GS_T_16777606) return GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER;
    if (sSubRace == GS_T_16777644) return GS_SU_NUJIIT_KOMALARI_BRIGHTMOON;
    if (sSubRace == GS_T_16777611) return GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN;
    if (sSubRace == GS_T_16777603) return GS_SU_NUJIIT_RIVERLORD_FANGLORD;
    if (sSubRace == GS_T_16777607) return GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER;
    if (sSubRace == GS_T_16777645) return GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON;
    if (sSubRace == GS_T_16777612) return GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN;
    if (sSubRace == GS_T_16777604) return GS_SU_NUJIIT_RESPLENDENT_FANGLORD;
    if (sSubRace == GS_T_16777608) return GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER;
    if (sSubRace == GS_T_16777646) return GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON;
//Malosari (wood elves)
    if (sSubRace == GS_T_16777580) return GS_SU_MALOSARI_GREENSWORN;
    if (sSubRace == GS_T_16777581) return GS_SU_MALOSARI_FREESWORN;
    if (sSubRace == GS_T_16777582) return GS_SU_MALOSARI_HORNSWORN;
    if (sSubRace == GS_T_16777583) return GS_SU_MALOSARI_EMERALD;
//Eldari (high elves)
    if (sSubRace == GS_T_16777585) return GS_SU_ELDARI_EMAELARI;
    if (sSubRace == GS_T_16777586) return GS_SU_ELDARI_AURARI;
    if (sSubRace == GS_T_16777587) return GS_SU_ELDARI_ALARI;
//Dunari (dark elves)
    if (sSubRace == GS_T_16777589) return GS_SU_DUNARI_FALLARI;
    if (sSubRace == GS_T_16777590) return GS_SU_DUNARI_VRAILSIARI;
    if (sSubRace == GS_T_16777591) return GS_SU_DUNARI_VULSWORN;
    if (sSubRace == GS_T_16777592) return GS_SU_DUNARI_LANTERNBEARER;
//Veydran (dragonborn)
    if (sSubRace == GS_T_16777618) return GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED;
    if (sSubRace == GS_T_16777619) return GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED;
    if (sSubRace == GS_T_16777620) return GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT;
    if (sSubRace == GS_T_16777621) return GS_SU_VEYDRAN_ABYSSALCOURT_TIMESWORN;
    if (sSubRace == GS_T_16777622) return GS_SU_VEYDRAN_ABYSSALCOURT_AETHERTOUCHED;
    if (sSubRace == GS_T_16777623) return GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED;
    if (sSubRace == GS_T_16777624) return GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED;
    if (sSubRace == GS_T_16777625) return GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT;
    if (sSubRace == GS_T_16777626) return GS_SU_VEYDRAN_WYRMBLOODED_TIMESWORN;
    if (sSubRace == GS_T_16777627) return GS_SU_VEYDRAN_WYRMBLOODED_AETHERTOUCHED;
    if (sSubRace == GS_T_16777628) return GS_SU_VEYDRAN_UNFADING_SKYBLESSED;
    if (sSubRace == GS_T_16777629) return GS_SU_VEYDRAN_UNFADING_SEAFORGED;
    if (sSubRace == GS_T_16777630) return GS_SU_VEYDRAN_UNFADING_STONEWROUGHT;
    if (sSubRace == GS_T_16777631) return GS_SU_VEYDRAN_UNFADING_TIMESWORN;
    if (sSubRace == GS_T_16777632) return GS_SU_VEYDRAN_UNFADING_AETHERTOUCHED;
//Cipher
    if (sSubRace == GS_T_16777633) return GS_SU_HUMAN_PRASIENE_CIPHER;
    if (sSubRace == GS_T_16777634) return GS_SU_HUMAN_ORI_CIPHER;
    if (sSubRace == GS_T_16777635) return GS_SU_HUMAN_NAVARREE_CIPHER;


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
//Ages Races
//Heartlander
    case GS_SU_HUMAN_PRASIENE: return GS_T_16777554;
    case GS_SU_HUMAN_ORI: return GS_T_16777555;
    case GS_SU_HUMAN_NAVARREE: return GS_T_16777556;
//Imperial
    case GS_SU_HUMAN_ARCHONBLOODED_DAVURI: return GS_T_16777639;
    case GS_SU_HUMAN_ARCHONBLOODED_ASHLANDER: return GS_T_16777641;
    case GS_SU_HUMAN_CIVITAS_ASHLANDER: return GS_T_16777640;
    case GS_SU_HUMAN_CIVITAS_DAVURI: return GS_T_16777638;
//Nijaran
    case GS_SU_HUMAN_INEN: return GS_T_16777561;
    case GS_SU_HUMAN_ASHARI: return GS_T_16777562;
//Bholdic
    case GS_SU_HUMAN_FYRSTUMEN: return GS_T_16777564;
    case GS_SU_HUMAN_KALANORF: return GS_T_16777565;
//Adhean (half elves)
    case GS_SU_ADHEAN_JUDHEAN: return GS_T_16777567;
    case GS_SU_ADHEAN_RUDHEAN: return GS_T_16777568;
//Malari (orcs)
    case GS_SU_MALARI_ASHFORGED: return GS_T_16777570;
    case GS_SU_MALARI_TUSKKIN: return GS_T_16777571;
    case GS_SU_MALARI_VARTOARI: return GS_T_16777572;
    case GS_SU_MALARI_UNBOWED: return GS_T_16777573;
//Nujiit (khajiit)
    case GS_SU_NUJIIT_PADARR_TWILIGHTBORN: return GS_T_16777609;
    case GS_SU_NUJIIT_PADARR_FANGLORD: return GS_T_16777601;
    case GS_SU_NUJIIT_PADARR_WHISPERSTALKER: return GS_T_16777605;
    case GS_SU_NUJIIT_PADARR_BRIGHTMOON: return GS_T_16777643;
    case GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN: return GS_T_16777610;
    case GS_SU_NUJIIT_KOMALARI_FANGLORD: return GS_T_16777602;
    case GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER: return GS_T_16777606;
    case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON: return GS_T_16777644;
    case GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN: return GS_T_16777611;
    case GS_SU_NUJIIT_RIVERLORD_FANGLORD: return GS_T_16777603;
    case GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER: return GS_T_16777607;
    case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON: return GS_T_16777645;
    case GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN: return GS_T_16777612;
    case GS_SU_NUJIIT_RESPLENDENT_FANGLORD: return GS_T_16777604;
    case GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER: return GS_T_16777608;
    case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON: return GS_T_16777646;
//Malosari (wood elves)
    case GS_SU_MALOSARI_GREENSWORN: return GS_T_16777580;
    case GS_SU_MALOSARI_FREESWORN: return GS_T_16777581;
    case GS_SU_MALOSARI_HORNSWORN: return GS_T_16777582;
    case GS_SU_MALOSARI_EMERALD: return GS_T_16777583;
//Eldari (high elves)
    case GS_SU_ELDARI_EMAELARI: return GS_T_16777585;
    case GS_SU_ELDARI_AURARI: return GS_T_16777586;
    case GS_SU_ELDARI_ALARI: return GS_T_16777587;
//Dunari (dark elves)
    case GS_SU_DUNARI_FALLARI: return GS_T_16777589;
    case GS_SU_DUNARI_VRAILSIARI: return GS_T_16777590;
    case GS_SU_DUNARI_VULSWORN: return GS_T_16777591;
    case GS_SU_DUNARI_LANTERNBEARER: return GS_T_16777592;
//Veydran (dragonborn)
    case GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED: return GS_T_16777618;
    case GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED: return GS_T_16777619;
    case GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT: return GS_T_16777620;
    case GS_SU_VEYDRAN_ABYSSALCOURT_TIMESWORN: return GS_T_16777621;
    case GS_SU_VEYDRAN_ABYSSALCOURT_AETHERTOUCHED: return GS_T_16777622;
    case GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED: return GS_T_16777623;
    case GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED: return GS_T_16777624;
    case GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT: return GS_T_16777625;
    case GS_SU_VEYDRAN_WYRMBLOODED_TIMESWORN: return GS_T_16777626;
    case GS_SU_VEYDRAN_WYRMBLOODED_AETHERTOUCHED: return GS_T_16777627;
    case GS_SU_VEYDRAN_UNFADING_SKYBLESSED: return GS_T_16777628;
    case GS_SU_VEYDRAN_UNFADING_SEAFORGED: return GS_T_16777629;
    case GS_SU_VEYDRAN_UNFADING_STONEWROUGHT: return GS_T_16777630;
    case GS_SU_VEYDRAN_UNFADING_TIMESWORN: return GS_T_16777631;
    case GS_SU_VEYDRAN_UNFADING_AETHERTOUCHED: return GS_T_16777632;
//Cipher
    case GS_SU_HUMAN_PRASIENE_CIPHER: return GS_T_16777633;
    case GS_SU_HUMAN_ORI_CIPHER: return GS_T_16777634;
    case GS_SU_HUMAN_NAVARREE_CIPHER: return GS_T_16777635;

    }

    return "";
}
//----------------------------------------------------------------
int gsSUGetECL(int nSubRace, int nLevel)
{
    //not implementing ECL for subraces
    return nLevel;
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
//not used anywhere. would need updating with new races if we decided to use favored classes
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

void gsSUApplySubRaceParts(object oPlayer)
{
    int nSubRace = gsSUGetSubRace(oPlayer);
    if(gsSUGetHasDigitigradeLegs(nSubRace))
    {
        SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 137, oPlayer);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 137, oPlayer);
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 136, oPlayer);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 136, oPlayer);
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPlayer);
        if(GetIsObjectValid(oArmor)){
            AssignCommand(oPlayer, ActionUnequipItem(oArmor));
            AssignCommand(oPlayer, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
        }
    }

    if(gsSUGetHasCatTail(nSubRace))
    {
        SetCreatureTailType(10013, oPlayer);
    }

    if(gsSUGetHasCatEars(nSubRace))
    {
        asEACreateEars(oPlayer);
    }

    if(gsSUGetHasTigerFace(nSubRace))
    {
        SetCreatureBodyPart(CREATURE_PART_HEAD, 194, oPlayer);
    }

    if(gsSUGetHasCatModel(nSubRace))
    {
        SetCreatureAppearanceType(oPlayer, 15117);
        SetObjectVisualTransform(oPlayer, OBJECT_VISUAL_TRANSFORM_SCALE,
                               1.25f + (Random(101) * 0.001f));
        
    }
}

int gsSUGetHasDigitigradeLegs(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_NUJIIT_PADARR_FANGLORD:
        case GS_SU_NUJIIT_PADARR_BRIGHTMOON:
        case GS_SU_NUJIIT_KOMALARI_FANGLORD:
        case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON:
        case GS_SU_NUJIIT_RIVERLORD_FANGLORD:
        case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON:
        case GS_SU_NUJIIT_RESPLENDENT_FANGLORD:
        case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetHasCatTail(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_NUJIIT_PADARR_TWILIGHTBORN:
        case GS_SU_NUJIIT_PADARR_FANGLORD:
        case GS_SU_NUJIIT_PADARR_BRIGHTMOON:
        case GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN:
        case GS_SU_NUJIIT_KOMALARI_FANGLORD:
        case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON:
        case GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN:
        case GS_SU_NUJIIT_RIVERLORD_FANGLORD:
        case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON:
        case GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN:
        case GS_SU_NUJIIT_RESPLENDENT_FANGLORD:
        case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetHasCatEars(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_NUJIIT_PADARR_TWILIGHTBORN:
        case GS_SU_NUJIIT_PADARR_BRIGHTMOON:
        case GS_SU_NUJIIT_KOMALARI_TWILIGHTBORN:
        case GS_SU_NUJIIT_KOMALARI_BRIGHTMOON:
        case GS_SU_NUJIIT_RIVERLORD_TWILIGHTBORN:
        case GS_SU_NUJIIT_RIVERLORD_BRIGHTMOON:
        case GS_SU_NUJIIT_RESPLENDENT_TWILIGHTBORN:
        case GS_SU_NUJIIT_RESPLENDENT_BRIGHTMOON:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetHasTigerFace(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_NUJIIT_PADARR_FANGLORD:
        case GS_SU_NUJIIT_KOMALARI_FANGLORD:
        case GS_SU_NUJIIT_RIVERLORD_FANGLORD:
        case GS_SU_NUJIIT_RESPLENDENT_FANGLORD:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetHasCatModel(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_NUJIIT_PADARR_WHISPERSTALKER:
        case GS_SU_NUJIIT_KOMALARI_WHISPERSTALKER:
        case GS_SU_NUJIIT_RIVERLORD_WHISPERSTALKER:
        case GS_SU_NUJIIT_RESPLENDENT_WHISPERSTALKER:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetSkyBlessed(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_VEYDRAN_ABYSSALCOURT_SKYBLESSED:
        case GS_SU_VEYDRAN_WYRMBLOODED_SKYBLESSED:
        case GS_SU_VEYDRAN_UNFADING_SKYBLESSED:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetSeaForged(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_VEYDRAN_ABYSSALCOURT_SEAFORGED:
        case GS_SU_VEYDRAN_WYRMBLOODED_SEAFORGED:
        case GS_SU_VEYDRAN_UNFADING_SEAFORGED:
        return TRUE;
    }
    return FALSE;
}

int gsSUGetStoneWrought(int nSubRace)
{
    switch(nSubRace)
    {
        case GS_SU_VEYDRAN_ABYSSALCOURT_STONEWROUGHT:
        case GS_SU_VEYDRAN_WYRMBLOODED_STONEWROUGHT:
        case GS_SU_VEYDRAN_UNFADING_STONEWROUGHT:
        return TRUE;
    }
    return FALSE;
}

