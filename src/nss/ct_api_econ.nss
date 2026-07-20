/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - ECONOMY (ct_api_econ.nss) - v2.1.0
================================================================================
Item purchase, appearance copying, PC item equip, and PW economy hooks.
Included by ct_api_sess.nss. Do not include directly in entry points.

PURCHASE BEHAVIOUR:
  On purchase, the NPC's item is copied into the PC's inventory and equipped.
  The PC's previously equipped item in that slot is UNEQUIPPED into their
  inventory - it is NOT destroyed. The player keeps their old item.

COST OVERRIDE (NPC blueprint local variables):
  CT_PRICE_1 = cloak    CT_PRICE_2 = helmet   CT_PRICE_3 = armor
  CT_PRICE_4 = weapon   CT_PRICE_5 = shield
  A value > 0 overrides GetGoldPieceValue. A value of 0 uses GetGoldPieceValue.

PW ECONOMY HOOKS (implemented in ct_api.nss):
  CT_OnPurchasePrice(oPC, oItem, nItemType, nBasePrice) -> int
    Called after the base price is calculated.
    Return a different value to override. Return -1 to block the purchase.
  CT_OnPurchaseComplete(oPC, oCopy, nItemType, nCost) -> void
    Called after a successful purchase for logging, rewards, etc.

All item replacements go through CT_ReplaceItem (ct_api.nss), which uses the
NPC's action queue to serialize unequip/destroy/equip with no DelayCommand.
================================================================================
*/

#include "ct_api"

// ============================================================================
// PROTOTYPES
// ============================================================================

int  CT_GetPurchaseCost(object oSession, object oPC, int nItemType);
void CT_PurchaseItem(object oSession, object oPC, int nItemType);
void CT_CopyItemDesign(object oSource, object oTarget, int nItemType);
void CT_EquipPCItem(object oSession, object oPC, int nItemType);
void CT_CopyArmorPart(object oSource, object oTarget, int nPart);
void CT_CopyItemColor(object oSource, object oTarget, int nItemType, int nChannel);
void CT_CopyItemStyle(object oSource, object oTarget, int nItemType);
void CT_CopyWeaponPart(object oSource, object oTarget, int nWeapPart);

// ============================================================================
// IMPLEMENTATIONS
// ============================================================================

// Returns the final purchase price for nItemType on the session NPC.
// Applies blueprint override (CT_PRICE_[N] > 0) then CT_OnPurchasePrice hook.
// Returns 0 if no item is equipped in the slot.
int CT_GetPurchaseCost(object oSession, object oPC, int nItemType) {
    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) return 0;
    int nOverride = GetLocalInt(oSession, "CT_PRICE_" + IntToString(nItemType));
    int nBase     = (nOverride > 0) ? nOverride : GetGoldPieceValue(oItem);
    return CT_OnPurchasePrice(oPC, oItem, nItemType, nBase);
}

