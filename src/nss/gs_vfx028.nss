#include "gs_inc_portal"

const string GS_TEMPLATE_PORTAL             = "gs_placeable273";
const string GS_TEMPLATE_PORTAL_DESTINATION = "gs_placeable313";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GetLocalInt(OBJECT_SELF, "GS_PO_DESTINATION") ?
                                  GS_TEMPLATE_PORTAL_DESTINATION : GS_TEMPLATE_PORTAL,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject)) gsPORegisterPortal(oObject);

    DestroyObject(OBJECT_SELF);
}
