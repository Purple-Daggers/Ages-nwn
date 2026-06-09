void main()
{
    object oSelf = OBJECT_SELF;
    AssignCommand(GetClickingObject(), ClearAllActions());
    AssignCommand(GetClickingObject(), ActionStartConversation(oSelf, "", TRUE, FALSE));
}