#include "gs_inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject();
    effect eEffect;
    effect eVisual = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    float fDelay   = 0.0;
    int nSpell     = gsSPGetSpellID();
    int nMetaMagic = GetMetaMagicFeat();

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget))
        {
            fDelay = gsSPGetRandomDelay();

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

            //resistance check
            if (! gsSPResistSpell(oCaster, oTarget, nSpell, fDelay))
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
                            eVisual,
                            EffectDamage(
                                gsSPGetDamage(1, 10, nMetaMagic),
                                DAMAGE_TYPE_ACID));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
            }
        }

        oTarget = GetNextInPersistentObject();
    }
}
