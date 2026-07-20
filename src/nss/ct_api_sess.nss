/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - SESSION (ct_api_sess.nss) - v1.1.0
================================================================================
Top-level include for the tailor system. Pulls in all sub-files and provides:
  - Per-PC session lifecycle (CT_CreateSession / CT_DestroySession)
  - Gender and race preview on the session NPC

INCLUDE CHAIN:
  ct_api_sess.nss
    ct_api_part.nss  -> ct_api.nss
    ct_api_color.nss -> ct_api.nss
    ct_api_item.nss  -> ct_api.nss
    ct_api_econ.nss  -> ct_api.nss

SESSION MODEL:
  The real tailor NPC is used directly as the session target. No separate
  creature is spawned. CT_CreateSession registers the NPC on the PC. All item
  modifications are applied to the real NPC. Multiple simultaneous sessions
  are managed by tracking which NPC is assigned to which PC via CT_SESSION_VAR.
================================================================================
*/

#include "ct_api_part"
#include "ct_api_color"
#include "ct_api_item"
#include "ct_api_econ"

// ============================================================================
// PROTOTYPES
// ============================================================================

// Session management
object CT_GetSession(object oPC);
void   CT_CreateSession(object oPC, object oTailorNPC);
void   CT_DestroySession(object oPC);
void   CT_SwapGender(object oPC, object oNPC);
void   CT_SetRace(object oPC, object oNPC, int nRace);
void   CT_CopyPCEquipmentToSession(object oPC, object oSession);

// Main dispatchers

// ============================================================================
// SESSION MANAGEMENT
// ============================================================================

// Returns the private session NPC for oPC, or OBJECT_INVALID if none exists.
// - oPC: The player character whose session to retrieve.
// * Sessions are stored as local objects on the PC via CT_SESSION_VAR.
object CT_GetSession(object oPC) {
    return GetLocalObject(oPC, CT_SESSION_VAR);
}

// Registers oTailorNPC as the session target for oPC.
// - oPC:        The player character opening the tailor conversation.
// - oTailorNPC: The real tailor NPC.
// * Stores oTailorNPC as the session object on oPC. No separate creature
//   is spawned - the real NPC is used directly as the appearance target.
// * Overwrites any previous session reference left on the PC.
void CT_CreateSession(object oPC, object oTailorNPC) {
    // Clear any previous session reference.
    DeleteLocalObject(oPC, CT_SESSION_VAR);
    SetLocalObject(oPC, CT_SESSION_VAR, oTailorNPC);
}

// Clears all session state variables on oPC.
// - oPC: The player character whose session to end.
// * The real tailor NPC is not destroyed - it persists for other players.
// * Safe to call if no session exists - no-ops silently.
void CT_DestroySession(object oPC) {
    DeleteLocalObject(oPC, CT_SESSION_VAR);
    DeleteLocalInt(oPC,    "CT_SESSION_GENDER");
    DeleteLocalInt(oPC,    "CT_SESSION_GENDER_SET");
    DeleteLocalInt(oPC,    "CT_SESSION_RACE");
    DeleteLocalInt(oPC,    "CT_SESSION_RACE_SET");
}

// Toggles the NPC's gender between male and female.
// - oPC: The player character.
// - oNPC: The session NPC to toggle.
// * Gender toggle is immediate. Appearance is reset to base on gender change.
// * Uses CT_SESSION_GENDER local int to track current gender state.
void CT_SwapGender(object oPC, object oNPC) {
    if (!GetIsObjectValid(oNPC)) return;

    // Get current gender (default to NPC's actual gender first time)
    int nCurrent = GetLocalInt(oPC, "CT_SESSION_GENDER");
    if (!GetLocalInt(oPC, "CT_SESSION_GENDER_SET")) {
        nCurrent = GetGender(oNPC);
        SetLocalInt(oPC, "CT_SESSION_GENDER_SET", TRUE);
    }

    // Toggle to opposite gender
    int nNew = (nCurrent == GENDER_FEMALE) ? GENDER_MALE : GENDER_FEMALE;
    SetGender(oNPC, nNew);
    SetLocalInt(oPC, "CT_SESSION_GENDER", nNew);

    if (CT_SWAP_GENDER_COPY_APPEARANCE) {
        // Preserve current appearance: re-equip copies of all items to force
        // geometry refresh after the gender change without losing any edits.
        // Unrolled explicitly by slot — NWScript does not support arrays.
        object oItem; object oCopy;
        oItem = CT_GetItem(oNPC, CT_ITEM_CLOAK);
        if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_CLOAK)); }
        oItem = CT_GetItem(oNPC, CT_ITEM_HELMET);
        if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_HELMET)); }
        oItem = CT_GetItem(oNPC, CT_ITEM_ARMOR);
        if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_ARMOR)); }
        oItem = CT_GetItem(oNPC, CT_ITEM_WEAPON);
        if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_WEAPON)); }
        oItem = CT_GetItem(oNPC, CT_ITEM_SHIELD);
        if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_SHIELD)); }
    } else {
        // Reset appearance: copy the PC's current equipment onto the NPC,
        // discarding any in-session edits and reflecting the new gender geometry.
        CT_CopyPCEquipmentToSession(oPC, oNPC);
    }

    string sLabel = (nNew == GENDER_FEMALE) ? "Female" : "Male";
    SendMessageToPC(oPC,CT_Action("GENDER: ") + CT_Value(sLabel));
}

