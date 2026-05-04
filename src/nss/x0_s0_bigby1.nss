//::///////////////////////////////////////////////
//:: Bigby's Interposing Hand
//:: [x0_s0_bigby1]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants -10 to hit to target for 1 round / level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "nw_i0_spells"
#include "gs_inc_spell"
#include "gs_inc_text"


void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                                              SPELL_BIGBYS_INTERPOSING_HAND,
                                              TRUE));
        //Check for metamagic extend
        if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
        {
             nDuration = nDuration * 2;
        }
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
//edited part.
if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, GetRandomDelay()))
{
        effect eAC1 = EffectAttackDecrease(10, AC_DODGE_BONUS);
        effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
        effect eLink = EffectLinkEffects(eAC1, eVis);


        //Apply the TO HIT PENALTIES bonuses and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink,
                            oTarget,
                            RoundsToSeconds(nDuration));
}//
        }
    }
}

