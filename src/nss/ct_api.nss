// ================================================================================
// CARCERIAN'S TAILOR SYSTEM - CORE API (ct_api.nss) - v1.0
// ================================================================================
//  Core constants, configuration, shared helpers, and design string serialization.
//  Included by all sub-files. Do not include directly in entry points - include
//  ct_api_sess.nss instead, which pulls in the full stack.

// ============================================================================
// VERSION & BUILD INFORMATION
// ============================================================================

const string CT_SYSTEM_NAME = "Carcerian's Tailor System";
const string CT_VERSION     = "1.0";
const int    CT_BUILD       = 1;

// ============================================================================
// TAILOR CONFIGURATION
// All constants below may be edited for your PW or CEP2 environment.
// Do not rename these constants; sub-files reference them by name.
// ============================================================================

// Campaign database filename used for all persistent storage calls.
// Change to match your PW's campaign name if needed.
// Campaign database name for persistent storage calls.
// Reserved for future use - no StoreCampaignObject calls are currently wired.
// PW admins: do not rely on this for persistence until implemented.
const string CT_DB_NAME        = "CT";

// Controls whether SWAP_GENDER carries the current session appearance across
// to the new gender display, or resets to the NPC's default item appearance.
//   TRUE  (default) - Appearance is preserved across gender swaps.
//   FALSE           - NPC resets to default item look after swap.
const int    CT_SWAP_GENDER_COPY_APPEARANCE = TRUE;

// Internal local variable storing the PC's current session NPC reference.
const string CT_SESSION_VAR    = "CT_SESSION_NPC";

// Must match the tag set on your tailor NPC blueprint in the Toolset.
const string CT_TAILOR_TAG     = "ct_tailor";
const string TAILOR_RESPAWN    = "ct_respawn";  // Resref for respawn waypoint
const string TAILOR_SHOP       = "ct_shop";     // Resref for Tailor Shop

// Blueprint resrefs used when creating items on the session NPC.
const string CT_HELMET_RESREF  = "ct_facemask"; // Default helmet blueprint
const string CT_CLOAK_RESREF   = "ct_cloak";    // Default cloak blueprint
const string CT_ARMOR_RESREF   = "ct_cloth";    // Default armor blueprint

// Enable debug feedback/logging to the server log. Set FALSE for production.
const int    CT_DEBUG          = FALSE;

// Custom token base. ct_conv.dlg NPC node uses <CUSTOM8200>,
// PC reply N uses <CUSTOM8200+N>.
const int CT_TOKEN_BASE = 8200;

// Convo Token Count
// Full menu = 30 lines, scrolls to 40
const int CT_TOKEN_MAX = 15;

// ============================================================================
// RGB STRING
// ============================================================================

const string CT_COLOR_TOKEN =
               "\x01\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"+
               "\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F"+
               "\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F"+
               "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F"+
               "\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F"+
               "\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F"+
               "\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F"+
               "\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F"+
               "\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F"+
               "\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F"+
               "\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF"+
               "\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF"+
               "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF"+
               "\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF"+
               "\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF"+
               "\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

const string CT_CLR_LEFT  = "<c";
const string CT_CLR_RIGHT = ">";
const string CT_CLR_END   = "</c>";

// Menu UI Parts
const string CT_MENU_CORNER = "ù";
const string CT_MENU_BAR    = CT_MENU_CORNER + "====================" + CT_MENU_CORNER;
const string CT_MENU_OFFSET = "|        ";
const string CT_MENU_LINE   = "\n";
const string CT_DELIM       = "|";

// ============================================================================
// ITEM TYPE CONSTANTS
// ============================================================================
const int CT_ITEM_CLOAK     = 1;
const int CT_ITEM_HELMET    = 2;
const int CT_ITEM_ARMOR     = 3;
const int CT_ITEM_WEAPON    = 4;
const int CT_ITEM_SHIELD    = 5;

// ============================================================================
// COLOR CHANNEL CONSTANTS (Bioware Standard)
// ============================================================================

