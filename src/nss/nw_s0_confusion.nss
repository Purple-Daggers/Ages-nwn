#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    float fDelay       = 0.0;
    float fDuration    = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDC            = GetSpellSaveDC();
    int nDuration      = nCasterLevel;
    int nValue         = 0;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    fDuration          = RoundsToSeconds(nDuration);

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),
        lLocation);

    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED),
                EffectConfused()));

    oTarget            = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation);

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
                if (! gsSPSavingThrow(OBJECT_SELF,       oTarget,
                                      nSpell,            nDC,
                                      SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS,
                                      fDelay))
                {
                    DelayCommand(
                        fDelay,
                        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            eVisual,
                            oTarget));
                    DelayCommand(
                        fDelay,
                        gsSPApplyEffect(
                            oTarget,
                            eEffect,
                            nSpell,
                            fDuration));
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation);
    }
}
