#include "gs_inc_execute"
#include "gs_inc_justice"

const string GS_TEMPLATE = "gs_placeable382";
const string GS_SCRIPT   = "gs_run_justice";

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
        gsJULoadJudgement(oObject);
        gsEXRegisterHour(oObject, GS_SCRIPT);
    }

    DestroyObject(OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
