/* BOSS library by Gigaschatten */

//void main() {}

#include "gs_inc_flag"
#include "gs_inc_location"

const string GS_BO_TEMPLATE_TRIGGER = "gs_creature178";
const int GS_BO_LIMIT_SLOT          = 5;

//create boss spawn positions in oArea
void gsBOSetUpArea(object oArea = OBJECT_SELF);
//set oCreature for oArea
void gsBOSetCreature(object oCreature, object oArea = OBJECT_SELF);
//return name of creature in nSlot of oArea
string gsBOGetCreatureName(int nSlot, object oArea = OBJECT_SELF);
//return template of creature in nSlot of oArea
string gsBOGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF);
//return challenge rating of creature in nSlot of oArea
float gsBOGetCreatureRating(int nSlot, object oArea = OBJECT_SELF);
//return location of creature in nSlot of oArea
location gsBOGetCreatureLocation(int nSlot, object oArea = OBJECT_SELF);
//remove creature in nSlot from oArea
void gsBORemoveCreature(int nSlot, object oArea = OBJECT_SELF);
//return true if oCreature is a boss
int gsBOGetIsBossCreature(object oCreature = OBJECT_SELF);
//save settings of oArea
void gsBOSaveArea(object oArea = OBJECT_SELF);
//load setting of oArea
void gsBOLoadArea(object oArea = OBJECT_SELF);

