/* SPELL Library by Gigaschatten */

//void main() {}

#include "gs_inc_combat2"
#include "x2_inc_spellhook"
#include "x0_i0_position"
#include "gs_inc_subrace"
#include "gs_inc_state"

const float GS_SP_DURATION_INSTANT        = -1.0;
const float GS_SP_DURATION_PERMANENT      = -2.0;

const int GS_SP_TYPE_BENEFICIAL           =  1;
const int GS_SP_TYPE_BENEFICIAL_SELECTIVE =  2;
const int GS_SP_TYPE_HARMFUL              =  3;
const int GS_SP_TYPE_HARMFUL_SELECTIVE    =  4;

const int OBJECT_TYPE_SPELLTARGET         = 73; //OBJECT_TYPE_CREATURE
                                                //OBJECT_TYPE_DOOR
                                                //OBJECT_TYPE_PLACEABLE;

const int DAMAGE_TYPE_BLOOD = 8192;

//return current spell id
int gsSPGetSpellID();
//execute gs_spellscript and return TRUE if spell is overridden
int gsSPGetOverrideSpell();
//override current spell of caller, use in gs_spellscript
void gsSPSetOverrideSpell();
//apply eEffect of nSpell to oTarget for fDuration
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT);
//return TRUE if oTarget is affected by a nType (GS_SP_TYPE_*) spell of oCaster
int gsSPGetIsAffected(int nType, object oCaster, object oTarget);
//return TRUE if oTarget resists nSpell of oCaster, show visual effect after fDelay
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0);
//
int gsSPSavingThrow(object oCaster, object oTarget, int nSpell, int nDC, int nSavingThrow, int nSavingThrowType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0);
//return damage with nCount rolls of nDice using nMetaMagic adding nBonus
int gsSPGetDamage(int nCount, int nDice, int nMetaMagic, int nBonus = 0);
//remove all effects of nSpell applied by oCaster from oTarget
void gsSPRemoveEffect(object oTarget, int nSpell, object oCaster = OBJECT_INVALID);
//return random float between fMinimum and fMaximum
float gsSPGetRandomDelay(float fMinimum = 0.5, float fMaximum = 1.5);
//return spell delay for fDistance
float gsSPGetDelay(float fDistance);
//return TRUE if oCreature is a humanoid
int gsSPGetIsHumanoid(object oCreature);
//return TRUE if oCreature is an animal
int gsSPGetIsAnimal(object oCreature);
//return TRUE if oCreature is an undead
int gsSPGetIsUndead(object oCreature);
//return TRUE if oCreature is a living being
int gsSPGetIsLiving(object oCreature);
//set if last spell of oCaster is nHarmful
void gsSPSetLastSpellHarmful(object oCaster = OBJECT_SELF, int nHarmful = TRUE);
//return TRUE if last spell of oCaster is harmful
int gsSPGetLastSpellHarmful(object oCaster = OBJECT_SELF);
//set last spell target of oCaster
void gsSPSetLastSpellTarget(object oCaster, object oTarget = OBJECT_INVALID);
//return last spell target of oCaster
object gsSPGetLastSpellTarget(object oCaster = OBJECT_SELF);
//set spell callback flag of oCaster
void gsSPSetSpellCallback(object oCaster = OBJECT_SELF);
//return spell callback flag of oCaster
int gsSPGetSpellCallback(object oCaster = OBJECT_SELF);
//reset spell callback flag of oCaster
void gsSPResetSpellCallback(object oCaster = OBJECT_SELF);
//return level of nSpell for nClass
int gsSPGetSpellLevel(int nSpell, int nClass = CLASS_TYPE_INVALID);
//return level of metamagic
int gsSPGetMetaMagicLevel(int nMetaMagic);

//remove up to nCount spells from oTarget that are affected by spell breach
void gsSPApplySpellBreach(object oTarget, int nCount);
//internally used
void _gsSPApplySpellBreach(object oTarget, int nSpell);
//make oCaster dispel area of effect oTarget by nChance
void gsSPDispelAreaOfEffect(object oCaster, object oTarget, int nChance = 100);
//return maximum mana of creature
int gsCMCalculateMaximumMana(object oCreature);
//void returning create object function for use by magic surge
void gsSPCreateObjectWrapper(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation = FALSE, string sNewTag = "");
//handle magic surge activation text
void gsSPMagicSurgeCallback(object oWildMagicHelper, object oCaster, string sSurgeName, string sSurgeTarget);
//handle magic surge
void gsSPMagicSurge(object oCaster, object oTarget, location lTarget, int nDoubleSurgeFlag = FALSE, int nForceSurge = 0);

