#include "gs_inc_subrace"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    return gsSUGetSubracePermission(oSpeaker, "Veydran");
}
