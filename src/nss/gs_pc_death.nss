#include "gs_inc_common"
#include "gs_inc_text"

const string GS_TEMPLATE_CORPSE = "gs_placeable016";
const string GS_TEMPLATE_SKULL  = "gs_item050";

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_CORPSE,
                                  GetLocation(OBJECT_SELF));
    string sName   = GetName(OBJECT_SELF);

    if (GetIsObjectValid(oTarget))
    {
        FloatingTextStringOnCreature(GS_T_16777484, oTarget, FALSE);
        DeleteLocalObject(oTarget, "GS_CORPSE");
    }

    if (GetIsObjectValid(oCorpse))
    {
        object oSkull = CreateItemOnObject(GS_TEMPLATE_SKULL, oCorpse);
        if (GetIsObjectValid(oSkull)) SetName(oSkull, sName);

        SetName(oCorpse, sName);
        gsCMCreateGold(GetLocalInt(OBJECT_SELF, "GS_GOLD"), oCorpse);
    }
}
