void main()
{
    object oFixture = OBJECT_SELF;
    AssignCommand(GetLastUsedBy(), ActionStartConversation(oFixture, "gs_fo_use", TRUE));
}