// Copies the equipped item appearance from oSource to oTarget for nItemType.
// - oSource:   Creature to copy appearance from (PC or session NPC).
// - oTarget:   Creature to apply appearance to.
// - nItemType: CT_ITEM_* constant identifying the slot.
// * ARMOR: chains all 19 part indices and 6 color channels in one pass,
//   destroying intermediates immediately. One CT_ReplaceItem at the end.
// * CLOAK / HELMET: copies the SIMPLE_MODEL index and all 6 color channels.
// * WEAPON: full CopyItem + 3 sub-model indices + 6 color channels.
// * SHIELD: full CopyItem (base item type determines geometry).
// * No-ops if oSource has no item in the slot.
// * ARMOR/CLOAK/HELMET: also no-ops if oTarget has no item to modify
//   (CopyItemAndModify requires an existing base item).
void CT_CopyItemDesign(object oSource, object oTarget, int nItemType) {
    object oSrcItem = CT_GetItem(oSource, nItemType);
    object oTrgItem = CT_GetItem(oTarget, nItemType);
    if (!GetIsObjectValid(oSrcItem)) return;

    object oPC = GetPCSpeaker();
    int bCopyingToPC = (oTarget == oPC);

    // SAFETY: For armor, always ensure NPC has something equipped (never goes naked)
    if (!bCopyingToPC && nItemType == CT_ITEM_ARMOR && !GetIsObjectValid(oTrgItem)) {
        SendMessageToPC(oPC, CT_Error("Error: Session model missing armor. Cannot modify."));
        return;
    }

    // When copying TO PC, validate item type and AC match
    if (bCopyingToPC && GetIsObjectValid(oTrgItem)) {
        // Get base item types
        int nSrcBase = GetBaseItemType(oSrcItem);
        int nTrgBase = GetBaseItemType(oTrgItem);

        // Weapon/Shield: must match base item type
        if ((nItemType == CT_ITEM_WEAPON || nItemType == CT_ITEM_SHIELD) && nSrcBase != nTrgBase) {
            SendMessageToPC(oPC, CT_Error("Cannot copy: PC weapon type does not match session model."));
            return;
        }

        // Armor: must have matching AC value
        if (nItemType == CT_ITEM_ARMOR) {
            string sSrcAC = Get2DAString("parts_chest", "ACBONUS", GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO));
            string sTrgAC = Get2DAString("parts_chest", "ACBONUS", GetItemAppearance(oTrgItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO));
            if (sSrcAC != sTrgAC) {
                SendMessageToPC(oPC,CT_Error( "Cannot copy: PC armor AC does not match session armor."));
                return;
            }
        }
    }

    // When copying TO NPC, if item types don't match, delete old and copy PC item
    if (!bCopyingToPC && GetIsObjectValid(oTrgItem)) {
        int nSrcBase = GetBaseItemType(oSrcItem);
        int nTrgBase = GetBaseItemType(oTrgItem);
        if (nSrcBase != nTrgBase) {
            // Types don't match: delete old item and copy PC item directly
            DestroyObject(oTrgItem);
            object oCopy = CopyItem(oSrcItem, oTarget, FALSE);
            AssignCommand(oTarget, ActionEquipItem(oCopy, CT_GetSlotType(nItemType)));
            SendMessageToPC(oPC, CT_Action("Replaced session item with your " + CT_ItemLabel(nItemType) + "."));
            return;
        }
    }

    // Weapon: full CopyItem (base item type defines geometry), then chain
    // three WEAPON_MODEL sub-index edits and 6 color channels.
    if (nItemType == CT_ITEM_WEAPON) {
        object oCopy = CopyItem(oSrcItem, oTarget, FALSE);  // FALSE = don't add to inventory
        object oOrig = oCopy;
        int p;
        for (p = 0; p < 3; p++) {
            int nVal = GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_WEAPON_MODEL, p);
            object oPrev = oCopy;
            oCopy = CopyItemAndModify(oCopy,
                ITEM_APPR_TYPE_WEAPON_MODEL, p, nVal, TRUE);
            if (oPrev != oOrig) DestroyObject(oPrev);
        }
        int c;
        for (c = 0; c < 6; c++) {
            int nVal = GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_ARMOR_COLOR, c);
            object oPrev = oCopy;
            oCopy = CopyItemAndModify(oCopy,
                ITEM_APPR_TYPE_ARMOR_COLOR, c, nVal, TRUE);
            if (oPrev != oOrig) DestroyObject(oPrev);
        }
        if (oOrig != oCopy) DestroyObject(oOrig);
        CT_ReplaceItem(oTarget, oTrgItem, oCopy, CT_GetSlotType(nItemType));
        return;
    }

    // Shield: full CopyItem replaces target item geometry.
    if (nItemType == CT_ITEM_SHIELD) {
        object oCopy = CopyItem(oSrcItem, oTarget, FALSE);  // FALSE = don't add to inventory
        CT_ReplaceItem(oTarget, oTrgItem, oCopy, CT_GetSlotType(nItemType));
        return;
    }

    // Armor, cloak, helmet require a base item to modify.
    if (!GetIsObjectValid(oTrgItem)) return;

    int nAppr = (nItemType == CT_ITEM_CLOAK || nItemType == CT_ITEM_HELMET)
                    ? ITEM_APPR_TYPE_SIMPLE_MODEL
                    : ITEM_APPR_TYPE_ARMOR_MODEL;

    // Copy the primary model index.
    object oNew  = CopyItemAndModify(oTrgItem, nAppr, 0,
        GetItemAppearance(oSrcItem, nAppr, 0), TRUE);
    object oOrig = oNew;

    // Chain all 19 part indices and 6 color channels for armor.
    // Chain all 6 color channels for cloak and helmet.
    // Intermediates are destroyed immediately; oTrgItem is passed to
    // CT_ReplaceItem and destroyed via the action queue.
    if (nItemType == CT_ITEM_ARMOR) {
        int p;
        for (p = 0; p <= 18; p++) {
            int nVal = GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_ARMOR_MODEL, p);
            object oPrev = oNew;
            oNew = CopyItemAndModify(oNew, ITEM_APPR_TYPE_ARMOR_MODEL, p, nVal, TRUE);
            if (oPrev != oOrig) DestroyObject(oPrev);
        }
        int c;
        for (c = 0; c < 6; c++) {
            int nVal = GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_ARMOR_COLOR, c);
            object oPrev = oNew;
            oNew = CopyItemAndModify(oNew, ITEM_APPR_TYPE_ARMOR_COLOR, c, nVal, TRUE);
            if (oPrev != oOrig) DestroyObject(oPrev);
        }
        DestroyObject(oOrig);
    } else if (nItemType == CT_ITEM_CLOAK || nItemType == CT_ITEM_HELMET) {
        // Also copy all 6 color channels for cloak and helmet.
        int c;
        for (c = 0; c < 6; c++) {
            int nVal = GetItemAppearance(oSrcItem, ITEM_APPR_TYPE_ARMOR_COLOR, c);
            object oPrev = oNew;
            oNew = CopyItemAndModify(oNew, ITEM_APPR_TYPE_ARMOR_COLOR, c, nVal, TRUE);
            if (oPrev != oOrig) DestroyObject(oPrev);
        }
        DestroyObject(oOrig);
    }

    CT_ReplaceItem(oTarget, oTrgItem, oNew, CT_GetSlotType(nItemType));
}

