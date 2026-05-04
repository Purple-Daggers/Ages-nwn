void main()
{
    if (GetIsDMPossessed(OBJECT_SELF))
    {
        if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                ExtraordinaryEffect(EffectCutsceneGhost()),
                                OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)),
                                OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
        }
    }
    else if (GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
        return;
    }

    DelayCommand(10.0, main());
}
