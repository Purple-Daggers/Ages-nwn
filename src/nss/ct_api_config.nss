// ============================================================================
// CONFIGURATION - ct_config
// All constants below may be edited for your PW or CEP2 environment.
// Do not rename these constants; sub-files reference them by name.
// ============================================================================

// Campaign database filename used for all persistent storage calls.
// Change to match your PW's campaign name if needed.
const string CT_DB_NAME        = "CT";

// Controls whether SWAP_GENDER carries the current session appearance across
// to the new gender display, or resets to the NPC's default item appearance.
//   TRUE  (default) - Appearance is preserved across gender swaps.
//   FALSE           - NPC resets to default item look after swap.
const int    CT_SWAP_GENDER_COPY_APPEARANCE = TRUE;

// Local variable name read from NPC blueprints on spawn.
// Set a string variable with this name on a tailor NPC blueprint to
// automatically apply a saved design string each time the NPC spawns.
const string CT_NPC_DESIGN_VAR = "CT_DESIGN";

// Internal local variable storing the PC's current session NPC reference.
const string CT_SESSION_VAR    = "CT_SESSION_NPC";

// Local variable tracking the PC's current collection page (0-based).
const string CT_PAGE_VAR       = "CT_COL_PAGE";

// Number of collection slots displayed per conversation page.
const int    CT_PAGE_SIZE      = 5;

// Tag used to identify tailor NPCs when searching nearby for "/ct open".
// Must match the tag set on your tailor NPC blueprint in the Toolset.
const string CT_TAILOR_TAG     = "ct_tailor";
const string TAILOR_HELMET     = "ct_facemask"; // Resref for helmet creation
const string TAILOR_CLOAK      = "ct_cloak";    // Resref for cloak creation
const string TAILOR_CLOTH      = "ct_cloth";    // Resref for armor creation
const string TAILOR_RESPAWN    = "ct_respawn";  // Resref for respawn waypoint
const string TAILOR_SHOP       = "ct_shop";  // Resref for Tailor Shop

// New names for smart item sourcing (Phase 2)
const string CT_HELMET_RESREF  = "ct_facemask"; // Default helmet blueprint
const string CT_CLOAK_RESREF   = "ct_cloak";    // Default cloak blueprint
const string CT_ARMOR_RESREF   = "ct_cloth";    // Default armor blueprint

// Maximum distance in metres within which the player must stand to open
// the tailor conversation. Prevents remote access via chat command.
const float  CT_OPEN_RANGE     = 4.0f;

// Enable debug feedback/logging to the server log. Set FALSE for production.
const int    CT_DEBUG          = FALSE;

// Sentinel written when an item slot is empty in a design string.
// On load, fields equal to this value leave the session NPC's slot untouched.
const int    CT_EMPTY          = -1;

// Custom token base. ct_conv.dlg NPC node uses <CUSTOM8200>,
// PC reply N uses <CUSTOM8200+N>.
const int CT_TOKEN_BASE = 8200;

// Convo Token Count
const int CT_TOKEN_MAX = 24;


