/* ITEM STATE Library by Gigaschatten */

//void main() {}

#include "gs_inc_common"
#include "gs_inc_craft"
#include "gs_inc_text"

//global
object gsISItem = OBJECT_INVALID;
int gsISEnabled = FALSE;

//initialize state of oItem
void gsISInitializeItemState(object oItem);
//return maximum charge of oItem
int gsISGetMaximumItemState(object oItem);
//return state of oItem
int gsISGetItemState(object oItem);
//decrease state of oItem by 1
void gsISDecreaseItemState(object oItem);
//increase state of oItem by 1
void gsISIncreaseItemState(object oItem);
//set state of oItem to nState
void gsISSetItemState(object oItem, int nState);
//return TRUE if oItem is a state item
int gsISGetIsStateItem(object oItem);
//return craft skill used to repair oItem
int gsISGetItemCraftSkill(object oItem);
//return dc of repairing oItem
int gsISGetItemRepairDC(object oItem);
//randomly corrupt equipment of caller
void gsISCorruptEquipment();
//repair oItem by oPC using nValue craft points
void gsISRepairItem(object oItem, object oPC, int nValue = 1);

void gsISInitializeItemState(object oItem)
{
    if (gsISGetIsStateItem(oItem) &&
        GetItemCharges(oItem) == 0)
    {
        SetItemCharges(oItem, gsISGetMaximumItemState(oItem));
    }
}
//----------------------------------------------------------------
int gsISGetMaximumItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return FALSE;

    int nStateMaximum = 10 + gsCMGetItemLevelByValue(gsCMGetItemValue(oItem));
    return nStateMaximum > 50 ? 50 : nStateMaximum;
}
//----------------------------------------------------------------
int gsISGetItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return FALSE;

    gsISInitializeItemState(oItem);
    return GetItemCharges(oItem);
}
//----------------------------------------------------------------
void gsISDecreaseItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return;
    gsISSetItemState(oItem, gsISGetItemState(oItem) - 1);
}
//----------------------------------------------------------------
void gsISIncreaseItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return;
    gsISSetItemState(oItem, gsISGetItemState(oItem) + 1);
}
//----------------------------------------------------------------
void gsISSetItemState(object oItem, int nState)
{
    if (! gsISGetIsStateItem(oItem)) return;

    object oPossessor = GetItemPossessor(oItem);
    string sName      = GetName(oItem);

    if (nState <= 0)
    {
        FloatingTextStringOnCreature(
            gsCMReplaceString(GS_T_16777433, sName),
            oPossessor,
            FALSE);
        DestroyObject(oItem);
    }

    string sString    = "";
    int nStateMaximum = gsISGetMaximumItemState(oItem);
    int nStateCurrent = gsISGetItemState(oItem);

    if (nState > nStateMaximum)  nState  = nStateMaximum;
    if (nState == nStateCurrent) return;
    if (nState > nStateCurrent)  sString = "<cªÕþ>";
    else                         sString = "<cþ((>";

    FloatingTextStringOnCreature(
        sString + sName + " (" +
        IntToString(nState) + "/" +
        IntToString(nStateMaximum) + ")",
        oPossessor,
        FALSE);
    SetItemCharges(oItem, nState);
}
//----------------------------------------------------------------
int gsISGetIsStateItem(object oItem)
{
    if (oItem != gsISItem)
    {
        gsISItem    = oItem;
        gsISEnabled = gsISGetItemCraftSkill(oItem) != FALSE;
    }

    return gsISEnabled;
}
//----------------------------------------------------------------
int gsISGetItemCraftSkill(object oItem)
{
    switch (GetBaseItemType(oItem))
    {
    case BASE_ITEM_ARMOR:
        return gsCMGetItemBaseAC(oItem) < 4 ? GS_CR_SKILL_SEW : GS_CR_SKILL_FORGE;

    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_BRACER:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_HELMET:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
        return GS_CR_SKILL_FORGE;

    case BASE_ITEM_BELT:
    case BASE_ITEM_BOOTS:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_GLOVES:
    case BASE_ITEM_SLING:
    case BASE_ITEM_WHIP:
        return GS_CR_SKILL_SEW;

    case BASE_ITEM_CLUB:
    case BASE_ITEM_QUARTERSTAFF:
        return GS_CR_SKILL_CARPENTER;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsISGetItemRepairDC(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return FALSE;

    int nDC =
        GS_CR_OFFSET_DC +
        gsCMGetItemLevelByValue(
            gsCMGetItemValue(oItem) * GS_CR_MODIFIER_DC);

    return nDC < 1 ? 1 : nDC;
}
//----------------------------------------------------------------
void gsISCorruptEquipment()
{
    if (Random(100) < 95) return;

    object oItem = OBJECT_INVALID;
    int nNth     = 0;

    oItem        = GetItemInSlot(INVENTORY_SLOT_ARMS);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BELT);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BOOTS);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CLOAK);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_HEAD);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (gsISGetIsStateItem(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);

    if (nNth)
    {
        oItem = GetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(Random(nNth)));
        gsISDecreaseItemState(oItem);
    }
}
//----------------------------------------------------------------
void gsISRepairItem(object oItem, object oPC, int nValue = 1)
{
    int nSkill            = gsISGetItemCraftSkill(oItem);
    int nItemRepairDC     = gsISGetItemRepairDC(oItem);
    int nMaximumItemState = gsISGetMaximumItemState(oItem);
    int nCraftPoints      = gsCRGetCraftPoints(oPC);
    int nFlag             = FALSE;
    int nNth              = 0;

    if (nValue < 1 || nValue > nCraftPoints) nValue = nCraftPoints;

    for (; nNth < nValue; nNth++)
    {
        //check skill
        if (gsCRGetIsSkillSuccessful(nSkill, nItemRepairDC, oPC))
        {
            gsISIncreaseItemState(oItem);

            //complete repair
            if (gsISGetItemState(oItem) >= nMaximumItemState)
            {
                gsCRDecreaseCraftPoints(nNth + 1, oPC);

                FloatingTextStringOnCreature(GS_T_16777478, oPC, FALSE);
                return;
            }

            nFlag = TRUE; //progress
        }
    }

    gsCRDecreaseCraftPoints(nNth, oPC);

    if (nFlag) FloatingTextStringOnCreature(GS_T_16777434, oPC, FALSE);
    else       FloatingTextStringOnCreature(GS_T_16777435, oPC, FALSE);
}
