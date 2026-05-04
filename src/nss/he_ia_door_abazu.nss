void main()
{
    object oClicking = GetClickingObject();

    if (GetIsPC(oClicking))
    {
        object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC,
                                              oClicking, 1,
                                              CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                                              CREATURE_TYPE_IS_ALIVE, TRUE);

        if (GetIsObjectValid(oCreature))
        {
            FloatingTextStringOnCreature(
                "The passage seems to be magically blocked.", oClicking, FALSE);
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE),
                oClicking);
            return;
        }
    }

    object oTarget   = GetTransitionTarget(OBJECT_SELF);
    AssignCommand(oClicking, JumpToObject(oTarget));
}
