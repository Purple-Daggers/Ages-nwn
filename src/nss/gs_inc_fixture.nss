/* FIXTURE library by Jamesfelicia, modified from Gigaschatten's fixture library*/

#include "gs_inc_location"

//void main() {}

//load nLimit objects from database sAreaID
void gsFXLoadFixture(string sAreaID, int nLimit = 40);
//save oFixture to database sAreaID containing a maximum of nLimit objects and return TRUE on success
int gsFXSaveFixture(string sAreaID, object oFixture = OBJECT_SELF, int nLimit = 40);
//delete oFixture from database sAreaID containing a maximum of nLimit objects
void gsFXDeleteFixture(string sFixtureID);

void gsFXLoadFixture(string sAreaID, int nLimit = 40)
{
    location lLocation;
    string sID = "";
    string sOwner = "";
    string sTemplate = "";
    string sNth      = "";
    string sName = "";
    string sDescription = "";
    int nNth         = 0;
    string sDatabase = "GS_FIXTURES";

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

        object oFixture = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
        SetName(oFixture, sName);
        SetDescription(oFixture, sDescription);
        SetLocalString(oFixture, "GS_FX_CREATOR", sOwner);
        SetLocalString(oFixture, "GS_FX_ID", sID);
    }
}
//----------------------------------------------------------------
int gsFXSaveFixture(string sAreaID, object oFixture = OBJECT_SELF, int nLimit = 40)
{
    string sDatabase = "GS_FIXTURES";

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS fixtures (id TEXT PRIMARY KEY, template TEXT, name TEXT, description TEXT, owner TEXT, area TEXT, position BLOB, direction REAL, broken INTEGER);");
    SqlStep(sqlCreateTable);

    sqlquery sqlGetFixtureCount = SqlPrepareQueryCampaign(sDatabase, "SELECT COUNT(*) from fixtures WHERE area = @area;");
    SqlBindString(sqlGetFixtureCount, "@area", sAreaID);
    if(SqlStep(sqlGetFixtureCount)){
        if(SqlGetInt(sqlGetFixtureCount, 0) > nLimit){
            return FALSE;
        }
    }

    sqlquery sqlSaveFixture = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO fixtures (id, template, name, description, owner, area, position, direction, broken) VALUES (@id, @template, @name, @description, @owner, @area, @position, @direction, @broken)");
    SqlBindString(sqlSaveFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    SqlBindString(sqlSaveFixture, "@template", GetResRef(oFixture));
    SqlBindString(sqlSaveFixture, "@name", GetName(oFixture));
    SqlBindString(sqlSaveFixture, "@description", GetDescription(oFixture));
    SqlBindString(sqlSaveFixture, "@owner", GetLocalString(oFixture, "GS_FX_CREATOR"));
    SqlBindString(sqlSaveFixture, "@area", sAreaID);
    SqlBindVector(sqlSaveFixture, "@position", GetPosition(oFixture));
    SqlBindFloat(sqlSaveFixture, "@direction", GetFacing(oFixture));
    SqlBindInt(sqlSaveFixture, "@broken", FALSE);
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
    string sDatabase = "GS_FIXTURES";
    sqlquery sqlDeleteFixture = SqlPrepareQueryCampaign(sDatabase, "DELETE FROM fixtures WHERE id = @id;");
    SqlBindString(sqlDeleteFixture, "@id", sFixtureID);
    SqlStep(sqlDeleteFixture);
}
//----------------------------------------------------------------
object gsFXMoveFixture(object oFixture, vector vPosition, float fDirection)
{
    string sDatabase = "GS_FIXTURES";
    sqlquery sqlMoveFixture = SqlPrepareQueryCampaign(sDatabase, "UPDATE fixtures SET position = @position, direction = @direction WHERE id = @id;");
    SqlBindVector(sqlMoveFixture, "@position", vPosition);
    SqlBindFloat(sqlMoveFixture, "@direction", fDirection);
    SqlBindString(sqlMoveFixture, "@id", GetLocalString(oFixture, "GS_FX_ID"));
    if (SqlStep(sqlMoveFixture))
    {
        object newFixture = CopyObject(oFixture, Location(GetArea(oFixture), vPosition, fDirection), OBJECT_INVALID, GetTag(oFixture), TRUE);
        DestroyObject(oFixture);
        return newFixture;
    }
    else
    {
        return OBJECT_INVALID;
    }
}

