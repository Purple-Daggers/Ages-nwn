#include "gs_inc_iprop"

void main()
{
    //slot 5

    object oPC         = GetPCSpeaker();
    int nInventorySlot = GetLocalInt(OBJECT_SELF, "GS_INVENTORY_SLOT");
    object oItem       = GetItemInSlot(nInventorySlot, oPC);

    if (GetIsObjectValid(oItem))
    {
        int nTableID = GetLocalInt(OBJECT_SELF, "GS_TABLE_ID");
        int nType    = GetLocalInt(OBJECT_SELF, "GS_TYPE");
        int nIndex   = GetLocalInt(OBJECT_SELF, "GS_INDEX");
        int nNth     = GetLocalInt(OBJECT_SELF, "GS_SLOT_5");

        if (nType  != ITEM_APPR_TYPE_ARMOR_MODEL  ||
            nIndex != ITEM_APPR_ARMOR_MODEL_TORSO ||
            gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) ==
            gsIPGetValue(nTableID, nNth, "AC"))
        {
            int nValue   = gsIPGetValue(nTableID, nNth, "ID");
            object oCopy = CopyItemAndModify(oItem, nType, nIndex, nValue, TRUE);

            if (GetIsObjectValid(oCopy))
            {
                AssignCommand(oPC, ActionEquipItem(oCopy, nInventorySlot));
                DestroyObject(oItem);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                    EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL),
                                    oPC,
                                    0.25);
            }
        }
    }
}
