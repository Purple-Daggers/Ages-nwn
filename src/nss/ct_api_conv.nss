/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - CONVERSATION ENGINE (ct_api_conv.nss) - v1.0
================================================================================
Implements a dynamic conversation system using pause/resume on a running .dlg.

HOW IT WORKS:
  The tailor NPC's OnConversation fires ct_npc_conv.nss which calls
  ActionStartConversation(oPC, "ct_conv", FALSE, FALSE).

  The .dlg file "ct_conv":
    ct_dlg_npc        - NPC node Text Appears When: sets token CT_TOKEN_BASE+0
    ct_dlg_pc1..N     - PC reply N Text Appears When: reads "ct_dialog[N]",
                        sets token CT_TOKEN_BASE+N, returns FALSE if empty.
    ct_dlg_fire1..N   - PC reply N Actions Taken: calls CT_DoDialogChoice(N).
    ct_dlg_end        - OnEnd/Abort: calls CT_EndConversation().

  CT_BuildMenu() writes to locals on oPC:
    "ct_npcline"        NPC dialogue text
    "ct_dialog[1..N]"   PC reply texts (empty = hidden)
    "ct_call[1..N]"     Next menu to call
    "ct_params[1..N]"   Integer parameter for next menu
    "ct_func[1..N]"     Function code to run before rebuilding

  CT_DoDialogChoice(N) reads those locals, executes the function, rebuilds
  the menu for nCall, then resumes the conversation.

MENU CONSTANTS:  MENU_* in ct_api_menu.nss
FUNC CONSTANTS:  FUNC_* in ct_api_funct.nss
TOKEN BASE:      CT_TOKEN_BASE (8200) in ct_config.nss
TOKEN COUNT:     CT_TOKEN_MAX  (15)   in ct_config.nss

================================================================================
*/

#include "ct_api_menu"

// ============================================================================
// PROTOTYPES
// ============================================================================

void   CT_BuildMenu(object oPC, int nMenu, int nParams=0);
void   CT_DoDialogChoice(object oPC, int nChoice);
void   CT_EndConversation(object oPC);
void   CT_ExecFunction(object oPC, int nFunc, int nParams);
void   CT_SetChoice(object oPC, int n, string sText, int nCall, int nParams=0, int nFunc=FUNC_NONE);
void   CT_ClearChoices(object oPC);
int    CT_OpenConv(object oPC);
int    CT_OpenConvFromNPC(object oPC, object oNPC);
void   CT_OpenTailorShop(object oPC, object oNPC);
string CT_ChanLabel(int nChan);
string CT_MenuHeader(string sTitle);

// Forward declaration - implemented in ct_api_item.nss
void CT_SetItemStyleExact(object oSession, int nItemType, int nValue);

// ============================================================================
// MENU DATA WRITERS
// ============================================================================


// Writes one PC reply choice to locals on oPC.
void CT_SetChoice(object oPC, int n, string sText, int nCall, int nParams=0, int nFunc=FUNC_NONE) {
    string sN = IntToString(n);
    SetLocalString(oPC, "ct_dialog" + sN, sText);
    SetLocalInt(oPC,    "ct_call"   + sN, nCall);
    SetLocalInt(oPC,    "ct_params" + sN, nParams);
    SetLocalInt(oPC,    "ct_func"   + sN, nFunc);
}

// Clears all reply slots (1..CT_TOKEN_MAX).
void CT_ClearChoices(object oPC) {
    int i;
    for (i = 1; i <= CT_TOKEN_MAX; i++) {
        string sN = IntToString(i);
        DeleteLocalString(oPC, "ct_dialog" + sN);
        DeleteLocalInt(oPC,    "ct_call"   + sN);
        DeleteLocalInt(oPC,    "ct_params" + sN);
        DeleteLocalInt(oPC,    "ct_func"   + sN);
    }
}

// ============================================================================
// UI HELPERS
// ============================================================================

// Returns the display label for a color channel index (0-5).
string CT_ChanLabel(int nChan) {
    switch (nChan) {
        case 0: return "Cloth 1";
        case 1: return "Cloth 2";
        case 2: return "Leather 1";
        case 3: return "Leather 2";
        case 4: return "Metal 1";
        case 5: return "Metal 2";
    }
    return "Color";
}

// ============================================================================
// DIALOG CHOICE HANDLER
// ============================================================================

void CT_DoDialogChoice(object oPC, int nChoice) {
    string sN   = IntToString(nChoice);
    int nCall   = GetLocalInt(oPC, "ct_call"   + sN);
    int nParams = GetLocalInt(oPC, "ct_params" + sN);
    int nFunc   = GetLocalInt(oPC, "ct_func"   + sN);

    ActionPauseConversation();

    if (nFunc != FUNC_NONE)
        CT_ExecFunction(oPC, nFunc, nParams);

    if (nCall == MENU_CLOSE || nCall == 0) {
        CT_EndConversation(oPC);
        ActionResumeConversation();
        return;
    }

    CT_BuildMenu(oPC, nCall, nParams);
    ActionResumeConversation();
}

// ============================================================================
// CONVERSATION OPEN / CLOSE
// ============================================================================

void CT_EndConversation(object oPC) {
    CT_ClearChoices(oPC);
    DeleteLocalString(oPC, "ct_npcline");
    DeleteLocalInt(oPC, "CT_IN_CONV");
    CT_DestroySession(oPC);
}

int CT_OpenConvFromNPC(object oPC, object oNPC) {
    if (GetLocalInt(oPC, "CT_IN_CONV")) return FALSE;

    CT_CreateSession(oPC, oNPC);
    SetLocalInt(oPC, "CT_IN_CONV", 1);
    CT_BuildMenu(oPC, MENU_MAIN);
    AssignCommand(oPC, SetFacingPoint(GetPosition(oNPC)));
    AssignCommand(oPC, ActionStartConversation(oPC, "ct_conv", TRUE, FALSE));
    return TRUE;
}

