// Tailor reply option "FIRE" Actions Taken script.
// Fires when the player selects reply "FIRE".
#include "ct_api_conv"
void main() {
    CT_DoDialogChoice(GetLastSpeaker(), StringToInt(GetScriptParam("FIRE")));
}

