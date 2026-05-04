#include "gs_inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();
    int nMetaMagic = GetMetaMagicFeat();
    int nDC        = GetSpellSaveDC();
    int nHD        = GetHitDice(oTarget);

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //resistance check
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    if (nHD <= 6)
    {
        if (nHD <= 3 ||
            gsSPSavingThrow(oCaster,           oTarget,
                            nSpell,            nDC,
                            SAVING_THROW_FORT, SAVING_THROW_TYPE_DEATH))
        {
            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_IMP_DEATH),
                    EffectDeath());

            gsSPApplyEffect(oTarget, eEffect, nSpell);
        }
    }

    if (! GetIsDead(oTarget))
    {
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
        {
            gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        }
        else
        {
            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY),
                    EffectDamage(
                        gsSPGetDamage(1, 10, nMetaMagic),
                        DAMAGE_TYPE_ACID));

            gsSPApplyEffect(oTarget, eEffect, nSpell);
        }
    }
}
