#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nSpell         = GetSpellId();
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);

    // Addition by Mithreas - set caster level for spells cast using subrace
    // abilities. --[
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "GS_SU_ABILITY")
    {
      nCasterLevel = GetHitDice(GetItemPossessor(oItem));
    }
    // ]-- end addition.
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectAreaOfEffect(AOE_PER_DARKNESS),
        lLocation,
        RoundsToSeconds(nDuration));
}
