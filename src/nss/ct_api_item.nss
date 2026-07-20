/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - ITEM APPEARANCE (ct_api_item.nss) - v2.1.0
================================================================================
Overall appearance model cycling for cloak, helmet, weapon, and shield.

CLOAKS:   single SIMPLE_MODEL index from cloakmodel.2da. 6 color channels.
HELMETS:  single SIMPLE_MODEL index from parts_head.2da. 6 color channels.
SHIELDS:  single SIMPLE_MODEL index. No color channels.
WEAPONS:  three WEAPON_MODEL sub-indices (0=top, 1=middle, 2=bottom).
          Each sub-index reads from a per-base-item 2DA file.
          6 color channels (ITEM_APPR_TYPE_ARMOR_COLOR) are also supported.

Blank model rows (LABEL == "" or "****") are skipped during cycling.

Cloak and helmet max range is read directly from baseitems.2da MaxRange column.

All item replacements go through CT_ReplaceItem (ct_api.nss), which uses the
NPC's action queue to serialize unequip/destroy/equip with no DelayCommand.
================================================================================
*/

#include "ct_api"

// ============================================================================
// PROTOTYPES
// ============================================================================

void   CT_CycleItemAppearance(object oSession, int nItemType, int nDir);
void   CT_SetCloakInvisible(object oSession);
void   CT_CycleWeaponPart(object oSession, int nWeapPart, int nDir);
void   CT_CycleWeaponColor(object oSession, int nChannel, int nDir);
void   CT_CycleLeftWeaponAppearance(object oSession, int nWeapPart, int nDir);
void   CT_CycleLeftWeaponColor(object oSession, int nWeapPart, int nDir);
string CT_GetWeapon2DA(object oWeapon, int nWeapPart);
void   CT_SetItemColorExact(object oSession, int nItemType, int nChannel, int nValue);
void   CT_SetArmorPartExact(object oSession, int nPart, int nValue);
void   CT_SetItemStyleExact(object oSession, int nItemType, int nValue);

// ============================================================================
// IMPLEMENTATIONS
// ============================================================================

