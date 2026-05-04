/*
  obj_setname
  Allows DMs to change the names of NPCs.
*/
void main()
{
  object oTarget = GetSpellTargetObject();
  object oItem   = GetSpellCastItem();
  object oDM     = GetItemPossessor(oItem);
  object oVoice  = CreateObject(OBJECT_TYPE_CREATURE, "setname_voice", GetLocation(oDM));
  SetLocalObject(oVoice, "target", oTarget);
  SendMessageToPC(oDM, "Now speak the name you want. Use the DM channel if " +
   "you don't want players to hear. Note that you must appear, or possess a " +
   "nearby NPC (e.g. the guy you're trying to rename) for this to work.\n" +
   "Sometimes you have to change area before you see the updated name. To " +
   "work around this for creatures, limbo the creature after changing its name, "+
   "then call it back.");
}
