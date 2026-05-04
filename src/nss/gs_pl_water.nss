#include "gs_inc_state"
#include "gs_inc_text"

void gsDrink(int nQuality)
{
    gsSTAdjustState(GS_ST_WATER, 50.0);

    if (Random(100) >= nQuality)
    {
        effect eEffect = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DISEASE_S),
                                           EffectDisease(DISEASE_FILTH_FEVER));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, OBJECT_SELF);
    }
}
//----------------------------------------------------------------
void main()
{
    object oUser = GetLastUsedBy();
    int nQuality = GetLocalInt(OBJECT_SELF, "GS_QUALITY");

    AssignCommand(oUser, ActionSpeakString(GS_T_16777236));
    AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    AssignCommand(oUser, ActionDoCommand(gsDrink(nQuality)));
}
