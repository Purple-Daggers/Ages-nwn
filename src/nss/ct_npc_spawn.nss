// Tailor NPC OnSpawn script for Carcerian's Tailor System.
// Attach to the tailor NPC blueprint's OnSpawn event in the Toolset.
// Also attach ct_npc_conv.nss to the OnConversation event so players can click
// the NPC to open the tailor (with automatic move-to if out of range).
//
// On spawn this script:
//   Builds the conversation tree (ct_conv_build) if it has not been built
//   yet this server session. This makes the system self-bootstrapping -
//      no OnModuleLoad script is required, though adding one is recommended
//      for servers with many tailor NPCs to avoid a one-time build delay on
//      the first player interaction.

#include "ct_api_sess"

void main() {

    // Bootstrap the conversation tree on first spawn if not already built.
    // Uses ExecuteScript to avoid a compile-time dependency on ct_conv_build,
    // keeping this script's include chain minimal.

    if (!GetLocalInt(GetModule(), "CT_CONV_BUILT"))
        ExecuteScript("ct_conv_build", GetModule());

}

