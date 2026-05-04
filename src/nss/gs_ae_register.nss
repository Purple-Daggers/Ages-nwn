#include "gs_inc_execute"

const string GS_TEMPLATE = "gs_placeable381";
const string GS_SCRIPT   = "gs_run_arena";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    location lLocation = GetLocation(OBJECT_SELF);
    object oObject     = OBJECT_INVALID;
    string sTag        = GetTag(OBJECT_SELF);
    string sName       = GetName(OBJECT_SELF);

    oObject = CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE, lLocation, FALSE, sTag);

    if (GetIsObjectValid(oObject))
    {
        SetName(oObject, sName);
        gsEXRegisterRound(oObject, GS_SCRIPT);
    }

    DestroyObject(OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