int gsSPGetSpellID()
{
    effect eEffect = EffectBlindness();
    return GetEffectSpellId(eEffect);
}
//----------------------------------------------------------------
int gsSPGetOverrideSpell()
{
    return ! X2PreSpellCastCode(); //temporary override

    ExecuteScript("gs_spellscript", OBJECT_SELF);

    int nOverrideSpell = GetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
    DeleteLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
    return nOverrideSpell;
}
//----------------------------------------------------------------
void gsSPSetOverrideSpell()
{
    SetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL", TRUE);
}
//----------------------------------------------------------------
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT)
{
    effect eCurrentEffect = GetFirstEffect(oTarget);
    int nHitPoints        = GetCurrentHitPoints(oTarget);
    int nCount1           = 0;
    int nEffective        = FALSE;

    //effect count before
    while (GetIsEffectValid(eCurrentEffect))
    {
        nCount1        += 1;
        eCurrentEffect  = GetNextEffect(oTarget);
    }

    //apply effect
    if (fDuration == GS_SP_DURATION_INSTANT)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
    }
    else
    {
        if (fDuration == GS_SP_DURATION_PERMANENT)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
        }

        //check applied effect
        nEffective = GetHasSpellEffect(nSpell, oTarget);
    }

    //check spell effectiveness
    if (! nEffective)
    {
        //check hit point count
        if (nHitPoints == GetCurrentHitPoints(oTarget))
        {
            //effect count after
            int nCount2    = 0;
            eCurrentEffect = GetFirstEffect(oTarget);

            while (GetIsEffectValid(eCurrentEffect))
            {
                nCount2        += 1;
                eCurrentEffect  = GetNextEffect(oTarget);
            }

            //check effect count
            if (nCount1 == nCount2)
            {
                //the spell is considered ineffective
                gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                return;
            }
        }
    }

    //the spell is considered effective
    gsC2AdjustSpellEffectiveness(nSpell, oTarget);
}
//----------------------------------------------------------------
int gsSPGetIsAffected(int nType, object oCaster, object oTarget)
{
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM) return TRUE;
    if (GetPlotFlag(oTarget))                       return FALSE;
    if (GetIsDM(oCaster))                           return TRUE;
    if (GetIsDead(oTarget))                         return FALSE;

    switch (nType)
    {
    case GS_SP_TYPE_BENEFICIAL:
        return TRUE;

    case GS_SP_TYPE_BENEFICIAL_SELECTIVE:
        if (GetIsReactionTypeFriendly(oTarget, oCaster) ||
            (GetFactionEqual(oTarget, oCaster) &&
             ! GetIsReactionTypeHostile(oTarget, oCaster)))
        {
            return TRUE;
        }
        break;

    case GS_SP_TYPE_HARMFUL:
        if (GetIsPC(oCaster))                           return TRUE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;

    case GS_SP_TYPE_HARMFUL_SELECTIVE:
        if (oTarget == oCaster)                         return FALSE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0)
{
    int nEffect = FALSE;

    switch (ResistSpell(oCaster, oTarget))
    {
    case 1: //resistance
        nEffect = VFX_IMP_MAGIC_RESISTANCE_USE;
        break;

    case 2: //imunity
        nEffect = VFX_IMP_GLOBE_USE;
        break;

    case 3: //absorption
        nEffect = VFX_IMP_SPELL_MANTLE_USE;
        break;
    }

    if (nEffect)
    {
        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(nEffect),
                oTarget));

        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPSavingThrow(object oCaster, object oTarget, int nSpell, int nDC, int nSavingThrow, int nSavingThrowType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0)
{
    if (GetIsDM(oCaster)) return FALSE;

    int nSuccess = FALSE;
    int nEffect  = FALSE;

    if (nDC < 1)        nDC =   1;
    else if (nDC > 255) nDC = 255;

    switch (nSavingThrow)
    {
    case SAVING_THROW_FORT:
        nSuccess = FortitudeSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_FORTITUDE_SAVING_THROW_USE;
        break;

    case SAVING_THROW_REFLEX:
        nSuccess = ReflexSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_REFLEX_SAVE_THROW_USE;
        break;

    case SAVING_THROW_WILL:
        nSuccess = WillSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_WILL_SAVING_THROW_USE;
        break;
    }

    switch (nSuccess)
    {
    case 0: //failure
        //death
        if ((nSavingThrowType == SAVING_THROW_TYPE_DEATH ||
             nSpell == SPELL_FINGER_OF_DEATH ||
             nSpell == SPELL_WEIRD) &&
            nSpell != SPELL_HORRID_WILTING)
        {
            nEffect = VFX_IMP_DEATH;
        }
        break;

    case 1: //success
        break;

    case 2: //immunity
        nSuccess = 0;
        nEffect  = VFX_IMP_MAGIC_RESISTANCE_USE;

        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        break;
    }

    if (nEffect)
    {
        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(nEffect),
                oTarget));
    }

    return nSuccess != 0;
}
//----------------------------------------------------------------
int gsSPGetDamage(int nCount, int nDice, int nMetaMagic, int nBonus = 0)
{
    int nDamage = 0;
    int nNth    = 0;

    switch (nMetaMagic)
    {
    case METAMAGIC_EMPOWER:
        for (; nNth < nCount; nNth++)
        {
            nDamage += Random(nDice) + 1;
        }
        nDamage += nDamage / 2;
        break;

    case METAMAGIC_MAXIMIZE:
        nDamage  = nCount * nDice;
        break;

    default:
        for (; nNth < nCount; nNth++)
        {
            nDamage += Random(nDice) + 1;
        }
        break;
    }

    return nDamage + nBonus;
}
//----------------------------------------------------------------
void gsSPRemoveEffect(object oTarget, int nSpell, object oCaster = OBJECT_INVALID)
{
    if (GetHasSpellEffect(nSpell, oTarget))
    {
        effect eEffect = GetFirstEffect(oTarget);
        int nCaster    = ! GetIsObjectValid(oCaster);

        while (GetIsEffectValid(eEffect))
        {
            if ((nCaster || GetEffectCreator(eEffect) == oCaster) &&
                GetEffectSpellId(eEffect) == nSpell)
            {
                RemoveEffect(oTarget, eEffect);
            }

            eEffect = GetNextEffect(oTarget);
        }
    }
}
//----------------------------------------------------------------
float gsSPGetRandomDelay(float fMinimum = 0.5, float fMaximum = 1.5)
{
    return fMinimum + IntToFloat(Random(FloatToInt(fMaximum * 10.0) + 1)) / 10.0;
}
//----------------------------------------------------------------
float gsSPGetDelay(float fDistance)
{
    return 3.0 * log(fDistance) + 2.0;
}
//----------------------------------------------------------------
int gsSPGetIsHumanoid(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_GOBLINOID:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsAnimal(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_ANIMAL:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsUndead(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_UNDEAD:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsLiving(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
        return FALSE;
    }

    return TRUE;
}
//----------------------------------------------------------------
void gsSPSetLastSpellHarmful(object oCaster = OBJECT_SELF, int nHarmful = TRUE)
{
    SetLocalInt(oCaster, "GS_SP_HARMFUL", nHarmful);
}
//----------------------------------------------------------------
int gsSPGetLastSpellHarmful(object oCaster = OBJECT_SELF)
{
    return GetLocalInt(oCaster, "GS_SP_HARMFUL");
}
//----------------------------------------------------------------
void gsSPSetLastSpellTarget(object oCaster, object oTarget = OBJECT_INVALID)
{
    SetLocalObject(oCaster, "GS_SP_TARGET", oTarget);
}
//----------------------------------------------------------------
object gsSPGetLastSpellTarget(object oCaster = OBJECT_SELF)
{
    return GetLocalObject(oCaster, "GS_SP_TARGET");
}
//----------------------------------------------------------------
void gsSPSetSpellCallback(object oCaster = OBJECT_SELF)
{
    SetLocalInt(oCaster, "GS_SP_CALLBACK", TRUE);
}
//----------------------------------------------------------------
int gsSPGetSpellCallback(object oCaster = OBJECT_SELF)
{
    return GetLocalInt(oCaster, "GS_SP_CALLBACK");
}
//----------------------------------------------------------------
void gsSPResetSpellCallback(object oCaster = OBJECT_SELF)
{
    DeleteLocalInt(oCaster, "GS_SP_CALLBACK");
}
//----------------------------------------------------------------
int gsSPGetSpellLevel(int nSpell, int nClass = CLASS_TYPE_INVALID)
{
    string sString = "";

    switch (nClass)
    {
    case CLASS_TYPE_BARD:     sString = "Bard";     break;
    case CLASS_TYPE_CLERIC:   sString = "Cleric";   break;
    case CLASS_TYPE_DRUID:    sString = "Druid";    break;
    case CLASS_TYPE_PALADIN:  sString = "Paladin";  break;
    case CLASS_TYPE_RANGER:   sString = "Ranger";   break;
    case CLASS_TYPE_SORCERER:
    case CLASS_TYPE_WIZARD:   sString = "Wiz_Sorc"; break;
    default:                  sString = "Innate";   break;
    }

    sString        = Get2DAString("spells", sString, nSpell);
    if (sString == "") sString = Get2DAString("spells", "Innate", nSpell);

    return StringToInt(sString);
}
//----------------------------------------------------------------
void gsSPApplySpellBreach(object oTarget, int nCount)
{
    int nSpell = gsC2GetFirstBreachableSpell();
    int nNth   = 0;

    while (nSpell && nNth++ < nCount)
    {
        _gsSPApplySpellBreach(oTarget, nSpell);
        nSpell = gsC2GetNextBreachableSpell();
    }
}
//----------------------------------------------------------------
void _gsSPApplySpellBreach(object oTarget, int nSpell)
{
    effect eEffect = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectSpellId(eEffect) == nSpell) RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}
//----------------------------------------------------------------
void gsSPDispelAreaOfEffect(object oCaster, object oTarget, int nChance = 100)
{
    if (GetIsDM(oCaster) ||
        oCaster == GetAreaOfEffectCreator(oTarget))
    {
        nChance = 100;
    }

    if (Random(100) < nChance)
    {
        FloatingTextStrRefOnCreature(100929, oCaster, FALSE);
        DestroyObject(oTarget);
    }
    else
    {
        FloatingTextStrRefOnCreature(100930, oCaster, FALSE);
    }
}
//-----------------------------------------------------------------
int gsSPGetMetaMagicLevel(int nMetaMagic)
{
    switch(nMetaMagic){
        case METAMAGIC_EMPOWER:
            return 2;
        break;
        case METAMAGIC_EXTEND:
            return 1;
        break;
        case METAMAGIC_MAXIMIZE:
            return 3;
        break;
        case METAMAGIC_NONE:
            return 0;
        break;
        case METAMAGIC_QUICKEN:
            return 4;
        break;
        case METAMAGIC_SILENT:
            return 1;
        break;
        case METAMAGIC_STILL:
            return 1;
        break;
    }
    return 0;
}
//-----------------------------------------------------------------
int gsCMCalculateMaximumMana(object oCreature)
{
    int nMaximumMana = 0;
    int nMaximumClassMana = 0;

    switch(GetLevelByClass(CLASS_TYPE_CLERIC, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_WIZARD, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_DRUID, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_SORCERER, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 5;
        break;
        case 2:
            nMaximumClassMana = 8;
        break;
        case 3:
            nMaximumClassMana = 17;
        break;
        case 4:
            nMaximumClassMana = 21;
        break;
        case 5:
            nMaximumClassMana = 32;
        break;
        case 6:
            nMaximumClassMana = 40;
        break;
        case 7:
            nMaximumClassMana = 47;
        break;
        case 8:
            nMaximumClassMana = 55;
        break;
        case 9:
            nMaximumClassMana = 71;
        break;
        case 10:
            nMaximumClassMana = 80;
        break;
        case 11:
            nMaximumClassMana = 91;
        break;
        case 12:
            nMaximumClassMana = 91;
        break;
        case 13:
            nMaximumClassMana = 103;
        break;
        case 14:
            nMaximumClassMana = 103;
        break;
        case 15:
            nMaximumClassMana = 117;
        break;
        case 16:
            nMaximumClassMana = 117;
        break;
        case 17:
            nMaximumClassMana = 133;
        break;
        case 18:
            nMaximumClassMana = 142;
        break;
        case 19:
            nMaximumClassMana = 153;
        break;
        case 20:
            nMaximumClassMana = 166;
        break;
        default:
            nMaximumClassMana = 166;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_BARD, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 5;
        break;
        case 2:
            nMaximumClassMana = 8;
        break;
        case 3:
            nMaximumClassMana = 17;
        break;
        case 4:
            nMaximumClassMana = 21;
        break;
        case 5:
            nMaximumClassMana = 32;
        break;
        case 6:
            nMaximumClassMana = 40;
        break;
        case 7:
            nMaximumClassMana = 47;
        break;
        case 8:
            nMaximumClassMana = 55;
        break;
        case 9:
            nMaximumClassMana = 71;
        break;
        case 10:
            nMaximumClassMana = 80;
        break;
        case 11:
            nMaximumClassMana = 91;
        break;
        case 12:
            nMaximumClassMana = 91;
        break;
        case 13:
            nMaximumClassMana = 103;
        break;
        case 14:
            nMaximumClassMana = 103;
        break;
        case 15:
            nMaximumClassMana = 117;
        break;
        case 16:
            nMaximumClassMana = 117;
        break;
        case 17:
            nMaximumClassMana = 133;
        break;
        case 18:
            nMaximumClassMana = 142;
        break;
        case 19:
            nMaximumClassMana = 153;
        break;
        case 20:
            nMaximumClassMana = 166;
        break;
        default:
            nMaximumClassMana = 166;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_PALADIN, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 0;
        break;
        case 2:
            nMaximumClassMana = 4;
        break;
        case 3:
            nMaximumClassMana = 5;
        break;
        case 4:
            nMaximumClassMana = 6;
        break;
        case 5:
            nMaximumClassMana = 10;
        break;
        case 6:
            nMaximumClassMana = 14;
        break;
        case 7:
            nMaximumClassMana = 15;
        break;
        case 8:
            nMaximumClassMana = 17;
        break;
        case 9:
            nMaximumClassMana = 22;
        break;
        case 10:
            nMaximumClassMana = 27;
        break;
        case 11:
            nMaximumClassMana = 29;
        break;
        case 12:
            nMaximumClassMana = 32;
        break;
        case 13:
            nMaximumClassMana = 35;
        break;
        case 14:
            nMaximumClassMana = 38;
        break;
        case 15:
            nMaximumClassMana = 41;
        break;
        case 16:
            nMaximumClassMana = 44;
        break;
        case 17:
            nMaximumClassMana = 50;
        break;
        case 18:
            nMaximumClassMana = 57;
        break;
        case 19:
            nMaximumClassMana = 60;
        break;
        case 20:
            nMaximumClassMana = 64;
        break;
        default:
            nMaximumClassMana = 64;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    return nMaximumMana;
}
//-----------------------------------------------------------------
void gsSPCreateObjectWrapper(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation = FALSE, string sNewTag = "")
{
    CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
}

//-----------------------------------------------------------------
void gsSPMagicSurgeCallback(object oWildMagicHelper, object oCaster, string sSurgeName, string sSurgeTarget)
{
    if(sSurgeTarget != ""){
                            FloatingTextStringOnCreature(
                            "Magic Surge: " + sSurgeName + " | " + sSurgeTarget,
                            oCaster,
                            TRUE);
    }
    DestroyObject(oWildMagicHelper, 60.0f);
}
//-----------------------------------------------------------------

//-----------------------------------------------------------------
void gsSPMagicSurge(object oCaster, object oTarget, location lTarget, int nDoubleSurgeFlag = FALSE, int nForceSurge = 0)
{
    string sSurgeName = "";
    string sSurgeTarget = "";
    object oOriginalTarget = oTarget;
    location lOriginalLocation = lTarget;

    location lCasterLocation = Location(GetArea(oCaster), GetPosition(oCaster), GetFacing(oCaster));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_PWSTUN),
                          lCasterLocation);

    if(oTarget == OBJECT_INVALID) oTarget = oCaster;

    switch(d2(1))
    {
        case 1:
            sSurgeTarget = "Target";
        break;
        case 2:
            sSurgeTarget = "Self";
            oTarget = oCaster;
            lTarget = lCasterLocation;
        break;
    }
    object oWildMagicHelper = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_sp_wmhelper", lTarget);

    //Some effects taken from Rod of Wonder item in toolset.
    int nSurge = d100(1);
    if(nForceSurge != 0)
    {
        nSurge = nForceSurge;
    }
    switch(nSurge){
        case -1: {
            sSurgeName = "Surge suppressed!";
            sSurgeTarget = "Self";
        }
        break;
        case 1: {
            sSurgeName = "Uuminen's Flash!";
            int nRand = Random(4) + 2;
            int i;
            float fDelay = 0.0f;
            effect eVis = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nRand; i++)
            {
                AssignCommand(oWildMagicHelper, DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget)));
                fDelay += 3.0;
            }
            return;
        }
        break;
        case 2:
            sSurgeName = "Polymorph!";
            if(GetMaster(oTarget) != OBJECT_INVALID) break;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectPolymorph(POLYMORPH_TYPE_CHICKEN),
                            oTarget,
                            RoundsToSeconds(d4()));
        break;
        case 3: {
            sSurgeName = "Windstorm!";
            // Play a low thundering sound
            PlaySound("as_wt_thunderds4");

            // Capture the first target object in the shape.
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                                RADIUS_SIZE_HUGE,
                                                lTarget, TRUE,
                                                OBJECT_TYPE_CREATURE |
                                                OBJECT_TYPE_DOOR |
                                                OBJECT_TYPE_AREA_OF_EFFECT);

            // Cycle through the targets within the spell shape
            while (GetIsObjectValid(oTarget)) {

                // Play a random sound
                switch (Random(5)) {
                case 0: AssignCommand(oTarget, PlaySound("as_wt_gustchasm1")); break;
                case 1: AssignCommand(oTarget, PlaySound("as_wt_gustcavrn1")); break;
                case 2: AssignCommand(oTarget, PlaySound("as_wt_gustgrass1")); break;
                case 3: AssignCommand(oTarget, PlaySound("as_wt_guststrng1")); break;
                case 4: AssignCommand(oTarget, PlaySound("fs_floatair")); break;
                }

                // Area-of-effect spells get blown away
                if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) {
                    DestroyObject(oTarget);
                }

                // * unlocked doors will reverse their open state
                else if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR) {
                    if (!GetLocked(oTarget)) {
                        if (GetIsOpen(oTarget) == FALSE)
                            AssignCommand(oTarget, ActionOpenDoor(oTarget));
                        else
                            AssignCommand(oTarget, ActionCloseDoor(oTarget));
                    }
                }

                // creatures will get knocked down, tough fort saving throw
                // to resist.
                else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
                    if( !FortitudeSave(oTarget, 15) ) {
                        effect eKnockdown = EffectKnockdown();
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                            eKnockdown,
                                            oTarget,
                                            RoundsToSeconds(1));
                    }
                }

                // Get the next target within the spell shape.
                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                            RADIUS_SIZE_HUGE,
                                            lTarget, TRUE,
                                            OBJECT_TYPE_CREATURE |
                                            OBJECT_TYPE_DOOR |
                                            OBJECT_TYPE_AREA_OF_EFFECT);
            }
        }
        break;
        case 4:
            sSurgeName = "Storm!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtObject(SPELL_STORM_OF_VENGEANCE, oTarget, METAMAGIC_ANY, TRUE, 0,
                                                                    PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        break;
        case 5: {
            sSurgeName = "Summon animal!";
            location lTargetLoc = GetOppositeLocation(oTarget);
            int nSummon = d100();
            string sSummon = "";
            if (nSummon < 26) {
                sSummon = "x0_penguin001";
            } else if (nSummon < 51) {
                sSummon = "nw_cow";
            } else {
                sSummon = "nw_deer";
            }

            /*ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
                                lTargetLoc);*/
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectSummonCreature(sSummon, VFX_FNF_SUMMON_MONSTER_1, 0.1f), oTarget);

            //CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
        }
        break;
        case 6:
            sSurgeName = "Butterflies!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtObject(505,
                                    oTarget,
                                    METAMAGIC_ANY, TRUE));
        break;
        case 7: {
            sSurgeName = "Flies!";
            effect eVis = EffectVisualEffect(VFX_DUR_FLIES);
            int nRand = Random(4) + 2;
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nRand));
        }
        break;
        case 8:  {
            sSurgeName = "Pixie Dust!";
            int nEffectPixieDust = 321;
            effect eDust =  EffectVisualEffect(nEffectPixieDust);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eDust,
                                oTarget,
                                RoundsToSeconds(d10(3) + 10));
        }
        break;
        case 9: {
            sSurgeName = "Fireballs!";
            int nDur = Random(2) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                AssignCommand(oWildMagicHelper,
                        DelayCommand(fDelay, ActionCastSpellAtObject(SPELL_FIREBALL, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
                fDelay += 6.0;
            }
            return;
        }
        break;
        case 10: {
            // target changes colors every round for 4-9 rounds
            sSurgeName = "Glow!";
            int nDur = Random(6) + 4;
            int i;
            float fDelay = 0.0f;
            int nRand;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                effect eVis;
                int nEffect;
                nRand = Random(7) + 1;
                if(nRand == 1)      nEffect = VFX_DUR_GLOW_PURPLE;
                else if(nRand == 2) nEffect = VFX_DUR_GLOW_RED;
                else if(nRand == 3) nEffect = VFX_DUR_GLOW_YELLOW;
                else if(nRand == 4) nEffect = VFX_DUR_GLOW_GREEN;
                else if(nRand == 5) nEffect = VFX_DUR_GLOW_ORANGE;
                else if(nRand == 6) nEffect = VFX_DUR_GLOW_BROWN;
                else if(nRand == 7) nEffect = VFX_DUR_GLOW_GREY;

                eVis = EffectVisualEffect(nEffect);
                AssignCommand(oWildMagicHelper, DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 5.0)));
                fDelay += 6.0;

            }
            return;
        }
        break;
        case 11: {
            sSurgeName = "Gems!";
            int nGems = Random(5) + 1;
            int i;
            int nRand;
            for (i=0; i < nGems; i++) {
                // Create the gems on the target
                string sResRef = "nw_it_gem0";
                nRand = Random(20);
                if (nRand == 0) {
                    sResRef += "11"; // topaz
                } else if (nRand < 7) {
                    sResRef += "02";
                } else if (nRand < 14) {
                    sResRef += "05";
                } else {
                    sResRef += "08";
                }
                object oGem = CreateObject(OBJECT_TYPE_ITEM, sResRef, GetRandomLocation(GetArea(oTarget), oTarget, DISTANCE_TINY));//CreateItemOnObject(sResRef, oTarget);
                if (GetIsObjectValid(oGem) == FALSE)
                {
                    sResRef = GetStringUpperCase(sResRef);
                    oGem = CreateObject(OBJECT_TYPE_ITEM, sResRef, GetRandomLocation(GetArea(oTarget), oTarget, DISTANCE_TINY));
                    if (GetIsObjectValid(oGem) == FALSE)
                    {
                    //  SpeakString("Gem " + sResRef + " is invalid");
                    }
                }
            }
        }
        break;
        case 12:
            sSurgeName = "Two surges!";
            if(nDoubleSurgeFlag == TRUE){
                sSurgeName = "Nothing!";
                gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
                return;
            }
            AssignCommand(oWildMagicHelper, DelayCommand(3.0f, gsSPMagicSurge(oCaster, oOriginalTarget, lOriginalLocation, TRUE)));
            AssignCommand(oWildMagicHelper, DelayCommand(6.0f, gsSPMagicSurge(oCaster, oOriginalTarget, lOriginalLocation, TRUE)));
        break;
        case 13:
            sSurgeName = "Petrification!";
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oTarget, RoundsToSeconds(10));
        break;
        case 14:
            sSurgeName = "Stonehold!";
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                EffectMovementSpeedDecrease(99), oTarget, RoundsToSeconds(2));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_STONEHOLD), oTarget, RoundsToSeconds(2));
        break;
        case 15: {
            sSurgeName = "Banished!";
            sSurgeTarget = "Self";
            oTarget = oCaster;
            lTarget = lCasterLocation;
            object oMazeWaypoint = GetWaypointByTag("MazeStart");
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_IMPLOSION),
                                lTarget);
            AssignCommand(oWildMagicHelper, DelayCommand(1.0f, ClearAllActions(TRUE, oTarget)));
            AssignCommand(oWildMagicHelper, DelayCommand(1.0f, AssignCommand(oTarget, JumpToLocation(GetLocation(oMazeWaypoint)))));
        }
        break;
        case 16: {
            sSurgeName = "Gold!";
            int nGoldPiles = Random(3) + 1;
            int i;
            for (i=0; i < nGoldPiles; i++) {
                object oGold = CreateObject(OBJECT_TYPE_PLACEABLE, "AS_GOLDPILE", GetRandomLocation(GetArea(oTarget), oTarget, DISTANCE_TINY));
            }
        }
        break;
        case 17: {
            sSurgeName = "Shrink!";
            float fDelay = 10.0f * IntToFloat(Random(5) + 1);
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, gsSUGetPlayerSubraceScale(oTarget) - 0.5f);
            AssignCommand(oWildMagicHelper, DelayCommand(fDelay, gsSUApplySubraceScale(oTarget)));
            return;
        }
        break;
        case 18: {
            sSurgeName = "Enlarge!";
            float fDelay = 10.0f * IntToFloat(Random(5) + 1);
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, gsSUGetPlayerSubraceScale(oTarget) + 0.5f);
            AssignCommand(oWildMagicHelper, DelayCommand(fDelay, gsSUApplySubraceScale(oTarget)));
            return;
        }
        break;
        case 19:
            sSurgeName = "Hunger!";
            sSurgeTarget = "Self";
            gsSTAdjustState(GS_ST_FOOD, -35.0f);
        break;
        case 20: {
            sSurgeName = "Lightning!";
            // lightning bolt
            int nDamage = d6(6);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                                                SPELLABILITY_BOLT_LIGHTNING));

            nDamage = GetReflexAdjustedDamage(nDamage,
                                            oTarget,
                                            13,
                                            SAVING_THROW_TYPE_ELECTRICITY);

            if (nDamage > 0 ){
                effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING,
                                            oCaster,
                                            BODY_NODE_HAND);
                effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
                effect eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);

                //Apply the VFX impact and effects
                DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                    eLightning,
                                    oTarget,
                                    1.7);
                }
            }
        break;
        case 21:
            sSurgeName = "Thirst!";
            sSurgeTarget = "Self";
            gsSTAdjustState(GS_ST_WATER, -35.0f);
        break;
        case 22:
            sSurgeName = "Torpor!";
            sSurgeTarget = "Self";
            gsSTAdjustState(GS_ST_REST, -35.0f);
            gsSTAdjustState(GS_ST_FOOD, 15.0f);
            gsSTAdjustState(GS_ST_WATER, 15.0f);
        break;
        case 23:
            sSurgeName = "Mana surge!";
            sSurgeTarget = "Self";
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION),
                          lCasterLocation);
            gsSTAdjustState(GS_ST_MANA, 100.0f);
        break;
        case 24:
            sSurgeName = "Mana drain!";
            sSurgeTarget = "Self";
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_PWKILL),
                          lCasterLocation);
            gsSTAdjustState(GS_ST_MANA, -50.0f);
        break;
        case 25:
            sSurgeName = "Sunlight!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_SUNBURST,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 26: {
            sSurgeName = "Grass!";
            effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
            AssignCommand(oWildMagicHelper, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                                eAOE,
                                GetLocation(oCaster),
                                RoundsToSeconds(d6())));
        }
        break;
        case 27: {
            sSurgeName = "Time Stop!";
            effect eTimestop = EffectTimeStop();
            effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
            AssignCommand(oWildMagicHelper, DelayCommand(0.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTimestop, oTarget, 6.0)));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        }
        break;
        case 28:
            sSurgeName = "Slow!";
            AssignCommand(oWildMagicHelper, ActionCastFakeSpellAtObject(SPELL_SLOW,
                                                                                oTarget,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT));
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                                                            EffectSlow(),
                                                                            oTarget,
                                                                            RoundsToSeconds(10)));
        break;
        case 29: {
            sSurgeName = "Ghostly!";
            int nTurns = 30;

            effect eReduction = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE, 0, FALSE);
            effect eConcealment = EffectConcealment(10, MISS_CHANCE_TYPE_NORMAL);
            effect eSpellImmunity = EffectSpellLevelAbsorption(1, 0);
            effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);

            effect eLink = EffectLinkEffects(eReduction, eConcealment);
            eLink = EffectLinkEffects(eSpellImmunity, eLink);
            eLink = EffectLinkEffects(eVis, eLink);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_GHOSTLY_VISAGE, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 30: {
            sSurgeName = "Ethereal!";
            int nTurns = 30;

            effect eReduction = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE, 0, FALSE);
            effect eConcealment = EffectConcealment(25, MISS_CHANCE_TYPE_NORMAL);
            effect eSpellImmunity = EffectSpellLevelAbsorption(2, 0);
            effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);

            effect eLink = EffectLinkEffects(eReduction, eConcealment);
            eLink = EffectLinkEffects(eSpellImmunity, eLink);
            eLink = EffectLinkEffects(eVis, eLink);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_ETHEREAL_VISAGE, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 31: {
            sSurgeName = "Clear mind!";
            int nTurns = 30;

            effect eImmunity = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
            effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

            effect eLink = EffectLinkEffects(eImmunity, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_LESSER_MIND_BLANK, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 32: {
            sSurgeName = "Glyphs!";
            int nDur = Random(5) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                float fDistance = Random(2) ? DISTANCE_MEDIUM : DISTANCE_LARGE;
                AssignCommand(oWildMagicHelper,
                        DelayCommand(fDelay, ActionCastSpellAtLocation(SPELL_GLYPH_OF_WARDING, GetRandomLocation(GetArea(oTarget), oTarget, fDistance), METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
                fDelay += 0.3;
            }
            return;
        }
        break;
        case 33: {
            sSurgeName = "Mass Shield!";
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                                RADIUS_SIZE_HUGE,
                                                lTarget, TRUE,
                                                OBJECT_TYPE_CREATURE);

            while (GetIsObjectValid(oTarget))
            {
                int nTurns = 30;
                effect eArmorClass = EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL);
                effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

                effect eLink = EffectLinkEffects(eArmorClass, eVis);

                SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_SHIELD, FALSE));

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLink, oTarget, TurnsToSeconds(nTurns));

                // Get the next target within the spell shape.
                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                            RADIUS_SIZE_HUGE,
                                            lTarget, TRUE,
                                            OBJECT_TYPE_CREATURE);
            }
        }
        break;
        case 34:
            sSurgeName = "Darkness!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(SPELL_DARKNESS,
                                                                                lTarget,
                                                                                METAMAGIC_EXTEND,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 35: {
            sSurgeName = "True seeing!";
            int nTurns = 30;

            effect eTrueSeeing = EffectTrueSeeing();
            effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);

            effect eLink = EffectLinkEffects(eTrueSeeing, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_TRUE_SEEING, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 36: {
            sSurgeName = "Terror!";
            int nRounds = 4;

            effect eFear = EffectFrightened();
            effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

            effect eLink = EffectLinkEffects(eFear, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_FEAR, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, RoundsToSeconds(nRounds));
        }
        break;
        case 37:
            sSurgeName = "Weird!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_WEIRD,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 38:
            sSurgeName = "Suffocation";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_DROWN,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 39:
            sSurgeName = "Stench!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(SPELL_STINKING_CLOUD,
                                                                                lTarget,
                                                                                METAMAGIC_EXTEND,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 40: {
            sSurgeName = "Blessing!";
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                                RADIUS_SIZE_HUGE,
                                                lTarget, TRUE,
                                                OBJECT_TYPE_CREATURE);

            while (GetIsObjectValid(oTarget))
            {
                int nTurns = 30;
                effect eAttackBonus = EffectAttackIncrease(1);
                effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEAD_HOLY);


                effect eLink = eAttackBonus;
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

                SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BLESS, FALSE));

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLink, oTarget, TurnsToSeconds(nTurns));

                // Get the next target within the spell shape.
                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                            RADIUS_SIZE_HUGE,
                                            lTarget, TRUE,
                                            OBJECT_TYPE_CREATURE);
            }
        }
        break;
        case 41: {
            sSurgeName = "Bane!";
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                                RADIUS_SIZE_HUGE,
                                                lTarget, TRUE,
                                                OBJECT_TYPE_CREATURE);

            while (GetIsObjectValid(oTarget))
            {
                int nTurns = 30;
                effect eAttackBonus = EffectAttackDecrease(1);
                effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEAD_EVIL);


                effect eLink = eAttackBonus;
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

                SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BANE, FALSE));

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLink, oTarget, TurnsToSeconds(nTurns));

                // Get the next target within the spell shape.
                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                            RADIUS_SIZE_HUGE,
                                            lTarget, TRUE,
                                            OBJECT_TYPE_CREATURE);
            }
        }
        break;
        case 42: {
            sSurgeName = "Heal!";
            int nRounds = 4;

            effect eHeal = EffectHeal(1000);
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEALING_X);

            effect eLink = eHeal;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_HEAL, FALSE));

            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            eLink, oTarget);
        }
        break;
        case 43: {
            sSurgeName = "Harm!";
            int nRounds = 4;

            int eHealth = GetCurrentHitPoints(oTarget);
            effect eDamage = EffectDamage(eHealth - d4(1), DAMAGE_TYPE_NEGATIVE);
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_HARM);

            effect eLink = eDamage;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_HARM, FALSE));

            DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            eLink, oTarget));
        }
        break;
        case 44:  {
            sSurgeName = "Elemental!";
            location lTargetLoc = GetOppositeLocation(oTarget);
            int nSummon = d100();
            string sSummon = "";
            string sFriendlySummon = "";
            switch(Random(4))
            {
                case 0:
                    sSummon = "airhuge001";
                    sFriendlySummon = "NW_S_AIRHUGE";
                break;
                case 1:
                    sSummon = "firehuge001";
                    sFriendlySummon = "NW_S_FIREHUGE";
                break;
                case 2:
                    sSummon = "earthhuge001";
                    sFriendlySummon = "NW_S_EARTHHUGE";
                break;
                case 3:
                    sSummon = "waterhuge001";
                    sFriendlySummon = "NW_S_WATERHUGE";
                break;
            }

            if(Random(2) == TRUE)
            {
                //Hostile summon
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2),
                                lTargetLoc);
                CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
            }
            else
            {
                //Friendly summon
                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectSummonCreature(sFriendlySummon, VFX_FNF_SUMMON_MONSTER_2, 0.1f), oTarget);
            }
        }
        break;
        case 45:  {
            sSurgeName = "Demonic Summoning!";
            location lTargetLoc = GetOppositeLocation(oTarget);
            int nSummon = d100();
            string sSummon = "dmfury001";

                //Hostile summon
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3),
                            lTargetLoc);
            CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
        }
        break;
        case 46: {
            sSurgeName = "Spirit Summoning!";
            location lTargetLoc = GetOppositeLocation(oTarget);
            int nSummon = d100();
            string sSummon = "sp_s_jub";

                //Friendly summon
                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectSummonCreature(sSummon, VFX_FNF_SUMMON_MONSTER_3, 0.1f), oTarget);
        }
        break;
        case 47: {
            sSurgeName = "Stoneskin!";
            int nTurns = 30;
            int nLimit = 100;

            effect eStoneskin = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nLimit);
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);

            effect eLink = EffectLinkEffects(eStoneskin, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_STONESKIN, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 48: {
            sSurgeName = "Ability boost!";
            int nTurns = 10;
            int nLimit = 100;

            effect eBoostStrength = EffectAbilityIncrease(ABILITY_STRENGTH, d4(1) + 1);
            effect eBoostDexterity = EffectAbilityIncrease(ABILITY_DEXTERITY, d4(1) + 1 );
            effect eBoostConstitution = EffectAbilityIncrease(ABILITY_CONSTITUTION, d4(1) + 1);
            effect eBoostIntelligence = EffectAbilityIncrease(ABILITY_INTELLIGENCE, d4(1) + 1);
            effect eBoostWisdom = EffectAbilityIncrease(ABILITY_WISDOM, d4(1) + 1);
            effect eBoostCharisma = EffectAbilityIncrease(ABILITY_CHARISMA, d4(1) + 1);

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

            effect eLink = EffectLinkEffects(eBoostStrength, eBoostDexterity);
            eLink = EffectLinkEffects(eBoostConstitution, eLink);
            eLink = EffectLinkEffects(eBoostIntelligence, eLink);
            eLink = EffectLinkEffects(eBoostWisdom, eLink);
            eLink = EffectLinkEffects(eBoostCharisma, eLink);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 49: {
            sSurgeName = "Ability drain!";
            int nTurns = 10;
            int nLimit = 100;

            effect eDrainStrength = EffectAbilityDecrease(ABILITY_STRENGTH, d4(1) + 1);
            effect eDrainDexterity = EffectAbilityDecrease(ABILITY_DEXTERITY, d4(1) + 1 );
            effect eDrainConstitution = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1) + 1);
            effect eDrainIntelligence = EffectAbilityDecrease(ABILITY_INTELLIGENCE, d4(1) + 1);
            effect eDrainWisdom = EffectAbilityDecrease(ABILITY_WISDOM, d4(1) + 1);
            effect eDrainCharisma = EffectAbilityDecrease(ABILITY_CHARISMA, d4(1) + 1);

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

            effect eLink = EffectLinkEffects(eDrainStrength, eDrainDexterity);
            eLink = EffectLinkEffects(eDrainConstitution, eLink);
            eLink = EffectLinkEffects(eDrainIntelligence, eLink);
            eLink = EffectLinkEffects(eDrainWisdom, eLink);
            eLink = EffectLinkEffects(eDrainCharisma, eLink);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 50:
            sSurgeName = "Grease!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_GREASE,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 51: {
            sSurgeName = "Great strength!";
            int nTurns = 10;
            int nLimit = 100;

            effect eBoostStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 12);

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

            effect eLink = eBoostStrength;

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_GREATER_BULLS_STRENGTH, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 52: {
            sSurgeName = "Stupidity!";
            int nTurns = 10;
            int nLimit = 100;

            effect eDrainIntelligence = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 12);
            effect eDrainWisdom = EffectAbilityDecrease(ABILITY_WISDOM, 12);

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

            effect eLink = EffectLinkEffects(eDrainIntelligence, eDrainWisdom);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            //SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_GREATER_BULLS_STRENGTH, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 53:
            sSurgeName = "Deadly Vapors!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_CLOUDKILL,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 54:
            sSurgeName = "Dizzy Vapors!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_MIND_FOG,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 55: {
            sSurgeName = "Catatonia!";
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_SLEEP);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oTarget, RoundsToSeconds(10));
        }
        break;
        case 56:
            sSurgeName = "Acid Fog!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_ACID_FOG,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 57:
            sSurgeName = "Incendiary cloud!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_INCENDIARY_CLOUD,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 58:{
            sSurgeName = "Detect Thoughts!";
            int nRounds = d4();
            int nLimit = nRounds * 5;

            effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

            //Link the visual and the damage reduction effect
            effect eLink = EffectLinkEffects(ePrem, eVis);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_PREMONITION, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, RoundsToSeconds(nRounds));
        }
        break;
        case 59: {
            sSurgeName = "Sanctuary!";
            effect eVisualEffect = EffectVisualEffect(VFX_DUR_SANCTUARY);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectEthereal(), eVisualEffect), oTarget, RoundsToSeconds(10));
        }
        break;
        case 60:  {
            sSurgeName = "Fall!";
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1));
        }
        break;
        case 61: {
            sSurgeName = "Regeneration!";
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(10, RoundsToSeconds(1)), oTarget, RoundsToSeconds(30));
        }
        break;
        case 62: {
            sSurgeName = "Spell mantle!";
            int nTurns = 30;
            int nPower = d8(1) + 8;

            effect eSpellImmunity = EffectSpellLevelAbsorption(9, nPower);
            effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);

            effect eLink = EffectLinkEffects(eSpellImmunity, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_SPELL_MANTLE, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 63: {
            sSurgeName = "Level loss!";

            effect eDrainLevel = EffectNegativeLevel(d4(1));

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

            effect eLink = eDrainLevel;

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_ENERVATION, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            eLink, oTarget);
        }
        break;
        case 64: {
            sSurgeName = "Silence!";
            int nTurns = 1;

            effect eSilence = EffectSilence();

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_SILENCE);

            effect eLink = eSilence;

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            //SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_GREATER_BULLS_STRENGTH, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 65:
            sSurgeName = "Tentacles!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_EVARDS_BLACK_TENTACLES,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 66: {
            sSurgeName = "Confusion!";
            int nTurns = 1;

            effect eConfused = EffectConfused();

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_CONFUSION_S);
            effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

            effect eLink = EffectLinkEffects(eConfused, eVis);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_CONFUSION, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 67: {
            sSurgeName = "Blindness!";
            int nTurns = 1;

            effect eBlindness = EffectBlindness();

            effect eVisualEffect = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

            effect eLink = eBlindness;

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BLINDNESS_AND_DEAFNESS, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 68:
            sSurgeName = "Missile storm!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(SPELL_ISAACS_LESSER_MISSILE_STORM,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 69: 
            sSurgeName = "Embrace chaos!";
            sSurgeTarget = "Self";
            oTarget = oCaster;
            AdjustAlignment(oTarget, ALIGNMENT_CHAOTIC, 1, FALSE);
        break;
        case 70: {
            sSurgeName = "Energy buffer!";
            int nTurns = 30;
            int nLimit = 100;

            int nDamageType = DAMAGE_TYPE_ACID | DAMAGE_TYPE_COLD | DAMAGE_TYPE_ELECTRICAL | DAMAGE_TYPE_FIRE | DAMAGE_TYPE_SONIC;
            effect eEnergyBuffer = EffectDamageResistance(nDamageType, 40, nLimit);
            effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);

            effect eLink = EffectLinkEffects(eEnergyBuffer, eVis);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_ENERGY_BUFFER, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 71: {
            sSurgeName = "Blur!";
            int nTurns = 30;

            effect eBlur = EffectConcealment(20);
            effect eVis = EffectVisualEffect(VFX_DUR_BLUR);

            effect eLink = EffectLinkEffects(eBlur, eVis);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 72: {
            sSurgeName = "Greater Entropic shield!";
            int nTurns = 10;

            effect eBlur = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
            effect eVis = EffectVisualEffect(VFX_DUR_BLUR);

            effect eLink = EffectLinkEffects(eBlur, eVis);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 73: {
            sSurgeName = "Arrow cushion!";
            int nTurns = 1;
            int nDamage = d6(10);

            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, 2);

            effect eVisualEffect = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
            effect eVisualEffect2= EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect2, oTarget);
            
            DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        }
        break;
        case 74: {
            sSurgeName = "Blood magic!";
            sSurgeTarget = "Self";
            oTarget = oCaster;
            int nDamage = d6(5);
            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLOOD, 10);
            effect eVisualEffect = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            gsSTAdjustState(GS_ST_MANA, 10.0f);
            DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        }
        break;
        case 75:
            sSurgeName = "Poison!";
            oWildMagicHelper = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_sp_wmhelper", lTarget);
            AssignCommand(oWildMagicHelper, ActionCastFakeSpellAtObject(SPELL_POISON,
                                                                                oTarget,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT));
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                                            EffectPoison(POISON_WYVERN_POISON),
                                                                            oTarget));
        break;
        case 76: {
            sSurgeName = "Bleeding!";
            int nDamage = d6(5);
            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLOOD, 10);
            effect eVisualEffect = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        }
        break;
        case 77: {
            sSurgeName = "Legend lore!";
            int nTurns = 10;

            effect eLore = EffectSkillIncrease(SKILL_LORE, 25);
            effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);

            effect eLink = EffectLinkEffects(eLore, eVis);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 78: {
            sSurgeName = "Midnight Shroud!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(SPELL_DARKNESS,
                                                                                lTarget,
                                                                                METAMAGIC_EXTEND,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
            int nTurns = 30;

            effect eVision = EffectUltravision();
            effect eReduction = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE, 0, FALSE);
            effect eReduction2 = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 1000, 0, FALSE);
            effect eArmorClass = EffectACIncrease(5, AC_NATURAL_BONUS);
            effect eDeathMagicImmunity = EffectImmunity(IMMUNITY_TYPE_DEATH);
            effect eSpellImmunity = EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_NECROMANCY);

            effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
            effect eVis2 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

            effect eLink = EffectLinkEffects(eVision, eReduction);
            eLink = EffectLinkEffects(eReduction2, eLink);
            eLink = EffectLinkEffects(eArmorClass, eLink);
            eLink = EffectLinkEffects(eDeathMagicImmunity, eLink);
            eLink = EffectLinkEffects(eSpellImmunity, eLink);
            eLink = EffectLinkEffects(eVis, eLink);
            eLink = EffectLinkEffects(eVis2, eLink);


            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 79: {
            sSurgeName = "Delayed Fireballs!";
            int nDur = Random(5) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                float fDistance = Random(2) ? DISTANCE_MEDIUM : DISTANCE_LARGE;
                AssignCommand(oWildMagicHelper,
                        DelayCommand(fDelay, ActionCastSpellAtLocation(SPELL_DELAYED_BLAST_FIREBALL, GetRandomLocation(GetArea(oTarget), oTarget, fDistance), METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
                fDelay += 0.3;
            }
            return;
        }
        break;
        case 80: {
            sSurgeName = "Disjunction!";
            int nDur = Random(5) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                float fDistance = Random(2) ? DISTANCE_MEDIUM : DISTANCE_LARGE;
                AssignCommand(oWildMagicHelper,
                        DelayCommand(fDelay, ActionCastSpellAtLocation(SPELL_MORDENKAINENS_DISJUNCTION, GetRandomLocation(GetArea(oTarget), oTarget, fDistance), METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
                fDelay += 0.3;
            }
            return;
        }
        break;
        case 81: {
            sSurgeName = "Blades!";
            int nDur = Random(5) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                float fDistance = Random(2) ? DISTANCE_MEDIUM : DISTANCE_LARGE;
                AssignCommand(oWildMagicHelper,
                        DelayCommand(fDelay, ActionCastSpellAtLocation(SPELL_BLADE_BARRIER, GetRandomLocation(GetArea(oTarget), oTarget, fDistance), METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
                fDelay += 0.3;
            }
            return;
        }
        break;
        case 82:
            sSurgeName = "Haste!";
            AssignCommand(oWildMagicHelper, ActionCastFakeSpellAtObject(SPELL_HASTE,
                                                                                oTarget,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT));
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                                                            EffectHaste(),
                                                                            oTarget,
                                                                            RoundsToSeconds(60)));
        break;
        case 83: {
            sSurgeName = "Undead!";
            
            location lTargetLoc = GetFlankingLeftLocation(oTarget);
            location lTargetLoc2 = GetFlankingRightLocation(oTarget);
            int nSummon = d100();
            string sSummon = "";
            if (nSummon < 26) {
                sSummon = "nw_ghast";
            } else if (nSummon < 51) {
                sSummon = "nw_skelwarr01";
            } else {
                sSummon = "nw_shadow";
            }

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
                                lTargetLoc);
            CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
                                lTargetLoc2);

            CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc2, TRUE);
        }
        break;
        case 84: {
            sSurgeName = "Skeletons!";
            int nDur = Random(10) + 2;
            int i;
            float fDelay;
            gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
            for(i = 1; i <= nDur; i++)
            {
                float fDistance = Random(2) ? DISTANCE_MEDIUM : DISTANCE_LARGE;
                location lLocation = GetRandomLocation(GetArea(oTarget), oTarget, fDistance);
                string sSummon = "nw_skeleton";
                AssignCommand(oWildMagicHelper, DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), lLocation)));
                AssignCommand(oWildMagicHelper, DelayCommand(fDelay, gsSPCreateObjectWrapper(OBJECT_TYPE_CREATURE, sSummon, lLocation)));
                fDelay += 0.3;
            }
            return;
        }
        break;
        case 85: {
            sSurgeName = "Sing!";
            int nEffectSing = VFX_DUR_BARD_SONG;
            effect eDust =  EffectVisualEffect(nEffectSing);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eDust,
                                oTarget,
                                RoundsToSeconds(d10(3) + 10));
        }
        break;
        case 86: {
            sSurgeName = "Fumble magic!";
            effect eEffectSpellFailure = EffectSpellFailure(90);
            effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
            effect eLink = EffectLinkEffects(eEffectSpellFailure, eVis);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLink,
                                oTarget,
                                RoundsToSeconds(2));
        }
        break;
        case 87:
            sSurgeName = "Web!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_WEB,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 88:
            sSurgeName = "Hand!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtObject(  SPELL_BIGBYS_INTERPOSING_HAND,
                                                                                oTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 89:
            sSurgeName = "Horn!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtObject(  SPELL_BALAGARNSIRONHORN,
                                                                                oWildMagicHelper,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 90:
            sSurgeName = "Earthquake!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_EARTHQUAKE,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 91:
            sSurgeName = "Knock!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_KNOCK,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 92:
            sSurgeName = "Reveal traps!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_FIND_TRAPS,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 93: {
            sSurgeName = "Curse!";
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                                            EffectCurse(2,2,2,2,2,2),
                                                                            oTarget));
        }
        break;
        case 94: {
            sSurgeName = "Satiate!";
            sSurgeTarget = "Self";
            oTarget = oCaster;
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEALING_L);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            gsSTAdjustState(GS_ST_REST, 100.0f);
            gsSTAdjustState(GS_ST_FOOD, 100.0f);
            gsSTAdjustState(GS_ST_WATER, 100.0f);
            gsSTAdjustState(GS_ST_SOBRIETY, 100.0f);
        }
        break;
        case 95:
            sSurgeName = "Contagion!";
            AssignCommand(oWildMagicHelper, ActionCastFakeSpellAtObject(SPELL_CONTAGION,
                                                                                oTarget,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT));
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                                            EffectDisease(DISEASE_BURROW_MAGGOTS),
                                                                            oTarget));
        break;
        case 96: {
            sSurgeName = "Drunk!";
            sSurgeTarget = "Self";
            oTarget = oCaster;
            effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEALING_L);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
            if(gsSTGetState(GS_ST_SOBRIETY) >= 50.0f){
                gsSTAdjustState(GS_ST_SOBRIETY, -120.0f);
            } else {
                gsSTAdjustState(GS_ST_SOBRIETY, -60.0f);
            }
        }
        break;
        case 97: {
            sSurgeName = "Invisibility!";
            int nTurns = 10;
            effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
            effect eConcealment = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
            effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);

            effect eLink = EffectLinkEffects(eInvisibility, eConcealment);
            eLink = EffectLinkEffects(eVis, eLink);

            SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_IMPROVED_INVISIBILITY, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oTarget, TurnsToSeconds(nTurns));
        }
        break;
        case 98: {
            sSurgeName = "Restoration!";
            //Declare major variables
            effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
            int bValid;

            effect eBad = GetFirstEffect(oTarget);
            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
                if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                    GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                    GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                    GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
                    GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                    GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                    GetEffectType(eBad) == EFFECT_TYPE_POISON ||
                    GetEffectType(eBad) == EFFECT_TYPE_DISEASE
                        )
                    {
                        //Remove effect if it is negative.
                        RemoveEffect(oTarget, eBad);
                    }
                eBad = GetNextEffect(oTarget);
            }
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
        }
        break;
        case 99:  {
            sSurgeName = "Light!";
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                                RADIUS_SIZE_HUGE,
                                                lTarget, TRUE,
                                                OBJECT_TYPE_CREATURE);

            while (GetIsObjectValid(oTarget))
            {
                int nTurns = 30;
                effect eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);

                effect eLink = eVis;

                SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_LIGHT, FALSE));

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLink, oTarget, TurnsToSeconds(nTurns));

                // Get the next target within the spell shape.
                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                            RADIUS_SIZE_HUGE,
                                            lTarget, TRUE,
                                            OBJECT_TYPE_CREATURE);
            }
        }
        break;
        case 100:
            sSurgeName = "Fireworks!";
                    AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_MASS_BLINDNESS_AND_DEAFNESS,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        default:
            sSurgeName = "Scripting error!";
            sSurgeTarget = "What?";
        break;
    }
    gsSPMagicSurgeCallback(oWildMagicHelper, oCaster, sSurgeName, sSurgeTarget);
}