// PURPOSE:
//   Sets the model's race to the specified race constant.
//   Updates appearance, geometry, and re-equips items if needed.
//
// PARAMETERS:
//   oPC - Player character
//   oNPC - Session NPC (the model)
//   nRace - Race constant (RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF, etc.)
//
// RETURNS:
//   None (void) - Updates appearance in place
//
// NOTES:
//   NWN races: DWARF, ELF, GNOME, HALFLING, HALF_ORC, HUMAN, HALF_ELF
//   Human and Half-Elf both map to human-like geometry
//   Race changes affect equipment geometry (re-equips to refresh)
//   Notifies player with color-coded message
void CT_SetRace(object oPC, object oNPC, int nRace) {
    if (!GetIsObjectValid(oNPC)) return;

    int nAppearance;
    string sLabel = "Unknown";

    switch(nRace) {
        case RACIAL_TYPE_DWARF:
            nAppearance = APPEARANCE_TYPE_DWARF;
            sLabel = "Dwarf";
            break;
        case RACIAL_TYPE_ELF:
            nAppearance = APPEARANCE_TYPE_ELF;
            sLabel = "Elf";
            break;
        case RACIAL_TYPE_GNOME:
            nAppearance = APPEARANCE_TYPE_GNOME;
            sLabel = "Gnome";
            break;
        case RACIAL_TYPE_HALFLING:
            nAppearance = APPEARANCE_TYPE_HALFLING;
            sLabel = "Halfling";
            break;
        case RACIAL_TYPE_HALFORC:
            nAppearance = APPEARANCE_TYPE_HALF_ORC;
            sLabel = "Half-Orc";
            break;
        // RACIAL_TYPE_HALFELF shares human geometry — both map to APPEARANCE_TYPE_HUMAN.
        case RACIAL_TYPE_HUMAN:
        default:
            nAppearance = APPEARANCE_TYPE_HUMAN;
            sLabel = "Human / Half-Elf";
            break;
    }

    // Set appearance type (includes race appearance)
    SetCreatureAppearanceType(oNPC, nAppearance);
    SetLocalInt(oPC, "CT_SESSION_RACE", nRace);
    SetLocalInt(oPC, "CT_SESSION_RACE_SET", TRUE);

    // Re-equip all items to force geometry refresh after appearance change.
    // Unrolled explicitly by slot — NWScript does not support arrays.
    object oItem; object oCopy;
    oItem = CT_GetItem(oNPC, CT_ITEM_CLOAK);
    if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_CLOAK)); }
    oItem = CT_GetItem(oNPC, CT_ITEM_HELMET);
    if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_HELMET)); }
    oItem = CT_GetItem(oNPC, CT_ITEM_ARMOR);
    if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_ARMOR)); }
    oItem = CT_GetItem(oNPC, CT_ITEM_WEAPON);
    if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_WEAPON)); }
    oItem = CT_GetItem(oNPC, CT_ITEM_SHIELD);
    if (GetIsObjectValid(oItem)) { oCopy = CopyItem(oItem, oNPC, TRUE); CT_ReplaceItem(oNPC, oItem, oCopy, CT_GetSlotType(CT_ITEM_SHIELD)); }

    SendMessageToPC(oPC,CT_Action("RACE: ") + CT_Value( sLabel));
}

// ============================================================================
// COPY PC EQUIPMENT TO SESSION
// ============================================================================

