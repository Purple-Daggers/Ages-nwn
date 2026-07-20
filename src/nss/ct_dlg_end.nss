// Tailor conversation OnEnd and Abort Conversation script.
// Attach to both events in ct_conv.dlg.
#include "ct_api_conv"
void main()
{
    CT_EndConversation(GetLastSpeaker());
}
