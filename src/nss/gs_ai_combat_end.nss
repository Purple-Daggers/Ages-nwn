#include "gs_inc_combat"
#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_COMBAT_ROUND_END));

    gsCBDetermineCombatRound();
}
