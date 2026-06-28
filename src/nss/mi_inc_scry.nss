#include "gs_inc_time"
#include "gs_inc_common"
// Returns true if a PC is in an area protected against scrying.
int IsProtected(object oPC);
// Stop scrying. Call via DelayCommand.
void stopscry(object oPC);
// Returns TRUE if the PC can use scrying.
int GetCanScry(object oPC);
// Returns TRUE if the area the PC is in is protected from scrying.
int IsProtected(object oPC);
// Fades the PC out and in again.
void blackout(object oPC);
// Remove scrying-related invis effects.
void removeinvis(object oPC);
int IsProtected(object oPC)
{
  object oProtector = GetNearestObjectByTag("scry_protector", oPC);

  if (GetArea(oProtector) == GetArea(oPC))
  {
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

void blackout(object oPC)
{
  FadeToBlack(oPC,FADE_SPEED_SLOW);
  DelayCommand(2.0,FadeFromBlack(oPC,FADE_SPEED_SLOW));
}

void Scrying(object oPC,object oTarg){

   int magelevel=GetLevelByClass(CLASS_TYPE_WIZARD,oPC)+GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
      /*
  if(GetDistanceBetween(oPC,oTarg)<2.0){
  SendMessageToPC(oPC,"You can't scry upon someone so close to you!");
  return;
  }     */
  if(GetHasSpellEffect(SPELL_SANCTUARY,oTarg) || GetHasSpellEffect(SPELL_INVISIBILITY,oTarg)
         ||GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE,oTarg) ||GetHasSpellEffect(SPELL_TRUE_SEEING,oTarg)
         ||GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY,oTarg) || IsProtected(oTarg))
         {
         blackout(oPC);
         SendMessageToPC(oPC,"You see nothing.");
         SendMessageToPC(oPC,"Scrying has failed: the target is warded against such divination.");
         return;
         }

  // Scry once per game day.
  int nTimestamp = gsTIGetActualTimestamp();
  int nTimeout   = GetLocalInt(oPC, "MI_SCRY_TIMEOUT");
  if (!nTimeout) nTimeout = GetCampaignInt("MI_SCRY_TIMEOUT", gsPCGetPlayerID(oPC));

  int bCanScry     = 0;

  if (nTimeout < nTimestamp)
  {
    nTimeout = nTimestamp + 28800; //TIME UPDATE: 8 hours

    SetLocalInt(oPC, "MI_SCRY_TIMEOUT", nTimeout);
    SetCampaignInt("MI_SCRY_TIMEOUT", gsPCGetPlayerID(oPC), nTimeout);
    bCanScry = 1;
  }

  if(bCanScry)
  {
    float scrydur=62.0;

    location pcLocation=GetLocation(oPC);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectInvisibility(EFFECT_TYPE_INVISIBILITY),
                        oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                        oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectCutsceneGhost(),
                        oPC);
    DelayCommand(scrydur, stopscry(oPC));

    object oCopy = CopyObject(oPC,pcLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    SetLocalObject(oPC, "pccopy", oCopy);

    //@@@ Improve this.
       if(GetCasterLevel(oPC)<=GetCasterLevel(oTarg))
         if(d4()>2)
          SendMessageToPC(oTarg,"You sense you are being watched from afar.");

    AssignCommand(oCopy,
                  ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,
                  0.2,
                  3600.00));
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                        oCopy,
                        3600.0);
    SetImmortal(oCopy,TRUE);
    SetCutsceneMode(oPC,TRUE);

    blackout(oPC);
    DelayCommand(1.0,AssignCommand(oPC,ActionJumpToObject(oTarg,FALSE)));
    DelayCommand(2.0,AssignCommand(oPC,ActionForceFollowObject(oTarg,1.0)));

    SetPlotFlag(oPC,TRUE);
  }
  else
  {
    SendMessageToPC(oPC,"You cannot use this ability again, yet.");
  }
}

void removeinvis(object oPC)
{
  effect eRemove=GetFirstEffect(oPC);
  int eType=GetEffectType(eRemove);
  while (GetIsEffectValid(eRemove))
  {
    if(eType==EFFECT_TYPE_VISUALEFFECT ||
       eType==SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE ||
       eType==EFFECT_TYPE_CUTSCENEGHOST ||
       eType==EFFECT_TYPE_INVISIBILITY ||
       eType==EFFECT_TYPE_ETHEREAL )
    {
         RemoveEffect(oPC, eRemove);
    }
   eRemove=GetNextEffect(oPC);
   eType=GetEffectType(eRemove);
 }
}

void stopscry(object oPC)
{
  AssignCommand(oPC, ClearAllActions(TRUE));          // doesn't work
  object oCopy = GetLocalObject(oPC, "pccopy");
  location pcLocation = GetLocation(oCopy);

  // debug code
  //WriteTimestampedLogEntry("Found copy: " + GetName(oCopy));

  SetImmortal(oCopy, FALSE);
  DestroyObject(oCopy, 0.0);

  DelayCommand(2.0, removeinvis(oPC));
  SetPlotFlag(oPC,FALSE);
  DelayCommand(1.2, AssignCommand(oPC, ActionJumpToLocation(pcLocation))); // doesn't work
  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                      EffectDamage(GetMaxHitPoints(oCopy)-GetCurrentHitPoints(oCopy),
                      DAMAGE_TYPE_POSITIVE,
                      DAMAGE_POWER_NORMAL),
                      oPC);

  blackout(oPC);
  DelayCommand(3.0, SetCutsceneMode(oPC,FALSE));
}

int GetCanScry(object oPC)
{
  if (GetLevelByClass(CLASS_TYPE_WIZARD,oPC) || GetLevelByClass(CLASS_TYPE_SORCERER,oPC))
  {
     return (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC));
  }

  return FALSE;
}
