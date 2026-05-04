#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    object oTarget     = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    float fDuration    = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    fDuration          = RoundsToSeconds(nDuration);

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectAbilityIncrease(ABILITY_CONSTITUTION, 4),
                EffectLinkEffects(
                    EffectAbilityIncrease(ABILITY_DEXTERITY, 4),
                    EffectAbilityIncrease(ABILITY_STRENGTH, 4))));

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
        GetSpellTargetLocation());

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL_SELECTIVE, OBJECT_SELF, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                eVisual,
                oTarget);
            gsSPApplyEffect(
                oTarget,
                eEffect,
                nSpell,
                fDuration);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
    }
}
