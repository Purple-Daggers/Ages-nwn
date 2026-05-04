#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nMetaMagic   = GetMetaMagicFeat();
    int nDC          = GetSpellSaveDC();
    int nDuration    = nMetaMagic == METAMAGIC_EXTEND ? 4 : 2;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    //affection check
    if (! gsSPGetIsHumanoid(oTarget)) return;
    if (GetHitDice(oTarget) > 5)      return;

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell)) return;

    //saving throw check
    if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS)) return;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),
                EffectDazed()));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_DAZED_S),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}
