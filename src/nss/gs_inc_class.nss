/* CLASS Library by Gigaschatten */

#include "gs_inc_pc"
#include "gs_inc_time"

//void main() {}

const string GS_CLASS_DATABASE = "GS_CLASSES";

//return unique id from nInstance of class sID
string gsCLGetUniqueID(string sID, int nInstance);
//return unique id of player that owns nInstance of class sID
string gsCLGetOwnerID(string sID, int nInstance);
//make oPC own nInstance of class sID, also set name and actualize timestamp
void gsCLSetOwner(string sID, int nInstance, object oPC);
//return owner name from nInstance of class sID
string gsCLGetName(string sID, int nInstance);
//set owner sName for nInstance of class sID
void gsCLSetName(string sID, int nInstance, string sName);
//return timestamp from nInstance of class sID
int gsCLGetTimestamp(string sID, int nInstance);
//set nTimestamp for nInstance of class sID
void gsCLSetTimestamp(string sID, int nInstance, int nTimestamp);
//set timestamp for nInstance of class sID to actual time
void gsCLSetActualTimestamp(string sID, int nInstance);
//return timeout from nInstance of class sID
int gsCLGetTimeout(string sID, int nInstance);
//set nTimeout for nInstance of class sID
void gsCLSetTimeout(string sID, int nInstance, int nTimeout);
//return TRUE if oPC owns nInstance of class sID
int gsCLGetIsOwner(string sID, int nInstance, object oPC);
//return TRUE if nInstance of class sID is vacant
int gsCLGetIsVacant(string sID, int nInstance);
//return TRUE if nInstance of class sID is available
int gsCLGetIsAvailable(string sID, int nInstance);
//release nInstance of class sID
void gsCLRelease(string sID, int nInstance);
//release all instances of class sID (database will be deleted)
void gsCLReleaseAll(string sID);

