void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        string sItemStripScript = GetLocalString(GetModule(), "GS_ITEM_STRIP_SCRIPT");

        if (sItemStripScript != "") ExecuteScript(sItemStripScript, oTarget);
    }
}
