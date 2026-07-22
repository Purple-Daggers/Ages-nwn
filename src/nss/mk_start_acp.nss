#include "mk_inc_debug"
#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    MK_DEBUG_TRACE("mk_start_acp: oPC='"+GetName(oPC)+"', oTarget='"+GetName(oTarget)+"'");

    AssignCommand(oPC, ActionStartConversation(oTarget, "mk_acp", TRUE, FALSE));
}
