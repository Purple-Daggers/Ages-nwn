#include "gs_inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_SPELLTARGET);
    effect eEffect;
    effect eVisual = EffectVisualEffect(VFX_IMP_ACID_S);
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
                //apply
                eEffect =
                    EffectLinkEffects(
                        eVisual,
                        EffectDamage(
                            gsSPGetDamage(2, 6, nMetaMagic),
                            DAMAGE_TYPE_ACID));

                DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
            }
        }

        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_SPELLTARGET);
    }
}
