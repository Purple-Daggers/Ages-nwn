#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = nCasterLevel / 2;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    if (nDuration < 1)                  nDuration  = 1;

    //apply
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID),
        lLocation);
    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectAreaOfEffect(AOE_PER_FOGACID),
        lLocation,
        RoundsToSeconds(nDuration));
}
