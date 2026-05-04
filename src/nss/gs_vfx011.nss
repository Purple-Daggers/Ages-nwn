#include "gs_inc_common"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    string sTemplate = gsCMGetTemplateByType(GetLocalInt(OBJECT_SELF, "GS_TYPE"));

    CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, GetLocation(OBJECT_SELF));

    DestroyObject(OBJECT_SELF);
}