// Returns the per-base-item 2DA filename for a weapon sub-part model.
// - oWeapon:   The weapon item to inspect (uses GetBaseItemType).
// - nWeapPart: 0 = top, 1 = middle, 2 = bottom.
// * Uses raw integer values from this build's nwscript.nss instead of
//   BASE_ITEM_* symbolic constants, which have non-standard values in
//   this CEP2 build and several (MACE, FALCHION, SPEAR) are undefined.
// * Returns "" for unsupported base item types or invalid nWeapPart.
//
// Weapon 2DA files used by the engine:
//   Bastard sword:  wbsword_t / _m / _b      Battle axe:   wbattleaxe_t/_m/_b
//   Club:           wclub_t / _m / _b         Dagger:       wdagger_t/_m/_b
//   Dart:           wdart_t / _m / _b         Dire mace:    wdiremace_t/_m/_b
//   Double axe:     wdoubleaxe_t / _m / _b    Dwarvenwaraxe:wdwarvenwaraxe_t/_m/_b
//   Falchion:       wfalchion_t / _m / _b     Flail:        wflail_t/_m/_b
//   Greataxe:       wgreataxe_t / _m / _b     Greatsword:   wgreatsword_t/_m/_b
//   Halberd:        whalberd_t / _m / _b      Handaxe:      whandaxe_t/_m/_b
//   Heavy crossbow: whcrossbow_t / _m / _b    Heavy flail:  whflail_t/_m/_b
//   Kama:           wkama_t / _m / _b         Katana:       wkatana_t/_m/_b
//   Kukri:          wkukri_t / _m / _b        Light crossbow: wlcrossbow_t/_m/_b
//   Light flail:    wlflail_t / _m / _b       Light hammer: wlighthammer_t/_m/_b
//   Light mace:     wlmace_t / _m / _b        Longbow:      wlongbow_t/_m/_b
//   Longsword:      wlsword_t / _m / _b       Mace:         wmace_t/_m/_b
//   Morningstar:    wmstar_t / _m / _b        Quarterstaff: wqstaff_t/_m/_b
//   Rapier:         wrapier_t / _m / _b       Scimitar:     wscimitar_t/_m/_b
//   Scythe:         wscythe_t / _m / _b       Shortbow:     wsbow_t/_m/_b
//   Shortspear:     wsspear_t / _m / _b       Shortsword:   wssword_t/_m/_b
//   Shuriken:       wshuriken_t / _m / _b     Sickle:       wsickle_t/_m/_b
//   Sling:          wsling_t / _m / _b        Spear:        wspear_t/_m/_b
//   Throwing axe:   wthrowaxe_t / _m / _b     Trident:      wtrident_t/_m/_b
//   Two-bladed sword: wtwobladed_t / _m / _b  Warhammer:    wwarhammer_t/_m/_b
//   Whip:           wwhip_t / _m / _b
string CT_GetWeapon2DA(object oWeapon, int nWeapPart) {
    if (nWeapPart < 0 || nWeapPart > 2) return "";

    string sSuffix = "";
    // Per nwscript: ITEM_APPR_WEAPON_MODEL_BOTTOM=0, MIDDLE=1, TOP=2
    if      (nWeapPart == 0) sSuffix = "_b";
    else if (nWeapPart == 1) sSuffix = "_m";
    else                     sSuffix = "_t";

    // Integer values taken directly from this build's nwscript.nss / baseitems.2da.
    // Symbolic BASE_ITEM_* constants are NOT used here because several
    // are undefined or have non-standard values in this CEP2 build.
    // NOTE: "Mace" and "Spear" referenced in older comments refer to lightmace (9)
    // and shortspear (58) respectively — both handled below. There is no plain
    // "mace" or "spear" row in vanilla or CEP2 baseitems.2da.
    string sPrefix = "";
    int nBase = GetBaseItemType(oWeapon);
    if      (nBase == 3)   sPrefix = "wbsword";        // BASE_ITEM_BASTARDSWORD
    else if (nBase == 2)   sPrefix = "wbattleaxe";     // BASE_ITEM_BATTLEAXE
    else if (nBase == 28)  sPrefix = "wclub";          // BASE_ITEM_CLUB
    else if (nBase == 22)  sPrefix = "wdagger";        // BASE_ITEM_DAGGER
    else if (nBase == 31)  sPrefix = "wdart";          // BASE_ITEM_DART
    else if (nBase == 32)  sPrefix = "wdiremace";      // BASE_ITEM_DIREMACE
    else if (nBase == 33)  sPrefix = "wdoubleaxe";     // BASE_ITEM_DOUBLEAXE
    else if (nBase == 108) sPrefix = "wdwarvenwaraxe"; // BASE_ITEM_DWARVENWARAXE
    else if (nBase == 305) sPrefix = "wfalchion";      // CEP2 falchion (baseitems row 305)
    else if (nBase == 18)  sPrefix = "wgreataxe";      // BASE_ITEM_GREATAXE
    else if (nBase == 13)  sPrefix = "wgreatsword";    // BASE_ITEM_GREATSWORD
    else if (nBase == 10)  sPrefix = "whalberd";       // BASE_ITEM_HALBERD
    else if (nBase == 38)  sPrefix = "whandaxe";       // BASE_ITEM_HANDAXE
    else if (nBase == 6)   sPrefix = "whcrossbow";     // BASE_ITEM_HEAVYCROSSBOW
    else if (nBase == 35)  sPrefix = "whflail";        // BASE_ITEM_HEAVYFLAIL
    else if (nBase == 40)  sPrefix = "wkama";          // BASE_ITEM_KAMA
    else if (nBase == 41)  sPrefix = "wkatana";        // BASE_ITEM_KATANA
    else if (nBase == 42)  sPrefix = "wkukri";         // BASE_ITEM_KUKRI
    else if (nBase == 7)   sPrefix = "wlcrossbow";     // BASE_ITEM_LIGHTCROSSBOW
    else if (nBase == 4)   sPrefix = "wlflail";        // BASE_ITEM_LIGHTFLAIL
    else if (nBase == 37)  sPrefix = "wlighthammer";   // BASE_ITEM_LIGHTHAMMER
    else if (nBase == 9)   sPrefix = "wlmace";         // BASE_ITEM_LIGHTMACE
    else if (nBase == 8)   sPrefix = "wlongbow";       // BASE_ITEM_LONGBOW
    else if (nBase == 1)   sPrefix = "wlsword";        // BASE_ITEM_LONGSWORD
    else if (nBase == 47)  sPrefix = "wmstar";         // BASE_ITEM_MORNINGSTAR
    else if (nBase == 50)  sPrefix = "wqstaff";        // BASE_ITEM_QUARTERSTAFF
    else if (nBase == 51)  sPrefix = "wrapier";        // BASE_ITEM_RAPIER
    else if (nBase == 53)  sPrefix = "wscimitar";      // BASE_ITEM_SCIMITAR
    else if (nBase == 55)  sPrefix = "wscythe";        // BASE_ITEM_SCYTHE
    else if (nBase == 11)  sPrefix = "wsbow";          // BASE_ITEM_SHORTBOW
    else if (nBase == 58)  sPrefix = "wsspear";        // BASE_ITEM_SHORTSPEAR
    else if (nBase == 0)   sPrefix = "wssword";        // BASE_ITEM_SHORTSWORD
    else if (nBase == 59)  sPrefix = "wshuriken";      // BASE_ITEM_SHURIKEN
    else if (nBase == 60)  sPrefix = "wsickle";        // BASE_ITEM_SICKLE
    else if (nBase == 61)  sPrefix = "wsling";         // BASE_ITEM_SLING
    else if (nBase == 63)  sPrefix = "wthrowaxe";      // BASE_ITEM_THROWINGAXE
    else if (nBase == 95)  sPrefix = "wtrident";       // BASE_ITEM_TRIDENT
    else if (nBase == 12)  sPrefix = "wtwobladed";     // BASE_ITEM_TWOBLADEDSWORD
    else if (nBase == 5)   sPrefix = "wwarhammer";     // BASE_ITEM_WARHAMMER
    else if (nBase == 111) sPrefix = "wwhip";          // BASE_ITEM_WHIP
    return (sPrefix == "") ? "" : sPrefix + sSuffix;
}

