#include "gs_inc_text"
#include "gs_inc_spell"

void main()
{

    if (gsSPGetOverrideSpell()) return;

    object oCaster      = GetLastSpellCaster();
    object oTarget      = GetSpellTargetObject();

    SetLocalInt(oTarget, "AS_SUPPRESS_SURGE", TRUE);

    AssignCommand(oTarget, SpeakString(GS_T_16777236));
    effect eVisualEffect = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    if (oCaster != oTarget)
    {
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
        AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget));
    }
    else
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualEffect, oTarget);
    }
}
