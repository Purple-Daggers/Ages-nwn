void main()
{
    object oAttacker = GetLastAttacker();
    effect eVisual   = EffectVisualEffect(VFX_IMP_DEATH);
    effect eEffect   = EffectDeath();

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectLinkEffects(eVisual, eEffect),
        oAttacker);
}
