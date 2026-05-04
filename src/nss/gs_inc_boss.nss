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
    string sDatabase = "GS_BO_" + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetCampaignString(sDatabase,
                          "NAME_" + sNth,
                          gsBOGetCreatureName(nNth, oArea));
        SetCampaignString(sDatabase,
                          "RESREF_" + sNth,
                          gsBOGetCreatureTemplate(nNth, oArea));
        SetCampaignFloat(sDatabase,
                         "RATING_" + sNth,
                         gsBOGetCreatureRating(nNth, oArea));
        gsLOSetDBLocation(sDatabase,
                          "LOCATION_" + sNth,
                          gsBOGetCreatureLocation(nNth, oArea));
    }
}
//----------------------------------------------------------------
void gsBOLoadArea(object oArea = OBJECT_SELF)
{
    string sDatabase = "GS_BO_" + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetLocalString(oArea,
                       "GS_BO_NAME_" + sNth,
                       GetCampaignString(sDatabase, "NAME_" + sNth));
        SetLocalString(oArea,
                       "GS_BO_RESREF_" + sNth,
                       GetCampaignString(sDatabase, "RESREF_" + sNth));
        SetLocalFloat(oArea,
                      "GS_BO_RATING_" + sNth,
                      GetCampaignFloat(sDatabase, "RATING_" + sNth));
        SetLocalLocation(oArea,
                         "GS_BO_LOCATION_" + sNth,
                         gsLOGetDBLocation(sDatabase, "LOCATION_" + sNth));
    }
}
