#include "gs_inc_iprop"
#include "gs_inc_text"
#include "gs_inc_token"

int StartingConditional()
{
    object oPC         = GetPCSpeaker();
    int nInventorySlot = GetLocalInt(OBJECT_SELF, "GS_INVENTORY_SLOT");
    object oItem       = GetItemInSlot(nInventorySlot, oPC);
    int nTableID       = GetLocalInt(OBJECT_SELF, "GS_TABLE_ID");
    int nType          = GetLocalInt(OBJECT_SELF, "GS_TYPE");
    int nIndex         = GetLocalInt(OBJECT_SELF, "GS_INDEX");
    int nLimit         = gsIPGetCount(nTableID);
    int nSlot          = 0;
    int nNth           = GetLocalInt(OBJECT_SELF, "GS_OFFSET");
    int nCount         = nNth + 5;

    for (; nNth < nCount; nNth++)
    {
        nSlot++;

        if (nNth < nLimit)
        {
            gsTKSetToken(99 + nSlot, IntToString(nNth));

            if (GetIsObjectValid(oItem))
            {
                if (nType  != ITEM_APPR_TYPE_ARMOR_MODEL  ||
                    nIndex != ITEM_APPR_ARMOR_MODEL_TORSO ||
                    gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) ==
                    gsIPGetValue(nTableID, nNth, "AC"))
                {
                    SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);
                    continue;
                }
            }

            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), -2);
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), -1);
        }
    }

    switch (nInventorySlot)
    {
    case INVENTORY_SLOT_CHEST:
        switch (nIndex)
        {
        case ITEM_APPR_ARMOR_MODEL_BELT:
            SetCustomToken(105, GS_T_16777244 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LBICEP:
            SetCustomToken(105, GS_T_16777245 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LFOOT:
            SetCustomToken(105, GS_T_16777246 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LFOREARM:
            SetCustomToken(105, GS_T_16777247 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LHAND:
            SetCustomToken(105, GS_T_16777248 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LSHIN:
            SetCustomToken(105, GS_T_16777249 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
            SetCustomToken(105, GS_T_16777250 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_LTHIGH:
            SetCustomToken(105, GS_T_16777251 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_NECK:
            SetCustomToken(105, GS_T_16777252 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_PELVIS:
            SetCustomToken(105, GS_T_16777253 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RBICEP:
            SetCustomToken(105, GS_T_16777254 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RFOOT:
            SetCustomToken(105, GS_T_16777255 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RFOREARM:
            SetCustomToken(105, GS_T_16777256 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RHAND:
            SetCustomToken(105, GS_T_16777257 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_ROBE:
            SetCustomToken(105, GS_T_16777258 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RSHIN:
            SetCustomToken(105, GS_T_16777259 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RSHOULDER:
            SetCustomToken(105, GS_T_16777260 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_RTHIGH:
            SetCustomToken(105, GS_T_16777261 + "\n");
            break;

        case ITEM_APPR_ARMOR_MODEL_TORSO:
            SetCustomToken(105, GS_T_16777262 + "\n");
            break;
        }
        break;

    case INVENTORY_SLOT_CLOAK:
        SetCustomToken(105, GS_T_16777507 + "\n");
        break;

    case INVENTORY_SLOT_HEAD:
        SetCustomToken(105, GS_T_16777508 + "\n");
        break;
    }

    return TRUE;
}
