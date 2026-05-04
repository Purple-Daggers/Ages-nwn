/*
  Standard include utility for scripts involving disguised PCs.
  Author: Mithreas
*/
#include "gs_inc_subrace"
const string DISGUISED = "disguised";

// Internal convenience method.
void p_ChangeAppearance(object oPC, int nAppearance);

// The disguised character makes a Perform or Bluff check, opposed by the
// Spot check of the spotter.  Returns TRUE if the spotter wins.
// nMultiplier is intended to be used to "weight" the decision in favour of the
// spotter - ideally, the calling code should set it to the number of times
// this NPC has tried to recognise this PC. Negative multipliers are ignored.
int SeeThroughDisguise(object oDisguised, object oSpotter, int nMultiplier = 0);

// Disguises a PC, changing their appearance by subrace.
void DisguisePC(object oPC);

// Undisguises a PC, returning their appearance to normal.
void UnDisguisePC(object oPC);

// Returns true if the PC has concealed their appearance.
int GetIsPCDisguised(object oPC);

/*
  Change the appearance of the specified creature.
*/
void p_ChangeAppearance(object oPC, int nAppearance)
{
  SetCreatureAppearanceType(oPC, nAppearance);
  FloatingTextStringOnCreature("You have successfully (un)disguised yourself.",
                                                                           oPC);
}

/*
  The disguised character makes a Perform or Bluff check, opposed by the
  Spot check of the spotter.  sDescription is given to any PCs involved
  as a server message.

  nMultiplier is intended to be used to "weight" the decision in favour of the
  spotter - ideally, the calling code should set it to the number of times
  this NPC has tried to recognise this PC. Negative multipliers are ignored.
*/
int SeeThroughDisguise(object oDisguised,
                       object oSpotter,
                       int    nMultiplier = 0)
{

  int nPerform = GetSkillRank(SKILL_PERFORM, oDisguised);
  int nBluff   = GetSkillRank(SKILL_BLUFF,   oDisguised);
  int nSpot    = GetSkillRank(SKILL_SPOT,    oSpotter);
  int nResult  = 0;

  if (nPerform > nBluff)
  {
    nResult = ( (d20() + nPerform) < (d20(nMultiplier) + nSpot) );
  }
  else
  {
    nResult = ( (d20() + nBluff) < (d20(nMultiplier) + nSpot) );
  }

  if (nResult)
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, "<cþ  >Recognised!");
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, "<cVþ >Recognised!");
    }
  }
  else
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, "<cVþ >Not recognised!");
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, "<cþ  >Not recognised!");
    }
  }

  return nResult;
}

/* Uility function to remove the disguise from a PC */
void UnDisguisePC(object oPC)
{
    // If the creature is disguised, get its base type and restore its
    // appearance accordingly.
    int nPCType = GetRacialType(oPC);
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

    switch (nPCType)
    {
      case RACIAL_TYPE_DWARF:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_DWARF);
        break;
      case RACIAL_TYPE_ELF:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_ELF);
        break;
      case RACIAL_TYPE_GNOME:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_GNOME);
        break;
      case RACIAL_TYPE_HALFELF:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALF_ELF);
        break;
      case RACIAL_TYPE_HALFLING:
        switch (nSubRace)
        {
          case GS_SU_SPECIAL_FEY:
            SendMessageToPC(oPC, "You're a fairy. You can't disguise yourself.");
            return;
          case GS_SU_SPECIAL_GOBLIN:
            p_ChangeAppearance(oPC, APPEARANCE_TYPE_GOBLIN_A);
            break;
          case GS_SU_SPECIAL_KOBOLD:
            p_ChangeAppearance(oPC, APPEARANCE_TYPE_KOBOLD_A);
            break;
          default:
            p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALFLING);
            break;
        }
        break;
      case RACIAL_TYPE_HALFORC:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALF_ORC);
        break;
      case RACIAL_TYPE_HUMAN:
        p_ChangeAppearance(oPC, APPEARANCE_TYPE_HUMAN);
        break;
      // Ignore all other racial types.
    }

    // Note that the PC is not disguised.
    SetLocalInt(oPC, DISGUISED, 0);
}

