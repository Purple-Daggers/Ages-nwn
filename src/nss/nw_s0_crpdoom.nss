#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectAreaOfEffect(AOE_PER_CREEPING_DOOM),
        lLocation,
        RoundsToSeconds(nDuration));
}
