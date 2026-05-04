/* LISTENER Library by Gigaschatten */

//void main() {}

const string GS_LI_TEMPLATE_LISTENER = "gs_creature017";

//create listener for oPC
void gsLICreateListener(object oPC);
//internally used
void _gsLIActionFollow(object oTarget);
//return target of oListener
object gsLIGetTarget(object oListener = OBJECT_SELF);
//destroy listener of oPC
void gsLIDestroyListener(object oPC);
//set last sMessage of oPC
void gsLISetLastMessage(string sMessage, object oPC = OBJECT_SELF);
//return last message of oPC
string gsLIGetLastMessage(object oPC = OBJECT_SELF);
//clear last message of oPC
void gsLIClearLastMessage(object oPC = OBJECT_SELF);

void gsLICreateListener(object oPC)
{
    object oListener = GetLocalObject(oPC, "GS_LI_LISTENER");
    if (GetIsObjectValid(oListener)) return;

    oListener        = CreateObject(OBJECT_TYPE_CREATURE,
                                    GS_LI_TEMPLATE_LISTENER,
                                    GetLocation(oPC));

    if (GetIsObjectValid(oListener))
    {
        SetLocalObject(oListener, "GS_LI_TARGET", oPC);
        SetLocalObject(oPC, "GS_LI_LISTENER", oListener);

        SetListenPattern(oListener, "**");
        SetListening(oListener, TRUE);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectCutsceneParalyze()),
                            oListener);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectCutsceneGhost()),
                            oListener);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)),
                            oListener);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectTrueSeeing()),
                            oListener);

        SetAILevel(oListener, AI_LEVEL_LOW);

        AssignCommand(oListener, _gsLIActionFollow(oPC));
    }
}
//----------------------------------------------------------------
void _gsLIActionFollow(object oTarget)
{
    object oTarget  = gsLIGetTarget();

    if (! GetIsObjectValid(oTarget))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    float fDistance = GetDistanceToObject(oTarget);

    SetCommandable(TRUE);
    if (fDistance >= 5.0 || fDistance == -1.0) ActionJumpToObject(oTarget);
    ActionWait(5.0);
    ActionDoCommand(_gsLIActionFollow(oTarget));
    SetCommandable(FALSE);
}
//----------------------------------------------------------------
object gsLIGetTarget(object oListener = OBJECT_SELF)
{
    return GetLocalObject(oListener, "GS_LI_TARGET");
}
//----------------------------------------------------------------
void gsLISetLastMessage(string sMessage, object oPC = OBJECT_SELF)
{
    SetLocalString(oPC, "GS_LI_MESSAGE", sMessage);
}
//----------------------------------------------------------------
string gsLIGetLastMessage(object oPC = OBJECT_SELF)
{
    return GetLocalString(oPC, "GS_LI_MESSAGE");
}
//----------------------------------------------------------------
void gsLIClearLastMessage(object oPC = OBJECT_SELF)
{
    DeleteLocalString(oPC, "GS_LI_MESSAGE");
}
