void main()
{
    object oSpeaker = GetPCSpeaker();
    AssignCommand(oSpeaker, ClearAllActions());
    AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, "as_cats", TRUE, FALSE));
}
