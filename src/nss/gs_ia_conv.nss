void main()
{
    object oSelf = OBJECT_SELF;

    AssignCommand(GetLastUsedBy(), ActionStartConversation(oSelf, "", TRUE, FALSE));
}
