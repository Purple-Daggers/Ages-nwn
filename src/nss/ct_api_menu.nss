// MENU FUNCT Constants

#include "ct_api_sess"

// Function codes - side effects run before rebuilding menu
const int FUNC_NONE         = 0;
const int FUNC_RESET        = 1;
const int FUNC_PART_NEXT    = 2;
const int FUNC_PART_BACK    = 3;
const int FUNC_PART_MIRROR   = 4;
const int FUNC_MIRROR_ALL    = 5;
const int FUNC_MIRROR_ALL_LR = 6;
const int FUNC_COLOR_NEXT    = 7;
const int FUNC_COLOR_BACK   = 8;
const int FUNC_STYLE_NEXT   = 9;
const int FUNC_STYLE_BACK   = 10;
const int FUNC_PURCHASE     = 11;
const int FUNC_EQUIP_WEAP   = 12;
const int FUNC_EQUIP_SHLD   = 13;
const int FUNC_SWAP_GENDER  = 14;
// Granular copy functions - each direction is a separate FUNC.
const int FUNC_WEAP_PART_NEXT = 21;
const int FUNC_WEAP_PART_BACK = 22;
// Left-hand weapon dedicated functions (always target INVENTORY_SLOT_LEFTHAND only).
// Use these in MENU_ADJUST_WEAPON_LEFT so a dual-wielder's right-hand weapon is never
// accidentally cycled when the menu was opened for the left-hand item.
const int FUNC_LEFT_WEAP_PART_NEXT  = 57; // params = weapon part (0/1/2)
const int FUNC_LEFT_WEAP_PART_BACK  = 58; // params = weapon part
const int FUNC_LEFT_WEAP_COLOR_NEXT = 59; // params = weapon part (maps to color channel)
const int FUNC_LEFT_WEAP_COLOR_BACK = 60; // params = weapon part
// Direction "FROM_PC" reads from the PC's item, applies to the NPC.
// Direction "TO_PC"   reads from the NPC's item, applies to the PC.
const int FUNC_COPY_PART_FROM_PC  = 23; // params = part index (0-18)
const int FUNC_COPY_PART_TO_PC    = 24; // params = part index
const int FUNC_COPY_COLOR_FROM_PC = 25; // params = itemType*10 + channel
const int FUNC_COPY_COLOR_TO_PC   = 26; // params = itemType*10 + channel
const int FUNC_COPY_STYLE_FROM_PC = 27; // params = item type (cloak/helmet/shield)
const int FUNC_COPY_STYLE_TO_PC   = 28; // params = item type
const int FUNC_COPY_WPART_FROM_PC = 29; // params = weapon part (0/1/2)
const int FUNC_COPY_WPART_TO_PC   = 30; // params = weapon part
const int FUNC_PART_STRIP        = 31; // params = part index - sets part to 1
const int FUNC_CLOAK_INVISIBLE   = 32; // sets cloak model to 99 (invisible)
const int FUNC_WEAP_COLOR_NEXT   = 33; // params = weapon part (0/1/2) - maps to color channel
const int FUNC_WEAP_COLOR_BACK   = 34; // params = weapon part
const int FUNC_COPY_DESIGN_FROM_PC = 35; // params = item type - full design NPC<-PC
const int FUNC_COPY_DESIGN_TO_PC   = 36; // params = item type - full design NPC->PC
const int FUNC_OPEN_SHOP           = 37; // open store tagged/resref TAILOR_SHOP
const int FUNC_EQUIP_CLOAK         = 38; // equip cloak, create if not equipped
const int FUNC_UNEQUIP_CLOAK       = 39; // unequip cloak to inventory
const int FUNC_EQUIP_HELMET        = 40; // equip helmet, create if not equipped
const int FUNC_UNEQUIP_HELMET      = 41; // unequip helmet to inventory
// 42-43 reserved (were FUNC_EQUIP_SHIELD / FUNC_UNEQUIP_SHIELD, removed).
const int FUNC_EQUIP_ARMOR         = 44; // equip armor, create if not equipped
const int FUNC_UNEQUIP_ARMOR       = 45; // unequip armor to inventory
const int FUNC_SET_RACE_DWARF      = 46; // set model race to dwarf
const int FUNC_SET_RACE_ELF        = 47; // set model race to elf
const int FUNC_SET_RACE_GNOME      = 48; // set model race to gnome
const int FUNC_SET_RACE_HALFLING   = 49; // set model race to halfling
const int FUNC_SET_RACE_HALF_ORC   = 50; // set model race to half-orc
const int FUNC_SET_RACE_HUMAN_HALFELF = 51; // set model race to human / half-elf (identical geometry)
const int FUNC_RESPAWN_MODEL       = 52; // destroy NPC and create new one (refresh)
const int FUNC_SET_COLOR_EXACT     = 53; // set color channel to exact value from LAST_CHAT_INT
const int FUNC_SET_PART_EXACT      = 54; // set armor part to exact value from LAST_CHAT_INT
const int FUNC_SET_STYLE_EXACT     = 55; // set item style to exact value from LAST_CHAT_INT
const int FUNCT_SHOW_INFO          = 56; // Show Tailor Info

