#include "gs_inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();
    int nMetaMagic = GetMetaMagicFeat();
    int nDC        = GetSpellSaveDC();

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //resistance check
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //apply
    if (! gsSPSavingThrow(oCaster, oTarget, nSpell, nDC, SAVING_THROW_FORT, SAVING_THROW_TYPE_ACID))
    {
        eEffect = EffectMovementSpeedDecrease(50);
        gsSPApplyEffect(oTarget, eEffect, nSpell, GS_SP_DURATION_PERMANENT);
    }

    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_S),
            EffectDamage(
                gsSPGetDamage(4, 6, nMetaMagic),
                DAMAGE_TYPE_ACID));

    gsSPApplyEffect(oTarget, eEffect, nSpell);
}
