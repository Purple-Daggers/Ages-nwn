//:://///////////////////////////////////////////////////
//:: ct_used - OnUsed opens Tailor Shop from Placable
//::////////////////////////////////////////////////////
/*
*/

 #include "ct_api_conv"

void main()
{
    object oPC = GetLastUsedBy();
    object oSelf = OBJECT_SELF;

    CT_OpenTailorShop(oPC,oSelf);

    // ActionStartConversation(oPC), "", TRUE);
}

