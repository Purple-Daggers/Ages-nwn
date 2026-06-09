void main()
{
    object oSelf = OBJECT_SELF;
    AssignCommand(GetPlaceableLastClickedBy(), ClearAllActions());
    AssignCommand(GetPlaceableLastClickedBy(), ActionStartConversation(oSelf, "", TRUE, FALSE));
}