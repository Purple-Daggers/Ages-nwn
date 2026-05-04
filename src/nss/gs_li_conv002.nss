#include "gs_inc_listener"

void main()
{
    if (! GetListenPatternNumber())
    {
        object oSpeaker = GetLastSpeaker();

        if (GetIsPC(oSpeaker)) gsLISetLastMessage(GetMatchedSubstring(0), oSpeaker);
    }
}