int CT_OpenConv(object oPC) {
    if (GetLocalInt(oPC, "CT_IN_CONV")) {
        SendMessageToPC(oPC, CT_Warning("[TAILOR] Already in a conversation."));
        return FALSE;
    }
    object oNPC = GetNearestObjectByTag(CT_TAILOR_TAG, oPC);
    if (!GetIsObjectValid(oNPC)) {
        SendMessageToPC(oPC, CT_Error("[TAILOR] No tailor found nearby. Move closer and try again."));
        return FALSE;
    }
    return CT_OpenConvFromNPC(oPC, oNPC);
}

// ============================================================================
// OPEN TAILOR SHOP
// ============================================================================

void CT_OpenTailorShop(object oPC, object oNPC) {
    object oShop = OBJECT_INVALID;
    int i;
    for (i = 1; i <= 20; i++) {
        object oObj = GetNearestObjectByTag(TAILOR_SHOP, oNPC, i);
        if (!GetIsObjectValid(oObj)) break;
        if (GetObjectType(oObj) == OBJECT_TYPE_STORE) { oShop = oObj; break; }
    }
    if (!GetIsObjectValid(oShop)) {
        oShop = CreateObject(OBJECT_TYPE_STORE, TAILOR_SHOP, GetLocation(oNPC), FALSE, TAILOR_SHOP);
        if (!GetIsObjectValid(oShop)) {
            SendMessageToPC(oPC, CT_Error("No shop found and resref \"" + TAILOR_SHOP + "\" is missing."));
            return;
        }
    }
    OpenStore(oShop, oPC);
}

// ============================================================================
// FUNCTION EXECUTOR
// ============================================================================

void CT_ExecFunction(object oPC, int nFunc, int nParams) {
    object oSession = CT_GetSession(oPC);
    if (!GetIsObjectValid(oSession)) return;

    switch (nFunc) {
        case FUNC_RESET:                  CT_CopyPCEquipmentToSession(oPC, oSession);          break;
        case FUNC_SWAP_GENDER:            CT_SwapGender(oPC, oSession);                        break;
        case FUNC_SET_RACE_DWARF:         CT_SetRace(oPC, oSession, RACIAL_TYPE_DWARF);        break;
        case FUNC_SET_RACE_ELF:           CT_SetRace(oPC, oSession, RACIAL_TYPE_ELF);          break;
        case FUNC_SET_RACE_GNOME:         CT_SetRace(oPC, oSession, RACIAL_TYPE_GNOME);        break;
        case FUNC_SET_RACE_HALFLING:      CT_SetRace(oPC, oSession, RACIAL_TYPE_HALFLING);     break;
        case FUNC_SET_RACE_HALF_ORC:      CT_SetRace(oPC, oSession, RACIAL_TYPE_HALFORC);      break;
        case FUNC_SET_RACE_HUMAN_HALFELF: CT_SetRace(oPC, oSession, RACIAL_TYPE_HUMAN);        break;
        case FUNC_RESPAWN_MODEL:          CT_RespawnModel(oPC, oSession);                      break;
        case FUNC_PART_NEXT:              CT_CustomizeArmorPart(oSession, nParams, 1);         break;
        case FUNC_PART_BACK:              CT_CustomizeArmorPart(oSession, nParams, -1);        break;
        case FUNC_PART_MIRROR:            CT_MirrorArmorPart(oSession, nParams);               break;
        case FUNC_MIRROR_ALL:             CT_MirrorAllParts(oSession, TRUE);                   break;
        case FUNC_MIRROR_ALL_LR:          CT_MirrorAllParts(oSession, FALSE);                  break;
        case FUNC_STYLE_NEXT:             CT_CycleItemAppearance(oSession, nParams, 1);        break;
        case FUNC_STYLE_BACK:             CT_CycleItemAppearance(oSession, nParams, -1);       break;
        case FUNC_WEAP_PART_NEXT:         CT_CycleWeaponPart(oSession, nParams, 1);            break;
        case FUNC_WEAP_PART_BACK:         CT_CycleWeaponPart(oSession, nParams, -1);           break;
        case FUNC_LEFT_WEAP_PART_NEXT:    CT_CycleLeftWeaponAppearance(oSession, nParams, 1);  break;
        case FUNC_LEFT_WEAP_PART_BACK:    CT_CycleLeftWeaponAppearance(oSession, nParams, -1); break;
        case FUNC_LEFT_WEAP_COLOR_NEXT:   CT_CycleLeftWeaponColor(oSession, nParams, 1);       break;
        case FUNC_LEFT_WEAP_COLOR_BACK:   CT_CycleLeftWeaponColor(oSession, nParams, -1);      break;
        case FUNC_PURCHASE:               CT_PurchaseItem(oSession, oPC, nParams);             break;
        case FUNC_EQUIP_WEAP:             CT_EquipPCItem(oSession, oPC, CT_ITEM_WEAPON);       break;
        case FUNC_EQUIP_SHLD:             CT_EquipPCItem(oSession, oPC, CT_ITEM_SHIELD);       break;
        case FUNC_PART_STRIP:             CT_StripArmorPart(oSession, nParams);                break;
        case FUNC_CLOAK_INVISIBLE:        CT_SetCloakInvisible(oSession);                      break;
        case FUNC_COPY_PART_FROM_PC:      CT_CopyArmorPart(oPC, oSession, nParams);            break;
        case FUNC_COPY_PART_TO_PC:        CT_CopyArmorPart(oSession, oPC, nParams);            break;
        case FUNC_COPY_STYLE_FROM_PC:     CT_CopyItemStyle(oPC, oSession, nParams);            break;
        case FUNC_COPY_STYLE_TO_PC:       CT_CopyItemStyle(oSession, oPC, nParams);            break;
        case FUNC_COPY_WPART_FROM_PC:     CT_CopyWeaponPart(oPC, oSession, nParams);           break;
        case FUNC_COPY_WPART_TO_PC:       CT_CopyWeaponPart(oSession, oPC, nParams);           break;
        case FUNC_COPY_DESIGN_FROM_PC:    CT_CopyItemDesign(oPC, oSession, nParams);           break;
        case FUNC_COPY_DESIGN_TO_PC:      CT_CopyItemDesign(oSession, oPC, nParams);           break;
        case FUNC_EQUIP_CLOAK:            CT_EquipCloak(oSession);                             break;
        case FUNC_UNEQUIP_CLOAK:          CT_UnequipCloak(oSession);                           break;
        case FUNC_EQUIP_HELMET:           CT_EquipHelmet(oSession);                            break;
        case FUNC_UNEQUIP_HELMET:         CT_UnequipHelmet(oSession);                          break;
        case FUNC_EQUIP_ARMOR:            CT_EquipArmor(oSession);                             break;
        case FUNC_UNEQUIP_ARMOR:          CT_UnequipArmor(oSession);                           break;
        case FUNC_OPEN_SHOP:              CT_OpenTailorShop(oPC, oSession);                    break;
        case FUNCT_SHOW_INFO:             CT_ShowInfo(oPC, oSession);                    break;

        case FUNC_COLOR_NEXT:
        case FUNC_COLOR_BACK: {
            int nDir  = (nFunc == FUNC_COLOR_NEXT) ? 1 : -1;
            int nType = nParams / 10;
            int nChan = nParams % 10;
            if (nType == CT_ITEM_WEAPON) CT_CycleWeaponColor(oSession, nChan, nDir);
            else                         CT_CycleItemColor(oSession, nType, nChan, nDir);
            break;
        }
        case FUNC_WEAP_COLOR_NEXT:        CT_CycleWeaponColor(oSession, nParams, 1);           break;
        case FUNC_WEAP_COLOR_BACK:        CT_CycleWeaponColor(oSession, nParams, -1);          break;

        case FUNC_COPY_COLOR_FROM_PC: {
            int nT = nParams / 10; int nC = nParams % 10;
            CT_CopyItemColor(oPC, oSession, nT, nC);
            break;
        }
        case FUNC_COPY_COLOR_TO_PC: {
            int nT = nParams / 10; int nC = nParams % 10;
            CT_CopyItemColor(oSession, oPC, nT, nC);
            break;
        }

        case FUNC_SET_COLOR_EXACT: {
            int nVal = GetLocalInt(oPC, "LAST_CHAT_INT");
            if (nVal > 0) {
                int nT = nParams / 10; int nC = nParams % 10;
                CT_SetItemColorExact(oSession, nT, nC, nVal);
            } else {
                SendMessageToPC(oPC, CT_Info("Type a number (1-175) in chat first, then pick Continue."));
            }
            break;
        }
        case FUNC_SET_PART_EXACT: {
            int nVal = GetLocalInt(oPC, "LAST_CHAT_INT");
            if (nVal > 0)
                CT_SetArmorPartExact(oSession, nParams, nVal);
            else
                SendMessageToPC(oPC, CT_Info("Type a number (1-255) in chat first, then pick Continue."));
            break;
        }
        case FUNC_SET_STYLE_EXACT: {
            int nVal = GetLocalInt(oPC, "LAST_CHAT_INT");
            if (nVal > 0)
                CT_SetItemStyleExact(oSession, nParams, nVal);
            else
                SendMessageToPC(oPC, CT_Info("Type a number in chat first, then pick Continue."));
            break;
        }
    }
}