string gsCLGetUniqueID(string sID, int nInstance)
{
    sqlquery sqlGetUniqueID = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "SELECT id from classes WHERE class_id = @class_id AND instance = @instance");
    SqlBindString(sqlGetUniqueID, "@class_id", sID);
    SqlBindInt(sqlGetUniqueID, "@instance", nInstance);
    if(SqlStep(sqlGetUniqueID)){
        return SqlGetString(sqlGetUniqueID, 0);
    } else {
        return "";
    }
    //return GetCampaignString("GS_CL_" + sID, "UNIQUE_ID_" + IntToString(nInstance));
}
//----------------------------------------------------------------
string gsCLGetOwnerID(string sID, int nInstance)
{
    sqlquery sqlGetOwner = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "SELECT owner from classes WHERE class_id = @class_id AND instance = @instance");
    SqlBindString(sqlGetOwner, "@class_id", sID);
    SqlBindInt(sqlGetOwner, "@instance", nInstance);
    if(SqlStep(sqlGetOwner)){
        return SqlGetString(sqlGetOwner, 0);
    } else {
        return "";
    }
    //return GetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetOwner(string sID, int nInstance, object oPC)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    if (sPlayerID != "")
    {
        string sUniqueID = GetRandomUUID();
        sqlquery sqlSetClassOwner = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "INSERT INTO classes (class_id, instance, id, owner) VALUES (@class_id, @instance, @id, @owner) ON CONFLICT (class_id, instance) DO UPDATE SET id = excluded.id, owner = excluded.owner;");
        SqlBindString(sqlSetClassOwner, "@class_id", sID);
        SqlBindInt(sqlSetClassOwner, "@instance", nInstance);
        SqlBindString(sqlSetClassOwner, "@id", sUniqueID);
        SqlBindString(sqlSetClassOwner, "@owner", sPlayerID);
        SqlStep(sqlSetClassOwner);
        /*SetCampaignString("GS_CL_" + sID, "UNIQUE_ID_" + IntToString(nInstance), sUniqueID);
        SetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance), sPlayerID);*/
        gsCLSetName(sID, nInstance, GetName(oPC));
        gsCLSetActualTimestamp(sID, nInstance);
    }
}
//----------------------------------------------------------------
string gsCLGetName(string sID, int nInstance)
{
    sqlquery sqlGetName = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "SELECT name from classes WHERE class_id = @class_id AND instance = @instance");
    SqlBindString(sqlGetName, "@class_id", sID);
    SqlBindInt(sqlGetName, "@instance", nInstance);
    if(SqlStep(sqlGetName)){
        return SqlGetString(sqlGetName, 0);
    } else {
        return "";
    }
    //return GetCampaignString("GS_CL_" + sID, "NAME_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetName(string sID, int nInstance, string sName)
{
    sqlquery sqlSetName = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "INSERT INTO classes (class_id, instance, name) VALUES (@class_id, @instance, @name) ON CONFLICT (class_id, instance) DO UPDATE SET name = excluded.name;");
    SqlBindString(sqlSetName, "@class_id", sID);
    SqlBindInt(sqlSetName, "@instance", nInstance);
    SqlBindString(sqlSetName, "@name", sName);
    SqlStep(sqlSetName);
    //SetCampaignString("GS_CL_" + sID, "NAME_" + IntToString(nInstance), sName);
}
//----------------------------------------------------------------
int gsCLGetTimestamp(string sID, int nInstance)
{
    sqlquery sqlGetTimestamp = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "SELECT timestamp from classes WHERE class_id = @class_id AND instance = @instance");
    SqlBindString(sqlGetTimestamp, "@class_id", sID);
    SqlBindInt(sqlGetTimestamp, "@instance", nInstance);
    if(SqlStep(sqlGetTimestamp)){
        return SqlGetInt(sqlGetTimestamp, 0);
    } else {
        return 0;
    }
    //return GetCampaignInt("GS_CL_" + sID, "TIMESTAMP_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetTimestamp(string sID, int nInstance, int nTimestamp)
{
    sqlquery sqlSetTimestamp = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "INSERT INTO classes (class_id, instance, timestamp) VALUES (@class_id, @instance, @timestamp) ON CONFLICT (class_id, instance) DO UPDATE SET timestamp = excluded.timestamp;");
    SqlBindString(sqlSetTimestamp, "@class_id", sID);
    SqlBindInt(sqlSetTimestamp, "@instance", nInstance);
    SqlBindInt(sqlSetTimestamp, "@timestamp", nTimestamp);
    SqlStep(sqlSetTimestamp);
    //SetCampaignInt("GS_CL_" + sID, "TIMESTAMP_" + IntToString(nInstance), nTimestamp);
}
//----------------------------------------------------------------
void gsCLSetActualTimestamp(string sID, int nInstance)
{
    gsCLSetTimestamp(sID, nInstance, gsTIGetActualTimestamp());
}
//----------------------------------------------------------------
int gsCLGetTimeout(string sID, int nInstance)
{
    sqlquery sqlGetTimeout = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "SELECT timeout from classes WHERE class_id = @class_id AND instance = @instance");
    SqlBindString(sqlGetTimeout, "@class_id", sID);
    SqlBindInt(sqlGetTimeout, "@instance", nInstance);
    if(SqlStep(sqlGetTimeout)){
        return SqlGetInt(sqlGetTimeout, 0);
    } else {
        return 0;
    }
    //return GetCampaignInt("GS_CL_" + sID, "TIMEOUT_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetTimeout(string sID, int nInstance, int nTimeout)
{
    sqlquery sqlSetTimeout = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "INSERT INTO classes (class_id, instance, timeout) VALUES (@class_id, @instance, @timeout) ON CONFLICT (class_id, instance) DO UPDATE SET timeout = excluded.timeout;");
    SqlBindString(sqlSetTimeout, "@class_id", sID);
    SqlBindInt(sqlSetTimeout, "@instance", nInstance);
    SqlBindInt(sqlSetTimeout, "@timeout", nTimeout);
    SqlStep(sqlSetTimeout);
    //SetCampaignInt("GS_CL_" + sID, "TIMEOUT_" + IntToString(nInstance), nTimeout);
}
//----------------------------------------------------------------
int gsCLGetIsOwner(string sID, int nInstance, object oPC)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    

    if (sPlayerID != "" &&
        gsCLGetOwnerID(sID, nInstance) == sPlayerID)
    {
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsCLGetIsVacant(string sID, int nInstance)
{
    string sPlayerID = gsCLGetOwnerID(sID, nInstance);
    return sPlayerID == "";
}
//----------------------------------------------------------------
int gsCLGetIsAvailable(string sID, int nInstance)
{
    if (! gsCLGetIsVacant(sID, nInstance))
    {
        int nTimeout = gsCLGetTimeout(sID, nInstance);

        if (nTimeout)
        {
            int nTimestamp = gsTIGetActualTimestamp() - gsCLGetTimestamp(sID, nInstance);

            if (nTimestamp < nTimeout) return FALSE;
        }
    }

    return TRUE;
}
//----------------------------------------------------------------
void gsCLRelease(string sID, int nInstance)
{
    sqlquery sqlReleaseInstance = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "INSERT INTO classes (class_id, instance, owner) VALUES (@class_id, @instance, @owner) ON CONFLICT (class_id, instance) DO UPDATE SET owner = excluded.owner;");
    SqlBindString(sqlReleaseInstance, "@class_id", sID);
    SqlBindInt(sqlReleaseInstance, "@instance", nInstance);
    SqlBindString(sqlReleaseInstance, "@owner", "");
    SqlStep(sqlReleaseInstance);
    //SetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance), "");
}
//----------------------------------------------------------------
void gsCLReleaseAll(string sID)
{
    sqlquery sqlDeleteClass = SqlPrepareQueryCampaign(GS_CLASS_DATABASE, "DELETE FROM classes WHERE class_id = @class_id");
    SqlBindString(sqlDeleteClass, "@class_id", sID);
    SqlStep(sqlDeleteClass);
    //DestroyCampaignDatabase("GS_CL_" + sID);
}