// Cycles the overall appearance model of cloak, helmet, or shield.
// - oSession:  The session NPC target.
// - nItemType: CT_ITEM_CLOAK, CT_ITEM_HELMET, or CT_ITEM_SHIELD.
//              CT_ITEM_WEAPON is NOT supported here - use CT_CycleWeaponPart.
// - nDir:      CT_NEXT (1) or CT_BACK (-1).
// * Each item type handled with appropriate appearance property.
// * Gets valid bounds from baseitems.2da MinRange/MaxRange.
// * do/while loop validates that CopyItemAndModify actually creates valid item.
// * Skips invalid appearance indices automatically.
// * Sets custom token for dialog display (instead of ).
// * No-ops if no item is equipped, or if called with CT_ITEM_WEAPON.
void CT_CycleItemAppearance(object oSession, int nItemType, int nDir) {
    if (nItemType == CT_ITEM_WEAPON) {
        return;
    }

    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) return;

    // Handle each item type with appropriate cycling
    switch (nItemType) {

    case CT_ITEM_HELMET:
        // HELMET: Use ITEM_APPR_TYPE_ARMOR_MODEL for head shape (mk_ pattern)
        {
            object oPC = GetPCSpeaker();
            int nMin = 1;  // Helmets always start at 1
            int nMax = StringToInt(Get2DAString("baseitems", "MaxRange", BASE_ITEM_HELMET));

            // Read current appearance - try ARMOR_MODEL first (mk_ uses this for helmets)
            int nNext = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
            if (nNext < nMin || nNext > nMax) {
                nNext = nMin;
            }

            int iLastChatInt = GetLocalInt(oPC,"LAST_CHAT_INT");
            if (iLastChatInt>0)  {nNext = iLastChatInt; SetLocalInt(oPC,"LAST_CHAT_INT",0);}

            // Cycle with validation: destroy failed copies, guard with safety counter.
            object oNew = OBJECT_INVALID;
            int nSafety = 0;
            do {
                nNext += nDir;
                if (nNext > nMax) nNext = nMin;
                if (nNext < nMin) nNext = nMax;

                oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0, nNext, TRUE);
                if (GetIsObjectValid(oNew)) {
                    int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
                    if (nVerify != nNext) {
                        DestroyObject(oNew);
                        oNew = OBJECT_INVALID;
                    }
                }
                nSafety++;
            } while (!GetIsObjectValid(oNew) && nSafety < nMax);
            if (!GetIsObjectValid(oNew)) return;
            CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(CT_ITEM_HELMET));
            SetCustomToken(CT_TOKEN_PARTNUMBER, CT_Label("Helmet Style") +
                CT_Value(": " + IntToString(nNext) + "/" + IntToString(nMax)));
            CT_NotifyCycledItem(GetPCSpeaker(), CT_Label("Helmet Style"), "Style", nNext, nMax);
        }
        break;

    case CT_ITEM_CLOAK:
        // CLOAK: Use ITEM_APPR_TYPE_SIMPLE_MODEL for style
        {
            object oPC = GetPCSpeaker();
            int nMin = 1;  // Cloaks always start at 1
            int nMax = StringToInt(Get2DAString("baseitems", "MaxRange", BASE_ITEM_CLOAK));

            int nNext = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            if (nNext < nMin || nNext > nMax) {
                nNext = nMin;
            }

            int iLastChatInt = GetLocalInt(oPC,"LAST_CHAT_INT");
            if (iLastChatInt>0)  {nNext = iLastChatInt; SetLocalInt(oPC,"LAST_CHAT_INT",0);}

            object oNew = OBJECT_INVALID;
            do {
                nNext += nDir;
                if (nNext > nMax) nNext = nMin;
                if (nNext < nMin) nNext = nMax;

                oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nNext, TRUE);
                // Verify the model was actually set (not a placeholder/error model)
                if (GetIsObjectValid(oNew)) {
                    int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
                    if (nVerify != nNext)
                    {
                        DestroyObject(oNew);
                        oNew = OBJECT_INVALID;
                    }
                }
            } while (!GetIsObjectValid(oNew));

            CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(CT_ITEM_CLOAK));
            SetCustomToken(CT_TOKEN_PARTNUMBER, CT_Label("Cloak Style") +
                CT_Value(": " + IntToString(nNext) + "/" + IntToString(nMax)));
            CT_NotifyCycledItem(GetPCSpeaker(), CT_Label("Cloak Style"), "Style", nNext, nMax);
        }
        break;

    case CT_ITEM_SHIELD:
        // SHIELD: Use ITEM_APPR_TYPE_SIMPLE_MODEL for style
        // Validates that models exist AND that they're not error placeholders
        {
            object oPC = GetPCSpeaker();
            int nMin = 1;
            int nMax = 255;

            int nNext = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            if (nNext < nMin || nNext > nMax) {
                nNext = nMin;
            }

            int iLastChatInt = GetLocalInt(oPC,"LAST_CHAT_INT");
            if (iLastChatInt>0)  {nNext = iLastChatInt; SetLocalInt(oPC,"LAST_CHAT_INT",0);}

            // Shield validation: skip blank LABELs and verify item creation succeeds
            object oNew = OBJECT_INVALID;
            int nSafety = 0;
            do {
                nNext += nDir;
                if (nNext > nMax) nNext = nMin;
                if (nNext < nMin) nNext = nMax;

                // Check if this model might exist (non-empty LABEL in wshield.2da)
                // string sLabel = Get2DAString("wshield", "LABEL", nNext);
                //if (sLabel != "" && sLabel != "****")
                //{

                    // Try to create - do/while validates it actually works
                    oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nNext, TRUE);

                    // Verify the model was actually set (not a placeholder error model)
                    int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
                    if (!GetIsObjectValid(oNew) || nVerify != nNext)
                    {
                        DestroyObject(oNew);
                        oNew = OBJECT_INVALID;  // Skip - appearance didn't actually change, likely error model
                    }

               // } else { oNew = OBJECT_INVALID;{  // Skip - empty label means no model

                nSafety++;
            } while (!GetIsObjectValid(oNew) && nSafety < nMax);

            // If we couldn't find a valid model after cycling through all, abort
            if (!GetIsObjectValid(oNew)) return;

            CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(CT_ITEM_SHIELD));
            SetCustomToken(CT_TOKEN_PARTNUMBER,
                CT_Label("Shield Style") +
                CT_Value(": " + IntToString(nNext) + "/" + IntToString(nMax)));
                CT_NotifyCycledItem(GetPCSpeaker(), CT_Label("Shield Style"), "Style", nNext, nMax);
        }
        break;
    }
}