// ============================================================================
// MENU BUILDERS
// ============================================================================

string CT_MenuTitle(string sMenuTitle)
{
    return
    CT_TextColor(CT_MENU_LINE + CT_MENU_BAR + CT_MENU_LINE, 255, 215, 0) +
    CT_TextColor(CT_MENU_OFFSET + sMenuTitle + CT_DELIM + CT_MENU_LINE, 255, 215, 0) +
    CT_TextColor(CT_MENU_BAR, 255, 215, 0);
}

// Builds a standard gold-bordered menu header string.
string CT_MenuHeader(string sTitle) {
    string sBar = CT_TextColor(CT_MENU_LINE + CT_MENU_BAR + CT_MENU_LINE, 255, 215, 0);
    return sBar + CT_TextColor(CT_MENU_OFFSET + sTitle, 255, 215, 0) + sBar;
}

// Sets the NPC dialogue line and its custom token.
void CT_SetNPCLine(object oPC, string sText) {
    SetLocalString(oPC, "ct_npcline", sText);
    SetCustomToken(CT_TOKEN_BASE, sText);
}

// ============================================================================
// MAIN MENU BUILDER
// ============================================================================

void CT_BuildMenu(object oPC, int nMenu, int nParams=0) {

    object oSession = CT_GetSession(oPC);

    // Shared strings - built once, reused across all menus.
    string sSep      = CT_TextColor(CT_MENU_BAR, 128, 128, 128);
    string sBack     = CT_TextColor("Back", 255, 215, 0);

    CT_ClearChoices(oPC);

    switch (nMenu) {

        // ---- MAIN ----
        case MENU_MAIN: {
            CT_SetNPCLine(oPC, CT_MenuTitle(MENU_MAIN_STR));

            object oArmor  = CT_GetItem(oSession, CT_ITEM_ARMOR);
            object oHelmet = CT_GetItem(oSession, CT_ITEM_HELMET);
            object oCloak  = CT_GetItem(oSession, CT_ITEM_CLOAK);
            object oWeapon = CT_GetItem(oSession, CT_ITEM_WEAPON);
            object oLeft   = CT_GetLeftHandItem(oSession);

            int n = 1;
            CT_SetChoice(oPC, n++, sSep, MENU_MAIN);
            CT_SetChoice(oPC, n++, CT_TextColor("Gender & Race", 255, 215, 0), MENU_ADJUST_BODY);
            CT_SetChoice(oPC, n++, sSep, MENU_MAIN);

            CT_SetChoice(oPC, n++,
                CT_TextColor("Adjust Armor", 255, 215, 0) + CT_TextColor(" (" +
                (GetIsObjectValid(oArmor) ? CT_GetItemDisplayName(oArmor) : "none") + ")", 200, 200, 200),
                MENU_ARMOR);
            CT_SetChoice(oPC, n++,
                CT_TextColor("Adjust Cloak", 255, 215, 0) + CT_TextColor(" (" +
                (GetIsObjectValid(oCloak) ? CT_GetItemDisplayName(oCloak) : "none") + ")", 200, 200, 200),
                MENU_CLOAK);
            CT_SetChoice(oPC, n++,
                CT_TextColor("Adjust Helmet", 255, 215, 0) + CT_TextColor(" (" +
                (GetIsObjectValid(oHelmet) ? CT_GetItemDisplayName(oHelmet) : "none") + ")", 200, 200, 200),
                MENU_HELMET);
            if (GetIsObjectValid(oLeft)) {
                int nBase  = GetBaseItemType(oLeft);
                int bIsShield = (nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_SMALLSHIELD);
                int nLMenu = bIsShield ? MENU_SHIELD : MENU_ADJUST_WEAPON_LEFT;
                string sLLabel = bIsShield ? "Adjust Shield" : "Adjust Off-Hand";
                CT_SetChoice(oPC, n++,
                    CT_TextColor(sLLabel, 255, 215, 0) + CT_TextColor(" (" + CT_GetItemDisplayName(oLeft) + ")", 200, 200, 200),
                    nLMenu);
            CT_SetChoice(oPC, n++,
                CT_TextColor("Adjust Weapon", 255, 215, 0) + CT_TextColor(" (" +
                (GetIsObjectValid(oWeapon) ? CT_GetItemDisplayName(oWeapon) : "none") + ")", 200, 200, 200),
                MENU_WEAPON);

            }

            CT_SetChoice(oPC, n++, sSep, MENU_MAIN);
            CT_SetChoice(oPC, n++, CT_TextColor("Purchase Item", 0, 255, 255), MENU_PURCHASE);
            CT_SetChoice(oPC, n++, CT_TextColor("Browse Shop",   0, 255, 255), MENU_MAIN, 0, FUNC_OPEN_SHOP);
            CT_SetChoice(oPC, n++, sSep, MENU_MAIN);
            break;
        }

        // ---- ADJUST BODY ----
        case MENU_ADJUST_BODY: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_BODY_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_BODY);
            CT_SetChoice(oPC, i++, CT_TextColor("Change Gender",       255, 215, 0), MENU_ADJUST_BODY, 0, FUNC_SWAP_GENDER);
            CT_SetChoice(oPC, i++, CT_TextColor("Change Race",         255, 215, 0), MENU_SELECT_RACE);
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_BODY);
            CT_SetChoice(oPC, i++, CT_TextColor("Tailor Information",  255, 215, 0), MENU_INFO);
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_BODY);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        // ---- SELECT RACE ----
        case MENU_SELECT_RACE: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_RACE_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_SELECT_RACE);
            CT_SetChoice(oPC, i++, CT_TextColor("Dwarf",            255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_DWARF);
            CT_SetChoice(oPC, i++, CT_TextColor("Elf",              255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_ELF);
            CT_SetChoice(oPC, i++, CT_TextColor("Gnome",            255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_GNOME);
            CT_SetChoice(oPC, i++, CT_TextColor("Halfling",         255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_HALFLING);
            CT_SetChoice(oPC, i++, CT_TextColor("Half-Orc",         255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_HALF_ORC);
            CT_SetChoice(oPC, i++, CT_TextColor("Human / Half-Elf", 255, 215, 0), MENU_SELECT_RACE, 0, FUNC_SET_RACE_HUMAN_HALFELF);
            CT_SetChoice(oPC, i++, sSep, MENU_SELECT_RACE);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Gender & Race", 128, 128, 128), MENU_ADJUST_BODY);
            break;
        }

        // ---- INFO ----
        case MENU_INFO: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_INFO_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_INFO);
            CT_SetChoice(oPC, i++, CT_Warning("System: ")  + CT_Value(CT_SYSTEM_NAME), MENU_INFO);
            CT_SetChoice(oPC, i++, CT_TextColor("Version: ",255,215,0) + CT_Value(CT_VERSION), MENU_INFO);
            CT_SetChoice(oPC, i++, CT_TextColor("Build: ",255,165,0)   + CT_Value(IntToString(CT_BUILD)), MENU_INFO);
            CT_SetChoice(oPC, i++, sSep, MENU_INFO);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Gender & Race", 128, 128, 128), MENU_ADJUST_BODY);
            break;
        }

        // ---- ARMOR ----
        case MENU_ARMOR: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Parts",         255, 215, 0), MENU_ARMOR_PARTS);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Colors",        255, 215, 0), MENU_ARMOR_COLORS);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR);
            CT_SetChoice(oPC, i++, CT_TextColor("Mirror Parts",       255, 215, 0), MENU_ARMOR_MIR);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my armor", 255, 215, 0), MENU_ARMOR, CT_ITEM_ARMOR, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my armor",   255, 215, 0), MENU_ARMOR, CT_ITEM_ARMOR, FUNC_COPY_DESIGN_TO_PC);

            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_ARMOR)))
                 CT_SetChoice(oPC, i++, CT_TextColor("Unequip Armor",  255, 215, 0), MENU_ARMOR, 0, FUNC_UNEQUIP_ARMOR);
            else
                 CT_SetChoice(oPC, i++, CT_TextColor("Equip Armor",    255, 215, 0), MENU_ARMOR, 0, FUNC_EQUIP_ARMOR);

            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        case MENU_ARMOR_PARTS: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_PARTS_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_PARTS);
            CT_SetChoice(oPC, i++, CT_TextColor("Torso", 255, 215, 0) + CT_TextColor(" (AC-Locked)", 128, 128, 128), MENU_PART, ITEM_APPR_ARMOR_MODEL_TORSO);
            CT_SetChoice(oPC, i++, CT_TextColor("Pelvis",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_PELVIS);
            CT_SetChoice(oPC, i++, CT_TextColor("Belt",    255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_BELT);
            CT_SetChoice(oPC, i++, CT_TextColor("Neck",    255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_NECK);
            CT_SetChoice(oPC, i++, CT_TextColor("Arms",    255, 215, 0), MENU_ARMOR_ARMS);
            CT_SetChoice(oPC, i++, CT_TextColor("Legs",    255, 215, 0), MENU_ARMOR_LEGS);
            CT_SetChoice(oPC, i++, CT_TextColor("Robe",    255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_ROBE);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_PARTS);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Armor", 128, 128, 128), MENU_ARMOR);
            break;
        }

        case MENU_ARMOR_ARMS: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader("ARM PARTS"));
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_ARMS);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Shoulder", 255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RSHOULDER);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Shoulder",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LSHOULDER);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Bicep",    255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RBICEP);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Bicep",     255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LBICEP);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Forearm",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RFOREARM);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Forearm",   255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LFOREARM);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Hand",     255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RHAND);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Hand",      255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LHAND);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_ARMS);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Parts", 128, 128, 128), MENU_ARMOR_PARTS);
            break;
        }

        case MENU_ARMOR_LEGS: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader("LEG PARTS"));
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_LEGS);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Thigh", 255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RTHIGH);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Thigh",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LTHIGH);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Shin",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RSHIN);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Shin",   255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LSHIN);
            CT_SetChoice(oPC, i++, CT_TextColor("Right Foot",  255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_RFOOT);
            CT_SetChoice(oPC, i++, CT_TextColor("Left Foot",   255, 215, 0), MENU_PART, ITEM_APPR_ARMOR_MODEL_LFOOT);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_LEGS);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Parts", 128, 128, 128), MENU_ARMOR_PARTS);
            break;
        }

        // Generic part cycling - nParams = ITEM_APPR_ARMOR_MODEL_* index
        case MENU_PART: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(CT_GetPartName(nParams)));
            CT_SetChoice(oPC, i++, sSep, MENU_PART);
            int bPaired = (nParams >= 0 && nParams <= 5) || (nParams >= 10 && nParams <= 17);
            CT_SetChoice(oPC, i++, CT_TextColor("Next",     255, 215, 0), MENU_PART, nParams, FUNC_PART_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous", 255, 215, 0), MENU_PART, nParams, FUNC_PART_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_PART);

            if (bPaired) {
                int bThigh   = (nParams == ITEM_APPR_ARMOR_MODEL_LTHIGH || nParams == ITEM_APPR_ARMOR_MODEL_RTHIGH);
                int bSrcEven = (nParams % 2 == 0);
                string sDir;
                if (bThigh) sDir = bSrcEven ? "Mirror to right." : "Mirror to left.";
                else        sDir = bSrcEven ? "Mirror to left."  : "Mirror to right.";
                CT_SetChoice(oPC, i++, sDir, MENU_PART, nParams, FUNC_PART_MIRROR);
            }

            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my armor", 255, 215, 0), MENU_PART, nParams, FUNC_COPY_PART_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my armor",   255, 215, 0), MENU_PART, nParams, FUNC_COPY_PART_TO_PC);

            if (nParams != ITEM_APPR_ARMOR_MODEL_TORSO) {
                CT_SetChoice(oPC, i++, CT_TextColor("Strip Part (Reset part to 1)", 255, 215, 0), MENU_PART, nParams, FUNC_PART_STRIP);
            }
            CT_SetChoice(oPC, i++, sSep, MENU_PART);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Parts", 128, 128, 128), MENU_ARMOR_PARTS);
            break;
        }

        case MENU_ARMOR_MIR: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_MIRROR_STR));
            // CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_MIRROR_STR) +
            // CT_TextColor(CT_MENU_LINE + "      (Copy all paired parts)", 128, 128, 128));
            // CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_MIRROR_STR), 128, 128, 128);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_MIR);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy parts Right to Left", 255, 215, 0), MENU_ARMOR, 0, FUNC_MIRROR_ALL);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy parts Left to Right", 255, 215, 0), MENU_ARMOR, 0, FUNC_MIRROR_ALL_LR);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_MIR);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Armor", 128, 128, 128), MENU_ARMOR);
            break;
        }

        case MENU_ARMOR_COLORS: {
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_ARMOR_COLOR_STR));
            int i;
            // ITEM_APPR_ARMOR_NUM_COLORS = 6, channels 0-5 only.
            // Previously looped to i < 7, creating a ghost "Color" entry for channel 6.
            for (i = 0; i < ITEM_APPR_ARMOR_NUM_COLORS; i++)
                CT_SetChoice(oPC, i+1, CT_TextColor(CT_ChanLabel(i), 255, 215, 0), MENU_COLOR, CT_ITEM_ARMOR * 10 + i);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_COLORS);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my armor", 255, 215, 0), MENU_ARMOR_COLORS, CT_ITEM_ARMOR, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my armor",   255, 215, 0), MENU_ARMOR_COLORS, CT_ITEM_ARMOR, FUNC_COPY_DESIGN_TO_PC);
            CT_SetChoice(oPC, i++, sSep, MENU_ARMOR_COLORS);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Armor", 128, 128, 128), MENU_ARMOR);
            break;
        }

        // Generic color cycling - nParams = nItemType*10 + nChannel
        case MENU_COLOR: {
            int i = 1;
            int nType = nParams / 10;
            int nChan = nParams % 10;

            string sChanLabel;
            if (nType == CT_ITEM_WEAPON) {
                switch (nChan) {
                    case 0: sChanLabel = "Bottom Color"; break;
                    case 1: sChanLabel = "Middle Color"; break;
                    case 2: sChanLabel = "Top Color";    break;
                    default: sChanLabel = "Color " + IntToString(nChan); break;
                }
            } else {
                sChanLabel = CT_ChanLabel(nChan);
            }

            CT_SetNPCLine(oPC, CT_MenuHeader(GetStringUpperCase(CT_ItemLabel(nType)) + " - " + sChanLabel));
            CT_SetChoice(oPC, i++, sSep, MENU_COLOR, nParams);
            CT_SetChoice(oPC, i++, CT_TextColor("Next",       255, 215, 0), MENU_COLOR, nParams, FUNC_COLOR_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous",   255, 215, 0), MENU_COLOR, nParams, FUNC_COLOR_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_COLOR, nParams);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my " + GetStringLowerCase(CT_ItemLabel(nType)), 255, 215, 0), MENU_COLOR, nParams, FUNC_COPY_COLOR_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my "   + GetStringLowerCase(CT_ItemLabel(nType)), 255, 215, 0), MENU_COLOR, nParams, FUNC_COPY_COLOR_TO_PC);

            int nBack = MENU_ARMOR_COLORS;
            if      (nType == CT_ITEM_CLOAK)  nBack = MENU_CLOAK_COL;
            else if (nType == CT_ITEM_HELMET) nBack = MENU_HELMET_COL;
            else if (nType == CT_ITEM_WEAPON) nBack = MENU_WEAPON_COLOR;

            CT_SetChoice(oPC, i++, sSep, MENU_COLOR, nParams);
            CT_SetChoice(oPC, i++, sBack, nBack);
            break;
        }

        // ---- CLOAK ----
        case MENU_CLOAK: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_CLOAK_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK);
            CT_SetChoice(oPC, i++, CT_TextColor("Next Cloak",              255, 215, 0), MENU_CLOAK, CT_ITEM_CLOAK, FUNC_STYLE_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous Cloak",          255, 215, 0), MENU_CLOAK, CT_ITEM_CLOAK, FUNC_STYLE_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Cloak Colors",        255, 215, 0), MENU_CLOAK_COL);
            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my cloak", 255, 215, 0), MENU_CLOAK, CT_ITEM_CLOAK, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my cloak",   255, 215, 0), MENU_CLOAK, CT_ITEM_CLOAK, FUNC_COPY_DESIGN_TO_PC);

            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_CLOAK)))
               CT_SetChoice(oPC, i++, CT_TextColor("Unequip Cloak",  255, 215, 0), MENU_CLOAK, 0, FUNC_UNEQUIP_CLOAK);
            else
               CT_SetChoice(oPC, i++, CT_TextColor("Equip Cloak",    255, 215, 0), MENU_CLOAK, 0, FUNC_EQUIP_CLOAK);

            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        case MENU_CLOAK_COL: {
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_CLOAK_COLOR_STR));
            int i = 1;
            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK_COL);
            // Loop channels 0-5. Previously looped i=2..7 and used CT_ITEM_CLOAK*10+i,
            // encoding channels 2-7 into nParams instead of 0-5 — a channel offset bug.
            int c;
            for (c = 0; c < ITEM_APPR_ARMOR_NUM_COLORS; c++)
                CT_SetChoice(oPC, i++, CT_TextColor(CT_ChanLabel(c), 255, 215, 0), MENU_COLOR, CT_ITEM_CLOAK * 10 + c);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my cloak", 255, 215, 0), MENU_CLOAK_COL, CT_ITEM_CLOAK, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my cloak",   255, 215, 0), MENU_CLOAK_COL, CT_ITEM_CLOAK, FUNC_COPY_DESIGN_TO_PC);
            CT_SetChoice(oPC, i++, sSep, MENU_CLOAK_COL);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Cloak", 128, 128, 128), MENU_CLOAK);
            break;
        }

        // ---- HELMET ----
        case MENU_HELMET: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_HELMET_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_HELMET);
            CT_SetChoice(oPC, i++, CT_TextColor("Next Helmet",                255, 215, 0), MENU_HELMET, CT_ITEM_HELMET, FUNC_STYLE_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous Helmet",            255, 215, 0), MENU_HELMET, CT_ITEM_HELMET, FUNC_STYLE_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_HELMET);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Helmet Colors",          255, 215, 0), MENU_HELMET_COL);
            CT_SetChoice(oPC, i++, sSep, MENU_HELMET);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my helmet",  255, 215, 0), MENU_HELMET, CT_ITEM_HELMET, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my helmet",    255, 215, 0), MENU_HELMET, CT_ITEM_HELMET, FUNC_COPY_DESIGN_TO_PC);

            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_HELMET)))
               CT_SetChoice(oPC, i++, CT_TextColor("Unequip Helmet",   255, 215, 0), MENU_HELMET, 0, FUNC_UNEQUIP_HELMET);
            else
               CT_SetChoice(oPC, i++, CT_TextColor("Equip Helmet",     255, 215, 0), MENU_HELMET, 0, FUNC_EQUIP_HELMET);

            CT_SetChoice(oPC, i++, sSep, MENU_HELMET);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        case MENU_HELMET_COL: {
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_HELMET_COLOR_STR));
            int i;
            // ITEM_APPR_ARMOR_NUM_COLORS = 6, channels 0-5 only.
            for (i = 0; i < ITEM_APPR_ARMOR_NUM_COLORS; i++)
                CT_SetChoice(oPC, i+1, CT_TextColor(CT_ChanLabel(i), 255, 215, 0), MENU_COLOR, CT_ITEM_HELMET * 10 + i);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my helmet", 255, 215, 0), MENU_HELMET_COL, CT_ITEM_HELMET, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my helmet",   255, 215, 0), MENU_HELMET_COL, CT_ITEM_HELMET, FUNC_COPY_DESIGN_TO_PC);
            CT_SetChoice(oPC, i++, sSep, MENU_HELMET_COL);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Helmet", 128, 128, 128), MENU_HELMET);
            break;
        }

        // ---- WEAPON ----
        case MENU_WEAPON: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_WEAPON_RIGHT_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Parts",          255, 215, 0), MENU_WEAPON_PARTS);
            CT_SetChoice(oPC, i++, CT_TextColor("Edit Colors",         255, 215, 0), MENU_WEAPON_COLOR);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my weapon", 255, 215, 0), MENU_WEAPON, CT_ITEM_WEAPON, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my weapon",   255, 215, 0), MENU_WEAPON, CT_ITEM_WEAPON, FUNC_COPY_DESIGN_TO_PC);
            object oPCWeapon = CT_GetItem(oPC, CT_ITEM_WEAPON);
            if (GetIsObjectValid(oPCWeapon))
                CT_SetChoice(oPC, i++,
                    CT_TextColor("Equip my ", 255, 215, 0) + CT_TextColor(Get2DAString("baseitems", "label", GetBaseItemType(oPCWeapon)), 200, 200, 200),
                    MENU_WEAPON, 0, FUNC_EQUIP_WEAP);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        case MENU_WEAPON_COLOR: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_WEAPON_RIGHT_COLOR_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_COLOR);
            CT_SetChoice(oPC, i++, CT_TextColor("Top Color",    255, 215, 0), MENU_COLOR, CT_ITEM_WEAPON * 10 + 2);
            CT_SetChoice(oPC, i++, CT_TextColor("Middle Color", 255, 215, 0), MENU_COLOR, CT_ITEM_WEAPON * 10 + 1);
            CT_SetChoice(oPC, i++, CT_TextColor("Bottom Color", 255, 215, 0), MENU_COLOR, CT_ITEM_WEAPON * 10 + 0);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_COLOR);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Weapon", 128, 128, 128), MENU_WEAPON);
            break;
        }

        case MENU_WEAPON_PARTS: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_WEAPON_RIGHT_PART_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_PARTS);
            CT_SetChoice(oPC, i++, CT_TextColor("Top Part",    255, 215, 0), MENU_WEAPON_PART, 2);
            CT_SetChoice(oPC, i++, CT_TextColor("Middle Part", 255, 215, 0), MENU_WEAPON_PART, 1);
            CT_SetChoice(oPC, i++, CT_TextColor("Bottom Part", 255, 215, 0), MENU_WEAPON_PART, 0);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_PARTS);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Weapon", 128, 128, 128), MENU_WEAPON);
            break;
        }

        case MENU_WEAPON_PART: {
            int i = 1;
            string sPart;
            switch (nParams) {
                case 0: sPart = "BOTTOM PART"; break;
                case 1: sPart = "MIDDLE PART"; break;
                case 2: sPart = "TOP PART";    break;
                default: sPart = "PART " + IntToString(nParams); break;
            }
            CT_SetNPCLine(oPC, CT_MenuHeader("WEAPON " + sPart));
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_PART, nParams);
            CT_SetChoice(oPC, i++, CT_TextColor("Next",                255, 215, 0), MENU_WEAPON_PART, nParams, FUNC_WEAP_PART_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous",            255, 215, 0), MENU_WEAPON_PART, nParams, FUNC_WEAP_PART_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_PART, nParams);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my weapon", 255, 215, 0), MENU_WEAPON_PART, nParams, FUNC_COPY_WPART_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my weapon",   255, 215, 0), MENU_WEAPON_PART, nParams, FUNC_COPY_WPART_TO_PC);
            CT_SetChoice(oPC, i++, sSep, MENU_WEAPON_PART, nParams);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Parts", 128, 128, 128), MENU_WEAPON_PARTS);
            break;
        }

        // ---- LEFT-HAND WEAPON ----
        // Uses FUNC_LEFT_WEAP_* which dispatch to CT_CycleLeftWeaponAppearance/Color,
        // targeting INVENTORY_SLOT_LEFTHAND exclusively. This prevents the right-hand
        // weapon from being cycled when a player dual-wields.
        case MENU_ADJUST_WEAPON_LEFT: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_WEAPON_LEFT_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_WEAPON_LEFT);
            CT_SetChoice(oPC, i++, CT_TextColor("Top Part",     255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 2, FUNC_LEFT_WEAP_PART_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Middle Part",  255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 1, FUNC_LEFT_WEAP_PART_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Bottom Part",  255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 0, FUNC_LEFT_WEAP_PART_NEXT);
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_WEAPON_LEFT);
            CT_SetChoice(oPC, i++, CT_TextColor("Top Color",    255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 2, FUNC_LEFT_WEAP_COLOR_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Middle Color", 255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 1, FUNC_LEFT_WEAP_COLOR_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Bottom Color", 255, 215, 0), MENU_ADJUST_WEAPON_LEFT, 0, FUNC_LEFT_WEAP_COLOR_NEXT);
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_WEAPON_LEFT);
            // CT_ITEM_SHIELD maps to INVENTORY_SLOT_LEFTHAND, so FUNC_EQUIP_SHLD copies
            // whatever the PC has in their left hand (weapon or shield) onto the NPC.
            object oPCLeft = CT_GetLeftHandItem(oPC);
            if (GetIsObjectValid(oPCLeft))
                CT_SetChoice(oPC, i++,
                    CT_TextColor("Equip my ", 255, 215, 0) + CT_TextColor(Get2DAString("baseitems", "label", GetBaseItemType(oPCLeft)), 200, 200, 200),
                    MENU_ADJUST_WEAPON_LEFT, 0, FUNC_EQUIP_SHLD);
            CT_SetChoice(oPC, i++, sSep, MENU_ADJUST_WEAPON_LEFT);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        // ---- SHIELD ----
        case MENU_SHIELD: {
            int i = 1;
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_SHIELD_STR));
            CT_SetChoice(oPC, i++, sSep, MENU_SHIELD);
            CT_SetChoice(oPC, i++, CT_TextColor("Next Shield",           255, 215, 0), MENU_SHIELD, CT_ITEM_SHIELD, FUNC_STYLE_NEXT);
            CT_SetChoice(oPC, i++, CT_TextColor("Previous Shield",       255, 215, 0), MENU_SHIELD, CT_ITEM_SHIELD, FUNC_STYLE_BACK);
            CT_SetChoice(oPC, i++, sSep, MENU_SHIELD);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy from my shield",   255, 215, 0), MENU_SHIELD, CT_ITEM_SHIELD, FUNC_COPY_DESIGN_FROM_PC);
            CT_SetChoice(oPC, i++, CT_TextColor("Copy to my shield",     255, 215, 0), MENU_SHIELD, CT_ITEM_SHIELD, FUNC_COPY_DESIGN_TO_PC);
            object oPCShield = CT_GetItem(oPC, CT_ITEM_SHIELD);
            if (GetIsObjectValid(oPCShield))
                CT_SetChoice(oPC, i++,
                    CT_TextColor("Equip my ", 255, 215, 0) + CT_TextColor(Get2DAString("baseitems", "label", GetBaseItemType(oPCShield)), 200, 200, 200),
                    MENU_SHIELD, 0, FUNC_EQUIP_SHLD);
            CT_SetChoice(oPC, i++, sSep, MENU_SHIELD);
            CT_SetChoice(oPC, i++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        // ---- PURCHASE ----
        case MENU_PURCHASE: {
            CT_SetNPCLine(oPC, CT_MenuHeader(MENU_PURCHASE_STR));
            int n = 1;
            CT_SetChoice(oPC, n++, sSep, MENU_PURCHASE);
            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_ARMOR)))
                CT_SetChoice(oPC, n++, CT_TextColor(
                    "Armor ("+ GetName(CT_GetItem(oSession, CT_ITEM_ARMOR))+") "
                    +IntToString(GetGoldPieceValue(CT_GetItem(oSession, CT_ITEM_ARMOR)))
                    +" GP",  255, 215, 0), MENU_MAIN, CT_ITEM_ARMOR,  FUNC_PURCHASE);
            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_CLOAK)))
                CT_SetChoice(oPC, n++, CT_TextColor(
                    "Cloak ("+ GetName(CT_GetItem(oSession, CT_ITEM_CLOAK))+") "
                    +IntToString(GetGoldPieceValue(CT_GetItem(oSession, CT_ITEM_CLOAK)))
                    +" GP",  255, 215, 0), MENU_MAIN, CT_ITEM_CLOAK,  FUNC_PURCHASE);
            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_HELMET)))
                CT_SetChoice(oPC, n++, CT_TextColor(
                "Helmet ("+ GetName(CT_GetItem(oSession, CT_ITEM_HELMET))+") "
                    +IntToString(GetGoldPieceValue(CT_GetItem(oSession, CT_ITEM_HELMET)))
                    +" GP",  255, 215, 0), MENU_MAIN, CT_ITEM_HELMET, FUNC_PURCHASE);
            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_WEAPON)))
                CT_SetChoice(oPC, n++, CT_TextColor(
                "Weapon ("+ GetName(CT_GetItem(oSession, CT_ITEM_WEAPON))+") "
                    +IntToString(GetGoldPieceValue(CT_GetItem(oSession, CT_ITEM_WEAPON)))
                    +" GP",  255, 215, 0), MENU_MAIN, CT_ITEM_WEAPON, FUNC_PURCHASE);
            if (GetIsObjectValid(CT_GetItem(oSession, CT_ITEM_SHIELD)))
                CT_SetChoice(oPC, n++, CT_TextColor(
                "Shield ("+ GetName(CT_GetItem(oSession, CT_ITEM_SHIELD))+") "
                    +IntToString(GetGoldPieceValue(CT_GetItem(oSession, CT_ITEM_SHIELD)))
                    +" GP",  255, 215, 0), MENU_MAIN, CT_ITEM_SHIELD, FUNC_PURCHASE);
            CT_SetChoice(oPC, n++, sSep, MENU_PURCHASE);
            CT_SetChoice(oPC, n++, sBack + CT_TextColor(" to Main", 128, 128, 128), MENU_MAIN);
            break;
        }

        case MENU_CLOSE:
        default:
            CT_EndConversation(oPC);
            return;
    }

    // Push all slot texts into custom tokens for the .dlg to display.
    int i;
    for (i = 1; i <= CT_TOKEN_MAX; i++)
        SetCustomToken(CT_TOKEN_BASE + i, GetLocalString(oPC, "ct_dialog" + IntToString(i)));
}


