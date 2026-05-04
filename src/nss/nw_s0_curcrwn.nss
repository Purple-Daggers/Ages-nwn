#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    effect eEffect;
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic     = GetMetaMagicFeat();
    int nValue         = gsSPGetDamage(4, 8, nMetaMagic, nCasterLevel);

    if (nMetaMagic != METAMAGIC_EMPOWER &&
        GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nValue += nValue / 2;
    }

    if (gsSPGetIsUndead(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

            //attack check
            if (TouchAttackMelee(oTarget) > 0)
            {
                //resistance check
                if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell))
                {
                    //apply
                    eEffect =
                        EffectLinkEffects(
                            EffectVisualEffect(VFX_IMP_SUNSTRIKE),
                            EffectDamage(nValue, DAMAGE_TYPE_DIVINE));

                    gsSPApplyEffect(oTarget, eEffect, nSpell);
                }
            }
        }
    }
    else
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_IMP_HEALING_G),
                    EffectHeal(nValue));

            gsSPApplyEffect(oTarget, eEffect, nSpell);
        }
    }
}