// Sells the item in nItemType slot on oSession to oPC.
// - oSession:  The session NPC.
// - oPC:       The purchasing player character.
// - nItemType: CT_ITEM_* constant identifying the slot to purchase.
// * Blocks plot-flagged and cursed items.
// * ARMOR: blocks purchase if the NPC's torso AC (parts_chest.2da) differs
//   from the PC's torso AC. Prevents stat changes via appearance-only purchase.
// * Price: blueprint override (CT_PRICE_[N]) -> CT_OnPurchasePrice hook.
//   Returns -1 from hook to block the purchase.
// * Replaces any existing item on the PC in that slot via CT_ReplaceItem.
// * Calls CT_OnPurchaseComplete after a successful sale.
void CT_PurchaseItem(object oSession, object oPC, int nItemType) {
    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) {
        SendMessageToPC(oPC, CT_Error("Error: Slot is empty."));
        return;
    }
    if (GetPlotFlag(oItem)) {
        SendMessageToPC(oPC,CT_Error("That item cannot be purchased - it is a plot item."));
        return;
    }
    if (GetItemCursedFlag(oItem)) {
        SendMessageToPC(oPC, CT_Error("That item cannot be purchased - it is cursed."));
        return;
    }

    // ARMOR: torso AC guard - prevents stat cheating via appearance purchase.
    if (nItemType == CT_ITEM_ARMOR) {
        object oPCArmor = CT_GetItem(oPC, CT_ITEM_ARMOR);
        if (GetIsObjectValid(oPCArmor)) {
            int nNPCTorso = GetItemAppearance(oItem,   ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
            int nPCTorso  = GetItemAppearance(oPCArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
            string sNPCAC = Get2DAString("parts_chest", "ACBONUS", nNPCTorso);
            string sPCAC  = Get2DAString("parts_chest", "ACBONUS", nPCTorso);
            if (sNPCAC != sPCAC) {
                SendMessageToPC(oPC, CT_Error("That armor cannot be purchased - the torso model has a different base AC than yours."));
                return;
            }
        }
    }

    int nCost = CT_GetPurchaseCost(oSession, oPC, nItemType);
    if (nCost < 0) {
        SendMessageToPC(oPC, CT_Error("Cost < 0. That item cannot be purchased."));
        return;
    }
    if (GetGold(oPC) < nCost) {
        SendMessageToPC(oPC,
            CT_Error("INSUFFICIENT GOLD (" + IntToString(nCost) + "GP)!"));
        return;
    }

    TakeGoldFromCreature(nCost, oPC, TRUE);

    // Unequip the PC's current item into their inventory (do NOT destroy it).
    object oOldPC = CT_GetItem(oPC, nItemType);
    if (GetIsObjectValid(oOldPC)) AssignCommand(oPC, ActionUnequipItem(oOldPC));

    // Copy the NPC's item into the PC's inventory and equip it.
    object oCopy = CopyItem(oItem, oPC, TRUE);

    AssignCommand(oPC, ActionEquipItem(oCopy, CT_GetSlotType(nItemType)));

    SendMessageToPC(oPC, CT_Action("PURCHASED FOR " + IntToString(nCost) + "GP"));

    CT_OnPurchaseComplete(oPC, oCopy, nItemType, nCost);
}

// Copies the PC's equipped weapon or shield onto the session NPC for preview.
// - oSession:  The session NPC.
// - oPC:       The player character whose item to display.
// - nItemType: CT_ITEM_WEAPON or CT_ITEM_SHIELD only.
// * Uses CopyItem (not CopyItemAndModify) so the NPC displays the correct
//   weapon geometry, which is determined by base item type, not appearance.
// * Replaces any existing item in the NPC's slot via CT_ReplaceItem.
// * No-ops for item types other than weapon/shield (armor uses CT_ResetSession).
void CT_EquipPCItem(object oSession, object oPC, int nItemType) {
    if (nItemType != CT_ITEM_WEAPON && nItemType != CT_ITEM_SHIELD) {
        return;
    }
    object oSrc = CT_GetItem(oPC, nItemType);
    if (!GetIsObjectValid(oSrc)) {
        string sSlot = (nItemType == CT_ITEM_WEAPON) ? "weapon" : "shield";
        SendMessageToPC(oPC, CT_Error("You have no " + sSlot + " equipped."));
        return;
    }
    object oOld  = CT_GetItem(oSession, nItemType);
    object oCopy = CopyItem(oSrc, oSession, TRUE);
    CT_ReplaceItem(oSession, oOld, oCopy, CT_GetSlotType(nItemType));

    string sName  = GetName(oSrc);
    string sLabel = (nItemType == CT_ITEM_WEAPON) ? "WEAPON" : "SHIELD";
    SendMessageToPC(oPC,CT_Action("EQUIP: " + sLabel + " (" + sName + ")"));
}

// ============================================================================
// GRANULAR APPEARANCE COPY (single part / channel / style / weapon sub-part)
// ============================================================================
//
// All four functions below copy a single appearance attribute from oSource
// to oTarget without affecting any other slot or appearance value.
// Used by the dialogue menu system to give the player "Copy from / to my..."
// options inside each cycling submenu.
//
// All copies use CT_ReplaceItem (action queue, no delays) for clean equip.
// Each function silently no-ops if either side lacks the required item.

// Copies a single armor part model index from oSource's armor to oTarget's.
// - oSource: Creature to read the part value from.
// - oTarget: Creature to apply the part value to.
// - nPart:   Armor part index (0-18).
// * Both source and target must have armor equipped.
void CT_CopyArmorPart(object oSource, object oTarget, int nPart) {
    object oSrc = CT_GetItem(oSource, CT_ITEM_ARMOR);
    object oDst = CT_GetItem(oTarget, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oSrc) || !GetIsObjectValid(oDst)) return;
    int nValue = GetItemAppearance(oSrc, ITEM_APPR_TYPE_ARMOR_MODEL, nPart);
    object oNew = CopyItemAndModify(oDst,
        ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nValue, TRUE);
    CT_ReplaceItem(oTarget, oDst, oNew, INVENTORY_SLOT_CHEST);
}