/* Utility function to disguise a PC */
void DisguisePC(object oPC)
{
    int nPCType = GetRacialType(oPC);
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

    if (GetGender(oPC) == GENDER_MALE)
    {
      // Male disguises.
      switch (nPCType)
      {
        case RACIAL_TYPE_DWARF:
          switch (nSubRace)
          {
            case GS_SU_DWARF_GRAY:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DUERGAR_CHIEF);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DWARF_NPC_MALE);
              break;
          }
          break;
        case RACIAL_TYPE_ELF:
          switch (nSubRace)
          {
            case GS_SU_ELF_DROW:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DROW_WARRIOR_1);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_ELF_NPC_MALE_02);
              break;
          }
          break;
        case RACIAL_TYPE_GNOME:
          switch (nSubRace)
          {
            case GS_SU_GNOME_DEEP:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_SVIRF_MALE);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_GNOME_NPC_MALE);
              break;
          }
          break;
        case RACIAL_TYPE_HALFELF:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HUMAN_NPC_MALE_04);
          break;
        case RACIAL_TYPE_HALFLING:
          switch (nSubRace)
          {
            case GS_SU_SPECIAL_FEY:
              SendMessageToPC(oPC, "You're a fairy. You can't disguise yourself.");
              return;
            case GS_SU_SPECIAL_GOBLIN:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_GOBLIN_CHIEF_B);
              break;
            case GS_SU_SPECIAL_KOBOLD:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_KOBOLD_CHIEF_A);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALFLING_NPC_MALE);
              break;
          }
          break;
        case RACIAL_TYPE_HALFORC:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01);
          break;
        case RACIAL_TYPE_HUMAN:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HUMAN_NPC_MALE_04);
          break;
        // Ignore all other racial types.
      }
    }
    else
    {
      // Female disguises.
      switch (nPCType)
      {
        case RACIAL_TYPE_DWARF:
          switch (nSubRace)
          {
            case GS_SU_DWARF_GRAY:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DUERGAR_SLAVE);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DWARF_NPC_FEMALE);
              break;
          }
          break;
        case RACIAL_TYPE_ELF:
          switch (nSubRace)
          {
            case GS_SU_ELF_DROW:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_DROW_FEMALE_1);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_ELF_NPC_FEMALE);
              break;
          }
          break;
        case RACIAL_TYPE_GNOME:
          switch (nSubRace)
          {
            case GS_SU_GNOME_DEEP:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_SVIRF_FEMALE);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_GNOME_NPC_FEMALE);
              break;
          }
          break;
        case RACIAL_TYPE_HALFELF:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03);
          break;
        case RACIAL_TYPE_HALFLING:
          switch (nSubRace)
          {
            case GS_SU_SPECIAL_FEY:
              SendMessageToPC(oPC, "You're a fairy. You can't disguise yourself.");
              return;
            case GS_SU_SPECIAL_GOBLIN:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_GOBLIN_SHAMAN_B);
              break;
            case GS_SU_SPECIAL_KOBOLD:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_KOBOLD_CHIEF_B);
              break;
            default:
              p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALFLING_NPC_FEMALE);
              break;
          }
          break;
        case RACIAL_TYPE_HALFORC:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE);
          break;
        case RACIAL_TYPE_HUMAN:
          p_ChangeAppearance(oPC, APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03);
          break;
        // Ignore all other racial types.
      }
    }
    // Note that the PC is disguised.
    SetLocalInt(oPC, DISGUISED, 1);
}

int GetIsPCDisguised(object oPC)
{
  return GetLocalInt(oPC, DISGUISED);
}

int GetCanPCDisguiseSelf(object oPC)
{
  int nBluff = GetSkillRank(SKILL_BLUFF, oPC, FALSE);
  int nPerform = GetSkillRank(SKILL_PERFORM, oPC, FALSE);

  if (nBluff >= 20 || nPerform >= 20) return TRUE;
  return FALSE;
}
