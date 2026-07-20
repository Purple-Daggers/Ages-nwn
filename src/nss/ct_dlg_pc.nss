// Tailor reply option "PC" Text Appears When.
// Returns TRUE and sets custom token when reply slot "PC" has text.
#include "ct_api_conv"
int StartingConditional() {
    object oPC = GetLastSpeaker();
    string sPC = GetScriptParam("PC");
    int nIF = StringToInt(sPC);
    string s = GetLocalString(oPC, "ct_dialog"+sPC);
    if (s == "") return FALSE;
    SetCustomToken(CT_TOKEN_BASE + nIF, s);
    return TRUE;
}
