#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration  = 24;

    //affection check
    if (oTarget != GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION))          return;
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //stack check
    if (GetHasSpellEffect(nSpell, oTarget))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        SupernaturalEffect(
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                EffectLinkEffects(
                    EffectAttackIncrease(2),
                    EffectLinkEffects(
                        EffectAbilityIncrease(
                            ABILITY_WISDOM,
                            gsSPGetDamage(1, 10, nMetaMagic)),
                        EffectLinkEffects(
                            EffectAbilityIncrease(ABILITY_CONSTITUTION, 4),
                            EffectAbilityIncrease(ABILITY_STRENGTH, 4))))));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HOLY_AID),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        HoursToSeconds(nDuration));
}
