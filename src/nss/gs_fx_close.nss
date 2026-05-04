void main()
{
    object oSelf = OBJECT_SELF;

    AssignCommand(GetLastClosedBy(), ActionStartConversation(oSelf, "", TRUE, FALSE));
}