// Copies a single color channel value from oSource's item to oTarget's item.
// - oSource:   Creature to read the color from.
// - oTarget:   Creature to apply the color to.
// - nItemType: CT_ITEM_ARMOR, CT_ITEM_CLOAK, or CT_ITEM_HELMET.
// - nChannel:  0-5 (CT_COLOR_CLOTH1 through CT_COLOR_METAL2).
// * Both source and target must have an item equipped in nItemType slot.
void CT_CopyItemColor(object oSource, object oTarget, int nItemType, int nChannel) {
    object oSrc = CT_GetItem(oSource, nItemType);
    object oDst = CT_GetItem(oTarget, nItemType);
    if (!GetIsObjectValid(oSrc) || !GetIsObjectValid(oDst)) return;
    int nValue = GetItemAppearance(oSrc, ITEM_APPR_TYPE_ARMOR_COLOR, nChannel);
    object oNew = CopyItemAndModify(oDst,
        ITEM_APPR_TYPE_ARMOR_COLOR, nChannel, nValue, TRUE);
    CT_ReplaceItem(oTarget, oDst, oNew, CT_GetSlotType(nItemType));
}

// Copies the SIMPLE_MODEL style index from oSource's item to oTarget's item.
// - oSource:   Creature to read the style from.
// - oTarget:   Creature to apply the style to.
// - nItemType: CT_ITEM_CLOAK, CT_ITEM_HELMET, or CT_ITEM_SHIELD.
// * Both source and target must have an item equipped in nItemType slot.
void CT_CopyItemStyle(object oSource, object oTarget, int nItemType) {
    object oSrc = CT_GetItem(oSource, nItemType);
    object oDst = CT_GetItem(oTarget, nItemType);
    if (!GetIsObjectValid(oSrc) || !GetIsObjectValid(oDst)) return;
    int nValue = GetItemAppearance(oSrc, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    object oNew = CopyItemAndModify(oDst,
        ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nValue, TRUE);
    CT_ReplaceItem(oTarget, oDst, oNew, CT_GetSlotType(nItemType));
}

// Copies a single weapon sub-model index from oSource's weapon to oTarget's.
// - oSource:   Creature to read the weapon part from.
// - oTarget:   Creature to apply the weapon part to.
// - nWeapPart: 0 = top, 1 = middle, 2 = bottom.
// * Both source and target must have a weapon equipped.
// * The weapon base item types do not need to match - appearance is purely
//   visual within the constraints of each weapon's per-base 2DA range.
void CT_CopyWeaponPart(object oSource, object oTarget, int nWeapPart) {
    object oSrc = CT_GetItem(oSource, CT_ITEM_WEAPON);
    object oDst = CT_GetItem(oTarget, CT_ITEM_WEAPON);
    if (!GetIsObjectValid(oSrc) || !GetIsObjectValid(oDst)) return;
    if (nWeapPart < 0 || nWeapPart > 2) return;
    int nValue = GetItemAppearance(oSrc, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart);
    object oNew = CopyItemAndModify(oDst,
        ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart, nValue, TRUE);
    CT_ReplaceItem(oTarget, oDst, oNew, INVENTORY_SLOT_RIGHTHAND);
}


