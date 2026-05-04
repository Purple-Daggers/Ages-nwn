#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectAbilityIncrease(ABILITY_STRENGTH, gsSPGetDamage(1, 4, nMetaMagic, 1)));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        HoursToSeconds(nDuration));
}
