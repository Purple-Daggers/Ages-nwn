#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_subrace"
#include "gs_inc_text"

void main()
{
    object oPC         = GetPCLevellingUp();
    object oPermission = OBJECT_INVALID;
    string sString     = "";
    int nLevel         = GetHitDice(oPC);
    int nXP            = GetXP(oPC);
    int nXPLevel       = nLevel * (nLevel - 1) / 2 * 1000;
    int nClassType     = 0;
    int nClassLevel    = 0;
    int nRequiredLevel = GetLocalInt(GetModule(), "GS_REQUIRED_LEVEL_PER_CLASS");
    int nNth           = 0;

    //required level
    for (nNth = 1; nNth <= 3; nNth++)
    {
        nClassType  = GetClassByPosition(nNth, oPC);
        if (nClassType == CLASS_TYPE_INVALID) break;
        nClassLevel = GetLevelByClass(nClassType, oPC);

        if (nClassLevel < nRequiredLevel)
        {
            if (nClassLevel > gsPCGetMemorizedClassLevel(nNth, oPC)) break;

            SetXP(oPC, nXPLevel - 1);
            gsPCMemorizeClassData(oPC);
            DelayCommand(0.5, SetXP(oPC, nXP));

            switch (nNth)
            {
            case 1: sString = GS_T_16777450; break;
            case 2: sString = GS_T_16777451; break;
            case 3: sString = GS_T_16777452; break;
            }

            FloatingTextStringOnCreature(
                gsCMReplaceString(
                    GS_T_16777449,
                    IntToString(nRequiredLevel),
                    sString),
                oPC,
                FALSE);
            return;
        }
    }

    //devastating critical
    if (GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD,   oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CLUB,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DART,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW,  oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KAMA,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KATANA,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW,  oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF,   oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SLING,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD, oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WHIP,           oPC))
    {
        SetXP(oPC, nXPLevel - 1);
        gsPCMemorizeClassData(oPC);
        DelayCommand(0.5, SetXP(oPC, nXP));

        FloatingTextStringOnCreature(GS_T_16777431, oPC, FALSE);
        return;
    }

    //prestige class
    for (nNth = 1; nNth <= 3; nNth++)
    {
        nClassType = GetClassByPosition(nNth, oPC);

        if (nClassType == CLASS_TYPE_INVALID) break;

        switch (nClassType)
        {
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_DIVINE_CHAMPION:
        case CLASS_TYPE_DRAGON_DISCIPLE:
        case CLASS_TYPE_DWARVEN_DEFENDER:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_PALE_MASTER:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_SHIFTER:
        case CLASS_TYPE_WEAPON_MASTER:
            if (gsPCGetMemorizedClassType(nNth, oPC) != nClassType)
            {
                oPermission =
                    GetItemPossessedBy(
                        oPC,
                        "GS_PERMISSION_CLASS_" + IntToString(nClassType));

                if (! GetIsObjectValid(oPermission))
                {
                    SetXP(oPC, nXPLevel - 1);
                    gsPCMemorizeClassData(oPC);
                    DelayCommand(0.5, SetXP(oPC, nXP));

                    FloatingTextStringOnCreature(GS_T_16777326, oPC, FALSE);
                    return;
                }
            }

        default:
            continue;
        }

        break;
    }

    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

    if (nSubRace)
    {
        //property
        object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        if (GetIsObjectValid(oItem)) gsSUApplyProperty(oItem, nSubRace, nLevel);

        //ability
        oItem        = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
        if (GetIsObjectValid(oItem)) gsSUApplyAbility(oItem, nSubRace, nLevel);
    }

    gsCMCalculateMaximumMana(oPC);

    gsPCMemorizeClassData(oPC);
    SendMessageToAllDMs(
        gsCMReplaceString(
            GS_T_16777325,
            GetName(oPC),
            IntToString(nLevel)));
}
