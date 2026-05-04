#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    float fDelay       = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 10) nCasterLevel = 10;
    int nMetaMagic     = GetMetaMagicFeat();
    int nDC            = GetSpellSaveDC();
    int nValue         = 0;

    oTarget            = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget))
        {
            fDelay = gsSPGetRandomDelay();

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, fDelay))
            {
                nValue = gsSPGetDamage(nCasterLevel, 10, nMetaMagic);

                //saving throw check
                nValue = GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY);

                if (nValue > 0)
                {
                    //apply
                    eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_ELECTRICAL));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }
}
