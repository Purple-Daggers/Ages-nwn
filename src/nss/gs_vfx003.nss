void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectPetrify()),
                        OBJECT_SELF);
    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    SetPlotFlag(OBJECT_SELF, TRUE);
}