// Standard NWN Color Channels (0-5) - ALWAYS Available
const int CT_COLOR_CLOTH1           = 0;
const int CT_COLOR_CLOTH2           = 1;
const int CT_COLOR_LEATHER1         = 2;
const int CT_COLOR_LEATHER2         = 3;
const int CT_COLOR_METAL1           = 4;
const int CT_COLOR_METAL2           = 5;

// PART AND COLOR CONSTANTS
const int CT_NEXT           = 1;
const int CT_BACK           = -1;

// MODEL RANGE CONSTANTS
const int CT_WEAPON_MODEL_MAX = 25;     // Maximum weapon model index

// Custom token for displaying part/style numbers in dialog
// Used instead of SendMessageToPC(() to allow dialog.tlk to display the index
const int CT_TOKEN_PARTNUMBER = 14423;

// ============================================================================
// FEEDBACK COLOR TAGS  (NWN compact color tag format)
// ============================================================================

//const string CT_CLR_GREEN   = "<c0f0>";  // Green   CT_TextColor("ACTION GREEN", 0, 255, 0) // Green
//const string CT_CLR_YELLOW  = "<c’’ >";  // Yellow  CT_TextColor("LABEL YELLOW", 255, 215, 0)  // Yellow
//const string CT_CLR_CYAN    = "<c0ff>";  // Cyan    CT_TextColor("INFO CYAN", 0, 255, 255) // Cyan
//const string CT_CLR_WHITE   = "<cfff>";  // White   CT_TextColor("VALUE WHITE", 255, 255, 255) // White
//const string CT_CLR_RED     = "<cf00>";  // Red     CT_TextColor("ERROR RED", 255, 0, 0) // Red
//const string CT_CLR_MAGENTA = "<cf0f>";  // Magenta CT_TextColor("VALUE MAGENTA", 255, 255, 0) // Magenta, combos 255, 215, 0 and / 255, 165, 0 also used
//const string CT_CLR_BLUE    = "<c00f>";  // Blue    CT_TextColor("TITLE BLUE", 0, 0, 255) // Blue

const string CT_BLUE = "Blue";
const string CT_CYAN = "Cyan";
const string CT_GREEN = "Green";
const string CT_RED = "Red";
const string CT_MAGENTA = "Magenta";
const string CT_WHITE = "White";
const string CT_YELLOW = "Yellow";

const string CT_ACTION = "Green";
const string CT_ERROR = "Red";
const string CT_INFO = "Cyan";
const string CT_LABEL = "Yellow";
const string CT_TITLE = "Blue";
const string CT_VALUE = "White";
const string CT_WARNING ="Magenta";

// ============================================================================
// PROTOTYPES
// ============================================================================

void CT_ShowInfo(object oPC, object oSession);

string CT_Color(string sColor, string sText = "");
string CT_ColorCode(int nRed=0, int nGreen=0, int nBlue=0);
string CT_TextColor(string sText, int ncRed, int ncGreen, int ncBlue);

string CT_Action(string sText = "");
string CT_Error(string sText = "");
string CT_Info(string sText = "");
string CT_Label(string sText = "");
string CT_Title(string sText = "");
string CT_Value(string sText = "");
string CT_Warning(string sText = "");

string CT_GetChannelName(int nChannel);
string CT_GetPart2DA(int nPart);
int    CT_GetSlotType(int nItemType);
object CT_GetItem(object oTarget, int nItemType);
void   CT_ReplaceItem(object oTarget, object oOld, object oNew, int nSlot);
string CT_GetItemDisplayName(object oItem);
object CT_GetLeftHandItem(object oTarget);
void   CT_SetRespawnWaypoint(object oNPC);
object CT_GetRespawnWaypoint(object oNPC);

int    CT_CanUse(object oPC, string sAction);
int    CT_OnPurchasePrice(object oPC, object oItem, int nItemType, int nBasePrice);
void   CT_OnPurchaseComplete(object oPC, object oCopy, int nItemType, int nCost);

void CT_PurgeInventory(object oSession);

object CT_GetOrCreateItemFromPC(object oPC, object oNPC, int nItemType);


// ============================================================================
// FUNCTIONS
// ============================================================================

