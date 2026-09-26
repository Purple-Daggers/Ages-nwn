void main()
{
    if(GetIsInCombat())
    {
        SendMessageToPC(OBJECT_SELF, "Cannot teleport in combat.");
        return;
    }
    if(StringToInt(Get2DAString("encumbrance", "Normal", GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH))) <= GetWeight(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, "Cannot teleport while encumbered.");
        return;
    }

    object oTeleportWaypoint = GetWaypointByTag("PrasinosTeleportDestination");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_IMPLOSION),
                          GetLocation(OBJECT_SELF));
    DelayCommand(1.0f, ClearAllActions(TRUE));
    DelayCommand(1.0f, AssignCommand(OBJECT_SELF, JumpToLocation(GetLocation(oTeleportWaypoint))));
}
