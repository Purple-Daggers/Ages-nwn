/* WORSHIP Library by Gigaschatten */

#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_spell"
#include "gs_inc_state"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_xp"

//void main() {}

const string GS_WORSHIP_DATABASE = "GS_WORSHIP";

const int GS_WO_TIMEOUT_FAVOR        = 3600; //TIME UPDATE: 1 hour
const int GS_WO_TIMEOUT_RESURRECTION = 14400; //TIME UPDATE: 4 hours

const int GS_WO_COST_LESSER_FAVOR    =     5;
const int GS_WO_COST_GREATER_FAVOR   =    10;
const int GS_WO_COST_RESURRECTION    =    25;

const int GS_WO_PENALTY_PER_LEVEL    =    15;

const int GS_WO_NONE                 =    -1;
const int GS_WO_BLACK_COMMUNION      =     1;
const int GS_WO_ELDAENURIS           =     2;
const int GS_WO_GOLDEN_COMMUNION     =     3;
const int GS_WO_GREAT_LEVIATHANS     =     4;
const int GS_WO_GREEN                =     5;
const int GS_WO_OLD_WAYS             =     6;
const int GS_WO_SCHOOL_OF_FLOWERS    =     7;
const int GS_WO_SISTER_MOONS         =     8;

//return TRUE if nDeity is available for oPlayer
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF);
//return deity constant resembling sDeity
int gsWOGetDeityByName(string sDeity);
//return name of nDeity
string gsWOGetNameByDeity(int nDeity);
//return presence of sDeity (0-100)
int gsWOGetPresence(string sDeity);
//adjust presence of sDeity by nAmount
void gsWOAdjustPresence(string sDeity, int nAmount);
//process all deities presence
void gsWOProcessPresence();
//return power of sDeity (0-100)
int gsWOGetPower(string sDeity);
//adjust power of sDeity by nAmount
void gsWOAdjustPower(string sDeity, int nAmount);
//process all deities power
void gsWOProcessPower();
//return TRUE if deity grants favor to oTarget
int gsWOGrantFavor(object oTarget = OBJECT_SELF);
//return TRUE if deity resurrects oTarget
int gsWOGrantResurrection(object oTarget = OBJECT_SELF);