// Show Tailor Info
void CT_ShowInfo(object oPC, object oSession)
{
    SendMessageToPC(oPC, CT_Label("System: ") + CT_Value(CT_SYSTEM_NAME));
    SendMessageToPC(oPC, CT_Label("Version: ") + CT_Value(CT_VERSION));
    SendMessageToPC(oPC, CT_Label("Build: ") + CT_Value(IntToString(CT_BUILD)));
}

// CT_PurgeItems removed - use CT_PurgeInventory (bag items) instead.

void CT_PurgeInventory(object oSession)
{
    object oItem = GetFirstItemInInventory(oSession);
    while ( oItem != OBJECT_INVALID ) {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oSession);
    }
}

string CT_Action(string sText = "")  {return CT_Color(CT_ACTION,sText);}
string CT_Error(string sText = "")   {return CT_Color(CT_ERROR,sText);}
string CT_Info(string sText = "")    {return CT_Color(CT_INFO,sText);}
string CT_Label(string sText = "")   {return CT_Color(CT_LABEL,sText);}
string CT_Title(string sText = "")   {return CT_Color(CT_TITLE,sText);}
string CT_Value(string sText = "")   {return CT_Color(CT_VALUE,sText);}
string CT_Warning(string sText = "") {return CT_Color(CT_WARNING,sText);}

string CT_Color(string sColor, string sText = "")
{

    if (sColor != "")
    {
        if (sColor == CT_BLUE)    return CT_TextColor(sText, 0, 0, 255);
        if (sColor == CT_CYAN)    return CT_TextColor(sText, 0, 255, 255);
        if (sColor == CT_GREEN)   return CT_TextColor(sText, 0, 255, 0);
        if (sColor == CT_MAGENTA) return CT_TextColor(sText, 255, 0, 255);   // true magenta, distinct from yellow
        if (sColor == CT_RED)     return CT_TextColor(sText, 255, 0, 0);
        if (sColor == CT_WHITE)   return CT_TextColor(sText, 255, 255, 255);
        if (sColor == CT_YELLOW)  return CT_TextColor(sText, 255, 215, 0);
    }

    return CT_CLR_END;
}


// Returns a properly color-coded token string based on specified RGB values.
// nRed, nGreen, nBlue = 0 to 255, if 0,0,0 return "</c>";
string ColorCode(int nRed=0, int nGreen=0, int nBlue=0)
{
    if (nRed+nGreen+nBlue==0) return "</c>";
    return "<c" + GetSubString(CT_COLOR_TOKEN, nRed,   1) +
                  GetSubString(CT_COLOR_TOKEN, nGreen, 1) +
                  GetSubString(CT_COLOR_TOKEN, nBlue,  1) + ">";
}

// Returns: Color-tagged text string ready for display
string CT_TextColor(string sText, int ncRed, int ncGreen, int ncBlue)
{
    string sColor = ColorCode(ncRed, ncGreen, ncBlue);
    return sColor+sText+"</c>";

}


// ============================================================================
// HELPER IMPLEMENTATIONS
// ============================================================================

// Returns the display name for a color channel index.
string CT_GetChannelName(int nChannel) {
    switch(nChannel) {
        case CT_COLOR_CLOTH1:               return "CLOTH1";
        case CT_COLOR_CLOTH2:               return "CLOTH2";
        case CT_COLOR_LEATHER1:             return "LEATHER1";
        case CT_COLOR_LEATHER2:             return "LEATHER2";
        case CT_COLOR_METAL1:               return "METAL1";
        case CT_COLOR_METAL2:               return "METAL2";
    }
    return "UNKNOWN";
}

// Returns the display label for the given item type constant.
string CT_ItemLabel(int nType) {
    switch (nType) {
        case CT_ITEM_ARMOR:  return "Armor";
        case CT_ITEM_CLOAK:  return "Cloak";
        case CT_ITEM_HELMET: return "Helmet";
        case CT_ITEM_WEAPON: return "Weapon";
        case CT_ITEM_SHIELD: return "Shield";
    }
    return "Item";
}

