/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - NPC CONVERSATION (ct_npc_conv.nss) - v2.0.0
================================================================================
Tailor NPC OnConversation script.
Attach to the tailor NPC blueprint's OnConversation event in the Toolset.
The NPC's Conversation field must be left as "(none)" in the Toolset.

 Example: AssignCommand(oPC, ActionStartConversation(oPC, "ct_conv", FALSE, FALSE))

This starts the dialogue file "ct_conv" on the PC themselves - no camera flip,
non-interruptable - giving a clean dialogue window.
================================================================================
*/

#include "ct_api_conv"

void main() {
    object oPC  = GetLastSpeaker();
    object oNPC = OBJECT_SELF;

    if (!GetIsPC(oPC)) return;

    // Already in session - ignore re-trigger.
    if (GetLocalInt(oPC, "CT_IN_CONV") == 1) return;

    CT_OpenConvFromNPC(oPC, oNPC);
}
