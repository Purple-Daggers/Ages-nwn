void main()
{
    object oFixture = OBJECT_SELF;
    AssignCommand(GetLastUsedBy(), ActionStartConversation(oFixture, "gs_bs_use", TRUE));
}

