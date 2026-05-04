#include "gs_inc_combat"
#include "gs_inc_combat2"
#include "gs_inc_effect"
#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_DAMAGED));

    gsFXBleed();
    gsC2SetDamage();

    object oHighestDamager = gsC2GetHighestDamager();
    object oLastDamager    = gsC2GetLastDamager();

    if (GetObjectType(oHighestDamager) == OBJECT_TYPE_AREA_OF_EFFECT)
        oHighestDamager = GetAreaOfEffectCreator(oHighestDamager);
    if (GetObjectType(oLastDamager) == OBJECT_TYPE_AREA_OF_EFFECT)
        oLastDamager    = GetAreaOfEffectCreator(oLastDamager);

    if (gsCBGetHasAttackTarget())
    {
        object oTarget = gsCBGetLastAttackTarget();

        if (GetIsObjectValid(oHighestDamager) &&
            oHighestDamager != oTarget)
        {
            gsCBDetermineCombatRound(oHighestDamager);
        }
    }
    else
    {
        gsCBDetermineCombatRound(oHighestDamager);
    }
}
