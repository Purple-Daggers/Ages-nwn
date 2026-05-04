void main()
{
    if (GetHasInventory(OBJECT_SELF))                      return;
    if (GetIsObjectValid(GetSittingCreature(OBJECT_SELF))) return;

    object oSelf = OBJECT_SELF;

    AssignCommand(GetLastUsedBy(), ActionStartConversation(oSelf, "", TRUE, FALSE));
}
