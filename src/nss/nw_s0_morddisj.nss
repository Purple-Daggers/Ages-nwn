#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    effect eEffect1;
    effect eEffect2    =
        ExtraordinaryEffect(
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
                EffectSpellResistanceDecrease(10)));
    effect eVisual1    = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect eVisual2    = EffectVisualEffect(VFX_IMP_BREACH);
    float fDuration    = RoundsToSeconds(10);
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nHarmful       = FALSE;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION),
        lLocation);

    if (GetIsObjectValid(oTarget))
    {
        //raise event
        nHarmful  = ! GetIsReactionTypeFriendly(oTarget);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

        //apply
        eEffect1  = EffectLinkEffects(eVisual1, EffectDispelMagicAll(nCasterLevel));
        gsSPApplyEffect(oTarget, eEffect1, nSpell);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oTarget);
        gsSPApplySpellBreach(oTarget, 6);
        gsSPApplyEffect(oTarget, eEffect2, nSpell, fDuration);
    }
    else
    {
        int nType = OBJECT_TYPE_SPELLTARGET | OBJECT_TYPE_AREA_OF_EFFECT;
        oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        eEffect1  = EffectDispelMagicBest(nCasterLevel);
        eEffect1  = EffectLinkEffects(eVisual1, EffectLinkEffects(eEffect1, eEffect1));

        while (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:
                gsSPDispelAreaOfEffect(OBJECT_SELF, oTarget);
                break;

            default:

                //raise event
                nHarmful = ! GetIsReactionTypeFriendly(oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

                //apply
                gsSPApplyEffect(oTarget, eEffect1, nSpell);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oTarget);
                gsSPApplySpellBreach(oTarget, 2);
                gsSPApplyEffect(oTarget, eEffect2, nSpell, fDuration);
            }

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        }
    }
}
