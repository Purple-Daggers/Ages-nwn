#include "gs_inc_iprop"

const string GS_TABLE       = "helmetmodel";
const int GS_INVENTORY_SLOT = INVENTORY_SLOT_HEAD;
const int GS_TYPE           = ITEM_APPR_TYPE_SIMPLE_MODEL;
const int GS_INDEX          = -2;

void main()
{
    int nTableID = gsIPGetTableID(GS_TABLE);

    SetLocalInt(OBJECT_SELF, "GS_TABLE_ID", nTableID);
    SetLocalInt(OBJECT_SELF, "GS_INVENTORY_SLOT", GS_INVENTORY_SLOT);
    SetLocalInt(OBJECT_SELF, "GS_TYPE", ITEM_APPR_TYPE_SIMPLE_MODEL);
    SetLocalInt(OBJECT_SELF, "GS_INDEX", GS_INDEX);
}
