#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    effect eEffect     = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 5) nCasterLevel = 5;
    int nHarmful       = FALSE;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),
        lLocation);

    if (GetIsObjectValid(oTarget))
    {
        //raise event
        nHarmful  = ! GetIsReactionTypeFriendly(oTarget);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

        //apply
        eEffect   = EffectLinkEffects(eEffect, EffectDispelMagicAll(nCasterLevel));
        gsSPApplyEffect(oTarget, eEffect, nSpell);
    }
    else
    {
        int nType = OBJECT_TYPE_SPELLTARGET | OBJECT_TYPE_AREA_OF_EFFECT;
        oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        eEffect   = EffectLinkEffects(eEffect, EffectDispelMagicBest(nCasterLevel));

        while (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:
                gsSPDispelAreaOfEffect(OBJECT_SELF, oTarget, 25 + nCasterLevel);
                break;

            default:

                //raise event
                nHarmful = ! GetIsReactionTypeFriendly(oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

                //apply
                gsSPApplyEffect(oTarget, eEffect, nSpell);
            }

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        }
    }
}
