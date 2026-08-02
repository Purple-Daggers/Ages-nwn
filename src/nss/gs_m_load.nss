#include "gs_inc_ambience"
#include "gs_inc_time"

const string AS_EAR_DATABASE = "AS_EARS";
const string AS_RP_REPUTATION_DATABASE = "AS_REPUTATION";
const string GS_BS_BOOKSHELF_DATABASE = "GS_BS_BOOKSHELVES";
const string GS_BOSS_DATABASE = "GS_BOSSES";
const string GS_CLASS_DATABASE = "GS_CLASSES";
const string GS_CONTAINER_DATABASE = "GS_CONTAINERS";
const string GS_CRAFTING_DATABASE = "gs_crafting";
const string GS_ENCOUNTER_DATABASE = "GS_ENCOUNTERS";
const string GS_FIXTURE_DATABASE = "GS_FIXTURES";
const string GS_FORUM_DATABASE = "GS_FO_FORUMS";
const string GS_MESSAGE_DATABASE = "GS_MESSAGE";
const string GS_PLACEABLE_DATABASE = "GS_PLACEABLES";
const string AS_SUBRACE_DATABASE = "AS_SUBRACES";
const string GS_SHOP_DATABASE = "GS_SHOPS";

void main()
{
    //time
    SetLocalInt(OBJECT_SELF, "GS_YEAR", GetCalendarYear());

    int nTimestamp = GetCampaignInt("GS_SYSTEM", "TIMESTAMP");

    if (nTimestamp) gsTISetTime(nTimestamp);

    //restart timeout
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");

    if (nTimeout)
    {
        nTimeout = nTimestamp + gsTIGetGameTimestamp(nTimeout);
        SetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT", nTimeout);
    }

    //spellscript
    SetLocalString(OBJECT_SELF, "X2_S_UD_SPELLSCRIPT", "gs_spellscript");

    //hide in plain sight check
    //ExecuteScript("gs_run_hipscheck", OBJECT_SELF);

    //ambience

    //Initialize SQLite database tables
    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "CREATE TABLE IF NOT EXISTS fixtures (id TEXT PRIMARY KEY, template TEXT, name TEXT, description TEXT, owner TEXT, area TEXT, position BLOB, direction REAL, broken INTEGER);");
    SqlStep(sqlCreateTable);
    sqlquery sqlCreateReputationTable = SqlPrepareQueryCampaign(AS_RP_REPUTATION_DATABASE, "CREATE TABLE IF NOT EXISTS reputations (player_id TEXT PRIMARY KEY, json TEXT);");
    SqlStep(sqlCreateReputationTable);
    sqlquery sqlCreateBookshelfTable = SqlPrepareQueryCampaign(GS_BS_BOOKSHELF_DATABASE, "CREATE TABLE IF NOT EXISTS books (id TEXT PRIMARY KEY, shelf_id TEXT, name TEXT, description TEXT, count INTEGER, notebook TEXT);");
    SqlStep(sqlCreateBookshelfTable);
    sqlquery sqlCreateBossTable = SqlPrepareQueryCampaign(GS_BOSS_DATABASE, "CREATE TABLE IF NOT EXISTS bosses (area TEXT, slot INTEGER, name TEXT, resref TEXT, rating REAL, position BLOB, direction REAL, enabled INTEGER, timeflag INTEGER, PRIMARY KEY (area, slot));");
    SqlStep(sqlCreateBossTable);
    sqlquery sqlCreateClassTable = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "CREATE TABLE IF NOT EXISTS classes (class_id TEXT, instance INTEGER, id TEXT, name TEXT, owner TEXT, timestamp INTEGER, timeout INTEGER, PRIMARY KEY (class_id, instance));");
    SqlStep(sqlCreateClassTable);
    sqlquery sqlCreateContainerTable = SqlPrepareQueryCampaign(GS_CONTAINER_DATABASE, "CREATE TABLE IF NOT EXISTS containers (id TEXT, slot INTEGER, in_use INTEGER, object BLOB, PRIMARY KEY (id, slot));");
    SqlStep(sqlCreateContainerTable);
    sqlquery sqlCreateSkillsTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "CREATE TABLE IF NOT EXISTS skill_ranks (id TEXT PRIMARY KEY, json TEXT);");
    SqlStep(sqlCreateSkillsTable);
    sqlquery sqlCreatePointsTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "CREATE TABLE IF NOT EXISTS craft_points (id TEXT PRIMARY KEY, points INTEGER);");
    SqlStep(sqlCreatePointsTable);
    sqlquery sqlCreateTimeoutTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "CREATE TABLE IF NOT EXISTS craft_timeout (id TEXT PRIMARY KEY, timeout INTEGER);");
    SqlStep(sqlCreateTimeoutTable);
    sqlquery sqlCreateRecipeTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "CREATE TABLE IF NOT EXISTS recipes (id TEXT PRIMARY KEY, skill INTEGER, slot INTEGER, json TEXT);");
    SqlStep(sqlCreateRecipeTable);
    sqlquery sqlCreateCreatureTable = SqlPrepareQueryCampaign(GS_ENCOUNTER_DATABASE, "CREATE TABLE IF NOT EXISTS creatures (area TEXT, slot INTEGER, name TEXT, resref TEXT, rating REAL, chance INTEGER, timeflag INTEGER, PRIMARY KEY (area, slot));");
    SqlStep(sqlCreateCreatureTable);
    sqlquery sqlCreateEncounterTable = SqlPrepareQueryCampaign(GS_ENCOUNTER_DATABASE, "CREATE TABLE IF NOT EXISTS encounters (area TEXT PRIMARY KEY, chance INTEGER, rating REAL);");
    SqlStep(sqlCreateEncounterTable);
    sqlquery sqlCreateFixturesTable = SqlPrepareQueryCampaign(GS_FIXTURE_DATABASE, "CREATE TABLE IF NOT EXISTS fixtures (id TEXT PRIMARY KEY, template TEXT, name TEXT, description TEXT, owner TEXT, area TEXT, position BLOB, direction REAL, broken INTEGER);");
    SqlStep(sqlCreateFixturesTable);
    sqlquery sqlCreateForumMessageTable = SqlPrepareQueryCampaign(GS_FORUM_DATABASE, "CREATE TABLE IF NOT EXISTS forum_messages (forum_id TEXT, message_id TEXT, timestamp INTEGER, message_poster TEXT, message_owner TEXT, PRIMARY KEY (forum_id, message_id, timestamp));");
    SqlStep(sqlCreateForumMessageTable);
    sqlquery sqlCreateMessageTable = SqlPrepareQueryCampaign(GS_MESSAGE_DATABASE, "CREATE TABLE IF NOT EXISTS messages (id TEXT PRIMARY KEY, timestamp INTEGER, title TEXT, text TEXT, author TEXT, author_id TEXT);");
    SqlStep(sqlCreateMessageTable);
    sqlquery sqlCreatePlaceableTable = SqlPrepareQueryCampaign(GS_PLACEABLE_DATABASE, "CREATE TABLE IF NOT EXISTS placeables (area TEXT, slot INTEGER, name TEXT, resref TEXT, position BLOB, direction REAL, PRIMARY KEY (area, slot));");
    SqlStep(sqlCreatePlaceableTable);
    sqlquery sqlCreateSubRaceTable = SqlPrepareQueryCampaign(AS_SUBRACE_DATABASE, "CREATE TABLE IF NOT EXISTS subraces (id TEXT PRIMARY KEY, subrace INTEGER, str_gift INTEGER, dex_gift INTEGER, con_gift INTEGER, int_gift INTEGER, wis_gift INTEGER, cha_gift INTEGER);");
    SqlStep(sqlCreateSubRaceTable);
    sqlquery sqlCreateShopTable = SqlPrepareQueryCampaign(GS_SHOP_DATABASE, "CREATE TABLE IF NOT EXISTS shops (class_id TEXT, instance INTEGER, markup INTEGER, faction TEXT, PRIMARY KEY (class_id, instance));");
    SqlStep(sqlCreateShopTable);

    gsAMInitialize();
}