void gsBOSetUpArea(object oArea = OBJECT_SELF)
{
    object oCreature = OBJECT_INVALID;
    string sResRef   = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sResRef = gsBOGetCreatureTemplate(nNth, oArea);

        if (sResRef != "")
        {
            oCreature =
                CreateObject(
                    OBJECT_TYPE_CREATURE,
                    GS_BO_TEMPLATE_TRIGGER,
                    gsBOGetCreatureLocation(nNth));

            if (GetIsObjectValid(oCreature))
            {
                SetLocalString(oCreature, "GS_BO_RESREF", sResRef);
            }
        }
    }
}
//----------------------------------------------------------------
void gsBOSetCreature(object oCreature, object oArea = OBJECT_SELF)
{
    if (! GetIsObjectValid(oCreature))                    return;
    if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCreature))                               return;
    if (! GetIsObjectValid(oArea))                        return;

    string sTemplate = GetResRef(oCreature);
    if (sTemplate == "")                                  return;
    string sResRef   = "";
    int nSlot        = FALSE;
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sResRef = gsBOGetCreatureTemplate(nNth, oArea);

        if (sResRef == sTemplate)
        {
            nSlot = nNth;
            break;
        }
        else if (! nSlot &&
                 sResRef == "")
        {
            nSlot = nNth;
        }
    }

    if (nNth)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_BO_NAME_" + sNth, GetName(oCreature, TRUE));
        SetLocalString(oArea, "GS_BO_RESREF_" + sNth, sTemplate);
        SetLocalFloat(oArea, "GS_BO_RATING_" + sNth, GetChallengeRating(oCreature));
        SetLocalLocation(oArea, "GS_BO_LOCATION_" + sNth, GetLocation(oCreature));
    }
}
//----------------------------------------------------------------
string gsBOGetCreatureName(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_BO_NAME_" + IntToString(nSlot));
}
//----------------------------------------------------------------
string gsBOGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_BO_RESREF_" + IntToString(nSlot));
}
//----------------------------------------------------------------
float gsBOGetCreatureRating(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalFloat(oArea, "GS_BO_RATING_" + IntToString(nSlot));
}
//----------------------------------------------------------------
location gsBOGetCreatureLocation(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalLocation(oArea, "GS_BO_LOCATION_" + IntToString(nSlot));
}
//----------------------------------------------------------------
void gsBORemoveCreature(int nSlot, object oArea = OBJECT_SELF)
{
    string sNth = IntToString(nSlot);

    DeleteLocalString(oArea, "GS_BO_NAME_" + sNth);
    DeleteLocalString(oArea, "GS_BO_RESREF_" + sNth);
    DeleteLocalFloat(oArea, "GS_BO_RATING_" + sNth);
    DeleteLocalLocation(oArea, "GS_BO_LOCATION_" + sNth);
}
//----------------------------------------------------------------
int gsBOGetIsBossCreature(object oCreature = OBJECT_SELF)
{
    return GetObjectType(oCreature) == OBJECT_TYPE_CREATURE &&
           gsFLGetFlag(GS_FL_BOSS, oCreature);
}
//----------------------------------------------------------------
void gsBOSaveArea(object oArea = OBJECT_SELF)
{
    string sDatabase = "GS_BOSSES";// + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        sqlquery sqlGetBoss = SqlPrepareQueryCampaign(sDatabase, "SELECT * FROM bosses WHERE area = @area AND slot = @slot");
        SqlBindString(sqlGetBoss, "@area", GetTag(oArea));
        SqlBindInt(sqlGetBoss, "@slot", nNth);
        if(SqlStep(sqlGetBoss)){
            //update
            sqlquery sqlUpdateBoss = SqlPrepareQueryCampaign(sDatabase, "UPDATE bosses SET name = @name, resref = @resref, rating = @rating, position = @position, direction = @direction, enabled = @enabled, timeflag = @timeflag WHERE area = @area AND slot = @slot");
            SqlBindString(sqlUpdateBoss, "@area", GetTag(oArea));
            SqlBindInt(sqlUpdateBoss, "@slot", nNth);
            SqlBindString(sqlUpdateBoss, "@name", gsBOGetCreatureName(nNth, oArea));
            SqlBindString(sqlUpdateBoss, "@resref", gsBOGetCreatureTemplate(nNth, oArea));
            SqlBindFloat(sqlUpdateBoss, "@rating", gsBOGetCreatureRating(nNth, oArea));
            SqlBindVector(sqlUpdateBoss, "@position", GetPositionFromLocation(gsBOGetCreatureLocation(nNth, oArea)));
            SqlBindFloat(sqlUpdateBoss, "@direction", GetFacingFromLocation(gsBOGetCreatureLocation(nNth, oArea)));
            SqlBindInt(sqlUpdateBoss, "@enabled", TRUE);
            SqlBindInt(sqlUpdateBoss, "@timeflag", 0);
            SqlStep(sqlUpdateBoss);
        } else {
            //insert
            sqlquery sqlCreateBoss = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO bosses (area, slot, name, resref, rating, position, direction, enabled, timeflag) VALUES (@area, @slot, @name, @resref, @rating, @position, @direction, @enabled, @timeflag)");
            SqlBindString(sqlCreateBoss, "@area", GetTag(oArea));
            SqlBindInt(sqlCreateBoss, "@slot", nNth);
            SqlBindString(sqlCreateBoss, "@name", gsBOGetCreatureName(nNth, oArea));
            SqlBindString(sqlCreateBoss, "@resref", gsBOGetCreatureTemplate(nNth, oArea));
            SqlBindFloat(sqlCreateBoss, "@rating", gsBOGetCreatureRating(nNth, oArea));
            SqlBindVector(sqlCreateBoss, "@position", GetPositionFromLocation(gsBOGetCreatureLocation(nNth, oArea)));
            SqlBindFloat(sqlCreateBoss, "@direction", GetFacingFromLocation(gsBOGetCreatureLocation(nNth, oArea)));
            SqlBindInt(sqlCreateBoss, "@enabled", TRUE);
            SqlBindInt(sqlCreateBoss, "@timeflag", 0);
            SqlStep(sqlCreateBoss);
        }
    }
}
//----------------------------------------------------------------
void gsBOLoadArea(object oArea = OBJECT_SELF)
{
    string sDatabase = "GS_BOSSES";// + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    sqlquery sqlGetBosses = SqlPrepareQueryCampaign(sDatabase, "SELECT slot, name, resref, rating, position, direction, enabled, timeflag FROM bosses WHERE area = @area");
    SqlBindString(sqlGetBosses, "@area", GetTag(oArea));
    while(SqlStep(sqlGetBosses)){
        nNth = SqlGetInt(sqlGetBosses, 0);
        sNth = IntToString(nNth);
        

        SetLocalString(oArea,
                       "GS_BO_NAME_" + sNth,
                       SqlGetString(sqlGetBosses, 1));
        SetLocalString(oArea,
                       "GS_BO_RESREF_" + sNth,
                       SqlGetString(sqlGetBosses, 2));
        SetLocalFloat(oArea,
                      "GS_BO_RATING_" + sNth,
                      SqlGetFloat(sqlGetBosses, 3));
        SetLocalLocation(oArea,
                         "GS_BO_LOCATION_" + sNth,
                         gsLOConstructLocation(GetTag(oArea), SqlGetVector(sqlGetBosses, 4), SqlGetFloat(sqlGetBosses, 5)));
        SetLocalInt(oArea,
                      "GS_BO_ENABLED_" + sNth,
                      SqlGetInt(sqlGetBosses, 6));
        SetLocalInt(oArea,
                      "GS_BO_TIMEFLAG_" + sNth,
                      SqlGetInt(sqlGetBosses, 7));      
    }
}