// Returns display name for a specific armor part: "TORSO", "RIGHT ARM", "LEFT LEG", etc.
string CT_GetPartName(int nPart) {
    switch (nPart) {
        case 0:  return "RIGHT FOOT";
        case 1:  return "LEFT FOOT";
        case 2:  return "RIGHT SHIN";
        case 3:  return "LEFT SHIN";
        case 4:  return "LEFT THIGH";
        case 5:  return "RIGHT THIGH";
        case 6:  return "PELVIS";
        case 7:  return "TORSO";
        case 8:  return "BELT";
        case 9:  return "NECK";
        case 10: return "RIGHT FOREARM";
        case 11: return "LEFT FOREARM";
        case 12: return "RIGHT BICEP";
        case 13: return "LEFT BICEP";
        case 14: return "RIGHT SHOULDER";
        case 15: return "LEFT SHOULDER";
        case 16: return "RIGHT HAND";
        case 17: return "LEFT HAND";
        case 18: return "ROBE";
    }
    return "PART";
}

// Returns weapon part name matching menu labels (Bottom/Middle/Top).
// ITEM_APPR_WEAPON_MODEL_BOTTOM=0, MIDDLE=1, TOP=2.
// Previously returned "BLADE"/"HILT"/"HANDLE" which conflicted with
// the "Bottom Part"/"Middle Part"/"Top Part" labels shown in menus.
string CT_GetWeaponPartName(int nWeaponPart) {
    switch (nWeaponPart) {
        case 0: return "BOTTOM";
        case 1: return "MIDDLE";
        case 2: return "TOP";
    }
    return "PART";
}

// Sends a colorized feedback message with item name, property, and current/max values
// Format: ITEMNAME: Property [current/max]" with color-coding
void CT_NotifyCycledItem(object oPC, string sItemName, string sProperty, int nCurrent, int nMax)
{
    string sMsg = CT_Label(sItemName) + CT_Value(": " + sProperty + " " + "[" + IntToString(nCurrent) + "/" + IntToString(nMax) + "]");
    SendMessageToPC(oPC, sMsg);
}

// Returns the 2DA filename for the given armor part index (0-18).
// Standard NWN armor part layout (matches iprp_aparts.2da):
//   0=R foot      1=L foot       2=R shin       3=L shin
//   4=L thigh     5=R thigh      6=pelvis       7=torso (AC-locked)
//   8=belt        9=neck         10=R forearm   11=L forearm
//   12=R bicep    13=L bicep     14=R shoulder  15=L shoulder
//   16=R hand     17=L hand      18=robe
// Note the L/R thigh order is reversed from the rest (engine convention).
// Returns "" for out-of-range values.
string CT_GetPart2DA(int nPart) {
    // Standard NWN parts (0-18)
    switch(nPart) {
        case 0:  case 1:  return "parts_foot";
        case 2:  case 3:  return "parts_shin";
        case 4:  case 5:  return "parts_legs";
        case 6:           return "parts_pelvis";
        case 7:           return "parts_chest";
        case 8:           return "parts_belt";
        case 9:           return "parts_neck";
        case 10: case 11: return "parts_arm";
        case 12: case 13: return "parts_bicep";
        case 14: case 15: return "parts_shoulder";
        case 16: case 17: return "parts_hand";
        case 18:          return "parts_robe";
    }
    return "";  // Invalid part
}

// Returns the INVENTORY_SLOT_* constant for a CT_ITEM_* constant.
// Returns -1 for unrecognized values.
int CT_GetSlotType(int nItemType) {
    switch(nItemType) {
        case CT_ITEM_CLOAK:  return INVENTORY_SLOT_CLOAK;
        case CT_ITEM_HELMET: return INVENTORY_SLOT_HEAD;
        case CT_ITEM_ARMOR:  return INVENTORY_SLOT_CHEST;
        case CT_ITEM_SHIELD: return INVENTORY_SLOT_LEFTHAND;
        case CT_ITEM_WEAPON: return INVENTORY_SLOT_RIGHTHAND;
    }
    return -1;
}


// Returns the display name of an item (from GetName)
// Falls back to "Item" if no name is set
string CT_GetItemDisplayName(object oItem) {
    string sName = GetName(oItem);
    if (sName == "") {
        sName = "Item";
    }
    return sName;
}

