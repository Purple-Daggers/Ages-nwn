// Character legality checker. Used to spot hacked characters.
//
// Known issues - doesn't check spells known (or spells per day).
// Doesn't check that all the feats a character has are legal for them (just
// that they have the right number of feats).

const int MAX_FEAT  = 426; // Very few after here, so do them by hand for perf
                           // reasons.
const int MAX_SKILL = 26;

// Returns TRUE if the PC is a completely legal first level character, false
// otherwise.
int miCharacterIsLegal(object oPC);

int miCharacterIsLegal(object oPC)
{
  int nClass = GetClassByPosition(1, oPC);
  int nRace  = GetRacialType(oPC);
  int nBaseHP;
  int nBaseSkillPoints;
  int nNumFeats = 1;

  int nFavouredAbilityScore = -1;
  int nBadAbilityScore1 = -1;
  int nBadAbilityScore2 = -1;

  switch (nClass)
  {
   case CLASS_TYPE_BARBARIAN:
     nBaseHP = 12;
     nBaseSkillPoints = 4;
     nNumFeats += 7;
     break;
   case CLASS_TYPE_BARD:
     nBaseHP = 6;
     nBaseSkillPoints = 4;
     nNumFeats += 6;
     break;
   case CLASS_TYPE_CLERIC:
     nBaseHP = 8;
     nBaseSkillPoints = 2;
     nNumFeats += 6;
     break;
   case CLASS_TYPE_DRUID:
     nBaseHP = 8;
     nBaseSkillPoints = 4;
     nNumFeats += 6;
     break;
   case CLASS_TYPE_FIGHTER:
     nBaseHP = 10;
     nBaseSkillPoints = 2;
     nNumFeats += 7; // Including bonus feat at first level.
     break;
   case CLASS_TYPE_MONK:
     nBaseHP = 8;
     nBaseSkillPoints = 4;
     nNumFeats += 7;
     break;
   case CLASS_TYPE_PALADIN:
     nBaseHP = 10;
     nBaseSkillPoints = 2;
     nNumFeats += 9;
     break;
   case CLASS_TYPE_RANGER:
     nBaseHP = 10;
     nBaseSkillPoints = 4;
     nNumFeats += 7;
     break;
   case CLASS_TYPE_ROGUE:
     nBaseHP = 6;
     nBaseSkillPoints = 8;
     nNumFeats += 3;
     break;
   case CLASS_TYPE_SORCERER:
     nBaseHP = 4;
     nBaseSkillPoints = 2;
     nNumFeats += 2;
     break;
   case CLASS_TYPE_WIZARD:
     nBaseHP = 4;
     nBaseSkillPoints = 2;
     nNumFeats += 3;
     break;
   default:
     WriteTimestampedLogEntry(GetName(oPC) + " had an illegal class: " + IntToString(nClass));
     return FALSE;
     break;
  }

  switch (nRace)
  {
    case RACIAL_TYPE_DWARF:
      nNumFeats += 8;
      nFavouredAbilityScore = ABILITY_CONSTITUTION;
      nBadAbilityScore1 = ABILITY_CHARISMA;
      break;
    case RACIAL_TYPE_ELF:
      nNumFeats += 8;
      nFavouredAbilityScore = ABILITY_DEXTERITY;
      nBadAbilityScore1 = ABILITY_CONSTITUTION;
      break;
    case RACIAL_TYPE_GNOME:
      nNumFeats += 9;
      nFavouredAbilityScore = ABILITY_CONSTITUTION;
      nBadAbilityScore1 = ABILITY_STRENGTH;
      break;
    case RACIAL_TYPE_HALFELF:
      nNumFeats += 6;
      break;
    case RACIAL_TYPE_HALFLING:
      nNumFeats += 6;
      nFavouredAbilityScore = ABILITY_DEXTERITY;
      nBadAbilityScore1 = ABILITY_STRENGTH;
      break;
    case RACIAL_TYPE_HALFORC:
      nNumFeats += 1;
      nFavouredAbilityScore = ABILITY_STRENGTH;
      nBadAbilityScore1 = ABILITY_CHARISMA;
      nBadAbilityScore2 = ABILITY_INTELLIGENCE;
      break;
    case RACIAL_TYPE_HUMAN:
      nNumFeats += 2; // Quick to Master + 1 bonus feat
      nBaseSkillPoints += 1;
      break;
    default:
     WriteTimestampedLogEntry(GetName(oPC) + " had an illegal race: " + IntToString(nRace));
     return FALSE;
     break;
  }

  // Check stats first.
  int nTotalPoints = 0;
  int nScore;
  int nAbility;
  for (nAbility = 0; nAbility < 6; nAbility ++)
  {
     int nBase = (nAbility = nFavouredAbilityScore)? 10: 8;
     if (nBase = 8) nBase = (nAbility = nBadAbilityScore1)? 6: 8;
     if (nBase = 8) nBase = (nAbility = nBadAbilityScore2)? 6: 8;

     nScore = GetAbilityScore(oPC, nAbility, TRUE);
     if (nScore <= 6)
     {
       nTotalPoints += nScore;
     }
     else if (nScore <= 8)
     {
       nTotalPoints += 6 + (nScore - 6) * 2;
     }
     else if (nScore <= 10)
     {
       nTotalPoints += 10 + (nScore - 8) * 3;
     }
     else
     {
       WriteTimestampedLogEntry(GetName(oPC) + " has illegal ability score ("
                      + IntToString(nScore) + ") for " + IntToString(nAbility));
       return FALSE;
     }
  }

  if (nTotalPoints != 30)
  {
    WriteTimestampedLogEntry(GetName(oPC) + " has illegal number of stat points ("
                                             + IntToString(nTotalPoints) + ")");
    return FALSE;
  }

  int nFeat;
  int nCountFeats = 0;
  for (nFeat = 0; nFeat <= MAX_FEAT; nFeat++)
  {
    if (GetHasFeat(nFeat, oPC)) nCountFeats++;
  }

  // Check a few feats by hand. These were added in HOTU and by checking them
  // manually we avoid having to cycle through 500 more feats.
  if (GetHasFeat(871, oPC)) nCountFeats++; // Curse song
  if (GetHasFeat(915, oPC)) nCountFeats++; // Skill Focus: bluff
  if (GetHasFeat(916, oPC)) nCountFeats++; // Skill Focus: intimidate
  if (GetHasFeat(944, oPC)) nCountFeats++; // Brew Potion
  if (GetHasFeat(945, oPC)) nCountFeats++; // Scribe Scroll
  if (GetHasFeat(946, oPC)) nCountFeats++; // Craft Wand
  if (GetHasFeat(952, oPC)) nCountFeats++; // Wpn Focus: Dw. axe
  if (GetHasFeat(993, oPC)) nCountFeats++; // Wpn Focus: Whip

  if (nCountFeats != nNumFeats)
  {
    WriteTimestampedLogEntry(GetName(oPC) + " has illegal number of feats ("
     + IntToString(nCountFeats) + ") - should have " + IntToString(nNumFeats));
    return FALSE;
  }

  int nSkill;
  int nCountSkillPoints = 0;
  for (nSkill = 0; nSkill <= MAX_SKILL; nSkill++)
  {
    nCountSkillPoints += GetSkillRank(nSkill, oPC, TRUE);
  }

  if (nCountSkillPoints != 4 * nBaseSkillPoints)
  {
    WriteTimestampedLogEntry(GetName(oPC) + " has illegal number of skill points ("
     + IntToString(nCountSkillPoints) + ") - should have " +
                                             IntToString(4 * nBaseSkillPoints));
    return FALSE;
  }

  // Add more checks here, if we think of any.

  return TRUE;
}

// Uncomment to compile for test purposes.
//void main() {}
