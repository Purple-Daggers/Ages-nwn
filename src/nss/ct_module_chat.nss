/*==============================================================================
    CARCERIAN'S TAILOR SYSTEM - MODULE CHAT (ct_module_chat.nss) - v1.0
================================================================================
    Module OnPlayerChat event script.
    Attach to: Module Properties OnPlayerChat
==============================================================================*/

void main()
{
    // Main module OnChat event:
    // find last player to speak a chat message.
    object oPC = GetPCChatSpeaker();
    string sLastChat = GetPCChatMessage();
    SetLocalString(oPC,"LAST_CHAT", sLastChat);
    // When a color or part number is prompeted get int
    SetLocalInt(oPC,"LAST_CHAT_INT", StringToInt(sLastChat));
}