// Returns the item in the left hand slot (INVENTORY_SLOT_LEFTHAND)
// Returns OBJECT_INVALID if no item in left hand
object CT_GetLeftHandItem(object oTarget) {
    return GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
}

// Returns the item in the slot corresponding to nItemType on oTarget.
// Returns OBJECT_INVALID if the slot is empty or nItemType is unrecognized.
object CT_GetItem(object oTarget, int nItemType) {
    int nSlot = CT_GetSlotType(nItemType);
    if (nSlot == -1) return OBJECT_INVALID;
    return GetItemInSlot(nSlot, oTarget);
}

void CT_ReplaceItem(object oTarget, object oOld, object oNew, int nSlot) {
    // All destruction is done via ActionDoCommand so it runs after unequip
    // in the action queue. The previous code also called DestroyObject(oOld)
    // directly (before the action queue ran), which risks destroying an item
    // that is still equipped. The direct calls have been removed.
    if (nSlot == INVENTORY_SLOT_CHEST && GetIsObjectValid(oNew)) {
        // Armor: equip new first so the NPC is never naked, then unequip old.
        AssignCommand(oTarget, ActionEquipItem(oNew, nSlot));
        if (GetIsObjectValid(oOld)) {
            AssignCommand(oTarget, ActionUnequipItem(oOld));
            AssignCommand(oTarget, ActionDoCommand(DestroyObject(oOld)));
        }
    } else {
        // All other slots: unequip old, destroy it, then equip new.
        if (GetIsObjectValid(oOld)) {
            AssignCommand(oTarget, ActionUnequipItem(oOld));
            AssignCommand(oTarget, ActionDoCommand(DestroyObject(oOld)));
        }
        if (GetIsObjectValid(oNew))
            AssignCommand(oTarget, ActionEquipItem(oNew, nSlot));
    }
}

// Returns TRUE if the equipped robe hides the specified armor part model.
// Queries parts_robe.2da using the robe's current model index so the result
// reflects the actual hide columns for that specific robe (e.g. a full robe
// hides torso/belt/shoulders/arms/legs/feet; a half-robe may only hide legs).
// Previously this function hardcoded only feet/shins/thighs as hideable,
// which missed torso, belt, neck, forearms, biceps, shoulders, and hands.
// - nModel: Armor part index (ITEM_APPR_ARMOR_MODEL_*, 0-18).
// - oArmor: The armor item whose robe slot to inspect.
int CT_APPR_IsHiddenByRobe(int nModel, object oArmor) {
    if (!GetIsObjectValid(oArmor)) return FALSE;

    int nRobeModel = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE);
    if (nRobeModel <= 0 || nRobeModel > 255) return FALSE;

    // Map armor part index to the corresponding HIDE* column name in parts_robe.2da.
    // Column names from parts_robe.2da header:
    //   HIDEFOOTR HIDEFOOTL HIDESHINR HIDESHINL HIDELEGR HIDELEGL HIDEPELVIS
    //   HIDECHEST HIDEBELT  HIDENECK  HIDEFORER HIDEFOREL HIDEBICEPR HIDEBICEPL
    //   HIDESHOL  HIDESHOR  HIDEHANDR HIDEHANDL (HIDEHEAD not used for armor parts)
    string sColumn = "";
    switch(nModel) {
        case ITEM_APPR_ARMOR_MODEL_RFOOT:     sColumn = "HIDEFOOTR";  break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT:     sColumn = "HIDEFOOTL";  break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN:     sColumn = "HIDESHINR";  break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN:     sColumn = "HIDESHINL";  break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH:    sColumn = "HIDELEGR";   break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH:    sColumn = "HIDELEGL";   break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS:    sColumn = "HIDEPELVIS"; break;
        case ITEM_APPR_ARMOR_MODEL_TORSO:     sColumn = "HIDECHEST";  break;
        case ITEM_APPR_ARMOR_MODEL_BELT:      sColumn = "HIDEBELT";   break;
        case ITEM_APPR_ARMOR_MODEL_NECK:      sColumn = "HIDENECK";   break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM:  sColumn = "HIDEFORER";  break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM:  sColumn = "HIDEFOREL";  break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP:    sColumn = "HIDEBICEPR"; break;
        case ITEM_APPR_ARMOR_MODEL_LBICEP:    sColumn = "HIDEBICEPL"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: sColumn = "HIDESHOR";   break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER: sColumn = "HIDESHOL";   break;
        case ITEM_APPR_ARMOR_MODEL_RHAND:     sColumn = "HIDEHANDR";  break;
        case ITEM_APPR_ARMOR_MODEL_LHAND:     sColumn = "HIDEHANDL";  break;
        // ITEM_APPR_ARMOR_MODEL_ROBE (18): robe never hides itself
        default: return FALSE;
    }

    return (Get2DAString("parts_robe", sColumn, nRobeModel) == "1");
}

