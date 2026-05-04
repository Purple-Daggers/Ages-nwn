void gsFollow(object oTarget)
{
    if (! GetIsObjectValid(oTarget)) return;

    if (GetArea(OBJECT_SELF) != GetArea(oTarget))
        ActionJumpToObject(oTarget);
    else if (GetDistanceToObject(oTarget) > 5.0)
        ActionForceMoveToObject(oTarget, TRUE, 4.0, 12.0);
    else
        ActionWait(6.0);
    ActionDoCommand(gsFollow(oTarget));
}
//----------------------------------------------------------------
void main()
{
    gsFollow(GetLocalObject(OBJECT_SELF, "GS_TARGET"));
}