// Copies player's gender, armor appearance, and equipped items to the session NPC.
// - oPC: The player character whose appearance to copy.
// - oSession: The session NPC to copy appearance to.
// * Copies: gender, all armor parts, all armor colors, cloak, helmet, weapon, shield
// * Replaces all session NPC appearance with PC's current appearance
void CT_CopyPCEquipmentToSession(object oPC, object oSession) {
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oSession)) return;

    object oPC_Armor = CT_GetItem(oPC, CT_ITEM_ARMOR);
    object oSess_Armor = CT_GetItem(oSession, CT_ITEM_ARMOR);

    // Copy gender
    int nPCGender = GetGender(oPC);
    SetGender(oSession, nPCGender);
    SetLocalInt(oPC, "CT_SESSION_GENDER", nPCGender);
    SetLocalInt(oPC, "CT_SESSION_GENDER_SET", TRUE);

    // Copy armor appearance (all 19 parts and 6 standard color channels)
    // Strategy: If AC matches, only copy parts and colors. If different, destroy old and replace.
    if (GetIsObjectValid(oPC_Armor) && GetIsObjectValid(oSess_Armor)) {
        int nPC_AC = GetItemACValue(oPC_Armor);
        int nSess_AC = GetItemACValue(oSess_Armor);

        // If AC matches, copy parts and colors into a modified copy, then replace.
        // oSess_Armor is used as the base for CopyItemAndModify; the final result
        // is equipped via CT_ReplaceItem so the NPC actually displays the new appearance.
        if (nPC_AC == nSess_AC) {
            object oOrigSessArmor = oSess_Armor;
            int i;
            // Standard NWN armor parts: ITEM_APPR_ARMOR_MODEL_RFOOT (0) to ITEM_APPR_ARMOR_MODEL_ROBE (18)
            for (i = ITEM_APPR_ARMOR_MODEL_RFOOT; i <= ITEM_APPR_ARMOR_MODEL_ROBE; i++) {
                int nPart = GetItemAppearance(oPC_Armor, ITEM_APPR_TYPE_ARMOR_MODEL, i);
                oSess_Armor = CopyItemAndModify(oSess_Armor, ITEM_APPR_TYPE_ARMOR_MODEL, i, nPart, TRUE);
            }
            // Standard NWN color channels 0-5 (ITEM_APPR_ARMOR_NUM_COLORS = 6)
            for (i = 0; i < ITEM_APPR_ARMOR_NUM_COLORS; i++) {
                int nColor = GetItemAppearance(oPC_Armor, ITEM_APPR_TYPE_ARMOR_COLOR, i);
                oSess_Armor = CopyItemAndModify(oSess_Armor, ITEM_APPR_TYPE_ARMOR_COLOR, i, nColor, TRUE);
            }
            // Equip the modified copy; original is destroyed via the action queue.
            CT_ReplaceItem(oSession, oOrigSessArmor, oSess_Armor, CT_GetSlotType(CT_ITEM_ARMOR));
        } else {
            // AC doesn't match - copy entire armor and replace
            object oCopy = CopyItem(oPC_Armor, oSession, TRUE);
            int i;

            // Standard NWN armor parts: ITEM_APPR_ARMOR_MODEL_RFOOT (0) to ITEM_APPR_ARMOR_MODEL_ROBE (18)
            for (i = ITEM_APPR_ARMOR_MODEL_RFOOT; i <= ITEM_APPR_ARMOR_MODEL_ROBE; i++) {
                int nPart = GetItemAppearance(oPC_Armor, ITEM_APPR_TYPE_ARMOR_MODEL, i);
                oCopy = CopyItemAndModify(oCopy, ITEM_APPR_TYPE_ARMOR_MODEL, i, nPart, TRUE);
            }

            // Standard NWN color channels 0-5 (ITEM_APPR_ARMOR_NUM_COLORS = 6)
            for (i = 0; i < ITEM_APPR_ARMOR_NUM_COLORS; i++) {
                int nColor = GetItemAppearance(oPC_Armor, ITEM_APPR_TYPE_ARMOR_COLOR, i);
                oCopy = CopyItemAndModify(oCopy, ITEM_APPR_TYPE_ARMOR_COLOR, i, nColor, TRUE);
            }

            // Replace session armor with modified copy
            CT_ReplaceItem(oSession, oSess_Armor, oCopy, CT_GetSlotType(CT_ITEM_ARMOR));
        }
    }

    // Copy cloak
    object oPC_Cloak = CT_GetItem(oPC, CT_ITEM_CLOAK);
    if (GetIsObjectValid(oPC_Cloak)) {
        object oNew = CopyItem(oPC_Cloak, oSession, TRUE);
        object oSess_Cloak = CT_GetItem(oSession, CT_ITEM_CLOAK);
        CT_ReplaceItem(oSession, oSess_Cloak, oNew, INVENTORY_SLOT_CLOAK);
    }

    // Copy helmet
    object oPC_Helmet = CT_GetItem(oPC, CT_ITEM_HELMET);
    if (GetIsObjectValid(oPC_Helmet)) {
        object oNew = CopyItem(oPC_Helmet, oSession, TRUE);
        object oSess_Helmet = CT_GetItem(oSession, CT_ITEM_HELMET);
        CT_ReplaceItem(oSession, oSess_Helmet, oNew, INVENTORY_SLOT_HEAD);
    }

    // Copy weapon
    object oPC_Weapon = CT_GetItem(oPC, CT_ITEM_WEAPON);
    if (GetIsObjectValid(oPC_Weapon)) {
        object oNew = CopyItem(oPC_Weapon, oSession, TRUE);
        object oSess_Weapon = CT_GetItem(oSession, CT_ITEM_WEAPON);
        CT_ReplaceItem(oSession, oSess_Weapon, oNew, INVENTORY_SLOT_RIGHTHAND);
    }

    // Copy shield
    object oPC_Shield = CT_GetItem(oPC, CT_ITEM_SHIELD);
    if (GetIsObjectValid(oPC_Shield)) {
        object oNew = CopyItem(oPC_Shield, oSession, TRUE);
        object oSess_Shield = CT_GetItem(oSession, CT_ITEM_SHIELD);
        CT_ReplaceItem(oSession, oSess_Shield, oNew, INVENTORY_SLOT_LEFTHAND);
    }

    string sGender = (nPCGender == GENDER_FEMALE) ? "Female" : "Male";
    SendMessageToPC(oPC, CT_Action("COPIED: ") + CT_Value(sGender) + CT_Action(" appearance and equipment"));

    // CopyItem calls above may leave unequipped intermediate items in the NPC's inventory.
    // Purge them now so the NPC's bag stays clean between sessions.
    CT_PurgeInventory(oSession);

}

