#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = nCasterLevel / 3;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    if (nDuration < 1)                  nDuration  = 1;

    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL),
        lLocation,
        RoundsToSeconds(nDuration));
}


