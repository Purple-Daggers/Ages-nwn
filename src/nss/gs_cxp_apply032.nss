int StartingConditional()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        object oCorpse = GetLocalObject(oTarget, "GS_CORPSE");
        return GetIsObjectValid(oCorpse);
    }

    return FALSE;
}
