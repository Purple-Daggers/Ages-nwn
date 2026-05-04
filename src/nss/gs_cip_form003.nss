#include "gs_inc_iprop"

const int GS_INVENTORY_SLOT = INVENTORY_SLOT_CHEST;
const int GS_TYPE           = ITEM_APPR_TYPE_ARMOR_MODEL;
const int GS_INDEX          = ITEM_APPR_ARMOR_MODEL_BELT;

void main()
{
    int nTableID = gsIPGetAppearanceTableID(GS_INDEX);

    SetLocalInt(OBJECT_SELF, "GS_TABLE_ID", nTableID);
    SetLocalInt(OBJECT_SELF, "GS_INVENTORY_SLOT", GS_INVENTORY_SLOT);
    SetLocalInt(OBJECT_SELF, "GS_TYPE", GS_TYPE);
    SetLocalInt(OBJECT_SELF, "GS_INDEX", GS_INDEX);
}
