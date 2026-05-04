#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    string sResRef     = "";
    int nCasterLevel   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = GetMetaMagicFeat();
    int nDuration      = 24;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    if (nCasterLevel <= 11)      sResRef = "NW_S_GHOUL";
    else if (nCasterLevel <= 13) sResRef = "NW_S_GHAST";
    else if (nCasterLevel <= 15) sResRef = "NW_S_WIGHT";
    else                         sResRef = "NW_S_SPECTRE";

    int nCount = 0;
    object oCreature;

    // change by Mithreas to allow epic necromancers to summon up to 2 minions.
    if (GetIsPC(OBJECT_SELF) && // Giving henchmen to NPCs has some odd effects.
        GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, OBJECT_SELF))
    {
      AssignCommand(OBJECT_SELF, SetMaxHenchmen(2));
      for (nCount = 0; nCount < 2; nCount++)
      {
        oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
          GetSpellTargetLocation(), TRUE);
        AssignCommand(oCreature, SetIsDestroyable(TRUE,FALSE,FALSE));
        AssignCommand(OBJECT_SELF, AddHenchman(OBJECT_SELF, oCreature));

        // Added by Mithreas - buff creatures based on caster specialty.
        DelayCommand(1.0, ExecuteScript("mi_buff", oCreature));
      }
    }
    else
    {
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
            EffectSummonCreature(sResRef,VFX_NONE, 0.5, TRUE),
                            GetSpellTargetLocation());

      // Added by Mithreas - buff creatures based on caster specialty.
      DelayCommand(1.0, ExecuteScript("mi_buff", OBJECT_SELF));
    }

    //Apply the summon visual.
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}

