void main()
{
    object oEntering = GetEnteringObject();

    if (GetIsPC(oEntering) &&
        ! GetIsDM(oEntering))
    {
        int nEffect = VFX_DUR_GHOST_TRANSPARENT;

        switch (GetAlignmentGoodEvil(oEntering))
        {
        case ALIGNMENT_GOOD:
            nEffect = VFX_DUR_GLOW_LIGHT_BLUE;
            break;

        case ALIGNMENT_NEUTRAL:
            nEffect = VFX_DUR_GLOW_GREY;
            break;

        case ALIGNMENT_EVIL:
            nEffect = VFX_DUR_GLOW_RED;
            break;
        }

        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            EffectVisualEffect(nEffect),
            oEntering);
    }

    ExecuteScript("gs_a_enter", OBJECT_SELF);
}