// Sets a color channel on an item to an exact value entered by the player.
// - oSession:  The session NPC target.
// - nItemType: CT_ITEM_ARMOR, CT_ITEM_CLOAK, or CT_ITEM_HELMET.
// - nChannel:  Material channel (0-5).
// - nValue:    Exact color palette index (0-175). Clamped to valid range.
// * No-ops if no item is equipped in the specified slot.
void CT_SetItemColorExact(object oSession, int nItemType, int nChannel, int nValue) {
    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) return;

    // Clamp to valid palette range
    if (nValue < 0)   nValue = 0;
    if (nValue > 175) nValue = 175;

    // Must use ITEM_APPR_TYPE_ARMOR_COLOR (= 4), NOT nItemType (CT_ITEM_* = 1-5).
    // Passing nItemType here would corrupt the item by modifying the wrong appearance
    // property type (e.g. ITEM_APPR_TYPE_ARMOR_MODEL instead of ARMOR_COLOR for armor).
    object oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nChannel, nValue, TRUE);
    if (!GetIsObjectValid(oNew)) return;
    CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(nItemType));
    SendMessageToPC(GetPCSpeaker(),
        CT_Label("COLOR: " + CT_GetChannelName(nChannel) + " = ") +
        CT_Value(IntToString(nValue) + "/175"));
}

