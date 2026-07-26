/* SPELL Library by Gigaschatten */

//void main() {}

#include "gs_inc_combat2"
#include "x2_inc_spellhook"
#include "x0_i0_position"

const float GS_SP_DURATION_INSTANT        = -1.0;
const float GS_SP_DURATION_PERMANENT      = -2.0;

const int GS_SP_TYPE_BENEFICIAL           =  1;
const int GS_SP_TYPE_BENEFICIAL_SELECTIVE =  2;
const int GS_SP_TYPE_HARMFUL              =  3;
const int GS_SP_TYPE_HARMFUL_SELECTIVE    =  4;

const int OBJECT_TYPE_SPELLTARGET         = 73; //OBJECT_TYPE_CREATURE
                                                //OBJECT_TYPE_DOOR
                                                //OBJECT_TYPE_PLACEABLE;

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
    if(nForceSurge > 0)
    {
        nSurge = nForceSurge;
    }
    switch(nSurge){
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
            sSurgeName = "Summon!";
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

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
                                lTargetLoc);

            CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
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
                                oCaster,
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
                object oGem = CreateItemOnObject(sResRef,
                                oTarget);
                if (GetIsObjectValid(oGem) == FALSE)
                {
                    sResRef = GetStringUpperCase(sResRef);
                    oGem = CreateItemOnObject(sResRef, oTarget);
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
        case 16:
        case 17:
        case 18:
        case 19:
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

        //Make a ranged touch attack
        if (nDamage > 0 && TouchAttackRanged(oTarget) > 0) {
            effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING,
                                           oCaster,
                                           BODY_NODE_HAND);
            effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
            effect eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLightning,
                                oTarget,
                                1.7);
            }
        }
        break;
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
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
        case 29:
        case 30:
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
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
        case 39:
        case 40:
        case 41:
        case 42:
        case 43:
        case 44:
        case 45:
        case 46:
        case 47:
        case 48:
        case 49:
        case 50:
            sSurgeName = "Grease!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_GREASE,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
        case 56:
        case 57:
        case 58:{
            sSurgeName = "Detect Thoughts!";
            int nRounds = d4();
            int nLimit = nRounds * 5;

            effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

            //Link the visual and the damage reduction effect
            effect eLink = EffectLinkEffects(ePrem, eVis);

            //Fire cast spell at event for the specified target
            SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_PREMONITION, FALSE));

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink, oCaster, RoundsToSeconds(nRounds));
        }
        break;
        case 59:
        case 60:
        case 61:
        case 62:
        case 63:
        case 64:
        case 65:
        case 66:
        case 67:
        case 68:
            sSurgeName = "Greater missile storm!";
            AssignCommand(oWildMagicHelper, ActionCastSpellAtLocation(  SPELL_ISAACS_GREATER_MISSILE_STORM,
                                                                                lTarget,
                                                                                METAMAGIC_NONE,
                                                                                TRUE,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT,
                                                                                TRUE));
        break;
        case 69:
        case 70:
        case 71:
        case 72:
        case 73:
        case 74:
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
        case 76:
        case 77:
        case 78:
        case 79:
        case 80:
        case 81:
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
        case 83:
        case 84:
        case 85:
        case 86:
        case 87:
        case 88:
        case 89:
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
        case 92:
        case 93:
        case 94:
        case 95:
            sSurgeName = "Contagion!";
            AssignCommand(oWildMagicHelper, ActionCastFakeSpellAtObject(SPELL_CONTAGION,
                                                                                oTarget,
                                                                                PROJECTILE_PATH_TYPE_DEFAULT));
            AssignCommand(oWildMagicHelper, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                                            EffectDisease(DISEASE_BURROW_MAGGOTS),
                                                                            oTarget));
        break;
        case 96:
        case 97:
        case 98:
        case 99:
        case 100:
            sSurgeName = "Mass blindness!";
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