#include "gs_inc_spell"
#include "gs_inc_text"

void gsTimestop()
{
    object oTarget = GetFirstObjectInArea();
    effect eEffect =
        ExtraordinaryEffect(
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),
                EffectCutsceneParalyze()));

    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            FloatingTextStringOnCreature(GS_T_16777432, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 9.0);
        }

        oTarget = GetNextObjectInArea();
    }
}
//----------------------------------------------------------------
void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell = GetSpellId();

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_TIME_STOP),
        GetLocation(OBJECT_SELF));

    DelayCommand(0.75, gsTimestop());
}