// Sets an armor part model to an exact value entered by the player.
// - oSession: The session NPC target.
// - nPart:    Armor part index (0-18). Torso (7) is AC-locked; use CT_CustomizeArmorPart
//             for torso so the AC guard runs. This function skips the torso.
// - nValue:   Exact model index (1-255). Clamped to valid range.
// * Reads nValue from the PC's LAST_CHAT_INT local int (set by ct_module_chat).
// * No-ops if no armor is equipped on oSession, or if nPart is the torso.
void CT_SetArmorPartExact(object oSession, int nPart, int nValue) {
    // Use ITEM_APPR_ARMOR_MODEL_TORSO (not CREATURE_PART_TORSO) — both equal 7 in
    // this build, but the correct semantic constant for armor appearance is ITEM_APPR.
    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO) {
        SendMessageToPC(GetPCSpeaker(),
            CT_Error("Torso cannot be set directly - use Next/Previous to respect AC lock."));
        return;
    }
    object oArmor = CT_GetItem(oSession, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oArmor)) return;

    // Clamp to valid model range
    if (nValue < 1)   nValue = 1;
    if (nValue > 255) nValue = 255;

    object oNew = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nValue, TRUE);
    if (!GetIsObjectValid(oNew)) {
        SendMessageToPC(GetPCSpeaker(),
            CT_Warning("Part " + IntToString(nValue) + " is not valid for this slot."));
        return;
    }
    // Verify the engine actually accepted the model
    int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_ARMOR_MODEL, nPart);
    if (nVerify != nValue) {
        DestroyObject(oNew);
        SendMessageToPC(GetPCSpeaker(),
            CT_Warning("Part " + IntToString(nValue) + " is not valid for this slot."));
        return;
    }
    CT_ReplaceItem(oSession, oArmor, oNew, INVENTORY_SLOT_CHEST);
    SendMessageToPC(GetPCSpeaker(),
        CT_Warning(CT_GetPartName(nPart) + ": " + IntToString(nValue) + "/255"));
}

