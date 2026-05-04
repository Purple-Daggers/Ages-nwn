#include "gs_inc_spell"

void main()
{
    object oCaster   = GetAreaOfEffectCreator();
    object oTarget   = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_SPELLTARGET);
    effect eEffect;
    float fDelay     = 0.0;
    int nSpell       = gsSPGetSpellID();
    int nCasterLevel = GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic   = GetMetaMagicFeat();
    int nDC          = GetSpellSaveDC();
    int nValue       = 0;

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
                nValue = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

                //saving throw check
                nValue = GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster);

                if (nValue > 0)
                {
                    //apply
                    eEffect = EffectDamage(nValue, DAMAGE_TYPE_SLASHING);
                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
            }
        }

        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_SPELLTARGET);
    }
}
