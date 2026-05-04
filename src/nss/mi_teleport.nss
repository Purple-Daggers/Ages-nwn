/*
  Name: mi_teleport
  Author: Mithreas
  Date: 5 Feb 06
  Description: Teleports a PC and their associates (summons/companions/etc)
*/
// Jump a PC and all their companions to a location.
void JumpAllToLocation(object oPC, location lLocation);

void JumpAllToLocation(object oPC, location lLocation)
{
  object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
  object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
  object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  object oAC = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);

  AssignCommand(oPC, JumpToLocation(lLocation));
  if (oSummon != OBJECT_INVALID) AssignCommand(oSummon, JumpToLocation(lLocation));
  if (oDominated != OBJECT_INVALID) AssignCommand(oDominated, JumpToLocation(lLocation));
  if (oFamiliar != OBJECT_INVALID) AssignCommand(oFamiliar, JumpToLocation(lLocation));
  if (oAC != OBJECT_INVALID) AssignCommand(oAC, JumpToLocation(lLocation));
  if (oHenchman != OBJECT_INVALID) AssignCommand(oHenchman, JumpToLocation(lLocation));
}

// Jump a PC and all their companions to an object.
void JumpAllToObject(object oPC, object oTarget);

void JumpAllToObject(object oPC, object oTarget)
{
  object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
  object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
  object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  object oAC = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);

  AssignCommand(oPC, JumpToObject(oTarget));
  if (oSummon != OBJECT_INVALID) AssignCommand(oSummon, JumpToObject(oTarget));
  if (oDominated != OBJECT_INVALID) AssignCommand(oDominated, JumpToObject(oTarget));
  if (oFamiliar != OBJECT_INVALID) AssignCommand(oFamiliar, JumpToObject(oTarget));
  if (oAC != OBJECT_INVALID) AssignCommand(oAC, JumpToObject(oTarget));
  if (oHenchman != OBJECT_INVALID) AssignCommand(oHenchman, JumpToObject(oTarget));
}