// Sets the SIMPLE_MODEL style index on a cloak or helmet to an exact value.
// - oSession:  The session NPC target.
// - nItemType: CT_ITEM_CLOAK or CT_ITEM_HELMET only.
// - nValue:    Exact style index (1-255). Clamped to valid range.
// * Reads nValue from the PC's LAST_CHAT_INT local int (set by ct_module_chat).
// * No-ops if no item is equipped or nItemType is not cloak/helmet.
void CT_SetItemStyleExact(object oSession, int nItemType, int nValue) {
    if (nItemType != CT_ITEM_CLOAK && nItemType != CT_ITEM_HELMET) return;
    object oItem = CT_GetItem(oSession, nItemType);
    if (!GetIsObjectValid(oItem)) return;

    // Clamp to valid model range
    if (nValue < 1)   nValue = 1;
    if (nValue > 255) nValue = 255;

    object oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nValue, TRUE);
    if (!GetIsObjectValid(oNew)) {
        SendMessageToPC(GetPCSpeaker(),
            CT_Warning(CT_ItemLabel(nItemType) + " style " + IntToString(nValue) + " is not valid."));
        return;
    }
    // Verify the engine actually accepted the model
    int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    if (nVerify != nValue) {
        DestroyObject(oNew);
        SendMessageToPC(GetPCSpeaker(),
            CT_Warning(CT_ItemLabel(nItemType) + " style " + IntToString(nValue) + " is not valid."));
        return;
    }
    CT_ReplaceItem(oSession, oItem, oNew, CT_GetSlotType(nItemType));
    SendMessageToPC(GetPCSpeaker(),
        CT_Label(CT_ItemLabel(nItemType) + " Style: ") + CT_Value(IntToString(nValue)));
}



// Sets the cloak SIMPLE_MODEL to 99 (engine invisible / no-model row).
// Notifies the PC speaker of the change.
void CT_SetCloakInvisible(object oSession) {
    object oPC   = GetPCSpeaker();
    object oItem = CT_GetItem(oSession, CT_ITEM_CLOAK);
    if (!GetIsObjectValid(oItem)) return;
    object oNew = CopyItemAndModify(oItem,
        ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 99, TRUE);
    CT_ReplaceItem(oSession, oItem, oNew, INVENTORY_SLOT_CLOAK);
    SendMessageToPC(oPC, CT_Label("CLOAK: invisible") + CT_Value(" (99)"));
}

// Cycles one of the three weapon sub-model parts (top/middle/bottom).
// - oSession:  The session NPC target.
// - nWeapPart: 0 = bottom, 1 = middle, 2 = top.
// - nDir:      CT_NEXT (1) or CT_BACK (-1).
// * Each weapon part cycles independently through valid model indices.
// * Detects weapon in either right or left hand.
// * No-ops if no weapon is equipped.
void CT_CycleWeaponPart(object oSession, int nWeapPart, int nDir) {
    object oPC = GetPCSpeaker();

    // Get weapon from either hand
    object oWeapon = CT_GetItem(oSession, CT_ITEM_WEAPON);
    if (!GetIsObjectValid(oWeapon)) {
        // Try left hand if right hand is empty
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSession);
        if (!GetIsObjectValid(oWeapon) || GetBaseItemType(oWeapon) > 127) {
            return;  // Not a weapon
        }
    }

    if (nWeapPart < 0 || nWeapPart > 2) return;

    // Get current model value - weapons typically range 1-40 or so
    int nNext = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart);

    // Handle starting from 0 by moving to 1
    if (nNext < 1) nNext = 1;

    // Cycle with validation loop: skip indices that don't produce a valid item.
    // Mirrors the do/while pattern used in CT_CustomizeArmorPart and CT_CycleItemAppearance.
    int nMax = 25;
    object oNew = OBJECT_INVALID;
    int nSafety = 0;
    do {
        nNext += nDir;
        if (nNext > nMax) nNext = 1;
        if (nNext < 1)    nNext = nMax;
        oNew = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart, nNext, TRUE);
        if (GetIsObjectValid(oNew)) {
            int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart);
            if (nVerify != nNext) {
                DestroyObject(oNew);
                oNew = OBJECT_INVALID;
            }
        }
        nSafety++;
    } while (!GetIsObjectValid(oNew) && nSafety < nMax);

    if (!GetIsObjectValid(oNew)) return;  // No valid model found in full range

    // Determine which slot weapon is in and use that for replacement
    int nSlot = INVENTORY_SLOT_RIGHTHAND;
    if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSession) == oWeapon) {
        nSlot = INVENTORY_SLOT_LEFTHAND;
    }

    // oNew is already the validated copy from the do/while loop above.
    CT_ReplaceItem(oSession, oWeapon, oNew, nSlot);

    // Set custom token for display with colors
    SetCustomToken(CT_TOKEN_PARTNUMBER, CT_Label(CT_GetWeaponPartName(nWeapPart)) +
        CT_Value(": " + IntToString(nNext) + "/" + IntToString(nMax)));
    CT_NotifyCycledItem(GetPCSpeaker(), CT_Label(CT_GetWeaponPartName(nWeapPart)), "Model", nNext, nMax);
}

