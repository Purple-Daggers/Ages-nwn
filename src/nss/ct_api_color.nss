/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - COLOR CYCLING (ct_api_color.nss) - v2.1.0
================================================================================
Color channel cycling for all equippable item types (0-175 value range).
Included by ct_api_sess.nss. Do not include directly in entry points.

nChannel is FIXED (which material: cloth1/cloth2/leather/etc.).
nDir steps the COLOR VALUE (0-175) within that channel.

All item replacements go through CT_ReplaceItem (ct_api.nss), which uses the
NPC's action queue to serialize unequip/destroy/equip with no DelayCommand.
================================================================================
*/

#include "ct_api"

// ============================================================================
// PROTOTYPES
// ============================================================================

void CT_CycleItemColor(object oSession, int nItemType, int nChannel, int nDir);

// ============================================================================
// IMPLEMENTATIONS
// ============================================================================

// Cycles the color VALUE on one fixed channel of an item equipped on oSession.
// - oSession:  The session NPC target.
// - nItemType: CT_ITEM_* constant identifying the item to recolor.
// - nChannel:  The material channel to change (CT_COLOR_CLOTH1 through
//              CT_COLOR_METAL2, i.e. 0-5, or 0-10 when CEP_EXTENDED = TRUE).
//              This is FIXED - nDir does not move between channels.
// - nDir:      CT_NEXT (1) or CT_BACK (-1). Steps the color value 0-175.
// * Color values run 0-175 (NWN's full palette range per channel).
// * Wraps: value 175 + 1 = 0; value 0 - 1 = 175.
// * No-ops if no item is equipped in the specified slot.
// * Notifies the PC speaker with the channel name and new value.
void CT_CycleItemColor(object oSession, int nItemType, int nChannel, int nDir) {
    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) return;

    // Validate that nChannel is a fixed, valid material channel index (0-5).
    if (nChannel < 0) return;
    if (nChannel > 5) return;
    // Read the current color VALUE (0-175) stored in this channel.
    int nCurrent = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nChannel);

    // Step the value and wrap within the NWN palette range 0-175.
    int nNext = nCurrent + nDir;
    if (nNext > 175) nNext = 0;
    if (nNext < 0)   nNext = 175;

    object oNew = CopyItemAndModify(oItem,
        ITEM_APPR_TYPE_ARMOR_COLOR, nChannel, nNext, TRUE);
    CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(nItemType));
    SendMessageToPC(GetPCSpeaker(),
        CT_Label("COLOR: " + CT_GetChannelName(nChannel) + " = ") +
        CT_Value(IntToString(nNext) + "/175"));
}

