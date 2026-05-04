#include "gs_inc_spell"
#include "gs_inc_text"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    // Addition by Mithreas - set caster level for spells cast using subrace
    // abilities. --[
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "GS_SU_ABILITY")
    {
      // Svirfs use caster level = char level. Duergar get caster level = twice
      // char level.
      object oPC = GetItemPossessor(oItem);
      if (GetSubRace(oPC) == GS_T_16777264)
      {
        nCasterLevel = 2 * GetHitDice(oPC);
      }
      else
      {
        nCasterLevel = GetHitDice(oPC);
      }
    }
    // ]-- end addition.
    int nMetaMagic   = GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectInvisibility(INVISIBILITY_TYPE_NORMAL));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration)); //1 round per level instead of 1 turn per level
}