// Cycles the color for one weapon part.
// - oSession:  The session NPC target.
// - nWeapPart: 0=Bottom, 1=Middle, 2=Top.
// - nDir:      CT_NEXT (1) or CT_BACK (-1). Wraps 1-4.
// * Uses ITEM_APPR_TYPE_WEAPON_COLOR with channels BOTTOM/MIDDLE/TOP.
// * Color values 1-4 (standard weapon colors).
// * Each weapon part has independent color.
// * Detects weapon in either right or left hand.
// * No-ops if no weapon is equipped.
void CT_CycleWeaponColor(object oSession, int nWeapPart, int nDir) {
    object oPC = GetPCSpeaker();

    // Get weapon from either hand
    object oWeapon = CT_GetItem(oSession, CT_ITEM_WEAPON);
    if (!GetIsObjectValid(oWeapon)) {
        // Try left hand if right hand is empty
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSession);
        if (!GetIsObjectValid(oWeapon) || GetBaseItemType(oWeapon) > 127) {
            return;  // Not a weapon
        }
    }

    if (nWeapPart < 0 || nWeapPart > 2) return;

    // Map weapon part to color channel: BOTTOM=0, MIDDLE=1, TOP=2
    int nChannel;
    if      (nWeapPart == 0) nChannel = ITEM_APPR_WEAPON_COLOR_BOTTOM;
    else if (nWeapPart == 1) nChannel = ITEM_APPR_WEAPON_COLOR_MIDDLE;
    else                     nChannel = ITEM_APPR_WEAPON_COLOR_TOP;

    // Weapon colors range 1-4 (standard colors)
    int nMax = 4;
    int nNext = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_COLOR, nChannel) + nDir;
    if (nNext > nMax) nNext = 1;
    if (nNext < 1) nNext = nMax;

    // Determine which slot weapon is in and use that for replacement
    int nSlot = INVENTORY_SLOT_RIGHTHAND;
    if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSession) == oWeapon) {
        nSlot = INVENTORY_SLOT_LEFTHAND;
    }

    object oNew = CopyItemAndModify(oWeapon,
        ITEM_APPR_TYPE_WEAPON_COLOR, nChannel, nNext, TRUE);
    CT_ReplaceItem(oSession, oWeapon, oNew, nSlot);

    // Set custom token for display with colors
    SetCustomToken(CT_TOKEN_PARTNUMBER, CT_Label("Color " + CT_GetChannelName(nChannel)) +
        CT_Value(": " + IntToString(nNext) + "/" + IntToString(nMax)));
    CT_NotifyCycledItem(GetPCSpeaker(), CT_Label("Color " + CT_GetChannelName(nChannel)), "Color", nNext, nMax);
}

