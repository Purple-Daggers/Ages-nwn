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
    int nDC          = GetSpellSaveDC();

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpell));

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell)) return;

    //saving throw check
    if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_FORT)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectLinkEffects(
                EffectBlindness(),
                EffectDeaf()));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_BLIND_DEAF_M),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}
