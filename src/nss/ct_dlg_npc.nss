// Tailor NPC dialogue node Text Appears When script.
//
// Attach to the NPC text node in ct_conv.dlg.
// Sets custom token CT_TOKEN_BASE (8200) from "ct_npcline" local on the PC.
// On first call, starts the conversation and builds the opening menu.

#include "ct_api_conv"
int StartingConditional() {
    object oPC = GetLastSpeaker();
    // If this is the first time the node fires (conversation just opened),
    // the menu has already been built by CT_OpenConvFromNPC.
    string sLine = GetLocalString(oPC, "ct_npcline");
    if (sLine == "") return FALSE;
    SetCustomToken(CT_TOKEN_BASE, sLine);
    return TRUE;
}
