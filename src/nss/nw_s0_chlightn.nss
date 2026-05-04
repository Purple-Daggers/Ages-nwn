#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTargetPrimary   = GetSpellTargetObject();
    object oTargetSecondary = OBJECT_INVALID;
    object oTargetPrevious  = OBJECT_INVALID;
    location lLocation      = GetLocation(oTargetPrimary);
    effect eEffect;
    float fDelay            = 0.0;
    int nSpell              = GetSpellId();
    int nCasterLevel        = GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic          = GetMetaMagicFeat();
    int nDC                 = GetSpellSaveDC();
    int nValue1             = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);
    int nValue2             = 0;
    int nNth                = 0;

    //affection check
    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTargetPrimary))
    {
        //raise event
        SignalEvent(oTargetPrimary, EventSpellCastAt(OBJECT_SELF, nSpell));

        //resistance check
        if (! gsSPResistSpell(OBJECT_SELF, oTargetPrimary, nSpell))
        {
            nValue2 = GetReflexAdjustedDamage(nValue1, oTargetPrimary, nDC, SAVING_THROW_TYPE_ELECTRICITY);

            if (nValue2 > 0)
            {
                //apply
                eEffect =
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_IMP_LIGHTNING_S),
                        EffectDamage(nValue2, DAMAGE_TYPE_ELECTRICAL));

                gsSPApplyEffect(oTargetPrimary, eEffect, nSpell);
            }
            else
            {
                gsC2AdjustSpellEffectiveness(nSpell, oTargetPrimary, FALSE);
            }
        }
    }

    //beam effect
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND),
        oTargetPrimary,
        0.4);

    oTargetPrevious   = oTargetPrimary;
    nValue1          /= 2;

    //secondary target
    oTargetSecondary  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

    while (GetIsObjectValid(oTargetSecondary) &&
           nNth < nCasterLevel)
    {
        //affection check
        if (oTargetSecondary != oTargetPrimary &&
            gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTargetSecondary))
        {
            fDelay          += 0.2;

            //raise event
            SignalEvent(oTargetSecondary, EventSpellCastAt(OBJECT_SELF, nSpell));

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTargetSecondary, nSpell, fDelay))
            {
                nValue2 = GetReflexAdjustedDamage(nValue1, oTargetSecondary, nDC, SAVING_THROW_TYPE_ELECTRICITY);

                if (nValue2 > 0)
                {
                    //apply
                    eEffect =
                        EffectLinkEffects(
                            EffectVisualEffect(VFX_IMP_LIGHTNING_S),
                            EffectDamage(nValue2, DAMAGE_TYPE_ELECTRICAL));

                    DelayCommand(fDelay, gsSPApplyEffect(oTargetSecondary, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTargetSecondary, FALSE);
                }
            }

            if (GetObjectType(oTargetSecondary) == OBJECT_TYPE_CREATURE) nNth++;

            //beam effect
            DelayCommand(
                fDelay,
                ApplyEffectToObject(
                    DURATION_TYPE_TEMPORARY,
                    EffectBeam(VFX_BEAM_LIGHTNING, oTargetPrevious, BODY_NODE_CHEST),
                    oTargetSecondary,
                    0.4));

            oTargetPrevious  = oTargetSecondary;
            fDelay          += 0.2;
        }

        oTargetSecondary = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }
}
