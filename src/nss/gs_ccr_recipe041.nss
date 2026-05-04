void main()
{
    object oSelf = OBJECT_SELF;

    AssignCommand(GetPCSpeaker(), ActionStartConversation(oSelf, "gs_fx_use", TRUE, FALSE));
}
