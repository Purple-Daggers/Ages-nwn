//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons an adult red dragon for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////
#include "x2_inc_toollib"

#include "x2_inc_spellhook"
void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    // Changed by Mithreas to: increase duration, select colour of dragon based
    // on summoner.
    // Palemasters summon dracoliches
    // RDDs and evil chars summon reds
    // Goods summon silvers
    // Neutrals summon prismatics
    // The first of the above conditions applies (i.e. a good RDD gets red).
    int nDuration = 30 + Random(41);
    effect eSummon;
    effect eVis = EffectVisualEffect(460);
    string sResRef;
    object oCaster = OBJECT_SELF;
    if (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) > 0)
    {
      sResRef = "mi_sum_dracolich";
    }
    else if ((GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL) ||
        (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oCaster) > 0))
    {
      sResRef = "x2_s_drgred001";
    }
    else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
    {
      sResRef = "mi_sum_silv_drg";
    }
    else
    {
      sResRef = "mi_sum_pris_drg";
    }

    eSummon = EffectSummonCreature(sResRef,481,0.0f,TRUE);

    // * make it so dragon cannot be dispelled
    eSummon = ExtraordinaryEffect(eSummon);
    //Apply the summon visual and summon the dragon.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,GetSpellTargetLocation()));

    // Added by Mithreas - buff creatures based on caster specialty.
    DelayCommand(1.0, ExecuteScript("mi_buff", oCaster));
}