// ============================================================================
// EQUIP/UNEQUIP HELPERS
// ============================================================================

// Equip armor by creating from CT_ARMOR_RESREF resref if not already equipped.
void CT_EquipArmor(object oNPC) {
    object oPC = GetPCSpeaker();
    object oArmor = CT_GetItem(oNPC, CT_ITEM_ARMOR);
    if (GetIsObjectValid(oArmor)) return;  // Already has armor

    // Try to get/create armor: PC's version first, then fallback to blueprint
    object oNew = CT_GetOrCreateItemFromPC(oPC, oNPC, CT_ITEM_ARMOR);
    if (GetIsObjectValid(oNew)) {
        SendMessageToPC(oPC, CT_Action("Armor equipped on model."));
    } else {
        SendMessageToPC(oPC, CT_Error("Error: Could not create armor (missing resref: " + CT_ARMOR_RESREF + ")"));
    }
}

// Unequip armor and delete it.
void CT_UnequipArmor(object oNPC) {
    object oArmor = CT_GetItem(oNPC, CT_ITEM_ARMOR);
    if (GetIsObjectValid(oArmor)) {
        AssignCommand(oNPC, ActionUnequipItem(oArmor));
        AssignCommand(oNPC, ActionDoCommand(DestroyObject(oArmor)));
        SendMessageToPC(GetPCSpeaker(), CT_Action("Armor removed from model."));
    }
}

// Respawns the model NPC by destroying it and creating a new one from blueprint.
// - oPC:      The player character.
// - oSession: The current session NPC to destroy and replace.
// * Gets the current gender to determine which blueprint to use
// * "ct_male" for male, "ct_female" for female
// * Creates new NPC at same location as old one
// * Updates session reference on PC
// * Notifies player of respawn
void CT_RespawnModel(object oPC, object oSession) {
    if (!GetIsObjectValid(oSession)) return;

    // Get current gender
    int nGender = GetGender(oSession);
    string sResRef = (nGender == GENDER_FEMALE) ? "ct_female" : "ct_male";

    // Check for respawn waypoint first - use it if available
    object oWP = CT_GetRespawnWaypoint(oSession);
    location lLoc;

    if (GetIsObjectValid(oWP)) {
        lLoc = GetLocation(oWP);       // Use waypoint location
    } else {
        lLoc = GetLocation(oSession);  // Fallback: spawn at the old NPC's current position
    }

    // Destroy old NPC
    DestroyObject(oSession);

    // Create new NPC from blueprint
    object oNewNPC = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
    if (!GetIsObjectValid(oNewNPC)) {
        SendMessageToPC(oPC, CT_Error("Error: Could not respawn model (resref: " + sResRef + ")"));
        return;
    }

    // Reuse existing waypoint if available, otherwise create new one
    if (GetIsObjectValid(oWP)) {
        SetLocalObject(oNewNPC, TAILOR_RESPAWN, oWP);
    } else {
        CT_SetRespawnWaypoint(oNewNPC);
    }

    // Update session reference
    SetLocalObject(oPC, CT_SESSION_VAR, oNewNPC);

    // Reset gender tracking
    DeleteLocalInt(oPC, "CT_SESSION_GENDER");
    DeleteLocalInt(oPC, "CT_SESSION_GENDER_SET");

    if (GetIsObjectValid(oWP))
    {
        // Clear current actions so they don't get stuck
        AssignCommand(oNewNPC, ClearAllActions());
        AssignCommand(oNewNPC, ActionMoveToObject(oWP, FALSE));
    }

    SendMessageToPC(oPC, CT_Action("Model respawned."));
}


