#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    int nSpell     = GetSpellId();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //apply
    if (GetIsDead(oTarget))
    {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectVisualEffect(VFX_IMP_RAISE_DEAD),
                EffectResurrection()),
            oTarget);
    }
}

