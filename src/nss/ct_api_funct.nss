
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
const int FUNC_COL_SAVE     = 15;
const int FUNC_COL_LOAD     = 16;
const int FUNC_COL_DELETE   = 17;
const int FUNC_COL_RENAME   = 18;
const int FUNC_COL_PAGE_NEXT= 19;
const int FUNC_COL_PAGE_PREV= 20;
// Granular copy functions - each direction is a separate FUNC.
const int FUNC_WEAP_PART_NEXT = 21;
const int FUNC_WEAP_PART_BACK = 22;
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
const int FUNC_EQUIP_ARMOR         = 44; // equip armor, create if not equipped
const int FUNC_UNEQUIP_ARMOR       = 45; // unequip armor to inventory
const int FUNC_SET_RACE_DWARF      = 46; // set model race to dwarf
const int FUNC_SET_RACE_ELF        = 47; // set model race to elf
const int FUNC_SET_RACE_GNOME      = 48; // set model race to gnome
const int FUNC_SET_RACE_HALFLING   = 49; // set model race to halfling
const int FUNC_SET_RACE_HALF_ORC   = 50; // set model race to half-orc
const int FUNC_SET_RACE_HUMAN_HALFELF = 51; // set model race to human/half-elf
const int FUNC_RESPAWN_MODEL       = 52; // destroy NPC and create new one (refresh)
const int FUNC_SET_COLOR_EXACT     = 53; // set color channel to exact value from LAST_CHAT_INT
const int FUNC_SET_PART_EXACT      = 54; // set armor part to exact value from LAST_CHAT_INT
const int FUNC_SET_STYLE_EXACT     = 55; // set item style to exact value from LAST_CHAT_INT
const int FUNCT_SHOW_INFO          = 56; // Show Tailor Info
