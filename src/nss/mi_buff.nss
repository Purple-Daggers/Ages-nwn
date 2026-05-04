// Name: mi_buff
// Author: Mithreas
// Description: Called by spell scripts that summon creatures, to buff them
// based on caster abilities as follows.
// * If the summoned creature is undead, the script looks for Necromancy focuses
// * Otherwise the script looks for Conjuration focuses.
// For every focus the summoned creature gets +1 level (so epic spell focus
// grants +3 levels to all summoned creatures).
//
// The script can either be called on a henchman, or called on a caster. If the
// latter, the target is the caster's summon.
void main()
{
  object oTarget = OBJECT_SELF;
  if (!GetIsObjectValid(GetMaster(OBJECT_SELF)))
  {
    // This is a caster. Target should be their summon.
    oTarget = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF);
  }

  int nRacialType = GetRacialType(oTarget);

  int nBonus = 0;
  object oCaster = GetMaster(oTarget);
  if (nRacialType == RACIAL_TYPE_UNDEAD)
  {
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster))
    {
      nBonus = 3;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster))
    {
      nBonus = 2;
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster))
    {
      nBonus = 1;
    }
  }
  else
  {
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
    {
      nBonus = 3;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
    {
      nBonus = 2;
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCaster))
    {
      nBonus = 1;
    }
  }

  if (!nBonus) return;

  effect eBuff = EffectTemporaryHitpoints(8 * nBonus);
  eBuff = EffectLinkEffects(EffectAttackIncrease(nBonus), eBuff);
  eBuff = EffectLinkEffects(EffectACIncrease(nBonus), eBuff);
  eBuff = SupernaturalEffect(eBuff);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oTarget);

}
