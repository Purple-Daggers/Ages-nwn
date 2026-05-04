#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = GetMetaMagicFeat();
    int nDamage      = nCasterLevel / 2;
    int nDuration    = nCasterLevel;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //damage
    if (nDamage > 5)                    nDamage    = 5;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //remove damage shield
    if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_DEATH_ARMOR);
    }

    if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_ELEMENTAL_SHIELD);
    }

    if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_MESTILS_ACID_SHEATH);
    }

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(463),
                EffectDamageShield(nDamage, DAMAGE_BONUS_1d4, DAMAGE_TYPE_MAGICAL)));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}