// Menu IDs - which page to build
const int MENU_MAIN       = 1;
const int MENU_ARMOR       = 2;
const int MENU_ARMOR_PARTS = 3;
const int MENU_ARMOR_ARMS  = 4;
const int MENU_ARMOR_LEGS  = 5;
const int MENU_ARMOR_COLORS= 6;
const int MENU_ARMOR_MIR   = 7;
const int MENU_PART        = 8;  // generic single-part cycling (params = part index)
const int MENU_COLOR       = 9;  // generic color channel (params = item*10 + chan)
const int MENU_CLOAK       = 10;
const int MENU_CLOAK_COL   = 12;
const int MENU_HELMET      = 13;
const int MENU_HELMET_COL  = 15;
const int MENU_WEAPON      = 16;
const int MENU_WEAPON_PARTS= 17; // Bottom/middle/top selector (per nwscript BOTTOM=0,MIDDLE=1,TOP=2)
const int MENU_WEAPON_PART = 18; // Single weapon part cycler (params = 0/1/2)
const int MENU_SHIELD      = 19;
const int MENU_WEAPON_COLOR= 21; // Weapon color channel selector
const int MENU_PURCHASE    = 22;
const int MENU_ADJUST_BODY = 24; // Adjust Body submenu (gender, race, etc)
const int MENU_SELECT_RACE = 25; // Race selection submenu
const int MENU_ADJUST_WEAPON_LEFT = 26; // Left-hand weapon adjustment submenu
const int MENU_INFO        = 30; // Show NPC Info
const int MENU_CLOSE       = 99;

const string MENU_MAIN_STR = " CUSTOMIZE MODEL         ";

const string MENU_BODY_STR =               "   GENDER & RACE             |";
const string MENU_RACE_STR =               "     SELECT RACE                |";

const string MENU_ARMOR_STR =              "   ADJUST ARMOR              |";
const string MENU_ARMOR_PARTS_STR =        "    ARMOR PARTS                |";
const string MENU_ARMOR_MIRROR_STR =       "    MIRROR PARTS              |";
const string MENU_ARMOR_COLOR_STR =        "    ARMOR COLORS             |";

const string MENU_CLOAK_STR =              "    ADJUST CLOAK              |";
const string MENU_CLOAK_COLOR_STR =        "    CLOAK COLORS              |";

const string MENU_HELMET_STR =             "   ADJUST HELMET            |";
const string MENU_HELMET_COLOR_STR =       "   HELMET COLORS            |";

const string MENU_WEAPON_RIGHT_STR =       "    RIGHT WEAPON            |";
const string MENU_WEAPON_RIGHT_COLOR_STR = "  WEAPON COLORS            |";

const string MENU_WEAPON_RIGHT_PART_STR =  "   WEAPON PARTS              |";
const string MENU_WEAPON_LEFT_STR =        "   LEFT WEAPON               |";
const string MENU_SHIELD_STR =             "   ADJUST SHIELD              |";

const string MENU_PURCHASE_STR =           "   PURCHASE ITEM             |";
const string MENU_INFO_STR =               "  NPC INFORMATION        |";
