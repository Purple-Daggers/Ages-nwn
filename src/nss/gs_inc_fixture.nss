/* FIXTURE library by Jamesfelicia, modified from Gigaschatten's fixture library*/

#include "gs_inc_location"

const string GS_FX_FIXTURE_DATABASE = "GS_FIXTURES";
const string GS_FX_FIXTURE_RUBBLE = "gs_placeable392";

//void main() {}

//load nLimit objects from database sAreaID
void gsFXLoadFixture(string sAreaID, int nLimit = 40);
//save oFixture to database sAreaID containing a maximum of nLimit objects and return TRUE on success
int gsFXSaveFixture(string sAreaID, object oFixture = OBJECT_SELF, int nLimit = 40);
//delete oFixture from database sAreaID containing a maximum of nLimit objects
void gsFXDeleteFixture(string sFixtureID);
//Internal use
void _gsFXSpawnFixture(string sID, string sTemplate, string sName, string sDescription, string sOwner, location lLocation, int nBroken);

void gsFXLoadFixture(string sAreaID, int nLimit = 40)
{
    location lLocation;
    string sID = "";
    string sOwner = "";
    string sTemplate = "";
    string sNth      = "";
    string sName = "";
    string sDescription = "";
    int nBroken = FALSE;
    int nNth         = 0;
    string sDatabase = GS_FX_FIXTURE_DATABASE;

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS fixtures (id TEXT PRIMARY KEY, template TEXT, name TEXT, description TEXT, owner TEXT, area TEXT, position BLOB, direction REAL, broken INTEGER);");
    SqlStep(sqlCreateTable);

    sqlquery sqlGetFixtures = SqlPrepareQueryCampaign(sDatabase, "SELECT id, template, name, description, owner, area, position, direction, broken from fixtures WHERE area = @area;");
    SqlBindString(sqlGetFixtures, "@area", sAreaID);
    while(SqlStep(sqlGetFixtures))
    {
        sID = SqlGetString(sqlGetFixtures, 0);
        sTemplate = SqlGetString(sqlGetFixtures, 1);
        sName = SqlGetString(sqlGetFixtures, 2);
        sDescription = SqlGetString(sqlGetFixtures, 3);
        sOwner = SqlGetString(sqlGetFixtures, 4);
        lLocation = gsLOConstructLocation(SqlGetString(sqlGetFixtures, 5), SqlGetVector(sqlGetFixtures, 6), SqlGetFloat(sqlGetFixtures, 7));
        nBroken = SqlGetInt(sqlGetFixtures, 8);

        _gsFXSpawnFixture(sID, sTemplate, sName, sDescription, sOwner, lLocation, nBroken);
    }
}
//----------------------------------------------------------------
int gsFXSaveFixture(string sAreaID, object oFixture = OBJECT_SELF, int nLimit = 40)
{
    string sDatabase = GS_FX_FIXTURE_DATABASE;

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS fixtures (id TEXT PRIMARY KEY, template TEXT, name TEXT, description TEXT, owner TEXT, area TEXT, position BLOB, direction REAL, broken INTEGER);");
    SqlStep(sqlCreateTable);

    sqlquery sqlGetFixtureCount = SqlPrepareQueryCampaign(sDatabase, "SELECT COUNT(*) from fixtures WHERE area = @area;");
    SqlBindString(sqlGetFixtureCount, "@area", sAreaID);
    if(SqlStep(sqlGetFixtureCount)){
        if(SqlGetInt(sqlGetFixtureCount, 0) > nLimit){
            return FALSE;
        }
    }

    string sTemplate = GetResRef(oFixture);
    int nBroken = FALSE;
    if(GetResRef(oFixture) == GS_FX_FIXTURE_RUBBLE){
        nBroken = TRUE;
        sTemplate = GetLocalString(oFixture, "GS_FX_ORIGINAL_TEMPLATE");
    }

    sqlquery sqlSaveFixture = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO fixtures (id, template, name, description, owner, area, position, direction, broken) VALUES (@id, @template, @name, @description, @owner, @area, @position, @direction, @broken)");
    SqlBindString(sqlSaveFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    SqlBindString(sqlSaveFixture, "@template", sTemplate);
    SqlBindString(sqlSaveFixture, "@name", GetName(oFixture));
    SqlBindString(sqlSaveFixture, "@description", GetDescription(oFixture));
    SqlBindString(sqlSaveFixture, "@owner", GetLocalString(oFixture, "GS_FX_CREATOR"));
    SqlBindString(sqlSaveFixture, "@area", sAreaID);
    SqlBindVector(sqlSaveFixture, "@position", GetPosition(oFixture));
    SqlBindFloat(sqlSaveFixture, "@direction", GetFacing(oFixture));
    SqlBindInt(sqlSaveFixture, "@broken", nBroken);
    if(SqlStep(sqlSaveFixture))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
//----------------------------------------------------------------
void gsFXDeleteFixture(string sFixtureID)
{
    string sDatabase = GS_FX_FIXTURE_DATABASE;
    sqlquery sqlDeleteFixture = SqlPrepareQueryCampaign(sDatabase, "DELETE FROM fixtures WHERE id = @id;");
    SqlBindString(sqlDeleteFixture, "@id", sFixtureID);
    SqlStep(sqlDeleteFixture);
}
//----------------------------------------------------------------
object gsFXMoveFixture(object oPlayer, object oFixture, vector vPosition, float fDirection)
{
    string sDatabase = GS_FX_FIXTURE_DATABASE;
    object oNewFixture = CopyObject(oFixture, Location(GetArea(oFixture), vPosition, fDirection), OBJECT_INVALID, GetTag(oFixture), TRUE);
    if(!LineOfSightObject(oPlayer, oNewFixture)){
        DestroyObject(oNewFixture);
        return oFixture;
    }
    if (!GetIsObjectValid(oNewFixture)){
        DestroyObject(oNewFixture);
        return oFixture;
    }
    fDirection = GetFacing(oNewFixture);

    sqlquery sqlMoveFixture = SqlPrepareQueryCampaign(sDatabase, "UPDATE fixtures SET position = @position, direction = @direction WHERE id = @id;");
    SqlBindVector(sqlMoveFixture, "@position", vPosition);
    SqlBindFloat(sqlMoveFixture, "@direction", fDirection);
    SqlBindString(sqlMoveFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    SqlStep(sqlMoveFixture);
    DestroyObject(oFixture);
    return oNewFixture;
}
void gsFXPickupFixture(object oPlayer, object oFixture = OBJECT_SELF)
{
    string sTag = GetTag(oFixture);
    sTag            = GetStringRight(sTag, GetStringLength(sTag) - 6);
    object oFixtureItem = CreateItemOnObject(sTag, oPlayer);
    SetName(oFixtureItem, GetName(oFixture));
    SetDescription(oFixtureItem, GetDescription(oFixture));
    SetLocalString(oFixtureItem, "GS_FX_ID", GetLocalString(oFixture, "GS_FX_ID"));
    SetLocalString(oFixtureItem, "GS_FX_ORIGINAL_TEMPLATE", GetLocalString(oFixture, "GS_FX_ORIGINAL_TEMPLATE"));

    if (GetIsObjectValid(oFixtureItem) && (GetLocalString(oFixtureItem, "GS_FX_ID") != ""))
    {
        AssignCommand(oPlayer, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
        gsFXDeleteFixture(GetLocalString(oFixture, "GS_FX_ID"));
        DestroyObject(oFixture);
    }
    else
    {
        DestroyObject(oFixtureItem);
    }
}
void _gsFXSpawnFixture(string sID, string sTemplate, string sName, string sDescription, string sOwner, location lLocation, int nBroken)
{
    string sOriginalTemplate = sTemplate;
    if(nBroken){
        sTemplate = GS_FX_FIXTURE_RUBBLE;
    }
    object oFixture = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
    SetName(oFixture, sName);
    SetDescription(oFixture, sDescription);
    SetLocalString(oFixture, "GS_FX_CREATOR", sOwner);
    SetLocalString(oFixture, "GS_FX_ID", sID);
    if(nBroken){
        SetLocalString(oFixture, "GS_FX_ORIGINAL_TEMPLATE", sOriginalTemplate);
    }
}
void _gsFXReloadFixture(object oFixture = OBJECT_SELF)
{
    if(GetLocalString(oFixture, "GS_FX_ID") == ""){
        return;
    }
    string sDatabase = GS_FX_FIXTURE_DATABASE;
    sqlquery sqlGetFixture = SqlPrepareQueryCampaign(sDatabase, "SELECT id, template, name, description, owner, area, position, direction, broken from fixtures WHERE id = @id;");
    SqlBindString(sqlGetFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    if(SqlStep(sqlGetFixture)){
        string sID = SqlGetString(sqlGetFixture, 0);
        string sTemplate = SqlGetString(sqlGetFixture, 1);
        string sName = SqlGetString(sqlGetFixture, 2);
        string sDescription = SqlGetString(sqlGetFixture, 3);
        string sOwner = SqlGetString(sqlGetFixture, 4);
        location lLocation = gsLOConstructLocation(SqlGetString(sqlGetFixture, 5), SqlGetVector(sqlGetFixture, 6), SqlGetFloat(sqlGetFixture, 7));
        int nBroken = SqlGetInt(sqlGetFixture, 8);

        DestroyObject(oFixture);
        _gsFXSpawnFixture(sID, sTemplate, sName, sDescription, sOwner, lLocation, nBroken);
    }
}
void gsFXBreakFixture(object oFixture = OBJECT_SELF)
{
    if(GetLocalString(oFixture, "GS_FX_ID") == ""){
        return;
    }
    string sDatabase = GS_FX_FIXTURE_DATABASE;
    sqlquery sqlBreakFixture = SqlPrepareQueryCampaign(sDatabase, "UPDATE fixtures SET broken = 1 WHERE id = @id;");
    SqlBindString(sqlBreakFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    SqlStep(sqlBreakFixture);
    _gsFXReloadFixture(oFixture);
}
void gsFXRepairFixture(object oFixture = OBJECT_SELF)
{
    if(GetLocalString(oFixture, "GS_FX_ID") == ""){
        return;
    }
    string sDatabase = GS_FX_FIXTURE_DATABASE;
    sqlquery sqlRepairFixture = SqlPrepareQueryCampaign(sDatabase, "UPDATE fixtures SET broken = 0 WHERE id = @id;");
    SqlBindString(sqlRepairFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    SqlStep(sqlRepairFixture);
    _gsFXReloadFixture(oFixture);
}