// Access control hook. Returns TRUE to allow any action, FALSE to abort.
// Replace the body with PW-specific logic (quest flags, class checks, etc.).
int CT_CanUse(object oPC, string sAction) {
    return TRUE;
}

// PW economy price hook. Return nBasePrice to accept, or override.
// Return -1 to block the purchase entirely.
int CT_OnPurchasePrice(object oPC, object oItem, int nItemType, int nBasePrice) {
    return nBasePrice;
}

// PW economy post-purchase hook. Called after a successful sale.
// Add logging, rewards, or economy events here.
void CT_OnPurchaseComplete(object oPC, object oCopy, int nItemType, int nCost) {
    // Override with PW post-purchase logic.
}

// ============================================================================
// ITEM EQUIP/CREATE HELPERS
// ============================================================================


// Gets or creates an item on NPC with fallback priority.
// - oPC:       The player character (source of items).
// - oNPC:      The session NPC target (destination).
// - nItemType: CT_ITEM_ARMOR, CT_ITEM_HELMET, CT_ITEM_CLOAK, CT_ITEM_WEAPON, CT_ITEM_SHIELD.
// * Priority order:
//   1. Return NPC's item if already equipped
//   2. Copy from PC's item if available (PREFERRED)
//   3. Create from CT_[ITEM]_RESREF constant for armor/helmet/cloak (FALLBACK)
//   4. Return NULL if nothing available
// * IMPORTANT: Weapons/shields use PC source only (always available)
// * IMPORTANT: Armor/helmet/cloak try PC first, then blueprint fallback
// * Newly created items are automatically equipped
object CT_GetOrCreateItemFromPC(object oPC, object oNPC, int nItemType) {
    // Check if NPC already has item (equipped)
    object oNPCItem = CT_GetItem(oNPC, nItemType);
    if (GetIsObjectValid(oNPCItem)) {
        return oNPCItem;  // Already equipped, return it
    }

    // Try to copy from PC
    object oPCItem = CT_GetItem(oPC, nItemType);
    if (GetIsObjectValid(oPCItem)) {
        object oCopy = CopyItem(oPCItem, oNPC, FALSE);
        if (GetIsObjectValid(oCopy)) {
            AssignCommand(oNPC, ActionEquipItem(oCopy, CT_GetSlotType(nItemType)));
            return oCopy;  // PC's version is preferred
        }
    }

    // Fall back to RESREF for armor, helmet, cloak
    string sResRef = "";
    if      (nItemType == CT_ITEM_HELMET) sResRef = CT_HELMET_RESREF;
    else if (nItemType == CT_ITEM_CLOAK) sResRef = CT_CLOAK_RESREF;
    else if (nItemType == CT_ITEM_ARMOR) sResRef = CT_ARMOR_RESREF;

    // Try to create from blueprint
    if (sResRef != "") {
        object oNew = CreateObject(OBJECT_TYPE_ITEM, sResRef, GetLocation(oNPC));
        if (GetIsObjectValid(oNew)) {
            AssignCommand(oNPC, ActionEquipItem(oNew, CT_GetSlotType(nItemType)));
            return oNew;  // Fallback item created and equipped
        }
    }

    // Nothing available
    return OBJECT_INVALID;
}

