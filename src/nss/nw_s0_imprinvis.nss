#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect1;
    effect eEffect2;
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
    eEffect1 =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectInvisibility(INVISIBILITY_TYPE_NORMAL));
    eEffect2 =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_INVISIBILITY),
                EffectConcealment(50)));

    gsSPApplyEffect(
        oTarget,
        eEffect1,
        nSpell,
        RoundsToSeconds(nDuration)); //1 round per level instead of 1 turn per level
    gsSPApplyEffect(
        oTarget,
        eEffect2,
        nSpell,
        TurnsToSeconds(nDuration));
}


