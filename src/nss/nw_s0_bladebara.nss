#include "gs_inc_spell"

void main()
{
    object oCaster   = GetAreaOfEffectCreator();
    object oTarget   = GetEnteringObject();
    effect eEffect;
    int nSpell       = gsSPGetSpellID();
    int nCasterLevel = GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic   = GetMetaMagicFeat();
    int nDC          = GetSpellSaveDC();
    int nValue       = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //resistance check
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //saving throw check
    nValue = GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster);

    if (nValue > 0)
    {
        //apply
        eEffect = EffectDamage(nValue, DAMAGE_TYPE_SLASHING);
        gsSPApplyEffect(oTarget, eEffect, nSpell);
    }
    else
    {
        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
    }
}

