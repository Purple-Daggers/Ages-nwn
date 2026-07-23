void main()
{
    object oSpeaker = GetPCSpeaker();
    AssignCommand(oSpeaker, ClearAllActions());
    AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, "as_tails", TRUE, FALSE));
}
