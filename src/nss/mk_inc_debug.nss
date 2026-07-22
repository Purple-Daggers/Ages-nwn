
void MK_DEBUG_TRACE(string s);

int MK_DEBUG_GetDebugMode();

object MK_DEBUG_GetPC(object oPC = OBJECT_SELF)
{
    if (GetIsPC(oPC))
    {
        return oPC;
    }
    oPC = GetMaster(oPC);
    if (GetIsPC(oPC))
    {
        return oPC;
    }
    return GetFirstPC();
}

int MK_DEBUG_GetDebugMode()
{
    return GetLocalInt(GetModule(), "MK_DISPLAY_DEBUG_MESSAGES");
}

void MK_DEBUG_TRACE(string s)
{
    if (!MK_DEBUG_GetDebugMode()) return;
    object oPC = MK_DEBUG_GetPC(OBJECT_SELF);
    if (GetIsObjectValid(oPC))
    {
        SendMessageToPC(oPC, s);
    }
/**/
}

/*
void MK_DEBUG_SetCustomToken(int nCustomTokenNumber, string sTokenValue)
{
    SetCustomToken(nCustomTokenNumber, sTokenValue);
    MK_DEBUG_TRACE("SetCustomToken("+IntToString(nCustomTokenNumber)+",'"+sTokenValue+'")");
}
*/

void MK_DEBUG_SpawnScriptDebugger()
{
    if (!MK_DEBUG_GetDebugMode()) return;
    SpawnScriptDebugger();
}

/*
void main()
{

}
/**/