// Equips a cloak on oSession. If none equipped, creates one from TAILOR_CLOAK.
// Notifies the PC on success or failure.
void CT_EquipCloak(object oSession) {

    object oPC = GetPCSpeaker();
    object oCloak = CT_GetItem(oSession, CT_ITEM_CLOAK);
    if (GetIsObjectValid(oCloak)) return;  // Already has Cloak

    // Try to get/create Cloak: PC's version first, then fallback to blueprint
    object oNew = CT_GetOrCreateItemFromPC(oPC, oSession, CT_ITEM_CLOAK);
    if (GetIsObjectValid(oNew)) {
        SendMessageToPC(oPC, CT_Action("Cloak equipped on model."));
    } else {
        SendMessageToPC(oPC, CT_Error("Error: Could not create cloak (missing resref: " + CT_CLOAK_RESREF + ")"));
    }


}

// Unequips the cloak on oSession into inventory. No-op if none equipped.
void CT_UnequipCloak(object oSession) {
    object oPC   = GetPCSpeaker();
    object oCloak = CT_GetItem(oSession, CT_ITEM_CLOAK);

    if (!GetIsObjectValid(oCloak)) {
        SendMessageToPC(oPC, CT_Warning("No cloak equipped."));
        return;
    }

    AssignCommand(oSession, ActionUnequipItem(oCloak));
    SendMessageToPC(oPC, CT_Action("Cloak unequipped."));
}

// Equips a helmet on oSession. If none equipped, creates one from CT_HELMET_RESREF.
// Notifies the PC on success or failure.
void CT_EquipHelmet(object oSession)
{
    object oPC = GetPCSpeaker();
    object oHelmet = CT_GetItem(oSession, CT_ITEM_HELMET);
    if (GetIsObjectValid(oHelmet)) return;  // Already has Helmet

    // Try to get/create Helmet: PC's version first, then fallback to blueprint
    object oNew = CT_GetOrCreateItemFromPC(oPC, oSession, CT_ITEM_HELMET);
    if (GetIsObjectValid(oNew)) {
        SendMessageToPC(oPC, CT_Action("Helmet equipped on model."));
    } else {
        SendMessageToPC(oPC, CT_Error("Error: Could not create helmet (missing resref: " + CT_HELMET_RESREF + ")"));
    }
}

// Unequips the helmet on oSession into inventory. No-op if none equipped.
void CT_UnequipHelmet(object oSession) {
    object oPC    = GetPCSpeaker();
    object oHelmet = CT_GetItem(oSession, CT_ITEM_HELMET);

    if (!GetIsObjectValid(oHelmet)) {
        SendMessageToPC(oPC, CT_Warning("No helmet equipped."));
        return;
    }

    AssignCommand(oSession, ActionUnequipItem(oHelmet));
    SendMessageToPC(oPC, CT_Action("Helmet unequipped."));
}

// Creates an invisible waypoint at the NPC's current location.
// Stores waypoint reference on NPC using TAILOR_RESPAWN variable.
// Used to mark spawn location for later respawning.
void CT_SetRespawnWaypoint(object oNPC) {
    if (!GetIsObjectValid(oNPC)) return;

    // Try to find existing respawn waypoint by tag
    object oWaypoint = GetNearestObjectByTag(TAILOR_RESPAWN, oNPC);

    // If no existing waypoint found, create new one
    if (!GetIsObjectValid(oWaypoint)) {
        location lLoc = GetLocation(oNPC);
        oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, TAILOR_RESPAWN, lLoc);

        // Set the tag so future searches find it
        if (GetIsObjectValid(oWaypoint)) {
            SetTag(oWaypoint, TAILOR_RESPAWN);
        }
    }

    // Store waypoint reference on NPC
    if (GetIsObjectValid(oWaypoint)) {
        SetLocalObject(oNPC, TAILOR_RESPAWN, oWaypoint);
    }
}

// Retrieves the stored respawn waypoint for an NPC.
// Returns OBJECT_INVALID if no waypoint set.
object CT_GetRespawnWaypoint(object oNPC)
{return GetLocalObject(oNPC, TAILOR_RESPAWN);}



