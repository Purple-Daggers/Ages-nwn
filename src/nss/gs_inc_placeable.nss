/* PLACEABLE library by Gigaschatten */

//void main() {}

const int GS_PL_LIMIT_SLOT = 20;

//add oPlaceable to permanent placeable list
void gsPLAddPlaceable(object oPlaceable = OBJECT_SELF);
//return slot of oPlaceable or FALSE if oPlaceable is not listed
int gsPLGetPlaceableSlot(object oPlaceable = OBJECT_SELF);
//return name of placeable in nSlot of oArea
string gsPLGetPlaceableName(int nSlot, object oArea = OBJECT_SELF);
//return template of placeable in nSlot of oArea
string gsPLGetPlaceableTemplate(int nSlot, object oArea = OBJECT_SELF);
//return location of placeable in nSlot of oArea
location gsPLGetPlaceableLocation(int nSlot, object oArea = OBJECT_SELF);
//remove placeable in nSlot from oArea
void gsPLRemovePlaceable(int nSlot, object oArea = OBJECT_SELF);
//save settings of oArea
void gsPLSaveArea(object oArea = OBJECT_SELF);
//load settings of oArea
void gsPLLoadArea(object oArea = OBJECT_SELF);

void gsPLAddPlaceable(object oPlaceable = OBJECT_SELF)
{
    if (GetObjectType(oPlaceable) != OBJECT_TYPE_PLACEABLE) return;

    string sTemplate1  = GetResRef(oPlaceable);
    if (sTemplate1 == "")                                   return;
    object oArea       = GetArea(oPlaceable);
    location lLocation = GetLocation(oPlaceable);
    string sTemplate2  = "";
    int nSlot          = FALSE;
    int nNth           = 0;

    for (nNth = 1; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        sTemplate2 = gsPLGetPlaceableTemplate(nNth, oArea);

        if (sTemplate1 == sTemplate2 &&
            lLocation == gsPLGetPlaceableLocation(nNth, oArea))
        {
            return;
        }

        if (! nSlot &&
            sTemplate2 == "")
        {
            nSlot = nNth;
        }
    }

    if (nSlot)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_PL_NAME_" + sNth, GetName(oPlaceable));
        SetLocalString(oArea, "GS_PL_RESREF_" + sNth, sTemplate1);
        SetLocalLocation(oArea, "GS_PL_LOCATION_" + sNth, lLocation);
        SetLocalInt(oPlaceable, "GS_STATIC", TRUE);
    }
}
//----------------------------------------------------------------
int gsPLGetPlaceableSlot(object oPlaceable = OBJECT_SELF)
{
    object oArea       = GetArea(oPlaceable);
    location lLocation = GetLocation(oPlaceable);
    string sTemplate   = GetResRef(oPlaceable);
    int nNth           = 0;

    for (; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        if (sTemplate == gsPLGetPlaceableTemplate(nNth, oArea) &&
            lLocation == gsPLGetPlaceableLocation(nNth, oArea))
        {
            return nNth;
        }
    }

    return FALSE;
}
//----------------------------------------------------------------
string gsPLGetPlaceableName(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_PL_NAME_" + IntToString(nSlot));
}
//----------------------------------------------------------------
string gsPLGetPlaceableTemplate(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_PL_RESREF_" + IntToString(nSlot));
}
//----------------------------------------------------------------
location gsPLGetPlaceableLocation(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalLocation(oArea, "GS_PL_LOCATION_" + IntToString(nSlot));
}
//----------------------------------------------------------------
void gsPLRemovePlaceable(int nSlot, object oArea = OBJECT_SELF)
{
    location lLocation = gsPLGetPlaceableLocation(nSlot, oArea);
    object oObject     = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);
    string sNth        = IntToString(nSlot);

    if (GetIsObjectValid(oObject) &&
        GetLocation(oObject) == lLocation &&
        GetResRef(oObject) == gsPLGetPlaceableTemplate(nSlot, oArea))
    {
        DestroyObject(oObject);
    }

    DeleteLocalString(oArea, "GS_PL_NAME_" + sNth);
    DeleteLocalString(oArea, "GS_PL_RESREF_" + sNth);
    DeleteLocalLocation(oArea, "GS_PL_LOCATION_" + sNth);
}
//----------------------------------------------------------------
void gsPLSaveArea(object oArea = OBJECT_SELF)
{
    location lLocation;
    string sDatabase = "GS_PLACEABLES";//GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        lLocation = gsPLGetPlaceableLocation(nNth, oArea);
        sNth      = IntToString(nNth);

        sqlquery sqlInsertPlaceable = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO placeables (area, slot, name, resref, position, direction) VALUES (@area, @slot, @name, @resref, @position, @direction) ON CONFLICT (area, slot) DO UPDATE SET name = excluded.name, resref = excluded.resref, position = excluded.position, direction =  excluded.direction;");
        SqlBindString(sqlInsertPlaceable, "@area", GetTag(oArea));
        SqlBindInt(sqlInsertPlaceable, "@slot", nNth);
        SqlBindString(sqlInsertPlaceable, "@name", gsPLGetPlaceableName(nNth, oArea));
        SqlBindString(sqlInsertPlaceable, "@resref", gsPLGetPlaceableTemplate(nNth, oArea));
        SqlBindVector(sqlInsertPlaceable, "@position", GetPositionFromLocation(lLocation));
        SqlBindFloat(sqlInsertPlaceable, "@direction", GetFacingFromLocation(lLocation));
        SqlStep(sqlInsertPlaceable);

        /*
        SetCampaignString(sDatabase,
                          "NAME_" + sNth,
                          gsPLGetPlaceableName(nNth, oArea));
        SetCampaignString(sDatabase,
                          "RESREF_" + sNth,
                          gsPLGetPlaceableTemplate(nNth, oArea));
        SetCampaignVector(sDatabase,
                          "POSITION_" + sNth,
                          GetPositionFromLocation(lLocation));
        SetCampaignFloat(sDatabase,
                         "FACING_" + sNth,
                         GetFacingFromLocation(lLocation));
        */
    }
}
//----------------------------------------------------------------
void gsPLLoadArea(object oArea = OBJECT_SELF)
{
    object oObject   = OBJECT_INVALID;
    location lLocation;
    string sDatabase = "GS_PLACEABLES";//GetTag(oArea);
    string sTemplate = "";
    string sNth      = "";
    int nNth         = 0;

    sqlquery sqlGetPlaceables = SqlPrepareQueryCampaign(sDatabase, "SELECT slot, name, resref, position, direction FROM placeables WHERE area = @area");
    SqlBindString(sqlGetPlaceables, "@area", GetTag(oArea));

    while(SqlStep(sqlGetPlaceables))
    {   
        nNth = SqlGetInt(sqlGetPlaceables, 0);
        sNth = IntToString(nNth);
        sTemplate = SqlGetString(sqlGetPlaceables, 2);

        if (sTemplate != "")
        {
            lLocation = Location(oArea,
                                 SqlGetVector(sqlGetPlaceables, 3),
                                 SqlGetFloat(sqlGetPlaceables, 4));
            oObject   = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);

            if (! GetIsObjectValid(oObject) ||
                GetLocation(oObject) != lLocation)
            {
                oObject = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);

                if (GetIsObjectValid(oObject))
                {
                    SetLocalInt(oObject, "GS_STATIC", TRUE);
                    SetLocalString(oArea,
                                   "GS_PL_NAME_" + sNth,
                                   SqlGetString(sqlGetPlaceables, 1));
                    SetLocalString(oArea,
                                   "GS_PL_RESREF_" + sNth,
                                   sTemplate);
                    SetLocalLocation(oArea,
                                     "GS_PL_LOCATION_" + sNth,
                                     lLocation);
                }
            }
        }
    }
}