// Cycles the weapon model for a LEFT-HAND weapon.
// - oSession:  The session NPC target.
// - nWeapPart: Which part to cycle (0=Bottom, 1=Middle, 2=Top).
// - nDir:      CT_NEXT (1) or CT_BACK (-1). Wraps 1-40.
// * Gets weapon from LEFT HAND SLOT only.
// * No-ops if no weapon in left hand.
void CT_CycleLeftWeaponAppearance(object oSession, int nWeapPart, int nDir) {
    object oPC = GetPCSpeaker();

    // Get weapon from LEFT HAND ONLY
    object oWeapon = CT_GetLeftHandItem(oSession);
    if (!GetIsObjectValid(oWeapon) || GetBaseItemType(oWeapon) > 127) {
        SendMessageToPC(oPC, CT_Error("No weapon in left hand."));
        return;
    }

    if (nWeapPart < 0 || nWeapPart > 2) return;

    int nMax = 40;
    int nNext = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart);
    if (nNext < 1) nNext = 1;

    // Determine which slot weapon is in (should be left hand, but verify)
    int nSlot = INVENTORY_SLOT_LEFTHAND;
    if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSession) == oWeapon) {
        nSlot = INVENTORY_SLOT_RIGHTHAND;
    }

    // Cycle with validation loop matching CT_CycleWeaponPart: skip indices
    // that produce invalid items or whose appearance value does not stick.
    object oNew = OBJECT_INVALID;
    int nSafety = 0;
    do {
        nNext += nDir;
        if (nNext > nMax) nNext = 1;
        if (nNext < 1)    nNext = nMax;
        oNew = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart, nNext, TRUE);
        if (GetIsObjectValid(oNew)) {
            int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_WEAPON_MODEL, nWeapPart);
            if (nVerify != nNext) {
                DestroyObject(oNew);
                oNew = OBJECT_INVALID;
            }
        }
        nSafety++;
    } while (!GetIsObjectValid(oNew) && nSafety < nMax);
    if (!GetIsObjectValid(oNew)) return;

    CT_ReplaceItem(oSession, oWeapon, oNew, nSlot);

    // Set custom token for display with colors
    SetCustomToken(CT_TOKEN_PARTNUMBER,
        CT_Label("LEFT " + CT_GetWeaponPartName(nWeapPart)) +
        CT_Info(": " + IntToString(nNext) + "/" + IntToString(nMax)));
        CT_NotifyCycledItem(GetPCSpeaker(),
        CT_Label("LEFT " + CT_GetWeaponPartName(nWeapPart)), "Model", nNext, nMax);
}

// Cycles the color for a LEFT-HAND weapon part.
// - oSession:  The session NPC target.
// - nWeapPart: 0=Bottom, 1=Middle, 2=Top.
// - nDir:      CT_NEXT (1) or CT_BACK (-1). Wraps 1-4.
// * Gets weapon from LEFT HAND SLOT only.
// * Color values 1-4 (standard weapon colors).
// * No-ops if no weapon in left hand.
void CT_CycleLeftWeaponColor(object oSession, int nWeapPart, int nDir) {
    object oPC = GetPCSpeaker();

    // Get weapon from LEFT HAND ONLY
    object oWeapon = CT_GetLeftHandItem(oSession);
    if (!GetIsObjectValid(oWeapon) || GetBaseItemType(oWeapon) > 127) {
        SendMessageToPC(oPC, CT_Error("No weapon in left hand."));
        return;
    }

    if (nWeapPart < 0 || nWeapPart > 2) return;

    // Map weapon part to color channel: BOTTOM=0, MIDDLE=1, TOP=2
    int nChannel;
    if      (nWeapPart == 0) nChannel = ITEM_APPR_WEAPON_COLOR_BOTTOM;
    else if (nWeapPart == 1) nChannel = ITEM_APPR_WEAPON_COLOR_MIDDLE;
    else                     nChannel = ITEM_APPR_WEAPON_COLOR_TOP;

    // Weapon colors range 1-4 (standard colors)
    int nMax = 4;
    int nNext = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_COLOR, nChannel) + nDir;
    if (nNext > nMax) nNext = 1;
    if (nNext < 1) nNext = nMax;

    // Determine which slot weapon is in (should be left hand, but verify)
    int nSlot = INVENTORY_SLOT_LEFTHAND;
    if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSession) == oWeapon) {
        nSlot = INVENTORY_SLOT_RIGHTHAND;
    }

    object oNew = CopyItemAndModify(oWeapon,
        ITEM_APPR_TYPE_WEAPON_COLOR, nChannel, nNext, TRUE);

    CT_ReplaceItem(oSession, oWeapon, oNew, nSlot);

    // Set custom token for display with colors
    SetCustomToken(CT_TOKEN_PARTNUMBER,
        CT_Label("LEFT Color " + CT_GetChannelName(nChannel)) +
        CT_Info(": " + IntToString(nNext) + "/" + IntToString(nMax)));
        CT_NotifyCycledItem(GetPCSpeaker(),
        CT_Label("LEFT Color " + CT_GetChannelName(nChannel)), "Color", nNext, nMax);
}


