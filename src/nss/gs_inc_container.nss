/* CONTAINER library by Gigaschatten */

const string GS_DATABASE = "GS_CONTAINERS";

//void main() {}

//load nLimit objects from database sID to oContainer
void gsCOLoad(string sID, object oContainer, int nLimit = 10);
//save nLimit objects within oContainer to database sID
void gsCOSave(string sID, object oContainer, int nLimit = 10);

void gsCOLoad(string sID, object oContainer, int nLimit = 10)
{
    if (GetIsObjectValid(oContainer))
    {
        location lLocation = GetLocation(oContainer);
        string sNth        = "";
        int nNth           = 0;

        sqlquery sqlGetContainerContents = SqlPrepareQueryCampaign(GS_DATABASE, "SELECT slot, in_use, object FROM containers WHERE id = @id");
        SqlBindString(sqlGetContainerContents, "@id", sID);

        while(SqlStep(sqlGetContainerContents))
        {
            nNth = SqlGetInt(sqlGetContainerContents, 0);
            sNth = IntToString(nNth);
            if(SqlGetInt(sqlGetContainerContents, 1) == TRUE)
            {
                SqlGetObject(sqlGetContainerContents, 2, lLocation, oContainer, TRUE);
            }
        }

        /*for (nNth = 1; nNth <= nLimit; nNth++)
        {
            sNth = IntToString(nNth);

            if (GetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth))
            {
                RetrieveCampaignObject("GS_CO_" + sID,
                                       "OBJECT_" + sNth,
                                       lLocation,
                                       oContainer,
                                       OBJECT_INVALID,
                                       TRUE);
            }
        }*/
    }
}
//----------------------------------------------------------------
void gsCOSave(string sID, object oContainer, int nLimit = 10)
{
    if (GetIsObjectValid(oContainer) &&
        GetHasInventory(oContainer))
    {
        object oObject = GetFirstItemInInventory(oContainer);
        string sNth    = "";
        int nNth       = 0;

        while (GetIsObjectValid(oObject) &&
               nNth < nLimit)
        {
            sNth    = IntToString(++nNth);
            sqlquery sqlInsertObject = SqlPrepareQueryCampaign(GS_DATABASE, "INSERT INTO containers (id, slot, in_use, object) VALUES (@id, @slot, @in_use, @object) ON CONFLICT (id, slot) DO UPDATE SET in_use = excluded.in_use, object = excluded.object;");
            SqlBindString(sqlInsertObject, "@id", sID);
            SqlBindInt(sqlInsertObject, "@slot", StringToInt(sNth));
            SqlBindInt(sqlInsertObject, "@in_use", TRUE);
            SqlBindObject(sqlInsertObject, "@object", oObject, TRUE);
            //StoreCampaignObject("GS_CO_" + sID, "OBJECT_" + sNth, oObject, OBJECT_INVALID, TRUE);
            //SetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth, TRUE);
            SqlStep(sqlInsertObject);
            oObject = GetNextItemInInventory(oContainer);
        }

        while (nNth < nLimit)
        {
            sNth    = IntToString(++nNth);
            sqlquery sqlInsertObject = SqlPrepareQueryCampaign(GS_DATABASE, "INSERT INTO containers (id, slot, in_use) VALUES (@id, @slot, @in_use) ON CONFLICT (id, slot) DO UPDATE SET in_use = excluded.in_use");
            SqlBindString(sqlInsertObject, "@id", sID);
            SqlBindInt(sqlInsertObject, "@slot", StringToInt(sNth));
            SqlBindInt(sqlInsertObject, "@in_use", FALSE);
            SqlStep(sqlInsertObject);
            //SetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth, FALSE);
        }
    }
}