int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF)
{
    if (GetIsDM(oPlayer)) return TRUE;

    string sAlignment = "";

    switch (GetAlignmentLawChaos(oPlayer))
    {
    case ALIGNMENT_LAWFUL:  sAlignment = "L"; break;
    case ALIGNMENT_NEUTRAL: sAlignment = "N"; break;
    case ALIGNMENT_CHAOTIC: sAlignment = "C"; break;
    }

    switch (GetAlignmentGoodEvil(oPlayer))
    {
    case ALIGNMENT_GOOD:    sAlignment += "G"; break;
    case ALIGNMENT_NEUTRAL: sAlignment += "N"; break;
    case ALIGNMENT_EVIL:    sAlignment += "E"; break;
    }

    switch (nDeity)
    {
    case GS_WO_NONE:
        return TRUE;

    case GS_WO_BLACK_COMMUNION:
        return TRUE;

    case GS_WO_ELDAENURIS:
        return TRUE;

    case GS_WO_GOLDEN_COMMUNION:
        return TRUE;
        
    case GS_WO_GREAT_LEVIATHANS:
        return TRUE;

    case GS_WO_GREEN:
        return TRUE;
    
    case GS_WO_OLD_WAYS:
        return TRUE;
    
    case GS_WO_SCHOOL_OF_FLOWERS:
        return TRUE;

    case GS_WO_SISTER_MOONS:
        return TRUE;

    /*case GS_WO_AZUTH:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";*/
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsWOGetDeityByName(string sDeity)
{
    if (sDeity == "")                     return GS_WO_NONE;
    if (sDeity == "Black Communion")      return GS_WO_BLACK_COMMUNION;
    if (sDeity == "Eldænuris")            return GS_WO_ELDAENURIS;
    if (sDeity == "Golden Communion")     return GS_WO_GOLDEN_COMMUNION;
    if (sDeity == "Great Leviathans")     return GS_WO_GREAT_LEVIATHANS;
    if (sDeity == "Green")                return GS_WO_GREEN;
    if (sDeity == "Old Ways")             return GS_WO_OLD_WAYS;
    if (sDeity == "School of Flowers")    return GS_WO_SCHOOL_OF_FLOWERS;
    if (sDeity == "Sister Moons")         return GS_WO_SISTER_MOONS;


    return FALSE;
}
//----------------------------------------------------------------
string gsWOGetNameByDeity(int nDeity)
{
    switch (nDeity)
    {
    case GS_WO_BLACK_COMMUNION:          return "Black Communion";
    case GS_WO_ELDAENURIS:               return "Eldænuris";
    case GS_WO_GOLDEN_COMMUNION:         return "Golden Communion";
    case GS_WO_GREAT_LEVIATHANS:         return "Great Leviathans";
    case GS_WO_GREEN:                    return "Green";
    case GS_WO_OLD_WAYS:                 return "Old Ways";
    case GS_WO_SCHOOL_OF_FLOWERS:        return "School of Flowers";
    case GS_WO_SISTER_MOONS:             return "Sister Moons";
    }

    return "";
}
//----------------------------------------------------------------
int gsWOGetPresence(string sDeity)
{
    if (sDeity == "") return FALSE;

    object oModule = GetModule();
    int nPresence  = GetLocalInt(oModule, "GS_WO_PR_" + sDeity);

    if (! nPresence)
    {
        sqlquery sqlGetPresence = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "SELECT presence from deities WHERE name = @name");
        SqlBindString(sqlGetPresence, "@name", sDeity);
        if(SqlStep(sqlGetPresence))
        {
            nPresence = SqlGetInt(sqlGetPresence, 0) + 1;
        } else {
            nPresence = 1;
        }
        //nPresence = GetCampaignInt("GS_WO_PRESENCE", sDeity) + 1;
        SetLocalInt(oModule, "GS_WO_PR_" + sDeity, nPresence);
    }

    return nPresence - 1;
}
//----------------------------------------------------------------
void gsWOAdjustPresence(string sDeity, int nAmount)
{
    if (sDeity == "")       return;
    if (! nAmount)          return;

    int nPresence  = gsWOGetPresence(sDeity);
    nAmount       += nPresence;

    if (nAmount < 0)        nAmount =   0;
    else if (nAmount > 100) nAmount = 100;

    if (nPresence != nAmount)
    {
        SetLocalInt(GetModule(), "GS_WO_PR_" + sDeity, nAmount + 1);
        sqlquery sqlSetPresence = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "INSERT INTO deities (name, presence) VALUES (@name, @presence) ON CONFLICT (name) DO UPDATE SET presence = excluded.presence;");
        SqlBindString(sqlSetPresence, "@name", sDeity);
        SqlBindInt(sqlSetPresence, "@presence", nAmount);
        SqlStep(sqlSetPresence);
        //SetCampaignInt("GS_WO_PRESENCE", sDeity, nAmount);
    }
}
//----------------------------------------------------------------
void gsWOProcessPresence()
{
    int nNth = 1;

    for (; nNth <= 59; nNth++)
        gsWOAdjustPresence(gsWOGetNameByDeity(nNth), -1);
}
//----------------------------------------------------------------
int gsWOGetPower(string sDeity)
{
    if (sDeity == "") return FALSE;

    object oModule = GetModule();
    int nPower     = GetLocalInt(oModule, "GS_WO_PO_" + sDeity);

    if (! nPower)
    {
        sqlquery sqlGetPower = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "SELECT power from deities WHERE name = @name");
        SqlBindString(sqlGetPower, "@name", sDeity);
        if(SqlStep(sqlGetPower))
        {
            nPower = SqlGetInt(sqlGetPower, 0) + 1;
        } else {
            nPower = 1;
        }
        //nPower = GetCampaignInt("GS_WO_POWER", sDeity) + 1;
        SetLocalInt(oModule, "GS_WO_PO_" + sDeity, nPower);
    }

    return nPower - 1;
}
//----------------------------------------------------------------
void gsWOAdjustPower(string sDeity, int nAmount)
{
    if (sDeity == "")       return;
    if (! nAmount)          return;

    int nPower  = gsWOGetPower(sDeity);
    nAmount    += nPower;

    if (nAmount < 0)        nAmount =   0;
    else if (nAmount > 100) nAmount = 100;

    if (nPower != nAmount)
    {
        sqlquery sqlSetPower = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "INSERT INTO deities (name, power) VALUES (@name, @power) ON CONFLICT (name) DO UPDATE SET power = excluded.power;");
        SqlBindString(sqlSetPower, "@name", sDeity);
        SqlBindInt(sqlSetPower, "@power", nAmount);
        SqlStep(sqlSetPower);
        SetLocalInt(GetModule(), "GS_WO_PO_" + sDeity, nAmount + 1);
        //SetCampaignInt("GS_WO_POWER", sDeity, nAmount);
    }
}
//----------------------------------------------------------------
void gsWOProcessPower()
{
    string sDeity = "";
    int nPresence = 0;
    int nNth      = 1;

    for (; nNth <= 59; nNth++)
    {
        sDeity    = gsWOGetNameByDeity(nNth);
        nPresence = gsWOGetPresence(sDeity);

        if (nPresence >= 10) gsWOAdjustPower(sDeity, nPresence / 10);
        else                 gsWOAdjustPower(sDeity, -100);
    }
}
//----------------------------------------------------------------
int gsWOGrantFavor(object oTarget = OBJECT_SELF)
{
    //deity
    string sDeity  = GetDeity(oTarget);

    if (sDeity == "")
    {
        FloatingTextStringOnCreature(GS_T_16777282, oTarget, FALSE);
        return FALSE;
    }

    //timeout
    int nTimestamp = gsTIGetActualTimestamp();

    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR") > nTimestamp)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777283, sDeity), oTarget, FALSE);
        return FALSE;
    }

    SetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR", nTimestamp + GS_WO_TIMEOUT_FAVOR);

    //presence
    int nPresence  = gsWOGetPresence(sDeity);

    if (Random(100) >= nPresence)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777284, sDeity), oTarget, FALSE);
        return FALSE;
    }

    int nPower     = gsWOGetPower(sDeity);
    int nFlag      = FALSE;

    //greater favor
    if (nPower >= GS_WO_COST_GREATER_FAVOR)
    {
        //remove negative effects
        effect eEffect = GetFirstEffect(oTarget);
        int nHitDice   = GetHitDice(oTarget);

        while (GetIsEffectValid(eEffect))
        {
            switch (GetEffectType(eEffect))
            {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_CHARMED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_CURSE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_DISEASE:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POISON:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_SLOW:
            case EFFECT_TYPE_SPELL_FAILURE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_STUNNED:
                if (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY)
                {
                    RemoveEffect(oTarget, eEffect);
                    nFlag = TRUE;
                }
            }

            eEffect = GetNextEffect(oTarget);
        }

        int nCurrentHitPoints = GetCurrentHitPoints(oTarget);
        int nMaxHitPoints     = GetMaxHitPoints(oTarget);

        //heal
        if (nFlag || nCurrentHitPoints < nMaxHitPoints / 3)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectHeal(nMaxHitPoints - nCurrentHitPoints),
                                oTarget);
            nFlag = TRUE;
        }

        //divine wrath
        if (! nFlag)
        {
            location lLocation = GetLocation(oTarget);
            object oEnemy      = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            effect eVisual1    = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
            effect eVisual2    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            string sDeityEnemy = "";
            int nDamage        = 0;
            int nPresenceEnemy = 0;
            int nResistance    = 0;
            int nNth           = 0;

            while (GetIsObjectValid(oEnemy))
            {
                if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oTarget, oEnemy) &&
                    ! gsBOGetIsBossCreature(oEnemy))
                {
                    sDeityEnemy = GetDeity(oEnemy);

                    if (sDeityEnemy != sDeity)
                    {
                        if (GetIsPC(oEnemy))
                        {
                            nDamage        = d6(nPresence * nHitDice / 100);
                            nPresenceEnemy = sDeityEnemy == "" ?
                                             0 : gsWOGetPresence(sDeityEnemy);
                            nResistance    = nPresenceEnemy < 1 ?
                                             0 : d6(nPresenceEnemy * GetHitDice(oEnemy) / 100);
                        }
                        else
                        {
                            nDamage        = d6(nPresence);
                            nPresenceEnemy = sDeityEnemy == "" ?
                                             0 : gsWOGetPresence(sDeityEnemy);
                            nResistance    = nPresenceEnemy < 20 ?
                                             d6(20) : d6(nPresenceEnemy);
                        }

                        //visual effect
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oEnemy);

                        if (nResistance < nDamage)
                        {
                            FloatingTextStringOnCreature(GS_T_16777481, oEnemy, FALSE);

                            //apply damage
                            DelayCommand(
                                1.0,
                                ApplyEffectToObject(
                                    DURATION_TYPE_INSTANT,
                                    EffectLinkEffects(
                                        eVisual2,
                                        EffectDamage(
                                            nDamage - nResistance,
                                            DAMAGE_TYPE_DIVINE,
                                            DAMAGE_POWER_ENERGY)),
                                    oEnemy));
                        }
                        else
                        {
                            FloatingTextStringOnCreature(GS_T_16777480, oEnemy, FALSE);
                        }

                        nFlag = TRUE;
                        nNth++;
                    }
                }

                if (nNth >= 3) break; //affects a maximum of 3 creatures

                oEnemy = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            }
        }

        if (nFlag)
        {
            gsWOAdjustPower(sDeity, -GS_WO_COST_GREATER_FAVOR);
            FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777285, sDeity), oTarget, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_LOS_HOLY_20),
                                oTarget);

            //apply penalty
            if (GetIsInCombat(oTarget))
            {
                gsXPApplyDeathPenalty(oTarget, nHitDice * GS_WO_PENALTY_PER_LEVEL, TRUE);
            }

            return TRUE;
        }
    }

    //lesser favor
    if (nPower >= GS_WO_COST_LESSER_FAVOR)
    {
        //state
        if (gsSTGetState(GS_ST_FOOD, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_FOOD,  25.0);
        if (gsSTGetState(GS_ST_WATER, oTarget) <= 0.0) gsSTAdjustState(GS_ST_WATER, 25.0);
        if (gsSTGetState(GS_ST_REST, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_REST,  25.0);

        //ability
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CHARISMA, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CONSTITUTION, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_DEXTERITY, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_INTELLIGENCE, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_STRENGTH, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_WISDOM, Random(3)),
                            oTarget,
                            600.0);

        gsWOAdjustPower(sDeity, -GS_WO_COST_LESSER_FAVOR);
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777286, sDeity), oTarget, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_FNF_LOS_HOLY_10),
                            oTarget);
        return TRUE;
    }

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777287, sDeity), oTarget, FALSE);
    return FALSE;
}
//----------------------------------------------------------------
int gsWOGrantResurrection(object oTarget = OBJECT_SELF)
{
    if (! GetIsDead(oTarget))                                            return FALSE;
    string sDeity  = GetDeity(oTarget);
    if (sDeity == "")                                                    return FALSE;
    int nTimestamp = gsTIGetActualTimestamp();
    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_RESURRECTION") > nTimestamp) return FALSE;
    SetLocalInt(oTarget, "GS_WO_TIMEOUT_RESURRECTION", nTimestamp + GS_WO_TIMEOUT_RESURRECTION);
    int nPresence  = gsWOGetPresence(sDeity);
    if (Random(100) >= nPresence)                                        return FALSE;
    if (Random(100) < 10)                                                return FALSE;
    int nPower     = gsWOGetPower(sDeity);
    if (nPower < GS_WO_COST_RESURRECTION)                                return FALSE;

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectResurrection(),
                        oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetMaxHitPoints(oTarget) + 10),
                        oTarget);
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
            ExtraordinaryEffect(
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_SANCTUARY),
                        EffectEthereal()))),
        oTarget,
        6.0);

    gsWOAdjustPower(sDeity, -GS_WO_COST_RESURRECTION);
    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777288, sDeity), oTarget, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
                        oTarget);

    return TRUE;
}
